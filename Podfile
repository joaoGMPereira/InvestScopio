use_frameworks!
platform :ios, '13.0'


def all_pods
  #Security
  pod 'SwiftKeychainWrapper'
  pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift', :branch => 'master'
  
  #UIPods
  pod 'Hero', :git => 'https://github.com/barrault01/Hero.git', :commit => '6220387'
  pod 'Charts'
  pod 'lottie-ios'
  pod 'SkeletonView', :git => 'https://github.com/Juanpe/SkeletonView.git', :branch => 'master'
  pod 'BetterSegmentedControl', '~> 1.1'
  pod 'StepView'
  pod 'ZCAnimatedLabel', :git => 'https://github.com/joaoGMPereira/ZCAnimatedLabel.git'
  
  
  pod 'JewFeatures', :path => '../JEW-FEATURE'
  
  #Resquests
  pod 'Alamofire'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
end

target 'InvestScopio' do
  all_pods
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
