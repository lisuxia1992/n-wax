Pod::Spec.new do |s|
  s.name         = "n-wax"
  s.version      = "1.0"
  s.summary      = "Wax is a framework that lets you write native iPhone apps in Lua."
  s.license      = "MIT"
  s.author             = { "Felipe Cavalcanti" => "fjfcavalcanti@gmail.com" }
  s.source       = { :git => "https://github.com/felipejfc/n-wax/" }
  s.ios.deployment_target = '7.0'

  s.subspec 'no-arc' do |sp|
    sp.source_files = "lib/**/*.{h,m,c,S}"
    sp.compiler_flags = '-fno-objc-arc'
  end
end
