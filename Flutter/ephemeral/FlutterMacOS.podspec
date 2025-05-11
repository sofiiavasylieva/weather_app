#
# NOTE: This podspec is NOT to be published. It is only used as a local reference.
#

Pod::Spec.new do |s|
  s.name                  = 'FlutterMacOS'
  s.version               = '1.0.0'
  s.summary               = 'Flutter macOS Embedding'
  s.description           = <<-DESC
Flutter is Google's mobile app SDK for crafting high-quality native experiences on iOS, Android, and desktop in record time. It works with existing code, is used by developers and organizations around the world, and is free and open source. This pod embeds the macOS version of the Flutter engine.
                            DESC
  s.homepage              = 'https://flutter.dev'
  s.license               = { :type => 'BSD' }
  s.author                = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.source                = { :git => 'https://github.com/flutter/engine', :tag => s.version.to_s }
  s.platform              = :osx, '10.14'
  s.pod_target_xcconfig   = { 'DEFINES_MODULE' => 'YES' }
  s.vendored_frameworks   = 'FlutterMacOS.framework'
end
