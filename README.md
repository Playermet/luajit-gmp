# Features
 - Full support of 5.1.2 API (except low-level functions)

# Example code
```lua
  local gmp = require 'gmp' ('libgmp-10')

  local mpz = gmp.types.z

  local a,b = mpz(), mpz()

  gmp.z_init_set_str(a, '39679054966380032223487239670184', 10)
  gmp.z_init_set_str(b, '85186439059104575627262464195387', 10)

  gmp.z_mul(a,a,b)

  gmp.printf('Result: %Zd\n', a)

  gmp.z_clears(a,b)

```

# Differences from the C API
Binding is so close to the original API as possible, but some things still differ.
 1. Names lost 'gmp' prefix as not needed.
 2. f_get_d_2exp, f_get_str return exp as second result.
 3. Added luasprintf, for output output in lua string.

# TODO
 - Wrap mpz_import and mpz_export functions
