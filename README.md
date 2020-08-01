<p align="center">
  <h1 align="center" style="font-size: 48px;">💬 Flutter Freshchat</h1>
  <h5 align="center">
A Flutter plugin for integrating Freshchat in your mobile app.
</p>

## Setup

### Android

Add this to your `AndroidManifest.xml`

```xml
<provider
    android:name="android.support.v4.content.FileProvider"
    android:authorities="com.example.demoapp.provider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/freshchat_file_provider_paths" />
</provider>
```

If you have migrated to AndroidX your might need change the provider attribute `android:name` to this:

```xml
<provider android:name="androidx.core.content.FileProvider">
</provider>
```

Add this to your `Strings.xml` located inside `android/src/res/values`

```xml
<string name="freshchat_file_provider_authority">com.example.demoapp.provider</string>
```

**Firebase Cloud Messaging support**

1. Add dependency in `<app-name>/android/app/build.gradle`

```
dependencies {
  // ...
  implementation "com.github.freshdesk:freshchat-android:3.3.0"
}
```

2. Create `FreshchatMessagingService.java` (Java, not Kotlin) class to your app in the same directory as your `MainActivity` class

```
package <your package's identifier>;

import com.freshchat.consumer.sdk.Freshchat;
import com.google.firebase.messaging.RemoteMessage;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;


public class FreshchatMessagingService extends FlutterFirebaseMessagingService {

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
    }

    @Override
    public void onMessageReceived(final RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        if (Freshchat.isFreshchatNotification(remoteMessage)) {
            Freshchat.handleFcmMessage(this, remoteMessage);
        }
    }
}
```

3. In `AndroidManifest.xml` add

```
<service android:name=".FreshchatMessagingService">
  <intent-filter>
    <action android:name="com.google.firebase.MESSAGING_EVENT" />
  </intent-filter>
</service>
```

4. In your `Application` class change
```
FlutterFirebaseMessagingService.setPluginRegistrant(this)
```
to
```
FreshchatMessagingService.setPluginRegistrant(this)
```

### IOS

1. If you are using Objective-C in your flutter project then you will need to create a briging header between objective-C and swift to do that follow the steps below:

   > - Bridging Header must be created.
   > - Open the project with XCode. Then choose File -> New -> File -> Swift File.
   > - A dialog will be displayed when creating the swift file(Since this file is deleted, any name can be used.).
   > - XCode will ask you if you wish to create Bridging Header, click yes.
   > - Make sure you have use_frameworks! in the Runner block, in ios/Podfile。
   > - Make sure you have SWIFT_VERSION 4.2 selected in you XCode -> Build Settings
   > - Do flutter clean.
   > - Go to your ios folder, delete Podfile.lock and Pods folder and then execute pod install --repo-update

2. Add `use_frameworks!` at the top of your Podfile.
3. Add this to info.plist
   > Starting with iOS 10, Apple requires developers to declare access to privacy-sensitive controls ahead of time.

```xml
    <key>NSPhotoLibraryUsageDescription</key>
    <string>To Enable access to Photo Library</string>
    <key>NSCameraUsageDescription</key>
    <string>To take Images from Camera</string>
```

<!-- 4. At this point if you try to build you will get an error something related to duplicate `info.plist` (Note: It's something to do with Freshchat) you can remove this info by following the below instructions:

- Open your `.xcworkspace` in xcode.
- Goto to `Pods`.
- Select target `flutter_freshchat`.
- Select Build Phases and then go to Compile Sources.
- Look for two `info.plist` entries and remove them. -->

## Usage

To use this plugin, add `flutter_freshchat` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```dart
import 'package:flutter_freshchat/flutter_freshchat.dart';
```

Initialize the Freshchat app with `appID`, `appKey` & `domain` which you could get from here: [Where to find App ID and App Key](https://support.freshchat.com/support/solutions/articles/229192)<br/><br/>
It has following [FreshchatConfig] properties:

- `domain` Each Freshchat cluster falls in to one of this domains:
  - US - https://msdk.freshchat.com (default)
  - AU - https://msdk.au.freshchat.com
  - EU - https://msdk.eu.freshchat.com
  - IN - https://msdk.in.freshchat.com
  - US2 - https://msdk.us2.freshchat.com

- `cameraEnabled` property is used to either enable or disable camera
  within freshchat conversation widget. It default value is set to `true`.

- `gallerySelectionEnabled` property is used to either enable or disable gallery
  within freshchat conversation widget. It default value is set to `true`.

- `teamMemberInfoVisible` property is used to show team member info
  within freshchat conversation widget. It default value is set to `true`.

- `responseExpectationEnabled` property is used to show exceptions that occur
  within freshchat conversation widget. It default value is set to `true`.

- `showNotificationBanner` property is used enabled or disable in-app notification
  banner. It default value is set to `true`. (NOTE: IOS only).

- `notificationSoundEnabled` property is used enabled or disable in-app notification
  sound. It default value is set to `true`. (NOTE: IOS only).

```dart
await FlutterFreshchat.init(
  appID: 'YOUR_APP_ID_HERE', 
  appKey: 'YOUR_APP_KEY_HERE',
  domain: 'https://msdk.freshchat.com'
  );
```

Update the user info by setting by creating a `FreshchatUser` object

```dart
FreshchatUser user = FreshchatUser.initial();
user.email = "john@test.com";
user.firstName = "john";
user.lastName = "doe";
user.phoneCountryCode = "+91";
user.phone = "0123456789";

await FlutterFreshchat.updateUserInfo(user: user);

// Custom properties can be set by creating a Map<String, String>
Map<String, String> customProperties = Map<String, String>();
customProperties["loggedIn"] = "true";

await FlutterFreshchat.updateUserInfo(user: user, customProperties: customProperties);
```

Identify the user user by usin email address or any way you uniquely identify the user.
`externalID` is required and returns a `restoreID` you can save it and use to restore the chats

```dart
await FlutterFreshchat.identifyUser(externalID: 'USER_UNIQUE_ID', restoreID: 'USER_RESTORE_ID');
```

Show conversation opens a conversation screen and also list all the other conversation if a list obejct is supplied to it. You can also pass a title for the chat screen.

```dart
await FlutterFreshchat.showConversations(tags: const [], title: 'CHAT_SCREEN_TITLE');
```

Send message directly within the app without opening the Freshchat interface. `tag` is optional.

```dart
await FlutterFreshchat.send(message: 'YOUR_MESSAGE_HERE', tag: 'YOUR_TAG_HERE');
```

ShowFAQs opens a FAQ screen in a grid like format as default you can change the default setting by changing this paramters.<br>
`showFaqCategoriesAsGrid = true`<br>
`showContactUsOnAppBar = true`<br>
`showContactUsOnFaqScreens = false`<br>
`showContactUsOnFaqNotHelpful = false`<br>

```dart
await FlutterFreshchat.showFAQs();
```

Gets the unseen message count from freshchat you can use this to show a counter.

```dart
int count = await FlutterFreshchat.getUnreadMsgCount();
```

Reset user data at logout or when deemed appropriate based on user action in the app.

```dart
await FlutterFreshchat.resetUser();
```

## Example

Find the example wiring in the [Flutter_Freshchat example application](https://github.com/fayeed/flutter_freshchat/blob/master/example/lib/main.dart).

## API details

See the [flutter_freshchat.dart](https://github.com/fayeed/flutter_freshchat/blob/master/lib/flutter_freshchat.dart) for more API details

## Issues and feedback

Please file [issues](https://github.com/fayeed/flutter_freshchat/issues)
to send feedback or report a bug. Thank you!
