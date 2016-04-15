platform :ios, '9.0'
use_frameworks!

pod 'AEXML', '~> 2.0'
pod 'Alamofire', '~> 3.1'
pod 'GRValidation', '~> 0.2'
pod 'Moya', '~> 6.0'
pod 'SwiftGraph', '~> 1.0'
pod 'SwiftyJSON', '~> 2.3'
pod 'SVProgressHUD', '2.0-beta'

target 'Wayfindr DemoTests' do
  pod 'OHHTTPStubs', '~> 4.6'
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
