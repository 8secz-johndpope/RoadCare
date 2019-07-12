# Uncomment the next line to define a global platform for your project
# platform :ios, '10.3'

target 'Roadcare' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Roadcare
  pod 'SideMenu'
  pod 'MBProgressHUD'
  pod 'SDWebImage', '4.2.3'
  pod 'YNExpandableCell'
  pod 'Alamofire'
  pod 'Charts'
  pod 'CountryPickerView'
  pod 'SwiftyPickerPopover', '5.3.0'
  pod 'OneSignal', '>= 2.7.1', '< 3.0'
  
  target 'RoadcareTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RoadcareUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OneSignalNotificationServiceExtension' do
    pod 'OneSignal', '>= 2.7.1', '< 3.0'
  end

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end

end

