class AppEnvironment {
  const AppEnvironment._();

  static const production = 'production';
  static const staging = 'staging';

  static const environment = String.fromEnvironment(
    'TS_ENV',
    defaultValue: production,
  );

  static const productionApiBaseUrl =
      'https://api-dashboard.touristsaver.org/api/';
// TODO(ts-staging):
// Replace with https://api-staging.touristsaver.org/api/
// once the staging DNS and TLS certificate are commissioned.
  static const stagingApiBaseUrl = 'http://209.38.93.178:5000/api/';

  static const apiBaseUrl = String.fromEnvironment(
    'TS_API_BASE_URL',
    defaultValue:
        environment == staging ? stagingApiBaseUrl : productionApiBaseUrl,
  );

  static const isStaging = environment == staging;
  static const isProduction = environment == production;
}
