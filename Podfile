platform :ios, '9.0'
use_frameworks!

target 'Wayfindr Demo' do
  pod 'AEXML', '~> 4.0.2'
  pod 'Alamofire', '~> 4.3.0'
  pod 'Moya', '~> 8.0.1'
  pod 'SwiftGraph', '~> 1.2.0'
  pod 'SwiftyJSON', '~> 3.1.4'
  pod 'SVProgressHUD', '~> 2.1.2'
  pod 'BlueCatsSDK', :git => 'https://github.com/bluecats/bluecats-ios-sdk.git'
end

target 'Wayfindr DemoTests' do
  pod 'AEXML', '~> 4.0.2'
  pod 'SwiftyJSON', '~> 3.1.4'
  pod 'SwiftGraph', '~> 1.2.0'
  pod 'OHHTTPStubs', '~> 4.6'
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
