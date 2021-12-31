#
# Be sure to run `pod lib lint QfGameSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QfGameSDK'#名称
  s.version          = '2.0.1.7'#版本号
  s.summary          = '七风游戏访客端 iOS SDK.'#简短介绍，下面是详细介绍
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://www.119you.com/'#主页,这里要填写可以访问到的地址，不然验证不通过
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'#截图
  s.license          = { :type => 'MIT', :file => 'LICENSE' }#开源协议
  s.author           = { '1006052895@qq.com' => '1006052895@qq.com' }#作者信息
  s.source           = { :git => 'https://github.com/X-Mai/QfGameSDK.git', :tag => s.version.to_s }#项目地址，这里不支持ssh的地址，验证不通过，只支持HTTP和HTTPS，最好使用HTTPS
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'#多媒体介绍地址

  s.platform = :ios, '9.0'#支持的平台及版本
  s.ios.deployment_target = '9.0'#支持的版本

  s.source_files = 'QfGameSDK/Classes/DJSDK.h'#代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置
  
  # s.resource_bundles = {
  #   'QfGameSDK' => ['QfGameSDK/Assets/*.png']
  # }#资源文件地址

#   s.public_header_files = 'QfGameSDK/Classes/DJSDK.h'#公开头文件地址
  # s.frameworks = 'UIKit', 'MapKit'#所需的framework，多个用逗号隔开
  # s.dependency 'AFNetworking', '~> 2.3'#依赖关系，该项目所依赖的其他库，如果有多个需要填写多个s.dependency

  
  
#  #20211229 注释掉：使用七鱼对应的QY_iOS_SDK
#  s.vendored_frameworks = '**/QYSDK.framework','**/NIMSDK.framework'#手动依赖第三方framework
#  s.resources  = ['QfGameSDK/Assets/QYResource.bundle', 'QfGameSDK/Assets/QYLanguage.bundle', 'QfGameSDK/Assets/QYCustomResource.bundle','QfGameSDK/Assets/DJSDK2.0.bundle']
#  s.framework = 'AVFoundation', 'UIKit', 'SystemConfiguration', 'MobileCoreServices', 'WebKit', 'CoreTelephony', 'CoreText', 'CoreMedia', 'ImageIO', 'CoreMotion', 'AudioToolbox', 'Photos', 'AssetsLibrary', 'Accelerate','GameKit','JavaScriptCore','CoreFoundation','AdSupport'
#  s.libraries = 'c++', 'z','sqlite3.0','xml2'
    
    
  #20211229 使用七鱼对应的非本地资源管理
  s.dependency 'QY_iOS_SDK', '~>6.11.0'#通过Pod依赖的第三方库，多个库就多个s.dependency
  s.dependency 'NIMSDK_LITE', '8.8.3'
  s.framework = 'GameKit','JavaScriptCore','CoreFoundation','AdSupport'#如果使用pod管理QY_iOS_SDK情况下，需要添加自己开发的.a静态库对应依赖framework库
  s.resource = 'QfGameSDK/Assets/DJSDK2.0.bundle'#如果使用pod管理QY_iOS_SDK情况下，需要添加自己开发的.a静态库对应依赖的资源文件



  s.vendored_libraries = '**/libDJSDK.a'#手动依赖第三方.a文件
  
  
  s.requires_arc = true

end

