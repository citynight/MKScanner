Pod::Spec.new do |s|
  s.name             = "MKScanner"
  s.version          = "1.0.0"
  s.summary          = "A QRCode scanner."
  s.description      = <<-DESC
                       A QRCode scanner, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/Mekor/MKScaner"
  # s.screenshots      = "https://raw.githubusercontent.com/Mekor/MKScanner/master/screenshots_0.png", "https://raw.githubusercontent.com/Mekor/MKScanner/master/screenshots_1.png", "https://raw.githubusercontent.com/Mekor/MKScanner/master/screenshots_2.png"
  s.license          = 'MIT'
  s.author           = { "李小争" => "hiccer@163.com" }
  s.source           = { :git => "https://github.com/Mekor/MKScaner.git", :tag => s.version.to_s }
  # s.social_media_url = 'http://weibo.com/gliii'

  s.platform     = :ios, '7.1'
  # s.ios.deployment_target = '7.1'
  # s.osx.deployment_target = '10.11'
  s.requires_arc = true

  s.source_files = 'MKScanner/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end