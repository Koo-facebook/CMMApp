# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'CMMApp.xcworkspace'

target 'CMMApp' do
  project 'CMMApp.xcodeproj'
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for CMMApp
  pod 'Parse'
  pod 'ParseUI'
  pod 'AFNetworking'
  pod 'Bolts'
  pod 'Masonry'
  pod 'MBProgressHUD'
  pod 'DateTools'
  pod 'CCDropDownMenus'
  pod 'LGSideMenuController'
  pod 'lottie-ios'
  pod 'CMTabbarView'
  
end

target 'CMMKit' do
    project 'CMMKit/CMMKit.xcodeproj'
    #Pods for CMMKit
    
end

post_install do |lib|
    lib.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
    end
end
