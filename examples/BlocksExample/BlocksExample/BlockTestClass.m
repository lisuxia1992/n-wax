//
//  BlockTestClass.m
//  BlocksExample
//
//  Created by Felipe Cavalcanti on 22/02/15.
//  Copyright (c) 2015 felipejfc. All rights reserved.
//

#import "BlockTestClass.h"
#import "wax.h"
#import "wax_helpers.h"

@implementation BlockTestClass

- (void) testBlockFunction :(void (^) (NSString *text))block{
    block(@"felipejfc is awesome");
}

- (NSString *) isAlive{
    return @"i'm alive";
}

@end
