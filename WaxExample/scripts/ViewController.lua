waxClass{"ViewController", UIViewController}

function viewDidLoad(self)
  button = UIButton:buttonWithType(UIButtonTypeRoundedRect)
  button:addTarget_action_forControlEvents(self, "button2Clicked", UIControlEventTouchUpInside)
  button:setTitle_forState("dynamically created button", UIControlStateNormal)
  button:setFrame(CGRect(80, 210, 160, 40))
  self:view():addSubview(button)
end

function button2Clicked(self, sender)
  alert = UIAlertView:initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Profit!", "This button was created directly from lua code!", nil, "nice!", nil)
  alert:show()
end
