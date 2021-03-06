#
# Be sure to run `pod lib lint ORLocation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ORLocation'
  s.version          = '4.0.0'
  s.summary          = 'ORLocation - helpers to work with location services, etc.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'ORCurrentLocationDetector - simple way to detect current user location with completion block.
ORMapsHelper - mapItemWithCoordinate & mapItemsForAddress.'
                       DESC

  s.homepage         = 'https://github.com/Omega-R/ORLocation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maxim Soloviev' => 'maxim@omega-r.com', 'Egor Lindberg' => 'egor-lindberg@omega-r.com' }
  s.source           = { :git => 'https://github.com/Omega-R/ORLocation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/ORLocation/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ORLocation' => ['ORLocation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreLocation', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
