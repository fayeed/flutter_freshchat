package com.freshchat.flutter_freshchat;

import android.app.Application;
import android.util.Log;

import java.util.ArrayList;
import java.util.Map;

import com.freshchat.consumer.sdk.FaqOptions;
import com.freshchat.consumer.sdk.Freshchat;
import com.freshchat.consumer.sdk.FreshchatCallbackStatus;
import com.freshchat.consumer.sdk.FreshchatConfig;
import com.freshchat.consumer.sdk.FreshchatUser;
import com.freshchat.consumer.sdk.FreshchatMessage;
import com.freshchat.consumer.sdk.ConversationOptions;
import com.freshchat.consumer.sdk.UnreadCountCallback;
import com.freshchat.consumer.sdk.exception.MethodNotAllowedException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterFreshchatPlugin implements MethodCallHandler {
    private final Application application;

    private static final String METHOD_INIT = "init";
    private static final String METHOD_IDENTIFY_USER = "identifyUser";
    private static final String METHOD_UPDATE_USER_INFO = "updateUserInfo";
    private static final String METHOD_RESET_USER = "reset";
    private static final String METHOD_SHOW_CONVERSATIONS = "showConversations";
    private static final String METHOD_SHOW_FAQS = "showFAQs";
    private static final String METHOD_GET_UNREAD_MESSAGE_COUNT = "getUnreadMsgCount";
    private static final String METHOD_SETUP_PUSH_NOTIFICATIONS = "setupPushNotifications";
    private static final String METHOD_SEND_MESSAGE = "send";

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_freshchat");
        channel.setMethodCallHandler(new FlutterFreshchatPlugin((Application) registrar.context()));
    }

    private FlutterFreshchatPlugin(Application application) {
        this.application = application;
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {

        switch (call.method) {
        case METHOD_INIT:
            final String appID = call.argument("appID");
            final String appKey = call.argument("appKey");
            final String domain = call.argument("domain");
            final boolean cameraEnabled = call.argument("cameraEnabled");
            final boolean gallerySelectionEnabled = call.argument("gallerySelectionEnabled");
            final boolean teamMemberInfoVisible = call.argument("teamMemberInfoVisible");
            final boolean responseExpectationEnabled = call.argument("responseExpectationEnabled");

            Freshchat.setImageLoader(com.freshchat.consumer.sdk.j.af.aw(this.application.getApplicationContext()));
            FreshchatConfig freshchatConfig = new FreshchatConfig(appID, appKey);
            freshchatConfig.setCameraCaptureEnabled(cameraEnabled);
            freshchatConfig.setGallerySelectionEnabled(gallerySelectionEnabled);
            freshchatConfig.setResponseExpectationEnabled(responseExpectationEnabled);
            freshchatConfig.setTeamMemberInfoVisible(teamMemberInfoVisible);
            freshchatConfig.setDomain(domain);
            Freshchat.getInstance(this.application.getApplicationContext()).init(freshchatConfig);
            result.success(true);
            break;
        case METHOD_IDENTIFY_USER:
            final String externalId = call.argument("externalID");
            String restoreId = call.argument("restoreID");

            try {
                if (restoreId == "") {
                    Freshchat.getInstance(this.application.getApplicationContext()).identifyUser(externalId, null);
                    restoreId = Freshchat.getInstance(this.application.getApplicationContext()).getUser().getRestoreId();
                } else {
                    Freshchat.getInstance(this.application.getApplicationContext()).identifyUser(externalId, restoreId);
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

            FreshchatUser freshchatUser = Freshchat.getInstance(this.application.getApplicationContext()).getUser();
            freshchatUser.setFirstName(firstName);
            freshchatUser.setEmail(email);
            freshchatUser.setPhone(phoneCountryCode, phone);
            freshchatUser.setLastName(lastName);

            try {
                Freshchat.getInstance(this.application.getApplicationContext()).setUser(freshchatUser);

                if (customProperties != null) {
                    Freshchat.getInstance(this.application.getApplicationContext()).setUserProperties(customProperties);
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
                Freshchat.showConversations(this.application, convOptions);
            } else {
                Freshchat.showConversations(this.application.getApplicationContext());
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

            Freshchat.showFAQs(this.application, faqOptions);
            result.success(true);
            break;
        case METHOD_GET_UNREAD_MESSAGE_COUNT:
            Freshchat.getInstance(this.application.getApplicationContext()).getUnreadCountAsync(new UnreadCountCallback() {
                @Override
                public void onResult(FreshchatCallbackStatus freshchatCallbackStatus, int i) {
                    result.success(i);
                }
            });
            break;
        case METHOD_SETUP_PUSH_NOTIFICATIONS:
            final String token = call.argument("token");
            Freshchat.getInstance(this.application.getApplicationContext()).setPushRegistrationToken(token);
            result.success(true);
            break;
        case METHOD_RESET_USER:
            Freshchat.resetUser(this.application.getApplicationContext());
            result.success(true);
            break;
        case METHOD_SEND_MESSAGE:
            final String message = call.argument("message");
            final String tag = call.argument("tag");
            FreshchatMessage freshchatMessage = new FreshchatMessage();
            freshchatMessage.setTag(tag);
            freshchatMessage.setMessage(message);
            Freshchat.sendMessage(this.application.getApplicationContext(), freshchatMessage);
            result.success(true);
            break;
        default:
            result.notImplemented();
        }
    }
}
