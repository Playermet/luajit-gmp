local gmp = require 'gmp' ('libgmp-10')

local mpz = gmp.types.mpz

local a,b = mpz(), mpz()

gmp.mpz_init_set_str(a, '39679054966380032223487239670184', 10)
gmp.mpz_init_set_str(b, '85186439059104575627262464195387', 10)

gmp.mpz_mul(a,a,b)

gmp.printf('Result: %Zd\n', a)

gmp.mpz_clears(a,b)
