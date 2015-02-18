//
//  WaxFFIClosure.m
//  States
//
//  Created by Felipe Cavalcanti on 18/02/15.
//
//

#import "WaxFFIClosure.h"

@implementation WaxFFIClosure

ffi_closure*	closure;
ffi_cif	*		cif;
void *_closureFptr;

- (id)init
{
    self	= [super init];
    
    closure         = NULL;
    _closureFptr    = NULL;
    return	self;
}

- (IMP) createFFIClosure :(SEL) selector :(Class) class :(int) numArgs :(ffi_type *) retType :(ffi_type**) argTypes :(void*)closure_function{
    cif = malloc(sizeof(ffi_cif));
    closure = ffi_closure_alloc(sizeof(ffi_closure), &_closureFptr);
    if (closure!=(void*)-1)
    {
        if (ffi_prep_cif(cif, FFI_DEFAULT_ABI, numArgs,
                         retType, argTypes) == FFI_OK)
        {
            if (ffi_prep_closure_loc(closure, cif, closure_function,
                                     NULL, _closureFptr) == FFI_OK)
            {
                return (IMP)_closureFptr;
            }
        }
    }
    return NULL;
}


@end
