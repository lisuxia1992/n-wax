waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:whiteColor())
  local view = ViewController:init()
  self.window:addSubview(view)
  self.window:makeKeyAndVisible()
end
