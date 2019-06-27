Pod::Spec.new do |s|

  s.name         = "ZRRefresh"
  s.version      = "0.0.3"
  s.summary      = "刷新刷新组件"
  s.description  = <<-DESC
                    关于刷新组件
                   DESC

  s.homepage     = "https://dazhongge.com"
  s.license      = "MIT"
  s.author       = { "Rogue" => "619455850@qq.com" }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/RogueAndy/ZRRefresh.git", :tag => "#{s.version}" }

  s.source_files  = "ZRRefresh/*"
  s.public_header_files = "ZRRefresh/*.h"

  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
  s.dependency "MJRefresh", "3.2.0"
end
