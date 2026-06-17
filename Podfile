platform :ios, '16.0'

target 'Navigation' do
  use_frameworks!

  pod 'FirebaseCore'
  pod 'Firebase/Auth'
end

target 'StorageService' do
  use_frameworks!
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end