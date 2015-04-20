Pod::Spec.new do |s|
  s.name             = "Orbit"
  s.version          = "0.2.0"
  s.summary          = "A simple dependency injection framework."
  s.description      = <<-DESC
			Orbit is a simple dependency injection framework for Obj-C. 
                       DESC
  s.homepage         = "https://github.com/escoz/Orbit"
  s.license          = 'MIT'
  s.author           = { "Eduardo Scoz" => "eduardoscoz@gmail.com" }
  s.source           = { :git => "https://github.com/escoz/Orbit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/escoz'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
