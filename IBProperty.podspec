#
#  Be sure to run `pod spec lint IBProperty.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "IBProperty"
  s.version      = "1.2.1"
  s.ios.deployment_target = '9.0'
  s.summary      = "A iOS Kit which would adapt screen by XIB and Storyboard  better， and  use better  for XIB  and Storyboard。"
  #s.description  = <<-DESC
  #                 DESC

  s.homepage     = "https://github.com/SunriseOYR/IBProperty"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = "Oranges and lemons"
  s.social_media_url   = "https://www.jianshu.com/u/80c622a1fe98"
  s.source       = { :git => "https://github.com/SunriseOYR/IBProperty.git", :tag => "v#{s.version}" }
  s.source_files  = "IBProperty","IBProperty/**/*"
  s.requires_arc = true
  s.dependency "Aspects", "~> 1.4.1"
#  s.public_header_files = 'IBProperty/ORIBProperty.h'

 s.subspec 'Basis' do |ss|
    ss.ios.deployment_target = '9.0'

    ss.source_files = "IBProperty/Basis/**/*.{h,m}"
    ss.requires_arc = true
    ss.dependency "Aspects", "~> 1.4.1"
  end

end