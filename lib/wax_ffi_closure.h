/*
 Copyright (c) 2015 Felipe Cavalcanti (felipejfc)
 See the file LICENSE for copying permission.
 */

#import <Foundation/Foundation.h>
#import "ffi.h"
#import "lauxlib.h"
#import "wax_helpers.h"
#import "wax.h"
typedef struct _buffer_16 {char b[16];} buffer_16;
static int pcallUserdata(lua_State *L, id self, SEL selector, void ** args);

#define WAX_FFI_CLOSURE_METHOD_NAME(_type_) wax_##_type_##_call
#define WAX_FFI_CLOSURE_METHOD(_type_) \
static void WAX_FFI_CLOSURE_METHOD_NAME(_type_)(ffi_cif* cif, void *ret, void** args, void* userdata) { \
id self = *(id*)args[0]; \
SEL _cmd = *(SEL*)args[1];\
lua_State *L = wax_currentLuaState(); \
BEGIN_STACK_MODIFY(L); \
args=args[2];\
int result = pcallUserdata(L, self, _cmd, args); \
if (result == -1) { \
luaL_error(L, "Error calling '%s' on '%s'\n%s", _cmd, [[self description] UTF8String], lua_tostring(L, -1)); \
} \
else if (result == 0) { \
bzero(ret, sizeof(_type_)); \
END_STACK_MODIFY(L, 0) \
return;\
} \
\
NSMethodSignature *signature = [self methodSignatureForSelector:_cmd]; \
_type_ *pRet = (_type_ *)wax_copyToObjc(L, [signature methodReturnType], -1, nil);\
_type_ retV = *pRet;\
free(pRet);\
END_STACK_MODIFY(L, 0)\
*(_type_*)ret = retV;\
}

WAX_FFI_CLOSURE_METHOD(buffer_16)
WAX_FFI_CLOSURE_METHOD(id)
WAX_FFI_CLOSURE_METHOD(int)
WAX_FFI_CLOSURE_METHOD(long)
WAX_FFI_CLOSURE_METHOD(float)
WAX_FFI_CLOSURE_METHOD(double)
WAX_FFI_CLOSURE_METHOD(BOOL)

#pragma mark Override Methods
#pragma mark ---------------------

static int pcallUserdata(lua_State *L, id self, SEL selector, void ** args) {
    BEGIN_STACK_MODIFY(L)
    
    if (![[NSThread currentThread] isEqual:[NSThread mainThread]]) NSLog(@"PCALLUSERDATA: OH NO SEPERATE THREAD");
    
    // A WaxClass could have been created via objective-c (like via NSKeyUnarchiver)
    // In this case, no lua object was ever associated with it, so we've got to
    // create one.
    if (wax_instance_isWaxClass(self)) {
        BOOL isClass = self == [self class];
        wax_instance_create(L, self, isClass); // If it already exists, then it will just return without doing anything
        lua_pop(L, 1); // Pops userdata off
    }
    
    // Find the function... could be in the object or in the class
    if (!wax_instance_pushFunction(L, self, selector)) {
        lua_pushfstring(L, "Could not find function named \"%s\" associated with object %s(%p).(It may have been released by the GC)", selector, class_getName([self class]), self);
        goto error; // function not found in userdata...
    }
    
    // Push userdata as the first argument
    wax_fromInstance(L, self);
    if (lua_isnil(L, -1)) {
        lua_pushfstring(L, "Could not convert '%s' into lua", class_getName([self class]));
        goto error;
    }
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    size_t nargs = [signature numberOfArguments] - 1; // Don't send in the _cmd argument, only self
    int nresults = [signature methodReturnLength] ? 1 : 0;
    
    for (int i = 2; i < [signature numberOfArguments]; i++) { // start at 2 because to skip the automatic self and _cmd arugments
        const char *type = [signature getArgumentTypeAtIndex:i];
        wax_fromObjc(L, type, &(*args++));
    }
    
    if (wax_pcall(L, nargs, nresults)) { // Userdata will allways be the first object sent to the function
        goto error;
    }
    
    END_STACK_MODIFY(L, nresults)
    return nresults;
    
error:
    END_STACK_MODIFY(L, 1)
    return -1;
}

IMP createFFIClosure (SEL selector ,Class class, int numArgs, ffi_type * retType, ffi_type** argTypes, void* closure_function);
ffi_type* ffi_typeForTypeEncoding(char encoding);