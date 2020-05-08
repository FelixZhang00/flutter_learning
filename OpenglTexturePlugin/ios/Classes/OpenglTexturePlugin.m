#import "OpenglTexturePlugin.h"
#if __has_include(<OpenglTexturePlugin/OpenglTexturePlugin-Swift.h>)
#import <OpenglTexturePlugin/OpenglTexturePlugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "OpenglTexturePlugin-Swift.h"
#endif

@implementation OpenglTexturePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenglTexturePlugin registerWithRegistrar:registrar];
}
@end
