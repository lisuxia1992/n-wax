//
//  main.m
//  WaxExample
//
//  Created by Felipe Cavalcanti on 04/03/15.
//  Copyright (c) 2015 felipejfc. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "ProtocolLoader.h"
#import "wax.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        wax_start("init", nil);
        return UIApplicationMain(argc, argv, nil, @"AppDelegate");
    }
}
