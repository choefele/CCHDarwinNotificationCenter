Pod::Spec.new do |spec|
  spec.name     = 'CCHDarwinNotificationCenter'
  spec.version  = '1.0.2'
  spec.license  = 'MIT'
  spec.summary  = 'Inter-process signaling for iOS and OS X with addressable receivers using the Darwin notification center.'
  spec.homepage = 'https://github.com/choefele/CCHDarwinNotificationCenter'
  spec.authors  = { 'Claus Höfele' => 'claus@claushoefele.com' }
  spec.social_media_url = 'https://twitter.com/claushoefele'
  spec.source   = { :git => 'https://github.com/choefele/CCHDarwinNotificationCenter.git', :tag => spec.version.to_s }
  spec.requires_arc = true

  spec.ios.deployment_target = '7.0'
  spec.osx.deployment_target = '10.9'

  spec.source_files = 'CCHDarwinNotificationCenter/*.{h,m}'
  spec.private_header_files = 'CCHDarwinNotificationCenter/CCHDarwinNotificationCenterUtils.h'
end
