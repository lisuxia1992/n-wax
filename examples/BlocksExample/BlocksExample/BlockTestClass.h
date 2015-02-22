//
//  BlockTestClass.h
//  BlocksExample
//
//  Created by Felipe Cavalcanti on 22/02/15.
//  Copyright (c) 2015 felipejfc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockTestClass : NSObject
- (void) testBlockFunction :(void (^) (NSString *text))block;
- (NSString *) isAlive;

@end
