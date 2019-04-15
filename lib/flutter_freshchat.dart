import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class FlutterFreshchat {
  static const MethodChannel _channel =
      const MethodChannel('flutter_freshchat');

  static Future<bool> init(
      {@required String appID, @required String appKey}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'appID': appID,
      'appKey': appKey,
    };
    final bool result = await _channel.invokeMethod('init', params);
    return result;
  }

  static Future<bool> updateUserInfo(
      {@required String firstName, @required String email}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'firstName': firstName,
      'email': email,
    };

    final bool result = await _channel.invokeMethod('updateUserInfo', params);
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
