platform :ios, '11.2'
use_frameworks!

target 'Wayfindr Demo' do
  pod 'AEXML', '~> 4.3.3'
  pod 'Alamofire', '~> 4.8.1'
  pod 'Moya', '~> 12.0.1'
  pod 'SwiftGraph', '~> 2.0.0'
  pod 'SwiftyJSON', '~> 4.2.0'
  pod 'SVProgressHUD', '~> 2.2.5'
  pod 'BlueCatsSDK', :git => 'https://github.com/bluecats/bluecats-ios-sdk.git'
end

target 'Wayfindr DemoTests' do
  pod 'AEXML', '~> 4.3.3'
  pod 'SwiftyJSON', '~> 4.2.0'
  pod 'SwiftGraph', '~> 2.0.0'
  pod 'OHHTTPStubs', '~> 6.1.0'
  pod 'BlueCatsSDK', :git => 'https://github.com/bluecats/bluecats-ios-sdk.git'
end

post_install do | installer |
  installer.pods_project.targets.each do |target|
    if target.name == 'Pods'
      require 'fileutils'
      FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'Wayfindr Demo/Resources/Settings/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    end
  end
end

class ::Pod::Generator::Acknowledgements
  def header_text
    "Wayfindr uses "
  end
end
