

Pod::Spec.new do |s|
  
  s.name         = "ZXScrollPageView"
  s.version      = "1.1.0"
  s.summary      = "一个可滚动pageView"
  s.platform     = :ios, "7.0"

  s.homepage     = "https://github.com/anphen/ZXScrollPageView"

  s.license      = "MIT"

  s.author             = { "anphen" => "zxlx276@163.com" }

  s.source       = { :git => "https://github.com/anphen/ZXScrollPageView.git", :tag => "#{s.version}" }

  s.source_files  =  "ZXScrollPageView/*"

end
