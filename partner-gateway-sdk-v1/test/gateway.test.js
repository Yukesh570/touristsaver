'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const vm = require('node:vm');

const sdkSource = fs.readFileSync(
  path.join(__dirname, '..', 'touristsaver-partner-gateway.js'),
  'utf8'
);

function createStorage(initial = {}) {
  const values = new Map(Object.entries(initial));
  return {
    getItem(key) {
      return values.has(key) ? values.get(key) : null;
    },
    setItem(key, value) {
      values.set(key, String(value));
    },
    removeItem(key) {
      values.delete(key);
    },
    value(key) {
      return values.get(key);
    },
  };
}

function createHarness({
  href = 'https://partner.example/protected',
  fetchResult,
  fetchError,
  session = {},
} = {}) {
  const styles = new Map();
  const events = [];
  const requests = [];
  const redirects = [];
  const attributes = new Map();
  const storage = createStorage(session);

  const document = {
    head: {
      appendChild(node) {
        node.parentNode = this;
        styles.set(node.id, node);
      },
      removeChild(node) {
        styles.delete(node.id);
      },
    },
    documentElement: {
      setAttribute(name, value) {
        attributes.set(name, value);
      },
      removeAttribute(name) {
        attributes.delete(name);
      },
    },
    createElement() {
      return { id: '', textContent: '', parentNode: null };
    },
    getElementById(id) {
      return styles.get(id) || null;
    },
    dispatchEvent(event) {
      events.push(event);
    },
  };

  const location = {
    href,
    replace(url) {
      redirects.push(url);
    },
  };
  const history = {
    state: null,
    replaceState(_state, _title, cleanLocation) {
      location.href = new URL(cleanLocation, location.href).toString();
    },
  };

  const window = {
    URL,
    AbortController,
    Promise,
    Object,
    JSON,
    Number,
    String,
    Error,
    location,
    history,
    document,
    sessionStorage: storage,
    setTimeout,
    clearTimeout,
    CustomEvent: class CustomEvent {
      constructor(type, options) {
        this.type = type;
        this.detail = options.detail;
      }
    },
    async fetch(url, options) {
      requests.push({ url, options });
      if (fetchError) throw fetchError;
      return {
        ok: fetchResult?.ok ?? true,
        status: fetchResult?.status ?? 200,
        async json() {
          return fetchResult?.body;
        },
      };
    },
  };
  window.window = window;
  window.globalThis = window;

  vm.runInNewContext(sdkSource, window, {
    filename: 'touristsaver-partner-gateway.js',
  });

  return {
    gateway: window.TouristSaverGateway,
    window,
    requests,
    redirects,
    events,
    attributes,
    storage,
  };
}

function config(overrides = {}) {
  return {
    partner: 'example-partner',
    verifyEndpoint: 'https://api.touristsaver.example/verify-token',
    redirectUrl: 'https://touristsaver.example/member-offers',
    ...overrides,
  };
}

test('valid token is verified, removed from URL, and retained per tab', async () => {
  const harness = createHarness({
    href: 'https://partner.example/protected?campaign=launch&ts_token=secret#top',
    fetchResult: {
      body: {
        valid: true,
        partner: 'example-partner',
        expiresAt: '2026-07-05T05:00:00Z',
        requestId: 'request-1',
      },
    },
  });

  const result = await harness.gateway.init(config());

  assert.equal(result.authorised, true);
  assert.equal(harness.redirects.length, 0);
  assert.equal(
    harness.window.location.href,
    'https://partner.example/protected?campaign=launch#top'
  );
  assert.equal(harness.requests.length, 1);
  assert.deepEqual(JSON.parse(harness.requests[0].options.body), {
    token: 'secret',
    partner: 'example-partner',
    sdkVersion: '1.0.0',
  });
  assert.equal(
    harness.storage.value('touristsaver.gateway.token.example-partner'),
    'secret'
  );
  assert.equal(
    harness.attributes.get('data-ts-gateway-authorised'),
    'true'
  );
  assert.equal(harness.events[0].type, 'touristsaver:authorised');
});

test('missing token fails closed and redirects with a safe message', async () => {
  const harness = createHarness();
  const result = await harness.gateway.init(config());

  assert.equal(result.authorised, false);
  assert.equal(result.reason, 'missing_token');
  assert.equal(harness.requests.length, 0);
  const redirect = new URL(harness.redirects[0]);
  assert.equal(redirect.searchParams.get('ts_gateway_reason'), 'missing_token');
  assert.equal(
    redirect.searchParams.get('ts_gateway_message'),
    'This offer is exclusively available to TouristSaver members.'
  );
});

test('expired token is rejected and removed from session storage', async () => {
  const key = 'touristsaver.gateway.token.example-partner';
  const harness = createHarness({
    href: 'https://partner.example/protected?ts_token=expired',
    session: { [key]: 'old-token' },
    fetchResult: { body: { valid: false, reason: 'expired_token' } },
  });

  const result = await harness.gateway.init(config());

  assert.equal(result.reason, 'expired_token');
  assert.equal(harness.storage.value(key), undefined);
});

test('a token cannot be authorised for a different partner audience', async () => {
  const harness = createHarness({
    href: 'https://partner.example/protected?ts_token=valid-but-wrong-audience',
    fetchResult: {
      body: { valid: true, partner: 'another-partner' },
    },
  });

  const result = await harness.gateway.init(config());

  assert.equal(result.authorised, false);
  assert.equal(result.reason, 'partner_mismatch');
});

test('network failure fails closed as verification unavailable', async () => {
  const harness = createHarness({
    href: 'https://partner.example/protected?ts_token=network-test',
    fetchError: new Error('offline'),
  });

  const result = await harness.gateway.init(config());

  assert.equal(result.authorised, false);
  assert.equal(result.reason, 'verification_unavailable');
  assert.equal(harness.redirects.length, 1);
});

test('same-tab refresh token is revalidated from session storage', async () => {
  const harness = createHarness({
    session: {
      'touristsaver.gateway.token.example-partner': 'session-token',
    },
    fetchResult: {
      body: { valid: true, partner: 'example-partner' },
    },
  });

  const result = await harness.gateway.init(config());

  assert.equal(result.authorised, true);
  assert.equal(
    JSON.parse(harness.requests[0].options.body).token,
    'session-token'
  );
});

test('configuration rejects non-HTTPS production endpoints', async () => {
  const harness = createHarness();

  await assert.rejects(
    harness.gateway.init(
      config({ verifyEndpoint: 'http://api.example.com/verify-token' })
    ),
    (error) => error.code === 'invalid_configuration'
  );
  assert.equal(
    harness.attributes.get('aria-busy'),
    'true',
    'invalid configuration must leave the protected page blocked'
  );
});
