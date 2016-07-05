Pod::Spec.new do |s|

  s.name                 = "MKScanner"
  s.version              = "0.0.1"
  s.summary              = "QRCode Scanner"
  s.homepage             = "https://github.com/Mekor/MKScanner"
  s.license              = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Mekor" => "mekor@live.cn" }
  s.social_media_url   = "http://weibo.com/gliii"
  s.platform             = :ios, "7.0"
  s.source               = { :git => "https://github.com/Mekor/MKScanner.git", :tag => s.version }
  s.source_files          = "MKScanner/**/*.{h,m}"
  #s.resources          = "MKScanner/**/*.png"
  s.requires_arc         = true

end