import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/registration_code_resolution.dart';
import 'package:touristsaver/features/register/services/dio_register.dart';

void main() {
  test('posts the canonical code and country to the unified resolver',
      () async {
    late RequestOptions captured;
    final dio = Dio(
      BaseOptions(baseUrl: 'https://staging.example/api/'),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'valid': true,
                'category': 'campaign_invitation_code',
                'campaignName': 'Blue Butterfly Launch Gold Coast',
                'invitationName': 'Carrara Markets - July 2026',
                'communityGroupName': 'Carrara Markets',
                'membershipEffect': 'discovery_membership',
              },
            ),
          );
        },
      ),
    );

    final resolution =
        await DioRegister(registrationCodeClient: dio).resolveRegistrationCode(
      code: '333BUTTERFLY',
      countryId: 3,
    );

    expect(captured.method, 'POST');
    expect(captured.path, '/registration-codes/resolve');
    expect(captured.data, {
      'code': '333BUTTERFLY',
      'countryId': 3,
    });
    expect(resolution.valid, isTrue);
    expect(resolution.category, RegistrationCodeCategory.campaignInvitation);
    expect(resolution.campaignName, 'Blue Butterfly Launch Gold Coast');
    expect(resolution.invitationName, 'Carrara Markets - July 2026');
    expect(resolution.communityGroupName, 'Carrara Markets');
  });

  test('returns an unavailable result for transport or backend failure',
      () async {
    final dio = Dio(
      BaseOptions(baseUrl: 'https://staging.example/api/'),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        ),
      ),
    );

    final resolution =
        await DioRegister(registrationCodeClient: dio).resolveRegistrationCode(
      code: '333BUTTERFLY',
      countryId: 3,
    );

    expect(resolution.valid, isFalse);
    expect(resolution.backendReached, isFalse);
  });

  test('claims canonical Discovery membership with authenticated code only',
      () async {
    late RequestOptions captured;
    final dio = Dio(BaseOptions(baseUrl: 'https://staging.example/api/'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'status': 'success',
                'data': {
                  'discoveryMembership': {
                    'active': true,
                    'status': 'active',
                    'entitlementId': 42,
                    'campaignId': 7,
                    'campaignName': 'Wings of Discovery',
                    'currency': 'AUD',
                    'savingsCapAmountMinor': 2500,
                    'savingsConsumedMinor': 0,
                  },
                },
              },
            ),
          );
        },
      ),
    );

    final result = await DioRegister(authenticatedClient: dio)
        .claimDiscoveryRegistrationCode(code: ' wings2026 ');

    expect(captured.path, '/member/discovery/claim-registration-code');
    expect(captured.data, {'code': 'wings2026'});
    expect(result.isSuccess, isTrue);
    expect(result.membership?.entitlementId, 42);
    expect(result.membership?.campaignName, 'Wings of Discovery');
  });
}
