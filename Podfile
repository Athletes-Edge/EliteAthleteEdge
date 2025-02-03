# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EliteAthleteEdge' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EliteAthleteEdge
pod 'IQKeyboardManagerSwift'
pod 'Cosmos'
pod 'LGSideMenuController','2.1.1'
pod 'Alamofire'
pod 'AlamofireImage'
pod 'SwiftyJSON'
pod 'FlagPhoneNumber'
pod 'JGProgressHUD'
pod "AlignedCollectionViewFlowLayout"
#pod 'VerticalCardSwiper'
pod 'iOSDropDown'
pod 'YPImagePicker'
pod 'NVActivityIndicatorView'
pod 'ReachabilitySwift'
pod 'SDWebImage'

pod 'FirebaseCore'
pod 'FirebaseMessaging'
pod 'FirebaseAuth'
pod 'FirebaseStorage'
pod 'FirebaseFirestore'
pod 'FirebaseFirestoreSwift'
pod 'Firebase/DynamicLinks'
pod 'FormTextField'
pod 'Stripe'

  target 'EliteAthleteEdgeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'EliteAthleteEdgeUITests' do
    # Pods for testing
  end

end
post_install do |installer|
  # Set iOS deployment target
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end

  # Modify compiler flags for BoringSSL-GRPC
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end
