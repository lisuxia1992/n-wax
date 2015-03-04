/*
 Copyright (c) 2015 Felipe Cavalcanti (felipejfc)
 See the file LICENSE for copying permission.
 */

#import "wax_ffi_closure.h"
#import "wax_instance.h"
#import "wax_helpers.h"
#import "wax.h"
#import "lauxlib.h"

ffi_closure*	closure;
ffi_cif	*		cif;
void *_closureFptr;

ffi_type* ffi_typeForTypeEncoding(char encoding)
{
    switch (encoding)
    {
#ifdef __LP64__
        case	_C_ID:
        case	_C_CLASS:
        case	_C_SEL:
        case	_C_PTR:
        case	_C_CHARPTR:		return	&ffi_type_pointer;
            
        case	_C_CHR:			return	&ffi_type_sint8;
        case	_C_UCHR:		return	&ffi_type_uint8;
        case	_C_SHT:			return	&ffi_type_sint16;
        case	_C_USHT:		return	&ffi_type_uint16;
        case	_C_INT:
        case	_C_LNG:         return	&ffi_type_sint32;
        case	_C_UINT:
        case	_C_ULNG:		return	&ffi_type_uint32;
        case	_C_LNG_LNG:		return	&ffi_type_sint64;
        case	_C_ULNG_LNG:	return	&ffi_type_uint64;
        case	_C_FLT:			return	&ffi_type_float;
        case	_C_DBL:			return	&ffi_type_double;
        case	_C_BOOL:		return	&ffi_type_sint8;
        case	_C_VOID:		return	&ffi_type_void;
#else
        case	_C_ID:
        case	_C_CLASS:
        case	_C_SEL:
        case	_C_PTR:
        case	_C_CHARPTR:		return	&ffi_type_pointer;
            
        case	_C_CHR:			return	&ffi_type_sint8;
        case	_C_UCHR:		return	&ffi_type_uint8;
        case	_C_SHT:			return	&ffi_type_sint16;
        case	_C_USHT:		return	&ffi_type_uint16;
        case	_C_INT:         return	&ffi_type_sint32;
        case	_C_LNG:         return	&ffi_type_sint64;
        case	_C_UINT:        return	&ffi_type_uint32;
        case	_C_ULNG:		return	&ffi_type_uint64;
        case	_C_LNG_LNG:		return	&ffi_type_sint64;
        case	_C_ULNG_LNG:	return	&ffi_type_uint64;
        case	_C_FLT:			return	&ffi_type_float;
        case	_C_DBL:			return	&ffi_type_double;
        case	_C_BOOL:		return	&ffi_type_sint8;
        case	_C_VOID:		return	&ffi_type_void;
#endif
    }
    return	NULL;
}

IMP createFFIClosure (SEL selector ,Class class, int numArgs, ffi_type * retType, ffi_type** argTypes, void* closure_function){
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
