/*!
 * TouristSaver Partner Gateway SDK v1.0.0
 * Copyright (c) TouristSaver. All rights reserved.
 */
(function (root) {
  'use strict';

  var SDK_VERSION = '1.0.0';
  var DEFAULT_MESSAGE =
    'This offer is exclusively available to TouristSaver members.';
  var STYLE_ID = 'touristsaver-gateway-blocking-style';
  var activePromise = null;

  function GatewayError(code, message) {
    this.name = 'TouristSaverGatewayError';
    this.code = code;
    this.message = message;
  }
  GatewayError.prototype = Object.create(Error.prototype);
  GatewayError.prototype.constructor = GatewayError;

  function requireAbsoluteUrl(value, fieldName) {
    var parsed;
    try {
      parsed = new URL(value);
    } catch (_) {
      throw new GatewayError(
        'invalid_configuration',
        fieldName + ' must be an absolute URL.'
      );
    }

    var localHttp =
      parsed.protocol === 'http:' &&
      (parsed.hostname === 'localhost' || parsed.hostname === '127.0.0.1');
    if (parsed.protocol !== 'https:' && !localHttp) {
      throw new GatewayError(
        'invalid_configuration',
        fieldName + ' must use HTTPS (HTTP is allowed only for localhost).'
      );
    }
    return parsed.toString();
  }

  function normaliseConfig(input) {
    if (!input || typeof input !== 'object') {
      throw new GatewayError(
        'invalid_configuration',
        'TouristSaverGateway.init requires a configuration object.'
      );
    }

    var partner = String(input.partner || '').trim().toLowerCase();
    if (!/^[a-z0-9][a-z0-9_-]{1,63}$/.test(partner)) {
      throw new GatewayError(
        'invalid_configuration',
        'partner must be a registered lowercase partner slug.'
      );
    }

    if (!input.verifyEndpoint || !input.redirectUrl) {
      throw new GatewayError(
        'invalid_configuration',
        'verifyEndpoint and redirectUrl are required.'
      );
    }

    var timeout = Number(input.requestTimeoutMs || 8000);
    if (!Number.isFinite(timeout) || timeout < 1000 || timeout > 30000) {
      throw new GatewayError(
        'invalid_configuration',
        'requestTimeoutMs must be between 1000 and 30000.'
      );
    }

    return {
      partner: partner,
      verifyEndpoint: requireAbsoluteUrl(
        input.verifyEndpoint,
        'verifyEndpoint'
      ),
      redirectUrl: requireAbsoluteUrl(input.redirectUrl, 'redirectUrl'),
      unauthorisedMessage:
        typeof input.unauthorisedMessage === 'string' &&
        input.unauthorisedMessage.trim()
          ? input.unauthorisedMessage.trim()
          : DEFAULT_MESSAGE,
      tokenParameter:
        typeof input.tokenParameter === 'string' &&
        input.tokenParameter.trim()
          ? input.tokenParameter.trim()
          : 'ts_token',
      requestTimeoutMs: timeout,
      blockPage: input.blockPage !== false,
      persistTokenInSession: input.persistTokenInSession !== false,
      includeMessageInRedirect: input.includeMessageInRedirect !== false,
      onAuthorised:
        typeof input.onAuthorised === 'function' ? input.onAuthorised : null,
      onUnauthorised:
        typeof input.onUnauthorised === 'function'
          ? input.onUnauthorised
          : null,
    };
  }

  function sessionKey(config) {
    return 'touristsaver.gateway.token.' + config.partner;
  }

  function readSessionToken(config) {
    if (!config.persistTokenInSession) return null;
    try {
      return root.sessionStorage.getItem(sessionKey(config));
    } catch (_) {
      return null;
    }
  }

  function storeSessionToken(config, token) {
    if (!config.persistTokenInSession) return;
    try {
      root.sessionStorage.setItem(sessionKey(config), token);
    } catch (_) {
      // Storage can be unavailable in private browsing or embedded browsers.
    }
  }

  function clearSessionToken(config) {
    try {
      root.sessionStorage.removeItem(sessionKey(config));
    } catch (_) {
      // Nothing else is required when storage is unavailable.
    }
  }

  function takeTokenFromUrl(config) {
    var current = new URL(root.location.href);
    var token = current.searchParams.get(config.tokenParameter);
    if (!token || !token.trim()) return null;

    current.searchParams.delete(config.tokenParameter);
    var cleanLocation = current.pathname + current.search + current.hash;
    root.history.replaceState(root.history.state, '', cleanLocation);
    return token.trim();
  }

  function blockPage() {
    if (!root.document || root.document.getElementById(STYLE_ID)) return;
    var style = root.document.createElement('style');
    style.id = STYLE_ID;
    style.textContent =
      'html{visibility:hidden!important}html[data-ts-gateway-authorised="true"]{visibility:visible!important}';
    root.document.head.appendChild(style);
    root.document.documentElement.setAttribute('aria-busy', 'true');
  }

  function revealPage() {
    if (!root.document) return;
    root.document.documentElement.setAttribute(
      'data-ts-gateway-authorised',
      'true'
    );
    root.document.documentElement.removeAttribute('aria-busy');
    var style = root.document.getElementById(STYLE_ID);
    if (style && style.parentNode) style.parentNode.removeChild(style);
  }

  function emit(name, detail) {
    if (!root.document || typeof root.CustomEvent !== 'function') return;
    root.document.dispatchEvent(
      new root.CustomEvent('touristsaver:' + name, { detail: detail })
    );
  }

  function normaliseFailureReason(reason) {
    var allowed = [
      'missing_token',
      'invalid_token',
      'expired_token',
      'partner_mismatch',
      'partner_inactive',
      'membership_inactive',
      'verification_unavailable',
    ];
    return allowed.indexOf(reason) >= 0 ? reason : 'invalid_token';
  }

  function redirectUnauthorised(config, reason) {
    var safeReason = normaliseFailureReason(reason);
    clearSessionToken(config);

    var target = new URL(config.redirectUrl);
    target.searchParams.set('ts_gateway_reason', safeReason);
    if (config.includeMessageInRedirect) {
      target.searchParams.set(
        'ts_gateway_message',
        config.unauthorisedMessage
      );
    }

    var result = {
      authorised: false,
      partner: config.partner,
      reason: safeReason,
      redirectUrl: target.toString(),
    };
    emit('unauthorised', result);
    if (config.onUnauthorised) config.onUnauthorised(result);
    root.location.replace(result.redirectUrl);
    return result;
  }

  async function verifyToken(config, token) {
    if (typeof root.fetch !== 'function') {
      throw new GatewayError(
        'verification_unavailable',
        'This browser cannot contact the verification service.'
      );
    }

    var controller =
      typeof root.AbortController === 'function'
        ? new root.AbortController()
        : null;
    var timeoutId = root.setTimeout(function () {
      if (controller) controller.abort();
    }, config.requestTimeoutMs);

    try {
      var response = await root.fetch(config.verifyEndpoint, {
        method: 'POST',
        mode: 'cors',
        credentials: 'omit',
        cache: 'no-store',
        referrerPolicy: 'no-referrer',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          'X-TouristSaver-Gateway-Version': SDK_VERSION,
        },
        body: JSON.stringify({
          token: token,
          partner: config.partner,
          sdkVersion: SDK_VERSION,
        }),
        signal: controller ? controller.signal : undefined,
      });

      if (!response.ok) {
        throw new GatewayError(
          'verification_unavailable',
          'The verification service returned HTTP ' + response.status + '.'
        );
      }

      var payload;
      try {
        payload = await response.json();
      } catch (_) {
        throw new GatewayError(
          'verification_unavailable',
          'The verification service returned an unreadable response.'
        );
      }

      if (
        payload &&
        payload.valid === true &&
        payload.partner === config.partner
      ) {
        return payload;
      }

      return {
        valid: false,
        reason:
          payload && payload.valid === true
            ? 'partner_mismatch'
            : normaliseFailureReason(payload && payload.reason),
        requestId: payload && payload.requestId,
      };
    } finally {
      root.clearTimeout(timeoutId);
    }
  }

  async function run(config) {
    if (config.blockPage) blockPage();

    var token = takeTokenFromUrl(config) || readSessionToken(config);
    if (!token) return redirectUnauthorised(config, 'missing_token');

    try {
      var verification = await verifyToken(config, token);
      if (!verification.valid) {
        return redirectUnauthorised(config, verification.reason);
      }

      storeSessionToken(config, token);
      revealPage();
      var result = {
        authorised: true,
        partner: config.partner,
        expiresAt: verification.expiresAt || null,
        requestId: verification.requestId || null,
      };
      emit('authorised', result);
      if (config.onAuthorised) config.onAuthorised(result);
      return result;
    } catch (error) {
      return redirectUnauthorised(
        config,
        error && error.code === 'expired_token'
          ? 'expired_token'
          : 'verification_unavailable'
      );
    }
  }

  function init(input) {
    if (activePromise) return activePromise;
    if (!input || input.blockPage !== false) blockPage();
    var config;
    try {
      config = normaliseConfig(input);
    } catch (error) {
      emit('error', {
        code: error.code || 'invalid_configuration',
        message: error.message,
      });
      return Promise.reject(error);
    }
    activePromise = run(config);
    return activePromise;
  }

  root.TouristSaverGateway = Object.freeze({
    version: SDK_VERSION,
    init: init,
  });
})(typeof window !== 'undefined' ? window : globalThis);
