waxClass{"ViewController", UIViewController}

function viewDidLoad(self)
  button = UIButton:buttonWithType(UIButtonTypeRoundedRect)
  button:addTarget_action_forControlEvents(self, "button2Clicked", UIControlEventTouchUpInside)
  button:setTitle_forState("dynamically created button", UIControlStateNormal)
  button:setFrame(CGRect(80, 210, 160, 40))
  self:view():addSubview(button)
end

function button2Clicked(self, sender)
  local testBlock = BlockTestClass:init()
  -- local message = testBlock:isAlive()
  -- test if the objectivec class is alive
  -- alert = UIAlertView:initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Profit!", message, nil, "nice!", nil)
  -- alert:show()
  testFun(a)
  testBlock:testBlockFunction(
  toobjc(
    function(message)
      alert = UIAlertView:initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Called from block!", message, nil, "nice!", nil)
      alert:show()
    end
  ):asVoidMonadicBlock())
end

function testFun(block)
  a =1
end
