import 'package:petbond_uk/core/utils/config.dart';

class BaseUrl {
  static const String _prefix = '';

  static String getBaseUrl() {
    return AppConfig.apiBaseUrl;
  }

  static String getImageBaseUrl() {
    return AppConfig.imageBaseUrl;
  }

  static String getUrl() {
    return BaseUrl.getBaseUrl() + BaseUrl._prefix;
  }

  static String getStripeAuthUrl() {
    return AppConfig.stripeChannelAuthUrl;
  }
}
