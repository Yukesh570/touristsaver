import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/response/confirm_topup_res.dart';

void main() {
  test('keeps the paid Multi-Use recognition contract', () {
    final response = ConfirmTopUpResModel.fromJson({
      'status': 'Success',
      'data': {
        'assignedToName': 'Gold Coast Tourist Magazine',
        'codeOwnerType': 'areaOwner',
        'codeOwnerId': '103',
        'recognitionStyle': 'introduced_by',
      },
    });

    expect(response.data?.assignedToName, 'Gold Coast Tourist Magazine');
    expect(response.data?.codeOwnerType, 'areaOwner');
    expect(response.data?.codeOwnerId, 103);
    expect(response.data?.recognitionStyle, 'introduced_by');
    expect(response.data?.toJson()['assignedToName'],
        'Gold Coast Tourist Magazine');
  });
}
