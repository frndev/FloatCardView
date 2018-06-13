
Pod::Spec.new do |s|
  s.name         = "FloatCardView"
  s.version      = "0.0.1"
  s.summary      = "A CardView with some shadows and a footer view."
  s.homepage     = "https://github.com/frndev/FloatCardView"
  s.license      = { :type => "MIT" }
  s.author             = "frndev"
  s.platform = :ios, "9.0"
  s.source       = { :git => "https://github.com/frndev/FloatCardView.git", :tag => "#{s.version}" }
  s.swift_version = "4.1"
  s.source_files     = 'FloatCardView/*'
  s.requires_arc = true
end
