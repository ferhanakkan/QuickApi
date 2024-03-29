Pod::Spec.new do |s|
  s.name             = 'QuickApi'
  s.version          = '1.0.1'
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

  s.source_files = 'Sources/QuickApi/**/*'
  s.dependency 'Alamofire', '~> 5.4.0'
end
