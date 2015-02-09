-----------------------------------------------------------
--  Binding for GNU MP v5.1.2
-----------------------------------------------------------
local ffi = require 'ffi'
local jit = require 'jit'


local header = [[
  // __GMP_SHORT_LIMB
  // typedef unsigned int mp_limb_t;
  // typedef int          mp_limb_signed_t;

  // _LONG_LONG_LIMB
  // typedef unsigned long long int mp_limb_t;
  // typedef long long int          mp_limb_signed_t;

  typedef unsigned long int mp_limb_t;
  typedef long int          mp_limb_signed_t;

  typedef unsigned long int mp_bitcnt_t;

  typedef mp_limb_t*       mp_ptr;
  typedef const mp_limb_t* mp_srcptr;

  typedef int mp_size_t;
  typedef int mp_exp_t;

  // typedef long int mp_size_t;
  // typedef long int mp_exp_t;

  typedef struct
  {
    int _mp_alloc;
    int _mp_size;
    mp_limb_t* _mp_d;
  } __mpz_struct;

  typedef struct
  {
    __mpz_struct _mp_num;
    __mpz_struct _mp_den;
  } __mpq_struct;

  typedef struct
  {
    int        _mp_prec;
    int        _mp_size;
    mp_exp_t   _mp_exp;
    mp_limb_t* _mp_d;
  } __mpf_struct;

  typedef __mpz_struct mpz_t[1];
  typedef __mpq_struct mpq_t[1];
  typedef __mpf_struct mpf_t[1];

  typedef enum
  {
    GMP_RAND_ALG_DEFAULT = 0,
    GMP_RAND_ALG_LC = GMP_RAND_ALG_DEFAULT
  } gmp_randalg_t;

  typedef struct
  {
    mpz_t         _mp_seed;
    gmp_randalg_t _mp_alg;
    union {
      void *_mp_lc;
    } _mp_algdata;
  } __gmp_randstate_struct;

  typedef __gmp_randstate_struct gmp_randstate_t[1];

  typedef const __mpz_struct* mpz_srcptr;
  typedef __mpz_struct*       mpz_ptr;
  typedef const __mpf_struct* mpf_srcptr;
  typedef __mpf_struct*       mpf_ptr;
  typedef const __mpq_struct* mpq_srcptr;
  typedef __mpq_struct*       mpq_ptr;

  typedef void* FILE;


  void __gmp_randinit_default (gmp_randstate_t);
  void __gmp_randinit_lc_2exp (gmp_randstate_t, mpz_srcptr, unsigned long int, mp_bitcnt_t);
  int __gmp_randinit_lc_2exp_size (gmp_randstate_t, mp_bitcnt_t);
  void __gmp_randinit_mt (gmp_randstate_t);
  void __gmp_randinit_set (gmp_randstate_t, const __gmp_randstate_struct *);
  void __gmp_randseed (gmp_randstate_t, mpz_srcptr);
  void __gmp_randseed_ui (gmp_randstate_t, unsigned long int);
  void __gmp_randclear (gmp_randstate_t);
  unsigned long __gmp_urandomb_ui (gmp_randstate_t, unsigned long);
  unsigned long __gmp_urandomm_ui (gmp_randstate_t, unsigned long);
  int __gmp_asprintf (char **, const char *, ...);
  int __gmp_fprintf (FILE *, const char *, ...);
  int __gmp_printf (const char *, ...);
  int __gmp_snprintf (char *, size_t, const char *, ...);
  int __gmp_sprintf (char *, const char *, ...);
  int __gmp_fscanf (FILE *, const char *, ...);
  int __gmp_scanf (const char *, ...);
  int __gmp_sscanf (const char *, const char *, ...);
  void *__gmpz_realloc (mpz_ptr, mp_size_t);
  void __gmpz_abs (mpz_ptr, mpz_srcptr);
  void __gmpz_add (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_add_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_addmul (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_addmul_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_and (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_bin_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_bin_uiui (mpz_ptr, unsigned long int, unsigned long int);
  void __gmpz_cdiv_q (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_cdiv_q_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
  unsigned long int __gmpz_cdiv_q_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_cdiv_qr (mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
  unsigned long int __gmpz_cdiv_qr_ui (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_cdiv_r (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_cdiv_r_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
  unsigned long int __gmpz_cdiv_r_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  unsigned long int __gmpz_cdiv_ui (mpz_srcptr, unsigned long int);
  void __gmpz_clear (mpz_ptr);
  void __gmpz_clears (mpz_ptr, ...);
  void __gmpz_clrbit (mpz_ptr, mp_bitcnt_t);
  int __gmpz_cmp (mpz_srcptr, mpz_srcptr);
  int __gmpz_cmp_d (mpz_srcptr, double);
  int __gmpz_cmp_si (mpz_srcptr, signed long int);
  int __gmpz_cmp_ui (mpz_srcptr, unsigned long int);
  int __gmpz_cmpabs (mpz_srcptr, mpz_srcptr);
  int __gmpz_cmpabs_d (mpz_srcptr, double);
  int __gmpz_cmpabs_ui (mpz_srcptr, unsigned long int);
  void __gmpz_com (mpz_ptr, mpz_srcptr);
  void __gmpz_combit (mpz_ptr, mp_bitcnt_t);
  int __gmpz_congruent_p (mpz_srcptr, mpz_srcptr, mpz_srcptr);
  int __gmpz_congruent_2exp_p (mpz_srcptr, mpz_srcptr, mp_bitcnt_t);
  int __gmpz_congruent_ui_p (mpz_srcptr, unsigned long, unsigned long);
  void __gmpz_divexact (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_divexact_ui (mpz_ptr, mpz_srcptr, unsigned long);
  int __gmpz_divisible_p (mpz_srcptr, mpz_srcptr);
  int __gmpz_divisible_ui_p (mpz_srcptr, unsigned long);
  int __gmpz_divisible_2exp_p (mpz_srcptr, mp_bitcnt_t);
  void __gmpz_dump (mpz_srcptr);
  void *__gmpz_export (void *, size_t *, int, size_t, int, size_t, mpz_srcptr);
  void __gmpz_fac_ui (mpz_ptr, unsigned long int);
  void __gmpz_2fac_ui (mpz_ptr, unsigned long int);
  void __gmpz_mfac_uiui (mpz_ptr, unsigned long int, unsigned long int);
  void __gmpz_primorial_ui (mpz_ptr, unsigned long int);
  void __gmpz_fdiv_q (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_fdiv_q_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
  unsigned long int __gmpz_fdiv_q_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_fdiv_qr (mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
  unsigned long int __gmpz_fdiv_qr_ui (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_fdiv_r (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_fdiv_r_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
  unsigned long int __gmpz_fdiv_r_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  unsigned long int __gmpz_fdiv_ui (mpz_srcptr, unsigned long int);
  void __gmpz_fib_ui (mpz_ptr, unsigned long int);
  void __gmpz_fib2_ui (mpz_ptr, mpz_ptr, unsigned long int);
  int __gmpz_fits_sint_p (mpz_srcptr);
  int __gmpz_fits_slong_p (mpz_srcptr);
  int __gmpz_fits_sshort_p (mpz_srcptr);
  int __gmpz_fits_uint_p (mpz_srcptr);
  int __gmpz_fits_ulong_p (mpz_srcptr);
  int __gmpz_fits_ushort_p (mpz_srcptr);
  void __gmpz_gcd (mpz_ptr, mpz_srcptr, mpz_srcptr);
  unsigned long int __gmpz_gcd_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_gcdext (mpz_ptr, mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
  double __gmpz_get_d (mpz_srcptr);
  double __gmpz_get_d_2exp (signed long int *, mpz_srcptr);
  long int __gmpz_get_si (mpz_srcptr);
  char *__gmpz_get_str (char *, int, mpz_srcptr);
  unsigned long int __gmpz_get_ui (mpz_srcptr);
  mp_limb_t __gmpz_getlimbn (mpz_srcptr, mp_size_t);
  mp_bitcnt_t __gmpz_hamdist (mpz_srcptr, mpz_srcptr);
  void __gmpz_import (mpz_ptr, size_t, int, size_t, int, size_t, const void *);
  void __gmpz_init (mpz_ptr);
  void __gmpz_init2 (mpz_ptr, mp_bitcnt_t);
  void __gmpz_inits (mpz_ptr, ...);
  void __gmpz_init_set (mpz_ptr, mpz_srcptr);
  void __gmpz_init_set_d (mpz_ptr, double);
  void __gmpz_init_set_si (mpz_ptr, signed long int);
  int __gmpz_init_set_str (mpz_ptr, const char *, int);
  void __gmpz_init_set_ui (mpz_ptr, unsigned long int);
  size_t __gmpz_inp_raw (mpz_ptr, FILE *);
  size_t __gmpz_inp_str (mpz_ptr, FILE *, int);
  int __gmpz_invert (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_ior (mpz_ptr, mpz_srcptr, mpz_srcptr);
  int __gmpz_jacobi (mpz_srcptr, mpz_srcptr);
  int __gmpz_kronecker_si (mpz_srcptr, long);
  int __gmpz_kronecker_ui (mpz_srcptr, unsigned long);
  int __gmpz_si_kronecker (long, mpz_srcptr);
  int __gmpz_ui_kronecker (unsigned long, mpz_srcptr);
  void __gmpz_lcm (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_lcm_ui (mpz_ptr, mpz_srcptr, unsigned long);
  void __gmpz_lucnum_ui (mpz_ptr, unsigned long int);
  void __gmpz_lucnum2_ui (mpz_ptr, mpz_ptr, unsigned long int);
  int __gmpz_millerrabin (mpz_srcptr, int);
  void __gmpz_mod (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_mul (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_mul_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
  void __gmpz_mul_si (mpz_ptr, mpz_srcptr, long int);
  void __gmpz_mul_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_neg (mpz_ptr, mpz_srcptr);
  void __gmpz_nextprime (mpz_ptr, mpz_srcptr);
  size_t __gmpz_out_raw (FILE *, mpz_srcptr);
  size_t __gmpz_out_str (FILE *, int, mpz_srcptr);
  int __gmpz_perfect_power_p (mpz_srcptr);
  int __gmpz_perfect_square_p (mpz_srcptr);
  mp_bitcnt_t __gmpz_popcount (mpz_srcptr);
  void __gmpz_pow_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_powm (mpz_ptr, mpz_srcptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_powm_sec (mpz_ptr, mpz_srcptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_powm_ui (mpz_ptr, mpz_srcptr, unsigned long int, mpz_srcptr);
  int __gmpz_probab_prime_p (mpz_srcptr, int);
  void __gmpz_random (mpz_ptr, mp_size_t);
  void __gmpz_random2 (mpz_ptr, mp_size_t);
  void __gmpz_realloc2 (mpz_ptr, mp_bitcnt_t);
  mp_bitcnt_t __gmpz_remove (mpz_ptr, mpz_srcptr, mpz_srcptr);
  int __gmpz_root (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_rootrem (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_rrandomb (mpz_ptr, gmp_randstate_t, mp_bitcnt_t);
  mp_bitcnt_t __gmpz_scan0 (mpz_srcptr, mp_bitcnt_t);
  mp_bitcnt_t __gmpz_scan1 (mpz_srcptr, mp_bitcnt_t);
  void __gmpz_set (mpz_ptr, mpz_srcptr);
  void __gmpz_set_d (mpz_ptr, double);
  void __gmpz_set_f (mpz_ptr, mpf_srcptr);
  void __gmpz_set_q (mpz_ptr, mpq_srcptr);
  void __gmpz_set_si (mpz_ptr, signed long int);
  int __gmpz_set_str (mpz_ptr, const char *, int);
  void __gmpz_set_ui (mpz_ptr, unsigned long int);
  void __gmpz_setbit (mpz_ptr, mp_bitcnt_t);
  size_t __gmpz_size (mpz_srcptr);
  size_t __gmpz_sizeinbase (mpz_srcptr, int);
  void __gmpz_sqrt (mpz_ptr, mpz_srcptr);
  void __gmpz_sqrtrem (mpz_ptr, mpz_ptr, mpz_srcptr);
  void __gmpz_sub (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_sub_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_ui_sub (mpz_ptr, unsigned long int, mpz_srcptr);
  void __gmpz_submul (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_submul_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_swap (mpz_ptr, mpz_ptr);
  unsigned long int __gmpz_tdiv_ui (mpz_srcptr, unsigned long int);
  void __gmpz_tdiv_q (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_tdiv_q_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
  unsigned long int __gmpz_tdiv_q_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_tdiv_qr (mpz_ptr, mpz_ptr, mpz_srcptr, mpz_srcptr);
  unsigned long int __gmpz_tdiv_qr_ui (mpz_ptr, mpz_ptr, mpz_srcptr, unsigned long int);
  void __gmpz_tdiv_r (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_tdiv_r_2exp (mpz_ptr, mpz_srcptr, mp_bitcnt_t);
  unsigned long int __gmpz_tdiv_r_ui (mpz_ptr, mpz_srcptr, unsigned long int);
  int __gmpz_tstbit (mpz_srcptr, mp_bitcnt_t);
  void __gmpz_ui_pow_ui (mpz_ptr, unsigned long int, unsigned long int);
  void __gmpz_urandomb (mpz_ptr, gmp_randstate_t, mp_bitcnt_t);
  void __gmpz_urandomm (mpz_ptr, gmp_randstate_t, mpz_srcptr);
  void __gmpz_xor (mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpq_abs (mpq_ptr, mpq_srcptr);
  void __gmpq_add (mpq_ptr, mpq_srcptr, mpq_srcptr);
  void __gmpq_canonicalize (mpq_ptr);
  void __gmpq_clear (mpq_ptr);
  void __gmpq_clears (mpq_ptr, ...);
  int __gmpq_cmp (mpq_srcptr, mpq_srcptr);
  int __gmpq_cmp_si (mpq_srcptr, long, unsigned long);
  int __gmpq_cmp_ui (mpq_srcptr, unsigned long int, unsigned long int);
  void __gmpq_div (mpq_ptr, mpq_srcptr, mpq_srcptr);
  void __gmpq_div_2exp (mpq_ptr, mpq_srcptr, mp_bitcnt_t);
  int __gmpq_equal (mpq_srcptr, mpq_srcptr);
  void __gmpq_get_num (mpz_ptr, mpq_srcptr);
  void __gmpq_get_den (mpz_ptr, mpq_srcptr);
  double __gmpq_get_d (mpq_srcptr);
  char *__gmpq_get_str (char *, int, mpq_srcptr);
  void __gmpq_init (mpq_ptr);
  void __gmpq_inits (mpq_ptr, ...);
  size_t __gmpq_inp_str (mpq_ptr, FILE *, int);
  void __gmpq_inv (mpq_ptr, mpq_srcptr);
  void __gmpq_mul (mpq_ptr, mpq_srcptr, mpq_srcptr);
  void __gmpq_mul_2exp (mpq_ptr, mpq_srcptr, mp_bitcnt_t);
  void __gmpq_neg (mpq_ptr, mpq_srcptr);
  size_t __gmpq_out_str (FILE *, int, mpq_srcptr);
  void __gmpq_set (mpq_ptr, mpq_srcptr);
  void __gmpq_set_d (mpq_ptr, double);
  void __gmpq_set_den (mpq_ptr, mpz_srcptr);
  void __gmpq_set_f (mpq_ptr, mpf_srcptr);
  void __gmpq_set_num (mpq_ptr, mpz_srcptr);
  void __gmpq_set_si (mpq_ptr, signed long int, unsigned long int);
  int __gmpq_set_str (mpq_ptr, const char *, int);
  void __gmpq_set_ui (mpq_ptr, unsigned long int, unsigned long int);
  void __gmpq_set_z (mpq_ptr, mpz_srcptr);
  void __gmpq_sub (mpq_ptr, mpq_srcptr, mpq_srcptr);
  void __gmpq_swap (mpq_ptr, mpq_ptr);
  void __gmpf_abs (mpf_ptr, mpf_srcptr);
  void __gmpf_add (mpf_ptr, mpf_srcptr, mpf_srcptr);
  void __gmpf_add_ui (mpf_ptr, mpf_srcptr, unsigned long int);
  void __gmpf_ceil (mpf_ptr, mpf_srcptr);
  void __gmpf_clear (mpf_ptr);
  void __gmpf_clears (mpf_ptr, ...);
  int __gmpf_cmp (mpf_srcptr, mpf_srcptr);
  int __gmpf_cmp_d (mpf_srcptr, double);
  int __gmpf_cmp_si (mpf_srcptr, signed long int);
  int __gmpf_cmp_ui (mpf_srcptr, unsigned long int);
  void __gmpf_div (mpf_ptr, mpf_srcptr, mpf_srcptr);
  void __gmpf_div_2exp (mpf_ptr, mpf_srcptr, mp_bitcnt_t);
  void __gmpf_div_ui (mpf_ptr, mpf_srcptr, unsigned long int);
  void __gmpf_dump (mpf_srcptr);
  int __gmpf_eq (mpf_srcptr, mpf_srcptr, mp_bitcnt_t);
  int __gmpf_fits_sint_p (mpf_srcptr);
  int __gmpf_fits_slong_p (mpf_srcptr);
  int __gmpf_fits_sshort_p (mpf_srcptr);
  int __gmpf_fits_uint_p (mpf_srcptr);
  int __gmpf_fits_ulong_p (mpf_srcptr);
  int __gmpf_fits_ushort_p (mpf_srcptr);
  void __gmpf_floor (mpf_ptr, mpf_srcptr);
  double __gmpf_get_d (mpf_srcptr);
  double __gmpf_get_d_2exp (signed long int *, mpf_srcptr);
  mp_bitcnt_t __gmpf_get_default_prec (void);
  mp_bitcnt_t __gmpf_get_prec (mpf_srcptr);
  long __gmpf_get_si (mpf_srcptr);
  char *__gmpf_get_str (char *, mp_exp_t *, int, size_t, mpf_srcptr);
  unsigned long __gmpf_get_ui (mpf_srcptr);
  void __gmpf_init (mpf_ptr);
  void __gmpf_init2 (mpf_ptr, mp_bitcnt_t);
  void __gmpf_inits (mpf_ptr, ...);
  void __gmpf_init_set (mpf_ptr, mpf_srcptr);
  void __gmpf_init_set_d (mpf_ptr, double);
  void __gmpf_init_set_si (mpf_ptr, signed long int);
  int __gmpf_init_set_str (mpf_ptr, const char *, int);
  void __gmpf_init_set_ui (mpf_ptr, unsigned long int);
  size_t __gmpf_inp_str (mpf_ptr, FILE *, int);
  int __gmpf_integer_p (mpf_srcptr);
  void __gmpf_mul (mpf_ptr, mpf_srcptr, mpf_srcptr);
  void __gmpf_mul_2exp (mpf_ptr, mpf_srcptr, mp_bitcnt_t);
  void __gmpf_mul_ui (mpf_ptr, mpf_srcptr, unsigned long int);
  void __gmpf_neg (mpf_ptr, mpf_srcptr);
  size_t __gmpf_out_str (FILE *, int, size_t, mpf_srcptr);
  void __gmpf_pow_ui (mpf_ptr, mpf_srcptr, unsigned long int);
  void __gmpf_random2 (mpf_ptr, mp_size_t, mp_exp_t);
  void __gmpf_reldiff (mpf_ptr, mpf_srcptr, mpf_srcptr);
  void __gmpf_set (mpf_ptr, mpf_srcptr);
  void __gmpf_set_d (mpf_ptr, double);
  void __gmpf_set_default_prec (mp_bitcnt_t);
  void __gmpf_set_prec (mpf_ptr, mp_bitcnt_t);
  void __gmpf_set_prec_raw (mpf_ptr, mp_bitcnt_t);
  void __gmpf_set_q (mpf_ptr, mpq_srcptr);
  void __gmpf_set_si (mpf_ptr, signed long int);
  int __gmpf_set_str (mpf_ptr, const char *, int);
  void __gmpf_set_ui (mpf_ptr, unsigned long int);
  void __gmpf_set_z (mpf_ptr, mpz_srcptr);
  size_t __gmpf_size (mpf_srcptr);
  void __gmpf_sqrt (mpf_ptr, mpf_srcptr);
  void __gmpf_sqrt_ui (mpf_ptr, unsigned long int);
  void __gmpf_sub (mpf_ptr, mpf_srcptr, mpf_srcptr);
  void __gmpf_sub_ui (mpf_ptr, mpf_srcptr, unsigned long int);
  void __gmpf_swap (mpf_ptr, mpf_ptr);
  void __gmpf_trunc (mpf_ptr, mpf_srcptr);
  void __gmpf_ui_div (mpf_ptr, unsigned long int, mpf_srcptr);
  void __gmpf_ui_sub (mpf_ptr, unsigned long int, mpf_srcptr);
  void __gmpf_urandomb (mpf_t, gmp_randstate_t, mp_bitcnt_t);
]]

local bind = {}
local help = {}
local mod = {}


function mod.randinit_default(state)
  bind.__gmp_randinit_default(state)
end

function mod.randinit_lc_2exp(state, a, c, m2exp)
  bind.__gmp_randinit_lc_2exp(state, a, c, m2exp)
end

function mod.randinit_lc_2exp_size(state, size)
  return bind.__gmp_randinit_lc_2exp_size(state, size)
end

function mod.randinit_mt(state)
  bind.__gmp_randinit_mt(state)
end

function mod.randinit_set(rop, op)
  bind.__gmp_randinit_set(rop, op)
end

function mod.randseed(state, seed)
  bind.__gmp_randseed(state, seed)
end

function mod.randseed_ui(state, seed)
  bind.__gmp_randseed_ui(state, seed)
end

function mod.randclear(state)
  bind.__gmp_randclear(state)
end

function mod.urandomb_ui(state, n)
  return bind.__gmp_urandomb_ui(state, n)
end

function mod.urandomm_ui(state, n)
  return bind.__gmp_urandomm_ui(state, n)
end

function mod.asprintf(fmt, ...)
  local pp = ffi.new('char*[1]')
  local r = bind.__gmp_asprintf(pp, fmt, ...)
  return pp[0], r
end

function mod.luasprintf(fmt, ...)
  local pp = ffi.new('char*[1]')
  local r = bind.__gmp_asprintf(pp, fmt, ...)
  return ffi.string(pp[0])
end

function mod.fprintf(fp, fmt, ...)
  return bind.__gmp_fprintf(fp, fmt, ...)
end

function mod.printf(fmt, ...)
  return bind.__gmp_printf(fmt, ...)
end

function mod.snprintf(buf, size, fmt, ...)
  if not ffi.istype('char*', bug) then
    error("bad argument #1 to 'snprintf' (char* expected)", 2)
  end
  return bind.__gmp_snprintf(buf, size, fmt, ...)
end

function mod.sprintf(buf, fmt, ...)
  if not ffi.istype('char*', bug) then
    error("bad argument #1 to 'sprintf' (char* expected)", 2)
  end
  return bind.__gmp_sprintf(buf, fmt, ...)
end

function mod.fscanf(fp, fmt, ...)
  return bind.__gmp_fscanf(fp, fmt, ...)
end

function mod.scanf(fmt, ...)
  return bind.__gmp_scanf(fmt, ...)
end

function mod.sscanf(s, fmt, ...)
  return bind.__gmp_sscanf(s, fmt, ...)
end

function mod.z_realloc(integer, new_alloc)
  return bind.__gmpz_realloc(integer, new_alloc)
end

function mod.z_abs(rop, op)
  bind.__gmpz_abs(rop, op)
end

function mod.z_add(rop, op1, op2)
  bind.__gmpz_add(rop, op1, op2)
end

function mod.z_add_ui(rop, op1, op2)
  bind.__gmpz_add_ui(rop, op1, op2)
end

function mod.z_addmul(rop, op1, op2)
  bind.__gmpz_addmul(rop, op1, op2)
end

function mod.z_addmul_ui(rop, op1, op2)
  bind.__gmpz_addmul_ui(rop, op1, op2)
end

function mod.z_and(rop, op1, op2)
  bind.__gmpz_and(rop, op1, op2)
end

function mod.z_bin_ui(rop, n, k)
  bind.__gmpz_bin_ui(rop, n, k)
end

function mod.z_bin_uiui(rop, n, k)
  bind.__gmpz_bin_uiui(rop, n, k)
end

function mod.z_cdiv_q(q, n, d)
  bind.__gmpz_cdiv_q(q, n, d)
end

function mod.z_cdiv_q_2exp(q, n, b)
  bind.__gmpz_cdiv_q_2exp(q, n, b)
end

function mod.z_cdiv_q_ui(q, n, d)
  return bind.__gmpz_cdiv_q_ui(q, n, d)
end

function mod.z_cdiv_qr(q, r, n, d)
  bind.__gmpz_cdiv_qr(q, r, n, d)
end

function mod.z_cdiv_qr_ui(q, r, n, d)
  return bind.__gmpz_cdiv_qr_ui(q, r, n, d)
end

function mod.z_cdiv_r(r, n, d)
  bind.__gmpz_cdiv_r(r, n, d)
end

function mod.z_cdiv_r_2exp(r, n, b)
  bind.__gmpz_cdiv_r_2exp(r, n, b)
end

function mod.z_cdiv_r_ui(r, n, d)
  return bind.__gmpz_cdiv_r_ui(r, n, d)
end

function mod.z_cdiv_ui(n, d)
  return bind.__gmpz_cdiv_ui(n, d)
end

function mod.z_clear(x)
  bind.__gmpz_clear(x)
end

function mod.z_clears(x, ...)
  bind.__gmpz_clears(x, help.vararg(...))
end

function mod.z_clrbit(rop, bit_index)
  bind.__gmpz_clrbit(rop, bit_index)
end

function mod.z_cmp(op1, op2)
  return bind.__gmpz_cmp(op1, op2)
end

function mod.z_cmp_d(op1, op2)
  return bind.__gmpz_cmp_d(op1, op2)
end

function mod.z_cmp_si(op1, op2)
  return bind.__gmpz_cmp_si(op1, op2)
end

function mod.z_cmp_ui(op1, op2)
  return bind.__gmpz_cmp_ui(op1, op2)
end

function mod.z_cmpabs(op1, op2)
  return bind.__gmpz_cmpabs(op1, op2)
end

function mod.z_cmpabs_d(op1, op2)
  return bind.__gmpz_cmpabs_d(op1, op2)
end

function mod.z_cmpabs_ui(op1, op2)
  return bind.__gmpz_cmpabs_ui(op1, op2)
end

function mod.z_com(rop, op)
  bind.__gmpz_com(rop, op)
end

function mod.z_combit(rop, bit_index)
  bind.__gmpz_combit(rop, bit_index)
end

function mod.z_congruent_p(n, c, d)
  return bind.__gmpz_congruent_p(n, c, d)
end

function mod.z_congruent_2exp_p(n, c, b)
  return bind.__gmpz_congruent_2exp_p(n, c, b)
end

function mod.z_congruent_ui_p(n, c, d)
  return bind.__gmpz_congruent_ui_p(n, c, d)
end

function mod.z_divexact(q, n, d)
  bind.__gmpz_divexact(q, n, d)
end

function mod.z_divexact_ui(q, n, d)
  bind.__gmpz_divexact_ui(q, n, d)
end

function mod.z_divisible_p(n, d)
  return bind.__gmpz_divisible_p(n, d)
end

function mod.z_divisible_ui_p(n, d)
  return bind.__gmpz_divisible_ui_p(n, d)
end

function mod.z_divisible_2exp_p(n, b)
  return bind.__gmpz_divisible_2exp_p(n, b)
end

function mod.z_dump(u)
  bind.__gmpz_dump(u)
end

-- function mod.z_export(rop, countp, order, size, endian, nails, op)
-- --  void *__gmpz_export (void *, size_t *, int, size_t, int, size_t, mpz_srcptr)
--   return bind.__gmpz_export(rop, countp, order, size, endian, nails, op)
-- end

function mod.z_fac_ui(rop, n)
  bind.__gmpz_fac_ui(rop, n)
end

function mod.z_2fac_ui(rop, n)
  bind.__gmpz_2fac_ui(rop, n)
end

function mod.z_mfac_uiui(rop, n, m)
  bind.__gmpz_mfac_uiui(rop, n, m)
end

function mod.z_primorial_ui(rop, n)
  bind.__gmpz_primorial_ui(rop, n)
end

function mod.z_fdiv_q(q, n, d)
  bind.__gmpz_fdiv_q(q, n, d)
end

function mod.z_fdiv_q_2exp(q, n, b)
  bind.__gmpz_fdiv_q_2exp(q, n, b)
end

function mod.z_fdiv_q_ui(q, n, d)
  return bind.__gmpz_fdiv_q_ui(q, n, d)
end

function mod.z_fdiv_qr(q, r, n, d)
  bind.__gmpz_fdiv_qr(q, r, n, d)
end

function mod.z_fdiv_qr_ui(q, r, n, d)
  return bind.__gmpz_fdiv_qr_ui(q, r, n, d)
end

function mod.z_fdiv_r(r, n, d)
  bind.__gmpz_fdiv_r(r, n, d)
end

function mod.z_fdiv_r_2exp(r, n, b)
  bind.__gmpz_fdiv_r_2exp(r, n, b)
end

function mod.z_fdiv_r_ui(r, n, d)
  return bind.__gmpz_fdiv_r_ui(r, n, d)
end

function mod.z_fdiv_ui(n, d)
  return bind.__gmpz_fdiv_ui(n, d)
end

function mod.z_fib_ui(fn, n)
  bind.__gmpz_fib_ui(fn, n)
end

function mod.z_fib2_ui(fn, fnsub1, n)
  bind.__gmpz_fib2_ui(fn, fnsub1, n)
end

function mod.z_fits_sint_p(op)
  return bind.__gmpz_fits_sint_p(op)
end

function mod.z_fits_slong_p(op)
  return bind.__gmpz_fits_slong_p(op)
end

function mod.z_fits_sshort_p(op)
  return bind.__gmpz_fits_sshort_p(op)
end

function mod.z_fits_uint_p(op)
  return bind.__gmpz_fits_uint_p(op)
end

function mod.z_fits_ulong_p(op)
  return bind.__gmpz_fits_ulong_p(op)
end

function mod.z_fits_ushort_p(op)
  return bind.__gmpz_fits_ushort_p(op)
end

function mod.z_gcd(rop, op1, op2)
  bind.__gmpz_gcd(rop, op1, op2)
end

function mod.z_gcd_ui(rop, op1, op2)
  return bind.__gmpz_gcd_ui(rop, op1, op2)
end

function mod.z_gcdext(g, s, t, a, b)
  bind.__gmpz_gcdext(g, s, t, a, b)
end

function mod.z_get_d(op)
  return bind.__gmpz_get_d(op)
end

function mod.z_get_d_2exp(exp, op)
  return bind.__gmpz_get_d_2exp(exp, op)
end

function mod.z_get_si(op)
  return bind.__gmpz_get_si(op)
end

function mod.z_get_str(str, base, op)
  return ffi.string(bind.__gmpz_get_str(str, base, op))
end

function mod.z_get_ui(op)
  return bind.__gmpz_get_ui(op)
end

function mod.z_getlimbn(op, n)
  return bind.__gmpz_getlimbn(op, n)
end

function mod.z_hamdist(op1, op2)
  return bind.__gmpz_hamdist(op1, op2)
end

-- function mod.z_import(rop, count, order, size, endian, nails, op)
-- --  void __gmpz_import (mpz_ptr, size_t, int, size_t, int, size_t, const void *)
--   bind.__gmpz_import(rop, count, order, size, endian, nails, op)
-- end

function mod.z_init(x)
  bind.__gmpz_init(x)
end

function mod.z_init2(x, n)
  bind.__gmpz_init2(x, n)
end

function mod.z_inits(x, ...)
  bind.__gmpz_inits(x, help.vararg(...))
end

function mod.z_init_set(rop, op)
  bind.__gmpz_init_set(rop, op)
end

function mod.z_init_set_d(rop, op)
  bind.__gmpz_init_set_d(rop, op)
end

function mod.z_init_set_si(rop, op)
  bind.__gmpz_init_set_si(rop, op)
end

function mod.z_init_set_str(rop, str, base)
  return bind.__gmpz_init_set_str(rop, str, base)
end

function mod.z_init_set_ui(rop, op)
  bind.__gmpz_init_set_ui(rop, op)
end

function mod.z_inp_raw(rop, stream)
  return bind.__gmpz_inp_raw(rop, stream)
end

function mod.z_inp_str(rop, stream, base)
  return bind.__gmpz_inp_str(rop, stream, base)
end

function mod.z_invert(rop, op1, op2)
  return bind.__gmpz_invert(rop, op1, op2)
end

function mod.z_ior(rop, op1, op2)
  bind.__gmpz_ior(rop, op1, op2)
end

function mod.z_jacobi(a, b)
  return bind.__gmpz_jacobi(a, b)
end

function mod.z_kronecker_si(a, b)
  return bind.__gmpz_kronecker_si(a, b)
end

function mod.z_kronecker_ui(a, b)
  return bind.__gmpz_kronecker_ui(a, b)
end

function mod.z_si_kronecker(a, b)
  return bind.__gmpz_si_kronecker(a, b)
end

function mod.z_ui_kronecker(a, b)
  return bind.__gmpz_ui_kronecker(a, b)
end

function mod.z_lcm(rop, op1, op2)
  bind.__gmpz_lcm(rop, op1, op2)
end

function mod.z_lcm_ui(rop, op1, op2)
  bind.__gmpz_lcm_ui(rop, op1, op2)
end

function mod.z_lucnum_ui(ln, n)
  bind.__gmpz_lucnum_ui(ln, n)
end

function mod.z_lucnum2_ui(ln, lnsub1, n)
  bind.__gmpz_lucnum2_ui(ln, lnsub1, n)
end

function mod.z_millerrabin(n, reps)
  return bind.__gmpz_millerrabin(n, reps)
end

function mod.z_mod(r, n, d)
  bind.__gmpz_mod(r, n, d)
end

function mod.z_mul(rop, op1, op2)
  bind.__gmpz_mul(rop, op1, op1)
end

function mod.z_mul_2exp(rop, op1, op2)
  bind.__gmpz_mul_2exp(rop, op1, op2)
end

function mod.z_mul_si(rop, op1, op2)
  bind.__gmpz_mul_si(rop, op1, op2)
end

function mod.z_mul_ui(rop, op1, op2)
  bind.__gmpz_mul_ui(rop, op1, op2)
end

function mod.z_neg(rop, op)
  bind.__gmpz_neg(rop, op)
end

function mod.z_nextprime(rop, op)
  bind.__gmpz_nextprime(rop, op)
end

function mod.z_out_raw(stream, op)
  return bind.__gmpz_out_raw(stream, op)
end

function mod.z_out_str(stream, base, op)
  return bind.__gmpz_out_str(stream, base, op)
end

function mod.z_perfect_power_p(op)
  return bind.__gmpz_perfect_power_p(op)
end

function mod.z_perfect_square_p(op)
  return bind.__gmpz_perfect_square_p(op)
end

function mod.z_popcount(op)
  return bind.__gmpz_popcount(op)
end

function mod.z_pow_ui(rop, base, exp)
  bind.__gmpz_pow_ui(rop, base, exp)
end

function mod.z_powm(rop, base, exp, mod)
  bind.__gmpz_powm(rop, base, exp, mod)
end

function mod.z_powm_sec(rop, base, exp, mod)
  bind.__gmpz_powm_sec(rop, base, exp, mod)
end

function mod.z_powm_ui(rop, base, exp, mod)
  bind.__gmpz_powm_ui(rop, base, exp, mod)
end

function mod.z_probab_prime_p(n, reps)
  return bind.__gmpz_probab_prime_p(n, reps)
end

function mod.z_random(rop, max_size)
  bind.__gmpz_random(rop, max_size)
end

function mod.z_random2(rop, max_size)
  bind.__gmpz_random2(rop, max_size)
end

function mod.z_realloc2(x, n)
  bind.__gmpz_realloc2(x, n)
end

function mod.z_remove(rop, op, f)
  return bind.__gmpz_remove(rop, op, f)
end

function mod.z_root(rop, op, n)
  return bind.__gmpz_root(rop, op, n)
end

function mod.z_rootrem(root, rem, u, n)
  bind.__gmpz_rootrem(root, rem, u, n)
end

function mod.z_rrandomb(rop, state, n)
  bind.__gmpz_rrandomb(rop, state, n)
end

function mod.z_scan0(op, starting_bit)
  return bind.__gmpz_scan0(op, starting_bit)
end

function mod.z_scan1(op, starting_bit)
  return bind.__gmpz_scan1(op, starting_bit)
end

function mod.z_set(rop, op)
  bind.__gmpz_set(rop, op)
end

function mod.z_set_d(rop, op)
  bind.__gmpz_set_d(rop, op)
end

function mod.z_set_f(rop, op)
  bind.__gmpz_set_f(rop, op)
end

function mod.z_set_q(rop, op)
  bind.__gmpz_set_q(rop, op)
end

function mod.z_set_si(rop, op)
  bind.__gmpz_set_si(rop, op)
end

function mod.z_set_str(rop, str, base)
  return bind.__gmpz_set_str(rop, str, base)
end

function mod.z_set_ui(rop, op)
  bind.__gmpz_set_ui(rop, op)
end

function mod.z_setbit(rop, bit_index)
  bind.__gmpz_setbit(rop, bit_index)
end

function mod.z_size(op)
  return bind.__gmpz_size(op)
end

function mod.z_sizeinbase(op, base)
  return bind.__gmpz_sizeinbase(op, base)
end

function mod.z_sqrt(rop, op)
  bind.__gmpz_sqrt(rop, op)
end

function mod.z_sqrtrem(rop1, rop2, op)
  bind.__gmpz_sqrtrem(rop1, rop2, op)
end

function mod.z_sub(rop, op1, op2)
  bind.__gmpz_sub(rop, op1, op2)
end

function mod.z_sub_ui(rop, op1, op2)
  bind.__gmpz_sub_ui(rop, op1, op2)
end

function mod.z_ui_sub(rop, op1, op2)
  bind.__gmpz_ui_sub(rop, op1, op2)
end

function mod.z_submul(rop, op1, op2)
  bind.__gmpz_submul(rop, op1, op2)
end

function mod.z_submul_ui(rop, op1, op2)
  bind.__gmpz_submul_ui(rop, op1, op2)
end

function mod.z_swap(rop1, rop2)
  bind.__gmpz_swap(rop1, rop2)
end

function mod.z_tdiv_ui(n, d)
  return bind.__gmpz_tdiv_ui(n, d)
end

function mod.z_tdiv_q(q, n, d)
  bind.__gmpz_tdiv_q(q, n, d)
end

function mod.z_tdiv_q_2exp(q, n, b)
  bind.__gmpz_tdiv_q_2exp(q, n, b)
end

function mod.z_tdiv_q_ui(q, n, d)
  return bind.__gmpz_tdiv_q_ui(q, n, d)
end

function mod.z_tdiv_qr(q, r, n, d)
  bind.__gmpz_tdiv_qr(q, r, n, d)
end

function mod.z_tdiv_qr_ui(q, r, n, d)
  return bind.__gmpz_tdiv_qr_ui(q, r, n, d)
end

function mod.z_tdiv_r(r, n, d)
  bind.__gmpz_tdiv_r(r, n, d)
end

function mod.z_tdiv_r_2exp(r, n, b)
  bind.__gmpz_tdiv_r_2exp(r, n, b)
end

function mod.z_tdiv_r_ui(r, n, d)
  return bind.__gmpz_tdiv_r_ui(r, n, d)
end

function mod.z_tstbit(rop, bit_index)
  return bind.__gmpz_tstbit(rop, bit_index)
end

function mod.z_ui_pow_ui(rop, base, exp)
  bind.__gmpz_ui_pow_ui(rop, base, exp)
end

function mod.z_urandomb(rop, state, n)
  bind.__gmpz_urandomb(rop, state, n)
end

function mod.z_urandomm(rop, state, n)
  bind.__gmpz_urandomm(rop, state, n)
end

function mod.z_xor(rop, op1, op2)
  bind.__gmpz_xor(rop, op1, op2)
end

function mod.q_abs(rop, op)
  bind.__gmpq_abs(rop, op)
end

function mod.q_add(summ, addend1, addend2)
  bind.__gmpq_add(summ, addend1, addend2)
end

function mod.q_canonicalize(op)
  bind.__gmpq_canonicalize(op)
end

function mod.q_clear(x)
  bind.__gmpq_clear(x)
end

function mod.q_clears(x, ...)
  bind.__gmpq_clears(x, help.vararg(...))
end

function mod.q_cmp(op1, op2)
  return bind.__gmpq_cmp(op1, op2)
end

function mod.q_cmp_si(op1, num2, den2)
  return bind.__gmpq_cmp_si(op1, num2, den2)
end

function mod.q_cmp_ui(op1, num2, den2)
  return bind.__gmpq_cmp_ui(op1, num2, den2)
end

function mod.q_div(quotient, dividend, divisor)
  bind.__gmpq_div(quotient, dividend, divisor)
end

function mod.q_div_2exp(rop, op1, op2)
  bind.__gmpq_div_2exp(rop, op1, op2)
end

function mod.q_equal(op1, op2)
  return bind.__gmpq_equal(op1, op2)
end

function mod.q_get_num(numerator, rational)
  bind.__gmpq_get_num(numerator, rational)
end

function mod.q_get_den(denominator, rational)
  bind.__gmpq_get_den(denominator, rational)
end

function mod.q_get_d(op)
  return bind.__gmpq_get_d(op)
end

function mod.q_get_str(str, base, op)
  return ffi.string(bind.__gmpq_get_str(str, base, op))
end

function mod.q_init(x)
  bind.__gmpq_init(x)
end

function mod.q_inits(x, ...)
  bind.__gmpq_inits(x, help.vararg(...))
end

function mod.q_inp_str(rop, stream, base)
  return bind.__gmpq_inp_str(rop, stream, base)
end

function mod.q_inv(inverted_number, number)
  bind.__gmpq_inv(inverted_number, number)
end

function mod.q_mul(product, multiplier, multiplicand)
  bind.__gmpq_mul(product, multiplier, multiplicand)
end

function mod.q_mul_2exp(rop, op1, op2)
  bind.__gmpq_mul_2exp(rop, op1, op2)
end

function mod.q_neg(negated_operand, operand)
  bind.__gmpq_neg(negated_operand, operand)
end

function mod.q_out_str(stream, base, op)
  return bind.__gmpq_out_str(stream, base, op)
end

function mod.q_set(rop, op)
  bind.__gmpq_set(rop, op)
end

function mod.q_set_d(rop, op)
  bind.__gmpq_set_d(rop, op)
end

function mod.q_set_den(rational, denominator)
  bind.__gmpq_set_den(rational, denominator)
end

function mod.q_set_f(rop, op)
  bind.__gmpq_set_f(rop, op)
end

function mod.q_set_num(rational, numerator)
  bind.__gmpq_set_num(rational, numerator)
end

function mod.q_set_si(rop, op1, op2)
  bind.__gmpq_set_si(rop, op1, op2)
end

function mod.q_set_str(rop, str, base)
  return bind.__gmpq_set_str(rop, str, base)
end

function mod.q_set_ui(rop, op1, op2)
  bind.__gmpq_set_ui(rop, op1, op2)
end

function mod.q_set_z(rop, op)
  bind.__gmpq_set_z(rop, op)
end

function mod.q_sub(difference, minuend, subtrahend)
  bind.__gmpq_sub(difference, minuend, subtrahend)
end

function mod.q_swap(rop1, rop2)
  bind.__gmpq_swap(rop1, rop2)
end

function mod.f_abs(rop, op)
  bind.__gmpf_abs(rop, op)
end

function mod.f_add(rop, op1, op2)
  bind.__gmpf_add(rop, op1, op2)
end

function mod.f_add_ui(rop, op1, op2)
  bind.__gmpf_add_ui(rop, op1, op2)
end

function mod.f_ceil(rop, op)
  bind.__gmpf_ceil(rop, op)
end

function mod.f_clear(x)
  bind.__gmpf_clear(x)
end

function mod.f_clears(x, ...)
  bind.__gmpf_clears(x, help.vararg(...))
end

function mod.f_cmp(op1, op2)
  return bind.__gmpf_cmp(op1, op2)
end

function mod.f_cmp_d(op1, op2)
  return bind.__gmpf_cmp_d(op1, op2)
end

function mod.f_cmp_si(op1, op2)
  return bind.__gmpf_cmp_si(op1, op2)
end

function mod.f_cmp_ui(op1, op2)
  return bind.__gmpf_cmp_ui(op1, op2)
end

function mod.f_div(rop, op1, op2)
  bind.__gmpf_div(rop, op1, op2)
end

function mod.f_div_2exp(rop, op1, op2)
  bind.__gmpf_div_2exp(rop, op1, op2)
end

function mod.f_div_ui(rop, op1, op2)
  bind.__gmpf_div_ui(rop, op1, op2)
end

function mod.f_dump(u)
  bind.__gmpf_dump(u)
end

function mod.f_eq(op1, op2, op3)
  return bind.__gmpf_eq(op1, op2, op3)
end

function mod.f_fits_sint_p(op)
  return bind.__gmpf_fits_sint_p(op)
end

function mod.f_fits_slong_p(op)
  return bind.__gmpf_fits_slong_p(op)
end

function mod.f_fits_sshort_p(op)
  return bind.__gmpf_fits_sshort_p(op)
end

function mod.f_fits_uint_p(op)
  return bind.__gmpf_fits_uint_p(op)
end

function mod.f_fits_ulong_p(op)
  return bind.__gmpf_fits_ulong_p(op)
end

function mod.f_fits_ushort_p(op)
  return bind.__gmpf_fits_ushort_p(op)
end

function mod.f_floor(rop, op)
  bind.__gmpf_floor(rop, op)
end

function mod.f_get_d(op)
  return bind.__gmpf_get_d(op)
end

function mod.f_get_d_2exp(op)
  local exp = ffi.new('signed long int[1]')
  local rop = bind.__gmpf_get_d_2exp(exp, op)
  return rop, exp[0]
end

function mod.f_get_default_prec()
  return bind.__gmpf_get_default_prec()
end

function mod.f_get_prec(op)
  return bind.__gmpf_get_prec(op)
end

function mod.f_get_si(op)
  return bind.__gmpf_get_si(op)
end

function mod.f_get_str(str, base, n_digits, op)
  local exp = ffi.new('mp_exp_t[1]')
  local str = ffi.string(bind.__gmpf_get_str(str, exp, base, n_digits, op))
  return str, exp[0]
end

function mod.f_get_ui(op)
  return bind.__gmpf_get_ui(op)
end

function mod.f_init(x)
  bind.__gmpf_init(x)
end

function mod.f_init2(x, prec)
  bind.__gmpf_init2(x, prec)
end

function mod.f_inits(x, ...)
  bind.__gmpf_inits(x, help.vararg(...))
end

function mod.f_init_set(rop, op)
  bind.__gmpf_init_set(rop, op)
end

function mod.f_init_set_d(rop, op)
  bind.__gmpf_init_set_d(rop, op)
end

function mod.f_init_set_si(rop, op)
  bind.__gmpf_init_set_si(rop, op)
end

function mod.f_init_set_str(rop, str, base)
  return bind.__gmpf_init_set_str(rop, str, base)
end

function mod.f_init_set_ui(rop, op)
  bind.__gmpf_init_set_ui(rop, op)
end

function mod.f_inp_str(rop, stream, base)
  return bind.__gmpf_inp_str(rop, stream, base)
end

function mod.f_integer_p(op)
  return bind.__gmpf_integer_p(op)
end

function mod.f_mul(rop, op1, op2)
  bind.__gmpf_mul(rop, op1, op2)
end

function mod.f_mul_2exp(rop, op1, op2)
  bind.__gmpf_mul_2exp(rop, op1, op2)
end

function mod.f_mul_ui(rop, op1, op2)
  bind.__gmpf_mul_ui(rop, op1, op2)
end

function mod.f_neg(rop, op)
  bind.__gmpf_neg(rop, op)
end

function mod.f_out_str(stream, base, n_digits, op)
  return bind.__gmpf_out_str(stream, base, n_digits, op)
end

function mod.f_pow_ui(rop, op1, op2)
  bind.__gmpf_pow_ui(rop, op1, op2)
end

function mod.f_random2(rop, max_size, exp)
  bind.__gmpf_random2(rop, max_size, exp)
end

function mod.f_reldiff(rop, op1, op2)
  bind.__gmpf_reldiff(rop, op1, op2)
end

function mod.f_set(rop, op)
  bind.__gmpf_set(rop, op)
end

function mod.f_set_d(rop, op)
  bind.__gmpf_set_d(rop, op)
end

function mod.f_set_default_prec(prec)
  bind.__gmpf_set_default_prec(prec)
end

function mod.f_set_prec(rop, prec)
  bind.__gmpf_set_prec(rop, prec)
end

function mod.f_set_prec_raw(rop, prec)
  bind.__gmpf_set_prec_raw(rop, prec)
end

function mod.f_set_q(rop, op)
  bind.__gmpf_set_q(rop, op)
end

function mod.f_set_si(rop, op)
  bind.__gmpf_set_si(rop, op)
end

function mod.f_set_str(rop, str, base)
  return bind.__gmpf_set_str(rop, str, base)
end

function mod.f_set_ui(rop, op)
  bind.__gmpf_set_ui(rop, op)
end

function mod.f_set_z(rop, op)
  bind.__gmpf_set_z(rop, op)
end

function mod.f_size(op)
  return bind.__gmpf_size(op)
end

function mod.f_sqrt(rop, op)
  bind.__gmpf_sqrt(rop, op)
end

function mod.f_sqrt_ui(rop, op)
  bind.__gmpf_sqrt_ui(rop, op)
end

function mod.f_sub(rop, op1, op2)
  bind.__gmpf_sub(rop, op1, op2)
end

function mod.f_sub_ui(rop, op1, op2)
  bind.__gmpf_sub_ui(rop, op1, op2)
end

function mod.f_swap(rop1, rop2)
  bind.__gmpf_swap(rop1, rop2)
end

function mod.f_trunc(rop, op)
  bind.__gmpf_trunc(rop, op)
end

function mod.f_ui_div(rop, op1, op2)
  bind.__gmpf_ui_div(rop, op1, op2)
end

function mod.f_ui_sub(rop, op1, op2)
  bind.__gmpf_ui_sub(rop, op1, op2)
end

function mod.f_urandomb(rop, state, nbits)
  bind.__gmpf_urandomb(rop, state, nbits)
end


function help.vararg(...)
  local t = { ... }
  t[#t + 1] = 0
  return unpack(t)
end


local types = {}

types.z = 'mpz_t'
types.q = 'mpq_t'
types.f = 'mpf_t'
types.randstate = 'gmp_randstate_t'


mod.types = types

setmetatable(mod, {
  __call = function(self, name)
    ffi.cdef(header)

    bind = ffi.load(name)

    for k,v in pairs(types) do
      types[k] = ffi.typeof(v)
    end

    return self
  end
})

return mod
