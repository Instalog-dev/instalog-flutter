#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'instalog_ios'
  s.version          = '0.1.1'
  s.summary          = 'An iOS implementation of the instalog plugin.'
  s.description      = <<-DESC
  An iOS implementation of the instalog plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }  
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  s.dependency 'PLCrashReporter', '1.11.2'
  s.dependency "InstalogIOS", "~> 1.0.1"
  #s.vendored_frameworks = 'Frameworks/InstalogIOS.xcframework'
  #s.preserve_path = 'Frameworks/*'
  s.static_framework = true


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
