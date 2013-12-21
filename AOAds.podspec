#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "AOAds"
  s.version      = "0.1.0"
  s.summary      = "Ads im my projects"
  s.description  = ""
  s.homepage     = "https://github.com/alekoleg/AOAds.git"
  s.license      = 'MIT'
  s.author       = { "Oleg Alekseenko" => "alekoleg@gmail.com" }
  s.source       = { :git => "https://github.com/alekoleg/AOAds.git", :tag => s.version.to_s}
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit', 'QuartzCore'
  
end
