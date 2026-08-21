import 'package:dio/dio.dart';
import 'package:touristsaver/common/models/social_media_link.dart';
import 'package:touristsaver/constants/helper.dart';
import 'package:touristsaver/constants/url_end_point.dart';

class SocialMediaLinkService {
  Future<List<SocialMediaLink>> getActive() async {
    try {
      final Dio dio = await getClientNoToken();
      final Response<dynamic> response = await dio.get(activeSocialMediaLinks);
      final dynamic payload = response.data;
      final dynamic rawData = payload is Map ? payload['data'] : null;
      if (rawData is! List) return const [];
      return rawData
          .whereType<Map>()
          .map((item) => SocialMediaLink.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .where((item) =>
              item.displayName.trim().isNotEmpty &&
              Uri.tryParse(item.url)?.isScheme('https') == true)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
