# Uncomment this line to define a global platform for your project
platform :ios, "15.0"

use_modular_headers!

def shared_pods
  pod 'TinyConstraints' # , :git => 'https://github.com/roberthein/TinyConstraints.git', :branch => 'release/Swift-4.2'
  pod 'Reveal-SDK', :configurations => ['debug']
  pod 'SVProgressHUD'
end

target "StarWarsStarships" do
    shared_pods
end
