//
//  WaxFFIClosure.h
//  States
//
//  Created by Felipe Cavalcanti on 18/02/15.
//
//

#import <Foundation/Foundation.h>
#import "ffi.h"

@interface WaxFFIClosure : NSObject

- (IMP) createFFIClosure :(SEL) selector :(Class) class :(int) numArgs :(ffi_type *) retType :(ffi_type**) argTypes :(void*)closure_function;

@end
