import 'package:flutter/material.dart';
class AppConfig {
  // API endpoints
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://staging-api.petbond.co.uk/api/mobile/',
  );

  static const String imageBaseUrl = String.fromEnvironment(
    'IMAGE_BASE_URL',
    defaultValue: 'https://staging-api.petbond.co.uk/api/image-retrieve/',
  );

  static const String stripeChannelAuthUrl = String.fromEnvironment(
    'STRIPE_CHANNEL_AUTH_URL',
    defaultValue:
        'https://staging-api.petbond.co.uk/api/pusher/authenticate-channel',
  );

  // Third-party keys (provide at runtime via --dart-define)
  static const String pusherKey =
      String.fromEnvironment('PUSHER_KEY', defaultValue: '');

  static const String pusherCluster =
      String.fromEnvironment('PUSHER_CLUSTER', defaultValue: 'eu');

  static const String googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '');

  // Optional: environment label (e.g., staging, prod) for diagnostics
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'staging');
}
