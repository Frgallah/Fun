#
# Be sure to run `pod lib lint Fun.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Fun'
  s.version          = '0.1.0'
  s.summary          = 'Interactive Core Image  transition for view controller, just for fun not for real Apps'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Interactive Core Image  transition for view controller, just for fun not for real Apps. By using a few lines of code you can get an elegant transition.
                       DESC

  s.homepage         = 'https://github.com/frgallah/Fun'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'frgallah' => 'frgallah@outlook.com' }
  s.source           = { :git => 'https://github.com/frgallah/Fun.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'Fun' => ['Fun/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'GLKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
