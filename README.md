# flutter_freshchat

A Flutter plugin for integrating Freshchat in your mobile app. Supports android only atleast for now.

## Usage

To use this plugin, add `flutter_freshchat` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```dart
import 'package:flutter_freshchat/flutter_freshchat.dart';
```

Initialize the Freshchat app with `appID` and `appKey` which you could get from here: [Where to find App ID and App Key](https://support.freshchat.com/support/solutions/articles/229192)

```dart
await FlutterFreshchat.init(appID: 'YOUR_APP_ID_HERE', appKey: 'YOUR_APP_KEY_HERE');
```

Update the user info by setting to values `FirstName` and `email`

```dart
await FlutterFreshchat.updateUserInfo(firstName: 'FIRST_NAME_HERE', email: 'EMAIL_HERE');
```

Identify the user user by usin email address or any way you uniquely identify the user.
`externalID` is required and returns a `restoreID` you can save it and use to restore the chats

```dart
await FlutterFreshchat.identifyUser(externalID: 'USER_UNQIUE_ID', restoreID: 'USER_RESTORE_ID');
```

Show conversation opens a conversation screen and also list all the other conversation if a list obejct is supplied to it. You can also pass a title for teh chat screen.

```dart
await FlutterFreshchat.showConversations(tags: const [], title: 'CHAT_SCREEN_TITLE');
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
