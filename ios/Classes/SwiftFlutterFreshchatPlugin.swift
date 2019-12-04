import Flutter
import UIKit

public class SwiftFlutterFreshchatPlugin: NSObject, FlutterPlugin {
    private static let METHOD_INIT = "init"
    private static let METHOD_IDENTIFY_USER = "identifyUser"
    private static let METHOD_UPDATE_USER_INFO = "updateUserInfo"
    private static let METHOD_RESET_USER = "reset"
    private static let METHOD_SHOW_CONVERSATIONS = "showConversations"
    private static let METHOD_SHOW_FAQS = "showFAQs"
    private static let METHOD_GET_UNREAD_MESSAGE_COUNT = "getUnreadMsgCount"
    private static let METHOD_SETUP_PUSH_NOTIFICATIONS = "setupPushNotifications"
    private let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    private var vc: UIViewController {
        get {
            return UIApplication.shared.keyWindow!.rootViewController!
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_freshchat", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterFreshchatPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method){
            case SwiftFlutterFreshchatPlugin.METHOD_INIT:
                let arguments = call.arguments as! [String: Any]
                let appID = arguments["appID"] as! String
                let appKey = arguments["appKey"] as! String
                let cameraEnabled = arguments["cameraEnabled"] as! Bool
                let gallerySelectionEnabled = arguments["gallerySelectionEnabled"] as! Bool
                let teamMemberInfoVisible = arguments["teamMemberInfoVisible"] as! Bool
                let responseExpectationEnabled = arguments["responseExpectationEnabled"] as! Bool
                let showNotificationBanner = arguments["showNotificationBanner"] as! Bool
                let notificationSoundEnabled = arguments["notificationSoundEnabled"] as! Bool
                
                let freshchatConfig = FreshchatConfig.init(appID: appID, andAppKey: appKey)

                freshchatConfig?.gallerySelectionEnabled = gallerySelectionEnabled
                freshchatConfig?.cameraCaptureEnabled = cameraEnabled
                freshchatConfig?.teamMemberInfoVisible = teamMemberInfoVisible 
                freshchatConfig?.showNotificationBanner = showNotificationBanner 
                freshchatConfig?.responseExpectationVisible = responseExpectationEnabled
                freshchatConfig?.notificationSoundEnabled = notificationSoundEnabled

                Freshchat.sharedInstance().initWith(freshchatConfig)
                
                result(true)

            case SwiftFlutterFreshchatPlugin.METHOD_IDENTIFY_USER:
                let arguments = call.arguments as! [String: String]
                let externalId = arguments["externalID"]
                var restoreId = arguments["restoreID"]

                if (restoreId == "") {
                    Freshchat.sharedInstance().identifyUser(withExternalID: externalId, restoreID: nil)
                    restoreId = FreshchatUser.sharedInstance().restoreID
                } else {
                    Freshchat.sharedInstance().identifyUser(withExternalID: externalId, restoreID: restoreId)
                }
                result(restoreId)

            case SwiftFlutterFreshchatPlugin.METHOD_UPDATE_USER_INFO:
                let arguments = call.arguments as! [String: Any]
                let customProperties = arguments["custom_property_list"] as? [String: String]
                let user = FreshchatUser.sharedInstance()
                user?.firstName = arguments["first_name"] as? String
                user?.lastName = arguments["last_name"] as? String
                user?.phoneNumber  = arguments["phone"] as? String
                user?.email = arguments["email"] as? String
                user?.phoneCountryCode = arguments["phone_country_code"] as? String

                Freshchat.sharedInstance().setUser(user)

                for (kind, value) in customProperties ?? [:] {
                    Freshchat.sharedInstance().setUserPropertyforKey(kind, withValue: value)
                }

                result(true)

            case SwiftFlutterFreshchatPlugin.METHOD_SHOW_CONVERSATIONS:
                let arguments = call.arguments as! [String: Any]
                let tags = arguments["tags"] as! [String]
                let title = arguments["title"] as? String

                if (tags.count > 0) {
                    let options = ConversationOptions.init()
                    options.filter(byTags: tags, withTitle: title)

                    Freshchat.sharedInstance().showConversations(vc, with: options)
                } else {
                    Freshchat.sharedInstance().showConversations(vc)
                }
                result(true)

            case SwiftFlutterFreshchatPlugin.METHOD_SHOW_FAQS:
                let arguments = call.arguments as! [String: Bool]
                let options = FAQOptions.init()
                options.showFaqCategoriesAsGrid = arguments["showFaqCategoriesAsGrid"] ?? false
                options.showContactUsOnAppBar = arguments["showContactUsOnAppBar"] ?? false
                options.showContactUsOnFaqScreens = arguments["showContactUsOnFaqScreens"] ?? false
                Freshchat.sharedInstance().showFAQs(vc, with: options)
                result(true)

            case SwiftFlutterFreshchatPlugin.METHOD_GET_UNREAD_MESSAGE_COUNT:
                Freshchat.sharedInstance().unreadCount { (count:Int) -> Void in
                    result(count)
                }

            case SwiftFlutterFreshchatPlugin.METHOD_SETUP_PUSH_NOTIFICATIONS:
                let arguments = call.arguments as! [String: String]
                let token:String = arguments["token"] ?? ""
                Freshchat.sharedInstance().setPushRegistrationToken(token.data(using: .utf8))
                result(true)

            case SwiftFlutterFreshchatPlugin.METHOD_RESET_USER:
                Freshchat.sharedInstance().resetUser(completion: { () in
                    result(true)
                })

            default:
                result(false)
        }
    }
}
