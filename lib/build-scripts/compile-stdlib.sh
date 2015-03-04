#!/bin/zsh

# Compiles the wax stdlib into one file
lua "../build-scripts/luac.lua" wax wax.dat "../stdlib/" "../stdlib/init.lua" -L "../stdlib"/**/*.lua

# Dumps the compiled file into a byte array, then it places this into the source code
cat > "../wax_stdlib.h" <<EOF
// DO NOT MODIFY
// This is auto generated, it contains a compiled version of the wax stdlib
#define WAX_STDLIB {$(hexdump -v -e '1/1 "%d,"' wax.dat)}
EOF

# clean up
rm wax.dat
