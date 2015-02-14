Pod::Spec.new do |s|
  s.name         = "AOAds"
  s.version      = "0.1.0"
  s.summary      = "Ads im my projects"
  s.description  = "Small library that add ads from parse.com"
  s.homepage     = "https://github.com/alekoleg/AOAds.git"
  s.license      = 'MIT'
  s.author       = { "Oleg Alekseenko" => "alekoleg@gmail.com" }
  s.source       = { :git => "https://github.com/alekoleg/AOAds.git", :tag => s.version.to_s}
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  s.resources = 'Assets/*'

  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit', 'QuartzCore', 'CoreGraphics'

end
