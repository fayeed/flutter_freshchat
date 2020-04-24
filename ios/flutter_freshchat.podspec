  #
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_freshchat'
  s.version          = '0.0.5'
  s.summary          = 'A Flutter plugin for integrating Freshchat in your mobile app.'
  s.description      = <<-DESC
A Flutter plugin for integrating Freshchat in your mobile app.
                       DESC
  s.homepage         = 'https://github.com/fayeed/flutter_freshchat'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fayeed Pawaskar' => 'fayeed@live.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m,swift}'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'FreshchatSDK'
  s.frameworks 			 = "Foundation", "AVFoundation", "AudioToolbox", "CoreMedia", "CoreData", "ImageIO", "Photos", "SystemConfiguration", "Security", "WebKit"
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end

