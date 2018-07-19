# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CMMApp' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for CMMApp
  pod 'Parse'
  pod 'AFNetworking'
  pod 'Bolts'
  pod 'Masonry'
  pod 'MBProgressHUD'
  pod 'NgKeyboardTracker'
  pod 'DateTools'
  pod 'CCDropDownMenus'
end
post_install do |lib|
    lib.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
    end
end
