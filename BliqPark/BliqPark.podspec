Pod::Spec.new do |s|

  s.name         = "BliqPark"
  s.version      = "2.0.6"
  s.summary      = "Framework to use the Bliq`s parking services to find a free parking spot."
  s.swift_version = '4.2'

  s.description  = "Bliq Park offers detailed parking information in more than 500 cities across 15 countries. You can find further information and documentation on how to get started on https://www.aipark.io. "

  s.homepage     = "https://github.com/Bliq-Open-Source/BliqPark-iOS"

  s.license      = { :type => "Creative Commons BY NC SA 4.0", :file => "LICENSE" }
  s.author       = { "Julian Glaab" => "julian@aipark.io" }

  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/Bliq-Open-Source/BliqPark-iOS.git", :tag => "2.0.6" }

  s.source_files  = "BliqPark/*.swift", "BliqPark/**/*.swift"

  s.dependency "Alamofire", "~> 4.9.0"

end
