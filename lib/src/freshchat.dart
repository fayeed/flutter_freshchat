part of firebase_auth;

class FlutterFreshchat {
  static const MethodChannel _channel =
      const MethodChannel('flutter_freshchat');

  static Future<bool> init({
    @required String appID,
    @required String appKey,
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

  static Future<bool> updateUserInfo(
      {@required FreshchatUser user,
      Map<String, String> customProperties}) async {
    Map<String, dynamic> json = user.toJson();

    json['custom_property_list'] = customProperties;

    final bool result = await _channel.invokeMethod('updateUserInfo', json);
    return result;
  }

  static Future<String> identifyUser(
      {@required String externalID, String restoreID}) async {
    final Map<String, String> params = <String, String>{
      "externalID": externalID,
      "restoreID": restoreID != null ? restoreID : ""
    };

    final String result = await _channel.invokeMethod("identifyUser", params);
    return result;
  }

  static Future<bool> resetUser() async {
    final bool result = await _channel.invokeMethod('reset');
    return result;
  }

  static Future<bool> showConversations(
      {List<String> tags = const [], String title}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "tags": tags,
      "title": title
    };
    final bool result =
        await _channel.invokeMethod('showConversations', params);
    return result;
  }

  static Future<bool> showFAQs(
      {bool showFaqCategoriesAsGrid = true,
      bool showContactUsOnAppBar = true,
      bool showContactUsOnFaqScreens = false,
      bool showContactUsOnFaqNotHelpful = false}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "showFaqCategoriesAsGrid": showFaqCategoriesAsGrid,
      "showContactUsOnAppBar": showContactUsOnAppBar,
      "showContactUsOnFaqScreens": showContactUsOnFaqScreens,
      "showContactUsOnFaqNotHelpful": showContactUsOnFaqNotHelpful
    };

    final bool result = await _channel.invokeMethod('showFAQs', params);
    return result;
  }

  static Future<int> getUnreadMsgCount() async {
    final int result = await _channel.invokeMethod('getUnreadMsgCount');
    return result;
  }

  static Future<bool> setupPushNotifications({@required String token}) async {
    final Map<String, dynamic> params = <String, dynamic>{token: token};
    final bool result =
        await _channel.invokeMethod('setupPushNotifications', params);
    return result;
  }
}
