//
//  Freshchat.h
//
//
//  Copyright (c) 2017 Freshworks. All rights reserved.
//
//  Contact support@freshchat.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum TagFilterType {
    ARTICLE  = 1,
    CATEGORY = 2
};

#define FRESHCHAT_DID_FINISH_PLAYING_AUDIO_MESSAGE @"com.freshworks.freshchat_play_inapp_audio"
#define FRESHCHAT_WILL_PLAY_AUDIO_MESSAGE @"com.freshworks.freshchat_pause_inapp_audio"
#define FRESHCHAT_USER_RESTORE_ID_GENERATED @"com.freshworks.freshchat_user_restore_id_generated"
#define FRESHCHAT_USER_LOCALE_CHANGED @"com.freshworks.freshchat_user_locale_changed"
#define FRESHCHAT_UNREAD_MESSAGE_COUNT_CHANGED @"com.freshworks.freshchat_unread_message_count_changed"
#define FRESHCHAT_ACTION_USER_ACTIONS @"com.freshworks.freshchat_action_user_actions"

@class FreshchatConfig, FreshchatUser, FAQOptions, ConversationOptions, FreshchatMessage;

@interface FreshchatConfig : NSObject

/*
 * App ID of your App. This is used to identify the SDK for your app to freshchat.com.
 * Please see API & App under Settings ( https://web.freshchat.com/settings/apisdk ) to get your App ID.
 */
@property (strong, nonatomic) NSString *appID;
/*
 * App Key of your App. This is used to authenticate the SDK for your app to freshchat.io.
 * Please see API & App under Settings ( https://web.freshchat.com/settings/apisdk ) to get your App Key.
 */
@property (strong, nonatomic) NSString *appKey;
/*
 * Domain for freshchat. Do not change this.
 */
@property (strong, nonatomic) NSString *domain;
/**
 * Option to supply the SDK with your theme file's name. Make sure themeName is the same as the
 * theme plist file's name. Freshchat needs this for theming to work.
 * The setter throws an exception for an invalid filename
 */
@property (nonatomic, strong) NSString *themeName;
/**
 * Option to supply the SDK with a strings bundle for localization
 */
@property (nonatomic, strong) NSString *stringsBundle;
/*
 * Allow the user to attach images using the gallery. Defaults to YES.
 */
@property (nonatomic, assign) BOOL gallerySelectionEnabled;
/*
 * Allow the user to attach images using the camera. Defaults to YES.
 */
@property (nonatomic, assign) BOOL cameraCaptureEnabled;
/*
 * Enable alert sound when a notification is received. Defaults to YES.
 */
@property (nonatomic, assign) BOOL notificationSoundEnabled;
/*
 * Show/Hide Agent Avatar on the Chat. It is enabled by default. Default YES
 */
@property (nonatomic, assign) BOOL teamMemberInfoVisible;
/*
 * Enable/Disable Notification banner when a support message is received. Defaults to YES
 */
@property (nonatomic, assign) BOOL showNotificationBanner;
/*
 * Show/Hide Channel response time on the chat. Defaults to YES
 */
@property (nonatomic, assign) BOOL responseExpectationVisible;

/**
 *  Initialize Freshchat.
 *
 *  @discussion In order to initialize Freshchat, you'll need the App ID and App Key. Place the Freshchat initialization code in your app delegate, preferably at the top of the application:didFinishLaunchingWithOptions method.
 *
 *  @param appID  The App ID assigned to your app when it was created on the portal.
 *  @param appKey The App Key assigned to your app when it was created on the portal.
 *
 */
-(instancetype)initWithAppID:(NSString*)appID andAppKey:(NSString*)appKey;

@end

@interface Freshchat : NSObject

@property(nonatomic, strong, readonly) FreshchatConfig *config;

+(NSString *)SDKVersion;

/**
 *  Access the Freshchat instance.
 *
 *  @discussion Using the returned shared instance, you can access all the instance methods available in Freshchat.
 */
+(instancetype) sharedInstance;

/**
 *  Initialize configuration for Config.
 *
 *  @param config Freshchat Configuration of type FreshchatConfig
 */

-(void)initWithConfig:(FreshchatConfig *)config;

/**
 *  Show the Conversations / Chat to the user.
 *
 *  @discussion This method lets you launch and present the Channels list to the user. The user directly lands in the Conversation view if there is only one channel.
 *
 *  @param controller The view controller from where you present the Conversations view.
 *
 */
-(void)showConversations:(UIViewController *)controller;

/**
 *  Show the Conversations / Chat to the user.
 *
 *  @param options filter by tags
 *
 *  @discussion This method lets you launch and present the Channels list to the user. The user directly lands in the default Conversation view if no channels found.
 *
 */
-(void)showConversations:(UIViewController *)controller withOptions :(ConversationOptions *)options;

/**
 *  Show the FAQs to the user.
 *
 *  @discussion This method lets you show the FAQ view.
 *
 *  @param controller The view controller from where you present the FAQ view.
 *
 */
-(void)showFAQs:(UIViewController *)controller;

/**
 *  Show the FAQs to the user.
 *
 *  @discussion This method lets you show the FAQ view.
 *
 *  @param controller The view controller from where you present the FAQ view.
 *
 *  @param options filter by tags or control FAQ screen options
 *
 */
-(void)showFAQs:(UIViewController *)controller withOptions:(FAQOptions *)options;

/**
 *  Set user Info
 *
 *  @discussion Sends user information updates to the server. User properties such as Name, Email, Phone, Country Code and external Identifier.That are set will be synced with the server. External Identifier provided could be any unique value that your App can use to identify the user.
 *
 *  @param user User instance with the values to be updated.
 *
 */
-(void)setUser:(FreshchatUser *) user;

/**
 *  Get user Alias
 *
 *  @discussion This method lets you to get user Id in Strict Mode for setting up JWT paload
 *
 */
- (NSString *) getFreshchatUserId;

/*
 * Set user for JWT Auth strict mode
 *
 * Sync any change to user information, specified in JWT Token with Freshchat
 *
 */
- (void)setUserWithIdToken :(NSString *) jwtIdToken;

/*
 * In Auth Strict Mode get status of User Auth Token
 */
- (NSString *)getUserIdTokenStatus;

/**
*  Restore User
*
 *  @discussion To identify an user in Freshchat with an unique identifier from your system and restore an
 * user across devices/sessions/platforms based on an external identifier and restore id
*
*  @param externalID Set an identifier that your app can use to uniquely identify the user
*
*  @param restoreID Set the restore id for the user, to lookup and restore the user across devices/sessions/platforms
*
*/
-(void)identifyUserWithExternalID:(NSString *) externalID restoreID:(NSString *) restoreID;

/**
 * Identify and restore an user base on reference_id and can only be called in auth strict mode
 *
 * @param jwtIdToken Set a valid Id Token for the current user signed with your account key(s)
 *
 */
-(void)restoreUserWithIdToken:(NSString *) jwtIdToken;

/**
 *  Clear User Data
 *
 *  @discussion Use this function when your user needs to log out of the app .
 *  This will clean up all the data associated with the SDK for the user.
 *  Please use the completion block if you are updating user information or subsequently calling init
 *
 * @param Completion block to be called when clearData is completed
 *
 */
-(void)resetUserWithCompletion:(void (^)())completion;
/**
 *  Set User properties
 *
 *  @discussion Tag users with custom properties (key-value pairs) . The user properties associated here will be shown on the dashboard for the agent and also be used for segmentation for campaigns
 *
 *  @param props An NSDictionary containing the Properties for the User.
 *
 */
-(void)setUserProperties:(NSDictionary*)props;
/**
 *  Set user property
 *
 *  @discussion Use this method to update a single property for the user. Use updateUserProperties instead where possible.
 *
 *  @param key Property name
 *
 *  @param value Property value
 *
 */
-(void)setUserPropertyforKey:(NSString *) key withValue:(NSString *)value;
/**
 *  Update the APNS device token
 *
 *  @discussion Update the APNS device token when APNS registration is successful. The SDK uses this to send push notification when there are replies from the agent.
 *
 *  @param deviceToken APNS device token
 *
 */
-(void)setPushRegistrationToken:(NSData *) deviceToken;
/**
 *  Open Freshchat Deeplink
 *
 *  @discussion Handle freshchat channels,faq deeplink and present in viewController
 *
 *  @param linkStr Freshchat Deeplink String
 *
 *  @param viewController present Freshchat Screen from above the view Controller
 *
 */
-(void) openFreshchatDeeplink:(NSString *)linkStr viewController:(UIViewController *) viewController;
/**
 *  Check if a push notification was from Freshchat
 *
 *  @discussion Checks if the push notification received originated from Freshchat by examining the payload dictionary. Use this in conjunction with handleRemoteNotification
 *
 *  @param info NSDictionary object in didReceiveRemoteNotification for Push Notification.
 */
-(BOOL)isFreshchatNotification:(NSDictionary *)info;
/**
 *  Handle the Freshchat push notifications
 *
 *  @discussion Needs to be called when a push notification is received from Freshchat. This will present the conversation if user tapped on a push, or show a drop down notification, or update a currently active conversation screen depending on context.
 *
 *  @param info Dictionary received in didReceiveRemoteNotification for Push Notification.
 *  
 *  @param appState UIApplicationState object that helps the app be aware of whether it was already active and in the foreground when receiving the push notification, or was opened from the background
 */
-(void)handleRemoteNotification:(NSDictionary *)info andAppstate:(UIApplicationState)appState;
/**
 *  Get an embeddable controller for FAQs
 *
 *  @discussion Return a controller with FAQs View that can be embedded in other Controllers (e.g. in a UITabBarController )
 *
 *  @return UIController for FAQs View
 */
-(UIViewController*) getFAQsControllerForEmbed;
/**
 *  Get an embeddable controller for FAQs with filter options
 *
 *  @discussion Return a controller with Conversation view that can be embedded in other Controllers (e.g. in a UITabBarController )
 *
 *  @return UIController for FAQs filter View
 *
 */
-(UIViewController*) getFAQsControllerForEmbedWithOptions:(FAQOptions *) faqOptions;
/**
 *  Get an embeddable controller for Conversations
 *
 *  @discussion Return a controller with Conversation view that can be embedded in other Controllers (e.g. in a UITabBarController )
 *
 *  @return UIController for Conversation View
 *
 */
-(UIViewController*) getConversationsControllerForEmbed;
/**
 *  Get an embeddable controller for Conversations with filter options
 *
 *  @discussion Return a controller with Conversation view that can be embedded in other Controllers (e.g. in a UITabBarController )
 *
 *  @return UIController for Conversation filter View
 *
 */
-(UIViewController*) getConversationsControllerForEmbedWithOptions:(ConversationOptions *) convOptions;

/**
 *  Get the unread conversations count.
 *
 *  @discussion This method lets you asynchronously fetch the latest count of conversations that require the user's attention. It is updated with a 2 min interval.
 *
 *  @param completion Completion block with count.
 *
 */
-(void)unreadCountWithCompletion:(void(^)(NSInteger count))completion;

/**
 *  Get the unread conversations count.
 *
 *  @discussion This method lets you asynchronously fetch the latest count of conversations that require the user's attention. It is updated with a 2 min interval.
 *
 *  @param tags Tags of channels for which unread count is required.
 *  @param completion Completion block with count.
 *
 */
-(void)unreadCountForTags:(NSArray *)tags withCompletion:(void(^)(NSInteger count))completion;

/**
 *  Show custom banner for users in message screen
 */
-(void)updateConversationBannerMessage:(NSString *)message;

/**
 *  Send message to particular channel with specified tag value
 */
-(void) sendMessage:(FreshchatMessage *)messageObject;

/**
 *  Dismiss SDK for deeplink screens
 */
-(void) dismissFreshchatViews;

/**
 *  Code block for handling links. Return 'YES' to override default link behaviour and 'NO' to handle it on the block itself.
 */

@property (nonatomic, copy) BOOL(^customLinkHandler)(NSURL*);

/**
 *  Code block for push notification tap events . Return 'YES' to not allow channel open and 'NO' to launch the coresponding channel.
 */

@property (nonatomic, copy) BOOL(^onNotificationClicked)(NSString*);

@end


@interface FreshchatUser : NSObject

/*
 * User first name
 */
@property (strong, nonatomic) NSString *firstName;
/*
 * User last name
 */
@property (strong, nonatomic) NSString *lastName;
/*
 * User email
 */
@property (strong, nonatomic) NSString *email;
/*
 * Phone Number - Preferably Mobile Number
 */
@property (strong, nonatomic) NSString *phoneNumber;
/*
 * Phone Country Code e.g +91 for India
 */
@property (strong, nonatomic) NSString *phoneCountryCode;
/*
 * Unique identifier for the user.
 */
@property (strong, nonatomic, readonly) NSString *externalID;
/*
 * Restore id for user
 */
@property (strong, nonatomic, readonly) NSString *restoreID;

/*
 * Access the user info. If update user was called earlier, the instance would contain the persisted values.
 */
+(instancetype)sharedInstance;

@end

@interface FreshchatOptions : NSObject

@end

@interface FAQOptions : FreshchatOptions

/*
 * Option to Switch between Grid and List view in FAQs. Shows FAQ categories as a list when set to NO.
 * Default set to YES which presents a Grid view
 */
@property (nonatomic) BOOL showFaqCategoriesAsGrid;
/*
 * Option to show "contact us" button on the FAQ Screens,
 * Default set to YES which shows "contact us" button
 */
@property (nonatomic) BOOL showContactUsOnFaqScreens;
/*
 * Option to show "contact us" button on the navigation bar,
 * Default set to NO which hides "contact us" button on the navigation bar
 */
@property (nonatomic) BOOL showContactUsOnAppBar;
/*
 * Option to show conversation link on article rating bar for Negative response,
 * Default set to YES which shows conversation link there
 */
@property (nonatomic) BOOL showContactUsOnFaqNotHelpful;
/**
 *  @discussion This method lets you to filter the list of Categories or Articles by tags
 *
 *  @param Array of tags to filter by. Tags can be configured in the portal
 *
 *  @param Title for the list of filtered view
 *
 *  @param Type can be either Category or Article determining what to show. ( list of filtered articles or categories)
 */
-(void) filterByTags:(NSArray *) tags withTitle:(NSString *) title  andType : (enum TagFilterType) type;

/**
 *  @discussion This method lets you to filter the list of Channels by tags when user clicks on contact us
 *
 *  @param Array of tags to filter the channels list
 *
 *  @param Title for the list of filtered channels view
 */
-(void)filterContactUsByTags:(NSArray *) tags withTitle:(NSString *) title;
 
/**
 *  Preferred navigation bar title
 */
-(NSString *)filteredViewTitle;

/**
 *  List of tags you have supplied already
 *
 *  @discussion List of tags which are configured in portal
 */
-(NSArray *)tags;

/**
 *  Tags Filter type - FAQ's or Articles tags
 */
-(enum TagFilterType) filteredType;

/**
 *  Tags used to filter channels when clicking on "Contact Us" on FAQ screens
 */
-(NSArray *) contactUsTags;

/**
 *  Title for the list of filtered channels view which clicking "Contact Us"
 */
-(NSString *) contactUsTitle;

@end


@interface ConversationOptions : FreshchatOptions

/**
 *  Show Filtered Channels
 *
 *  @discussion This method lets you to launch and present a controller with the list of Channels filtered by the tags
 *
 *  @param Array of tags to filter the channels list
 *
 *  @param Title for the list of filtered channels view
 *
 */
-(void)filterByTags:(NSArray *)tags withTitle:(NSString *)title;

/**
 *  Preferred navigation bar title for filtered view of channels
 */
-(NSString *)filteredViewTitle;

/**
 *  Tags used for filtering the channels list
 */
-(NSArray *)tags;

@end

@interface FreshchatMessage : NSObject

/**
 *  Message text to be sent
 */
@property (strong, nonatomic) NSString *message;

/**
 *  Tag of the channel on which the message needs to be sent
 *  If tag does not match with any channel it is sent on the default channel
 */
@property (strong, nonatomic) NSString *tag;

/**
 *  Initialize the message object
 *
 *  @param Message text to send to agent
 *
 *  @param Tag of the channel on which the message needs to be sent
 */
-(instancetype)initWithMessage:(NSString *)message andTag:(NSString *)tag;

@end
