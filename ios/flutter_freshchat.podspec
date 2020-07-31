#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_freshchat'
  s.version          = '0.0.4'
  s.summary          = 'A Flutter plugin for integrating Freshchat in your mobile app.'
  s.description      = <<-DESC
A Flutter plugin for integrating Freshchat in your mobile app.
                       DESC
  s.homepage         = 'https://github.com/fayeed/flutter_freshchat'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fayeed Pawaskar' => 'fayeed@live.com' }
  s.source           = { :git => "https://github.com/freshdesk/freshchat-ios.git", :tag => "3.4.0" }
  s.source_files = 'Classes/**/*'
  # s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '4.2'

  s.frameworks = "Foundation", "AVFoundation", "AudioToolbox", "CoreMedia", "CoreData", "ImageIO", "Photos", "SystemConfiguration", "Security", "WebKit"
  s.dependency 'FreshchatSDK'

  s.static_framework = true
end
