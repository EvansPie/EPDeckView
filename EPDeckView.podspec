#
# Be sure to run `pod lib lint EPDeckView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EPDeckView"
  s.version          = "0.1.0"
  s.summary          = "EPDeckView` is an easy-to-use Swift library that provides a deck of views that can be swiped or thrown left/right (inspired by the Tinder app)."

  s.description      = <<-DESC
EPDeckView is inspired by the Tinder app and provides its core functionality, while it's easy to customize it. You can swipe the cards of the deck left/right or throw them with a button click.
                       DESC

  s.homepage         = "https://github.com/EvansPie/EPDeckView"
  s.license          = 'MIT'
  s.author           = { "Evangelos Pittas" => "evangelospittas@gmail.com" }
  s.source           = { :git => "https://github.com/EvansPie/EPDeckView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hopinside'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'EPDeckView' => ['Pod/Assets/*.png']
  }

end
