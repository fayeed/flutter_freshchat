#import "FlutterFreshchatPlugin.h"
#if __has_include(<flutter_freshchat/flutter_freshchat-Swift.h>)
#import <flutter_freshchat/flutter_freshchat-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_freshchat-Swift.h"
#endif

@implementation FlutterFreshchatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFreshchatPlugin registerWithRegistrar:registrar];
}
@end
