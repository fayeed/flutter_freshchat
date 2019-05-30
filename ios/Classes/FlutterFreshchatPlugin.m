#import "FlutterFreshchatPlugin.h"
#import <flutter_freshchat/flutter_freshchat-Swift.h>

@implementation FlutterFreshchatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFreshchatPlugin registerWithRegistrar:registrar];
}
@end
