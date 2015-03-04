/*
 *  wax_instance.h
 *  Lua
 *
 *  Created by ProbablyInteractive on 5/18/09.
 *  Copyright 2009 Probably Interactive. All rights reserved.
 *
 */

/*
 Copyright (c) 2015 Felipe Cavalcanti (felipejfc)
 See the file LICENSE for copying permission.
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "lua.h"

#define WAX_INSTANCE_METATABLE_NAME "wax.instance"

struct __va_list_tag {
    unsigned int gp_offset;
    unsigned int fp_offset;
    void *overflow_arg_area;
    void *reg_save_area;
};
typedef struct __va_list_tag __va_list_tag;

typedef struct _wax_instance_userdata {
    id instance;
    BOOL isClass;
    Class isSuper; // isSuper not only stores whether the class is a super, but it also contains the value of the next superClass.
	BOOL actAsSuper; // It only acts like a super once, when it is called for the first time.
} wax_instance_userdata;

int luaopen_wax_instance(lua_State *L);

wax_instance_userdata *wax_instance_create(lua_State *L, id instance, BOOL isClass);
wax_instance_userdata *wax_instance_createSuper(lua_State *L, wax_instance_userdata *instanceUserdata);
void wax_instance_pushUserdataTable(lua_State *L);
void wax_instance_pushStrongUserdataTable(lua_State *L);

BOOL wax_instance_pushFunction(lua_State *L, id self, SEL selector);
void wax_instance_pushUserdata(lua_State *L, id object);
BOOL wax_instance_isWaxClass(id instance);
