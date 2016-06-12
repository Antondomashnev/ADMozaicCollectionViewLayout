Pod::Spec.new do |s|

  s.name         = 'ADMozaikCollectionViewLayout'
  s.version      = '1.0.0'
  s.summary      = "Custom mozaic style collection view layout"

  s.description  = <<-DESC
                    ADMozaicCollectionViewLayout is yet another UICollectionViewLayout subclass that implements "brick" or "mozaic" layout.
                   DESC

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = 'https://github.com/Antondomashnev/ADMozaicCollectionViewLayout'
  s.author       = { 'Anton Domashnev' => 'antondomashnev@gmail.com' }

  s.source       = { :git => "https://github.com/Antondomashnev/ADPuzzleAnimation.git", :tag => s.version.to_s}
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/**/*.swift'

end
