# Agora Group or 1-1 Video Call with in-call Stats

Quickstart for group or 1-1 video call with stats in Flutter using Agora SDK. Use this guide for further development. 

## Prerequisites

- '>= Flutter 2.2.0'
- Agora [Developer Account](https://console.agora.io/)

## Setup Dependencies
Add the runtime dependency `agora_rtc_engine` as well as the generator `permission_handler` to your `pubspec.yaml`.
Check for the latest version.

```yaml
dependencies:
  flutter:
    sdk: flutter
  agora_rtc_engine: ^4.0.2
  permission_handler: ^8.1.2
```
## Create an Account and Obtain an App ID

To build and run the sample application, first obtain an app ID:

1. Create a developer account at agora.io. Once you finish the sign-up process, you are redirected to the dashboard.
2. Navigate in the dashboard tree on the left to Projects > Project List.
3. Copy the app ID that you obtain from the dashboard into a text file. You will use this when you launch the app.

## Update and Run the Sample Application

1. Open the main.dart file and replace the app ID and token.

```const appId = "";```

```const token = "";```


2. Install all the dependencies

```flutter pub get```

3. Once the build is complete, use the below given command to run the app. 

```flutter run```

## Resources

- You can find the complete API Documentation over [here](https://docs.agora.io/en/Video/API%20Reference/flutter/index.html).