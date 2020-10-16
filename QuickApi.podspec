#
# Be sure to run `pod lib lint QuickApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QuickApi'
  s.version          = '0.1.4'
  s.summary          = 'QuickApi is a easiest solution for your network layer. You can do your requests just in one line of code.'

  s.description      = <<-DESC
  'QuickApi is a most basic way to do your request. Also with QuickApi you can do get, post, delete and multipart requests.'
                       DESC

  s.homepage         = 'https://github.com/ferhanakkan/QuickApi'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ferhan Akkan' => 'ferhanakkan@gmail.com' }
  s.source           = { :git => 'https://github.com/ferhanakkan/QuickApi.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = "5.0"
  s.platforms = {
      "ios": "11.0"
  }

  s.source_files = 'QuickApi/Classes/**/*'
  s.resource = 'QuickApi/Resources/*'
  
  s.dependency 'Alamofire', '~> 5.2'
  s.dependency "PromiseKit", "~> 6.8"
end
