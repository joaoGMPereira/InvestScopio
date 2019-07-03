use_frameworks!
platform :ios, '11.0'


def all_pods
  #Security
  pod 'SwiftKeychainWrapper'
  pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift', :branch => 'master'
  
  #UIPods
  pod 'Hero', :git => 'https://github.com/barrault01/Hero.git', :commit => '6220387'
  pod 'lottie-ios'
  pod 'Charts'
  pod 'SkeletonView', :git => 'https://github.com/Juanpe/SkeletonView.git', :branch => 'master'
  pod 'BetterSegmentedControl', '~> 1.1'
  pod 'StepView'
  pod 'ZCAnimatedLabel', :git => 'https://github.com/joaoGMPereira/ZCAnimatedLabel.git'
  
  
  #Resquests
  pod 'Alamofire'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
end

target 'InvestScopio' do
  all_pods
end

target 'InvestScopioDev' do
  all_pods
end

