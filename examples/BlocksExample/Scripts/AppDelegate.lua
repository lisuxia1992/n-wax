require "ViewController"
require "BlockTestClass"

waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:whiteColor())
  self.window:makeKeyAndVisible()

  self.viewController = ViewController:init()
  self.window:addSubview(self.viewController:view())
end
