# petbond_uk

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configuration

This app reads runtime configuration from Dart environment defines. Provide values via `--dart-define`.

Keys expected by the app:

- `API_BASE_URL`: Base API endpoint
- `IMAGE_BASE_URL`: Image retrieval base URL
- `STRIPE_CHANNEL_AUTH_URL`: Pusher channel auth endpoint
- `PUSHER_KEY`: Pusher Channels API key
- `PUSHER_CLUSTER`: Pusher cluster (e.g., `eu`)
- `GOOGLE_MAPS_API_KEY`: Google Maps API key
- `FLAVOR`: Optional label (e.g., `staging`, `prod`)

See `.env.example` for suggested values. Flutter does not load `.env` files automatically; pass them as shown below.

## Running (examples)

PowerShell examples on Windows:

```powershell
Push-Location "c:\Users\FLIP\Documents\PetbondApp\2022-petbond-uk-mobile-app-master\2022-petbond-uk-mobile-app-master"
flutter run `
	--dart-define=API_BASE_URL=https://staging-api.petbond.co.uk/api/mobile/ `
	--dart-define=IMAGE_BASE_URL=https://staging-api.petbond.co.uk/api/image-retrieve/ `
	--dart-define=STRIPE_CHANNEL_AUTH_URL=https://staging-api.petbond.co.uk/api/pusher/authenticate-channel `
	--dart-define=PUSHER_KEY=your_pusher_key `
	--dart-define=PUSHER_CLUSTER=eu `
	--dart-define=GOOGLE_MAPS_API_KEY=your_maps_key `
	--dart-define=FLAVOR=staging
Pop-Location
```

To set a custom Android package ID for builds:

```powershell
$env:ORG_GRADLE_PROJECT_APP_ID = "com.yourcompany.petbond"
```

For release signing, supply `key.properties` (not committed) or set environment variables as documented in `android/app/build.gradle`.
