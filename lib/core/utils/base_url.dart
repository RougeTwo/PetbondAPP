class BaseUrl {
  static const String _baseUrl =
      'https://staging-api.petbond.co.uk/api/mobile/';
  static const String _imageUrl =
      'https://staging-api.petbond.co.uk/api/image-retrieve/';
  static const String _stripeChannelAuthUrl =
      'https://staging-api.petbond.co.uk/api/pusher/authenticate-channel';

  static const String _prefix = '';
  static String getBaseUrl() {
    return BaseUrl._baseUrl;
  }

  static String getImageBaseUrl() {
    return BaseUrl._imageUrl;
  }

  static String getUrl() {
    return BaseUrl.getBaseUrl() + BaseUrl._prefix;
  }

  static String getStripeAuthUrl() {
    return BaseUrl._stripeChannelAuthUrl;
  }
}
