package com.freshchat.flutter_freshchat;

import android.app.Activity;
import android.util.Log;

import java.util.ArrayList;

import com.freshchat.consumer.sdk.FaqOptions;
import com.freshchat.consumer.sdk.Freshchat;
import com.freshchat.consumer.sdk.FreshchatCallbackStatus;
import com.freshchat.consumer.sdk.FreshchatConfig;
import com.freshchat.consumer.sdk.FreshchatUser;
import com.freshchat.consumer.sdk.ConversationOptions;
import com.freshchat.consumer.sdk.UnreadCountCallback;
import com.freshchat.consumer.sdk.exception.MethodNotAllowedException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterFreshchatPlugin implements MethodCallHandler {
    private final Activity activity;

    private static final String METHOD_INIT = "init";
    private static final String METHOD_IDENTIFY_USER = "identifyUser";
    private static final String METHOD_UPDATE_USER_INFO = "updateUserInfo";
    private static final String METHOD_RESET_USER = "reset";
    private static final String METHOD_SHOW_CONVERSATIONS = "showConversations";
    private static final String METHOD_SHOW_FAQS = "showFAQs";
    private static final String METHOD_GET_UNREAD_MESSAGE_COUNT = "getUnreadMsgCount";
    private static final String METHOD_SETUP_PUSH_NOTIFICATIONS = "setupPushNotifications";

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_freshchat");
        channel.setMethodCallHandler(new FlutterFreshchatPlugin(registrar.activity()));
    }

    private FlutterFreshchatPlugin(Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {

        switch (call.method) {
        case METHOD_INIT:
            final String appID = call.argument("appID");
            final String appKey = call.argument("appKey");
            final boolean cameraEnabled = call.argument("cameraEnabled");

            FreshchatConfig freshchatConfig = new FreshchatConfig(appID, appKey);
            freshchatConfig.setCameraCaptureEnabled(cameraEnabled);

            Freshchat.getInstance(this.activity.getApplicationContext()).init(freshchatConfig);
            result.success(true);
            break;
        case METHOD_IDENTIFY_USER:
            final String externalId = call.argument("externalID");
            String restoreId = call.argument("restoreID");

            try {
                if (restoreId == "") {
                    Freshchat.getInstance(this.activity.getApplicationContext()).identifyUser(externalId, null);
                    restoreId = Freshchat.getInstance(this.activity.getApplicationContext()).getUser().getRestoreId();
                } else {
                    Freshchat.getInstance(this.activity.getApplicationContext()).identifyUser(externalId, restoreId);
                }
            } catch (MethodNotAllowedException e) {
                e.printStackTrace();
                result.error("Error while identifying User", "error", e);
            }
            result.success(restoreId);
            break;
        case METHOD_UPDATE_USER_INFO:
            final String firstName = call.argument("first_name");
            final String email = call.argument("email");
            final String phone = call.argument("phone");
            final String lastName = call.argument("last_name");
            final String createdTime = call.argument("created_time");
            final String phoneCountryCode = call.argument("phone_country_code");
            final Map<String, String> customProperties = call.argument("custom_property_list");

            FreshchatUser freshchatUser = Freshchat.getInstance(this.activity.getApplicationContext()).getUser();
            freshchatUser.setFirstName(firstName);
            freshchatUser.setEmail(email);
            freshchatUser.setPhone(phoneCountryCode, phone);
            freshchatUser.setLastName(lastName);

            try {
                Freshchat.getInstance(this.activity.getApplicationContext()).setUser(freshchatUser);

                if (customProperties != null) {
                    Freshchat.getInstance(this.activity.getApplicationContext()).setUserProperties(customProperties);
                }
            } catch (MethodNotAllowedException e) {
                e.printStackTrace();
                result.error("Error while setting User", "error", e);
            }
            result.success(true);
            break;
        case METHOD_SHOW_CONVERSATIONS:
            final ArrayList tags = call.argument("tags");
            final String title = call.argument("title");
            if (tags.size() > 0) {
                ConversationOptions convOptions = new ConversationOptions().filterByTags(tags, title);
                Freshchat.showConversations(this.activity, convOptions);
            } else {
                Freshchat.showConversations(this.activity.getApplicationContext());
            }
            result.success(true);
            break;
        case METHOD_SHOW_FAQS:
            final boolean showFaqCategoriesAsGrid = call.argument("showFaqCategoriesAsGrid");
            final boolean showContactUsOnAppBar = call.argument("showContactUsOnAppBar");
            final boolean showContactUsOnFaqScreens = call.argument("showContactUsOnFaqScreens");
            final boolean showContactUsOnFaqNotHelpful = call.argument("showContactUsOnFaqNotHelpful");

            FaqOptions faqOptions = new FaqOptions().showFaqCategoriesAsGrid(showFaqCategoriesAsGrid)
                    .showContactUsOnAppBar(showContactUsOnAppBar).showContactUsOnFaqScreens(showContactUsOnFaqScreens)
                    .showContactUsOnFaqNotHelpful(showContactUsOnFaqNotHelpful);

            Freshchat.showFAQs(this.activity, faqOptions);
            result.success(true);
            break;
        case METHOD_GET_UNREAD_MESSAGE_COUNT:
            Freshchat.getInstance(this.activity.getApplicationContext()).getUnreadCountAsync(new UnreadCountCallback() {
                @Override
                public void onResult(FreshchatCallbackStatus freshchatCallbackStatus, int i) {
                    result.success(i);
                }
            });
            break;
        case METHOD_SETUP_PUSH_NOTIFICATIONS:
            final String token = call.argument("token");
            Freshchat.getInstance(this.activity.getApplicationContext()).setPushRegistrationToken(token);
            result.success(true);
            break;
        case METHOD_RESET_USER:
            Freshchat.resetUser(this.activity.getApplicationContext());
            result.success(true);
            break;
        default:
            result.notImplemented();
        }
    }
}
