source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

target 'ADMozaikCollectionViewLayout' do
  pod 'Sourcery', '~> 0.5'
  pod 'FBSnapshotsViewerRunPhaseScript', '~> 0.1'

  target 'ADMozaikCollectionViewLayoutTests' do
    inherit! :search_paths
    pod 'FBSnapshotTestCase', :git=>'https://github.com/facebook/ios-snapshot-test-case.git', :branch=>'master'
    pod 'Nimble', :git=>'https://github.com/Quick/Nimble.git', :branch=>'master'
  end
end


