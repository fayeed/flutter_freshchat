part of freshchat;

class FlutterFreshchat {
  static const MethodChannel _channel =
      const MethodChannel('flutter_freshchat');

  /// Initialize the Freshchat app with `appID` and `appKey` which you could get from here:
  /// [Where to find App ID and App Key](https://support.freshchat.com/support/solutions/articles/229192)
  ///
  /// It has following [FreshchatConfig] properties:
  ///
  /// `cameraEnabled` property is used to either enable or disable camera
  /// within freshchat conversation widget. It default value is set to `true`.
  ///
  /// `gallerySelectionEnabled` property is used to either enable or disable gallery
  /// within freshchat conversation widget. It default value is set to `true`.
  ///
  /// `teamMemberInfoVisible` property is used to show team member info
  /// within freshchat conversation widget. It default value is set to `true`.
  ///
  /// `responseExpectationEnabled` property is used to show exceptions that occur
  /// within freshchat conversation widget. It default value is set to `true`.
  ///
  /// `showNotificationBanner` property is used enabled or disable in-app notfication
  /// banner. It default value is set to `true`. (NOTE: IOS only).
  ///
  /// `notificationSoundEnabled` property is used enabled or disable in-app notfication
  /// sound. It default value is set to `true`. (NOTE: IOS only).
  static Future<bool> init({
    required String appID,
    required String appKey,
    required String domain,
    bool cameraEnabled = true,
    bool gallerySelectionEnabled = true,
    bool teamMemberInfoVisible = true,
    bool responseExpectationEnabled = true,
    bool showNotificationBanner = true,
    bool notificationSoundEnabled = true,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'appID': appID,
      'appKey': appKey,
      'domain': domain,
      'cameraEnabled': cameraEnabled,
      'gallerySelectionEnabled': gallerySelectionEnabled,
      'teamMemberInfoVisible': teamMemberInfoVisible,
      'responseExpectationEnabled': responseExpectationEnabled,
      'showNotificationBanner': showNotificationBanner,
      'notificationSoundEnabled': notificationSoundEnabled,
    };
    final bool result = await _channel.invokeMethod('init', params);

    return result;
  }

  /// Update the user info by setting by creating a `FreshchatUser` object
  ///
  /// Custom properties can be set by using `customProperties` property
  ///
  /// ```dart
  /// Map<String, String> customProperties = Map<String, String>();
  /// customProperties["loggedIn"] = "true";
  /// ```
  static Future<bool> updateUserInfo({
    required FreshchatUser user,
    Map<String, String>? customProperties,
  }) async {
    Map<String, dynamic> json = user.toJson();

    json['custom_property_list'] = customProperties;

    final bool result = await _channel.invokeMethod('updateUserInfo', json);

    return result;
  }

  /// Identify the user user by usin email address or any way you uniquely
  /// identify the user.
  ///
  /// `externalID` is required and returns a `restoreID` you can save it
  /// and use to restore the chats messages.
  static Future<String> identifyUser({
    required String externalID,
    String? restoreID,
  }) async {
    final Map<String, String> params = <String, String>{
      "externalID": externalID,
      "restoreID": restoreID != null ? restoreID : ""
    };

    final String result = await _channel.invokeMethod("identifyUser", params);

    return result;
  }

  /// Reset user data at logout or when deemed appropriate based on user action
  /// in the app.
  static Future<bool> resetUser() async {
    final bool result = await _channel.invokeMethod('reset');
    return result;
  }

  /// Show conversation opens a conversation screen and also list all the other
  /// conversation if a list obejct is supplied to it.
  ///
  /// You can also pass a title for the chat screen.
  static Future<bool> showConversations({
    List<String> tags = const [],
    String? title,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "tags": tags,
      "title": title
    };
    final bool result =
        await _channel.invokeMethod('showConversations', params);

    return result;
  }

  /// ShowFAQs opens a FAQ screen in a grid like format as default you can change
  /// the default setting by changing this paramters.
  static Future<bool> showFAQs({
    bool showFaqCategoriesAsGrid = true,
    bool showContactUsOnAppBar = true,
    bool showContactUsOnFaqScreens = false,
    bool showContactUsOnFaqNotHelpful = false,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "showFaqCategoriesAsGrid": showFaqCategoriesAsGrid,
      "showContactUsOnAppBar": showContactUsOnAppBar,
      "showContactUsOnFaqScreens": showContactUsOnFaqScreens,
      "showContactUsOnFaqNotHelpful": showContactUsOnFaqNotHelpful
    };

    final bool result = await _channel.invokeMethod('showFAQs', params);

    return result;
  }

  /// Gets the unseen message count from freshchat you can use this to show a counter.
  static Future<int> getUnreadMsgCount() async {
    final int result = await _channel.invokeMethod('getUnreadMsgCount');
    return result;
  }

  /// Setup Push notification for freshchat by passing `token` to the methd.
  static Future<bool> setupPushNotifications({required String token}) async {
    final Map<String, dynamic> params = <String, dynamic>{"token": token};

    final bool result =
        await _channel.invokeMethod('setupPushNotifications', params);

    return result;
  }

  /// Send message
  static Future<bool> send({required String message, String? tag}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "message": message,
      "tag": tag
    };

    final bool result = await _channel.invokeMethod('send', params);

    return result;
  }
}
