The Problem
-----------
```
#define WAX_METHOD(_type_) \
static _type_ WAX_METHOD_NAME(_type_)(id self, SEL _cmd, ...) { \
va_list args; \
va_start(args, _cmd); \
va_list args_copy; \
va_copy(args_copy, args); \
/* Grab the static L... this is a hack */ \
lua_State *L = wax_currentLuaState(); \
BEGIN_STACK_MODIFY(L); \
int result = pcallUserdata(L, self, _cmd, args_copy); \
va_end(args_copy); \
va_end(args); \
if (result == -1) { \
    luaL_error(L, "Error calling '%s' on '%s'\n%s", _cmd, [[self description] UTF8String], lua_tostring(L, -1)); \
} \
else if (result == 0) { \
    _type_ returnValue; \
    bzero(&returnValue, sizeof(_type_)); \
    END_STACK_MODIFY(L, 0) \
    return returnValue; \
} \
\
NSMethodSignature *signature = [self methodSignatureForSelector:_cmd]; \
_type_ *pReturnValue = (_type_ *)wax_copyToObjc(L, [signature methodReturnType], -1, nil); \
_type_ returnValue = *pReturnValue; \
free(pReturnValue); \
END_STACK_MODIFY(L, 0) \
return returnValue; \
}
```

This method above is the problem, more specifically this snippet:
```
va_list args; \
va_start(args, _cmd); \
va_list args_copy; \
va_copy(args_copy, args); \
/* Grab the static L... this is a hack */ \
lua_State *L = wax_currentLuaState(); \
BEGIN_STACK_MODIFY(L); \
int result = pcallUserdata(L, self, _cmd, args_copy); \
```

va_start(args, _cmd); \

After this line, args was supposed to contain a pointer pointing to the top of the stack, directly to the args of the invocation, this happens under armv7 and armv7s archs, but not in armv64 unfortunatelly, apple messed out with it maybe... The problem is later, in pcallUserdata:

```
for (int i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        int size = wax_fromObjc(L, type, args);
        args += size; // HACK! Since va_arg requires static type, I manually increment the args
    }
```

this snippet was supposed to receive a pointer to the argument list from the other method so that it could iterate on it and grab the arguments one by one, but this is not happening, I'm trying to debug and find a deterministic behaviour to va_start, sometimes I can get the arguments by pointing to args-24 and them read then backwards, args-32 and so on, sometimes no, does anyone know how to use va_list and va_start successfully in apple's arm64 arch? Or maybe have any ideas for changing the way we grab the args? The patch I've made is working in the x64 simulator, but not on devices.


Wax X86_64
----------
Apple:
``
Beginning on February 1, 2015 new iOS apps submitted to the App Store must include 64-bit support and be built with the iOS 8 SDK. Beginning June 1, 2015 app updates will also need to follow the same requirements. To enable 64-bit in your project, we recommend using the default Xcode build setting of “Standard architectures” to build a single binary with both 32-bit and 64-bit code.
``

The original version of Wax is not compatible with x64 systems, which means that if you use
wax in your application you'll have to update it to this fork's version where i've made some hacks to 
make it compatible with x64 systems.

Wax
---

Wax is a framework that lets you write native iPhone apps in 
[Lua](http://www.lua.org/about.html). It bridges Objective-C and Lua using the 
Objective-C runtime. With Wax, **anything** you can do in Objective-C is **automatically**
available in Lua! What are you waiting for, give it a shot!

Why write iPhone apps in Lua?
-----------------------------

I love writing iPhone apps, but would rather write them in a dynamic language than in Objective-C. Here 
are some reasons why many people prefer Lua + Wax over Objective-C...

* Automatic Garbage Collection! Gone are the days of alloc, retain, and release.

* Less Code! No more header files, no more static types, array and dictionary literals! 
  Lua enables you to get more power out of less lines of code.

* Access to every Cocoa, UITouch, Foundation, etc.. framework, if it's written in Objective-C, 
  Wax exposes it to Lua automatically. All the frameworks you love are all available to you!

* Super easy HTTP requests. Interacting with a REST webservice has never been eaiser

* Lua has closures, also known as blocks! Anyone who has used these before knows how powerful they can be.

* Lua has a build in Regex-like pattern matching library.

Examples
--------

For some simple Wax apps, check out the [examples folder](http://github.com/probablycorey/wax/tree/master/examples/).

How would I create a UIView and color it red?

    -- forget about using alloc! Memory is automatically managed by Wax
    view = UIView:initWithFrame(CGRect(0, 0, 320, 100))

    -- use a colon when sending a message to an Objective-C Object
    -- all methods available to a UIView object can be accessed this way
    view:setBackgroundColor(UIColor:redColor())

What about methods with multiple arguments?

    -- Just add underscores to the method name, then write the arguments like
    -- you would in a regular C function
    UIApplication:sharedApplication():setStatusBarHidden_animated(true, false)

How do I send an array/string/dictionary

    -- Wax automatically converts array/string/dictionary objects to NSArray,
    -- NSString and NSDictionary objects (and vice-versa)
    images = {"myFace.png", "yourFace.png", "theirFace.png"}
    imageView = UIImageView:initWithFrame(CGRect(0, 0, 320, 460))
    imageView:setAnimationImages(images)

What if I want to create a custom UIViewController?

    -- Created in "MyController.lua"
    --
    -- Creates an Objective-C class called MyController with UIViewController
    -- as the parent. This is a real Objective-C object, you could even
    -- reference it from Objective-C code if you wanted to.
    waxClass{"MyController", UIViewController}

    function init()
      -- to call a method on super, simply use self.super
      self.super:initWithNibName_bundle("MyControllerView.xib", nil)
      return self
    end

    function viewDidLoad()
      -- Do all your other stuff here
    end

You said HTTP calls were easy, I don't believe you...

    url = "http://search.twitter.com/trends/current.json"

    -- Makes an asyncronous call, the callback function is called when a
    -- response is received
    wax.http.request{url, callback = function(body, response)
      -- request is just a NSHTTPURLResponse
      puts(response:statusCode())

      -- Since the content-type is json, Wax automatically parses it and places
      -- it into a Lua table
      puts(body)
    end}

Since Wax converts NSString, NSArray, NSDictionary and NSNumber to native Lua values, you have to force objects back to Objective-C sometimes. Here is an example.

    local testString = "Hello lua!"
    local bigFont = UIFont:boldSystemFontOfSize(30)
    local size = toobjc(testString):sizeWithFont(bigFont)
    puts(size)

Setup & Tutorials
-----------------

[Setting up Wax](https://github.com/probablycorey/wax/wiki/Installation)

[How does Wax work?](https://github.com/probablycorey/wax/wiki/Overview)

[Simple Twitter client in Wax](https://github.com/probablycorey/wax/wiki/Twitter)

Which API's are included?
-------------------------

They all are! I can't stress this enough, anything that is written in Objective-C (even external frameworks) will work automatically in Wax! UIAcceleration works like UIAcceleration, MapKit works like MapKit, GameKit works like GameKit, Snozberries taste like Snozberries!

Created By
----------
Corey Johnson (probablycorey at gmail dot com)

More
----
* [Feature Requests? Bugs?](http://github.com/probablycorey/wax/issues) - Issue tracking and release planning.
* [Mailing List](http://groups.google.com/group/iphonewax)
* [IRC: #wax](irc://chat.freenode.net/#wax) on http://freenode.net
* Quick question or problem? IM **probablyCorey** on AIM

Contribute
----------
Fork it, change it, commit it, push it, send pull request; instant glory!


The MIT License
---------------
Wax is Copyright (C) 2009 Corey Johnson See the file LICENSE for information of licensing and distribution.
