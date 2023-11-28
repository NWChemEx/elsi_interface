/* Copyright 2014 - 2023, A. Marek */

/*     This file is part of ELPA. */

/*     The ELPA library was originally created by the ELPA consortium, */
/*     consisting of the following organizations: */

/*     - Max Planck Computing and Data Facility (MPCDF), formerly known as */
/*       Rechenzentrum Garching der Max-Planck-Gesellschaft (RZG), */
/*     - Bergische Universität Wuppertal, Lehrstuhl für angewandte */
/*       Informatik, */
/*     - Technische Universität München, Lehrstuhl für Informatik mit */
/*       Schwerpunkt Wissenschaftliches Rechnen , */
/*     - Fritz-Haber-Institut, Berlin, Abt. Theorie, */
/*     - Max-Plack-Institut für Mathematik in den Naturwissenschaften, */
/*       Leipzig, Abt. Komplexe Strukutren in Biologie und Kognition, */
/*       and */
/*     - IBM Deutschland GmbH */


/*     More information can be found here: */
/*     http://elpa.mpcdf.mpg.de/ */

/*     ELPA is free software: you can redistribute it and/or modify */
/*     it under the terms of the version 3 of the license of the */
/*     GNU Lesser General Public License as published by the Free */
/*     Software Foundation. */

/*     ELPA is distributed in the hope that it will be useful, */
/*     but WITHOUT ANY WARRANTY; without even the implied warranty of */
/*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/*     GNU Lesser General Public License for more details. */

/*     You should have received a copy of the GNU Lesser General Public License */
/*     along with ELPA.  If not, see <http://www.gnu.org/licenses/> */

/*     ELPA reflects a substantial effort on the part of the original */
/*     ELPA consortium, and we ask you to respect the spirit of the */
/*     license that we chose: i.e., please contribute any changes you */
/*     may have back to the original ELPA library distribution, and keep */
/*     any derivatives of ELPA under the same license that we chose for */
/*     the original distribution, the GNU Lesser General Public License. */

/*  Author: Andreas Marek, MPCDF */
/*  This file is the generated version. Do NOT edit */


# 1 "../src/elpa2/kernels/real_avx512_2hv_single_precision.c"
# 1 "/usr/include/stdc-predef.h" 1 3







































# 1 "../src/elpa2/kernels/real_avx512_2hv_single_precision.c" 2














































# 1 "./config-f90.h" 1
# 48 "../src/elpa2/kernels/real_avx512_2hv_single_precision.c" 2

# 1 "../src/elpa2/kernels/../../general/precision_macros.h" 1
# 50 "../src/elpa2/kernels/../../general/precision_macros.h"

# 63 "../src/elpa2/kernels/../../general/precision_macros.h"






# 129 "../src/elpa2/kernels/../../general/precision_macros.h"



















# 233 "../src/elpa2/kernels/../../general/precision_macros.h"





# 247 "../src/elpa2/kernels/../../general/precision_macros.h"

# 311 "../src/elpa2/kernels/../../general/precision_macros.h"













# 54 "../src/elpa2/kernels/real_avx512_2hv_single_precision.c" 2
# 1 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c" 1
















































# 1 "./config-f90.h" 1
# 50 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c" 2

# 1 "/usr/include/stdlib.h" 1 3























# 1 "/usr/include/features.h" 1 3

































































































# 125 "/usr/include/features.h" 3

















# 148 "/usr/include/features.h" 3










# 182 "/usr/include/features.h" 3



# 191 "/usr/include/features.h" 3






























# 235 "/usr/include/features.h" 3

















# 259 "/usr/include/features.h" 3







# 291 "/usr/include/features.h" 3





































# 342 "/usr/include/features.h" 3























# 371 "/usr/include/features.h" 3


# 1 "/usr/include/sys/cdefs.h" 1 3









































# 49 "/usr/include/sys/cdefs.h" 3






# 70 "/usr/include/sys/cdefs.h" 3

# 80 "/usr/include/sys/cdefs.h" 3


















# 105 "/usr/include/sys/cdefs.h" 3







# 120 "/usr/include/sys/cdefs.h" 3



# 130 "/usr/include/sys/cdefs.h" 3














# 155 "/usr/include/sys/cdefs.h" 3




# 172 "/usr/include/sys/cdefs.h" 3














# 200 "/usr/include/sys/cdefs.h" 3












































# 251 "/usr/include/sys/cdefs.h" 3
























# 281 "/usr/include/sys/cdefs.h" 3











# 304 "/usr/include/sys/cdefs.h" 3

























# 341 "/usr/include/sys/cdefs.h" 3




























# 383 "/usr/include/sys/cdefs.h" 3

# 391 "/usr/include/sys/cdefs.h" 3

# 1 "/usr/include/bits/wordsize.h" 1 3











# 393 "/usr/include/sys/cdefs.h" 2 3

# 425 "/usr/include/sys/cdefs.h" 3

# 376 "/usr/include/features.h" 2 3























# 1 "/usr/include/gnu/stubs.h" 1 3





# 1 "/usr/include/gnu/stubs-64.h" 1 3









# 11 "/usr/include/gnu/stubs.h" 2 3
# 400 "/usr/include/features.h" 2 3


# 25 "/usr/include/stdlib.h" 2 3


# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 1 3


































typedef long ptrdiff_t;


# 47 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3
typedef unsigned long size_t;


















typedef int wchar_t;



# 80 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 87 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3




typedef struct {
  long long __clang_max_align_nonce1
      __attribute__((__aligned__(__alignof__(long long))));
  long double __clang_max_align_nonce2
      __attribute__((__aligned__(__alignof__(long double))));
} max_align_t;
# 103 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3






# 33 "/usr/include/stdlib.h" 2 3








# 1 "/usr/include/bits/waitflags.h" 1 3

































# 42 "/usr/include/stdlib.h" 2 3
# 1 "/usr/include/bits/waitstatus.h" 1 3































































# 1 "/usr/include/endian.h" 1 3



































# 1 "/usr/include/bits/endian.h" 1 3






# 37 "/usr/include/endian.h" 2 3







# 50 "/usr/include/endian.h" 3










# 1 "/usr/include/bits/byteswap.h" 1 3

























# 1 "/usr/include/bits/types.h" 1 3

























# 1 "/usr/include/bits/wordsize.h" 1 3











# 28 "/usr/include/bits/types.h" 2 3


typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;


typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;

typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;







typedef long int __quad_t;
typedef unsigned long int __u_quad_t;
# 67 "/usr/include/bits/types.h" 3































# 125 "/usr/include/bits/types.h" 3

# 1 "/usr/include/bits/typesizes.h" 1 3





























# 37 "/usr/include/bits/typesizes.h" 3

# 74 "/usr/include/bits/typesizes.h" 3















# 131 "/usr/include/bits/types.h" 2 3


typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned long int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;

typedef int __daddr_t;
typedef int __key_t;


typedef int __clockid_t;


typedef void * __timer_t;


typedef long int __blksize_t;




typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;


typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;


typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;


typedef long int __fsword_t;

typedef long int __ssize_t;


typedef long int __syscall_slong_t;

typedef unsigned long int __syscall_ulong_t;



typedef __off64_t __loff_t;
typedef __quad_t *__qaddr_t;
typedef char *__caddr_t;


typedef long int __intptr_t;


typedef unsigned int __socklen_t;




# 28 "/usr/include/bits/byteswap.h" 2 3
# 1 "/usr/include/bits/wordsize.h" 1 3











# 29 "/usr/include/bits/byteswap.h" 2 3






# 1 "/usr/include/bits/byteswap-16.h" 1 3






















# 36 "/usr/include/bits/byteswap.h" 2 3








static __inline unsigned int
__bswap_32 (unsigned int __bsx)
{
  return __builtin_bswap32 (__bsx);
}
# 93 "/usr/include/bits/byteswap.h" 3




# 106 "/usr/include/bits/byteswap.h" 3


static __inline __uint64_t
__bswap_64 (__uint64_t __bsx)
{
  return __builtin_bswap64 (__bsx);
}
# 154 "/usr/include/bits/byteswap.h" 3

# 61 "/usr/include/endian.h" 2 3












# 79 "/usr/include/endian.h" 3

# 99 "/usr/include/endian.h" 3

# 65 "/usr/include/bits/waitstatus.h" 2 3

union wait
  {
    int w_status;
    struct
      {

	unsigned int __w_termsig:7;
	unsigned int __w_coredump:1;
	unsigned int __w_retcode:8;
	unsigned int:16;
# 83 "/usr/include/bits/waitstatus.h" 3
      } __wait_terminated;
    struct
      {

	unsigned int __w_stopval:8;
	unsigned int __w_stopsig:8;
	unsigned int:16;
# 96 "/usr/include/bits/waitstatus.h" 3
      } __wait_stopped;
  };







# 43 "/usr/include/stdlib.h" 2 3






# 56 "/usr/include/stdlib.h" 3











typedef union
  {
    union wait *__uptr;
    int *__iptr;
  } __WAIT_STATUS __attribute__ ((__transparent_union__));



# 82 "/usr/include/stdlib.h" 3


# 94 "/usr/include/stdlib.h" 3



typedef struct
  {
    int quot;
    int rem;
  } div_t;



typedef struct
  {
    long int quot;
    long int rem;
  } ldiv_t;







__extension__ typedef struct
  {
    long long int quot;
    long long int rem;
  } lldiv_t;

















extern size_t __ctype_get_mb_cur_max (void) __attribute__ ((__nothrow__ , __leaf__)) ;




extern double atof (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;

extern int atoi (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;

extern long int atol (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;





__extension__ extern long long int atoll (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;





extern double strtod (const char *__restrict __nptr,
		      char **__restrict __endptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));





extern float strtof (const char *__restrict __nptr,
		     char **__restrict __endptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));

extern long double strtold (const char *__restrict __nptr,
			    char **__restrict __endptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));





extern long int strtol (const char *__restrict __nptr,
			char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));

extern unsigned long int strtoul (const char *__restrict __nptr,
				  char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));




__extension__
extern long long int strtoq (const char *__restrict __nptr,
			     char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));

__extension__
extern unsigned long long int strtouq (const char *__restrict __nptr,
				       char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));





__extension__
extern long long int strtoll (const char *__restrict __nptr,
			      char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));

__extension__
extern unsigned long long int strtoull (const char *__restrict __nptr,
					char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));




# 273 "/usr/include/stdlib.h" 3




extern __inline __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ , __leaf__)) atoi (const char *__nptr)
{
  return (int) strtol (__nptr, (char **) ((void*)0), 10);
}
extern __inline __attribute__ ((__gnu_inline__)) long int
__attribute__ ((__nothrow__ , __leaf__)) atol (const char *__nptr)
{
  return strtol (__nptr, (char **) ((void*)0), 10);
}




__extension__ extern __inline __attribute__ ((__gnu_inline__)) long long int
__attribute__ ((__nothrow__ , __leaf__)) atoll (const char *__nptr)
{
  return strtoll (__nptr, (char **) ((void*)0), 10);
}









extern char *l64a (long int __n) __attribute__ ((__nothrow__ , __leaf__)) ;


extern long int a64l (const char *__s)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;



# 1 "/usr/include/sys/types.h" 1 3
































typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;




typedef __loff_t loff_t;



typedef __ino_t ino_t;
# 58 "/usr/include/sys/types.h" 3


typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __uid_t uid_t;





typedef __off_t off_t;
# 96 "/usr/include/sys/types.h" 3


typedef __pid_t pid_t;





typedef __id_t id_t;




typedef __ssize_t ssize_t;





typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;





typedef __key_t key_t;



# 1 "/usr/include/time.h" 1 3























# 32 "/usr/include/time.h" 3

# 51 "/usr/include/time.h" 3








typedef __clock_t clock_t;















typedef __time_t time_t;















typedef __clockid_t clockid_t;











typedef __timer_t timer_t;





# 128 "/usr/include/time.h" 3


# 433 "/usr/include/time.h" 3

# 133 "/usr/include/sys/types.h" 2 3

# 144 "/usr/include/sys/types.h" 3

# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 1 3





































# 50 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3











# 69 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 80 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 87 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 103 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3






# 147 "/usr/include/sys/types.h" 2 3



typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;




# 185 "/usr/include/sys/types.h" 3









typedef int int8_t __attribute__ ((__mode__ (__QI__)));
typedef int int16_t __attribute__ ((__mode__ (__HI__)));
typedef int int32_t __attribute__ ((__mode__ (__SI__)));
typedef int int64_t __attribute__ ((__mode__ (__DI__)));


typedef unsigned int u_int8_t __attribute__ ((__mode__ (__QI__)));
typedef unsigned int u_int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int u_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int u_int64_t __attribute__ ((__mode__ (__DI__)));

typedef int register_t __attribute__ ((__mode__ (__word__)));













# 1 "/usr/include/sys/select.h" 1 3





























# 1 "/usr/include/bits/select.h" 1 3





















# 1 "/usr/include/bits/wordsize.h" 1 3











# 23 "/usr/include/bits/select.h" 2 3










# 43 "/usr/include/bits/select.h" 3

# 57 "/usr/include/bits/select.h" 3

# 31 "/usr/include/sys/select.h" 2 3


# 1 "/usr/include/bits/sigset.h" 1 3






















typedef int __sig_atomic_t;




typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;










# 34 "/usr/include/sys/select.h" 2 3



typedef __sigset_t sigset_t;



# 1 "/usr/include/time.h" 1 3























# 32 "/usr/include/time.h" 3

# 51 "/usr/include/time.h" 3

# 67 "/usr/include/time.h" 3

# 83 "/usr/include/time.h" 3

# 95 "/usr/include/time.h" 3

# 107 "/usr/include/time.h" 3


# 115 "/usr/include/time.h" 3





struct timespec
  {
    __time_t tv_sec;
    __syscall_slong_t tv_nsec;
  };





# 433 "/usr/include/time.h" 3

# 44 "/usr/include/sys/select.h" 2 3
# 1 "/usr/include/bits/time.h" 1 3





























struct timeval
  {
    __time_t tv_sec;
    __suseconds_t tv_usec;
  };



# 100 "/usr/include/bits/time.h" 3

# 46 "/usr/include/sys/select.h" 2 3


typedef __suseconds_t suseconds_t;





typedef long int __fd_mask;









typedef struct
  {






    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];


  } fd_set;






typedef __fd_mask fd_mask;























extern int select (int __nfds, fd_set *__restrict __readfds,
		   fd_set *__restrict __writefds,
		   fd_set *__restrict __exceptfds,
		   struct timeval *__restrict __timeout);








extern int pselect (int __nfds, fd_set *__restrict __readfds,
		    fd_set *__restrict __writefds,
		    fd_set *__restrict __exceptfds,
		    const struct timespec *__restrict __timeout,
		    const __sigset_t *__restrict __sigmask);










# 220 "/usr/include/sys/types.h" 2 3


# 1 "/usr/include/sys/sysmacros.h" 1 3






























__extension__
extern unsigned int gnu_dev_major (unsigned long long int __dev)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
__extension__
extern unsigned int gnu_dev_minor (unsigned long long int __dev)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
__extension__
extern unsigned long long int gnu_dev_makedev (unsigned int __major,
					       unsigned int __minor)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));


__extension__ extern __inline __attribute__ ((__gnu_inline__)) __attribute__ ((__const__)) unsigned int
__attribute__ ((__nothrow__ , __leaf__)) gnu_dev_major (unsigned long long int __dev)
{
  return ((__dev >> 8) & 0xfff) | ((unsigned int) (__dev >> 32) & ~0xfff);
}

__extension__ extern __inline __attribute__ ((__gnu_inline__)) __attribute__ ((__const__)) unsigned int
__attribute__ ((__nothrow__ , __leaf__)) gnu_dev_minor (unsigned long long int __dev)
{
  return (__dev & 0xff) | ((unsigned int) (__dev >> 12) & ~0xff);
}

__extension__ extern __inline __attribute__ ((__gnu_inline__)) __attribute__ ((__const__)) unsigned long long int
__attribute__ ((__nothrow__ , __leaf__)) gnu_dev_makedev (unsigned int __major, unsigned int __minor)
{
  return ((__minor & 0xff) | ((__major & 0xfff) << 8)
	  | (((unsigned long long int) (__minor & ~0xff)) << 12)
	  | (((unsigned long long int) (__major & ~0xfff)) << 32));
}









# 223 "/usr/include/sys/types.h" 2 3





typedef __blksize_t blksize_t;






typedef __blkcnt_t blkcnt_t;



typedef __fsblkcnt_t fsblkcnt_t;



typedef __fsfilcnt_t fsfilcnt_t;
# 260 "/usr/include/sys/types.h" 3









# 1 "/usr/include/bits/pthreadtypes.h" 1 3




















# 1 "/usr/include/bits/wordsize.h" 1 3











# 22 "/usr/include/bits/pthreadtypes.h" 2 3

# 56 "/usr/include/bits/pthreadtypes.h" 3




typedef unsigned long int pthread_t;


union pthread_attr_t
{
  char __size[56];
  long int __align;
};

typedef union pthread_attr_t pthread_attr_t;





typedef struct __pthread_internal_list
{
  struct __pthread_internal_list *__prev;
  struct __pthread_internal_list *__next;
} __pthread_list_t;
# 86 "/usr/include/bits/pthreadtypes.h" 3




typedef union
{
  struct __pthread_mutex_s
  {
    int __lock;
    unsigned int __count;
    int __owner;

    unsigned int __nusers;



    int __kind;

    short __spins;
    short __elision;
    __pthread_list_t __list;


# 125 "/usr/include/bits/pthreadtypes.h" 3
  } __data;
  char __size[40];
  long int __align;
} pthread_mutex_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_mutexattr_t;




typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_condattr_t;



typedef unsigned int pthread_key_t;



typedef int pthread_once_t;





typedef union
{

  struct
  {
    int __lock;
    unsigned int __nr_readers;
    unsigned int __readers_wakeup;
    unsigned int __writer_wakeup;
    unsigned int __nr_readers_queued;
    unsigned int __nr_writers_queued;
    int __writer;
    int __shared;
    unsigned long int __pad1;
    unsigned long int __pad2;


    unsigned int __flags;

  } __data;
# 212 "/usr/include/bits/pthreadtypes.h" 3
  char __size[56];
  long int __align;
} pthread_rwlock_t;

typedef union
{
  char __size[8];
  long int __align;
} pthread_rwlockattr_t;





typedef volatile int pthread_spinlock_t;




typedef union
{
  char __size[32];
  long int __align;
} pthread_barrier_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_barrierattr_t;








# 271 "/usr/include/sys/types.h" 2 3




# 315 "/usr/include/stdlib.h" 2 3






extern long int random (void) __attribute__ ((__nothrow__ , __leaf__));


extern void srandom (unsigned int __seed) __attribute__ ((__nothrow__ , __leaf__));





extern char *initstate (unsigned int __seed, char *__statebuf,
			size_t __statelen) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));



extern char *setstate (char *__statebuf) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));







struct random_data
  {
    int32_t *fptr;
    int32_t *rptr;
    int32_t *state;
    int rand_type;
    int rand_deg;
    int rand_sep;
    int32_t *end_ptr;
  };

extern int random_r (struct random_data *__restrict __buf,
		     int32_t *__restrict __result) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));

extern int srandom_r (unsigned int __seed, struct random_data *__buf)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));

extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
			size_t __statelen,
			struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2, 4)));

extern int setstate_r (char *__restrict __statebuf,
		       struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));






extern int rand (void) __attribute__ ((__nothrow__ , __leaf__));

extern void srand (unsigned int __seed) __attribute__ ((__nothrow__ , __leaf__));




extern int rand_r (unsigned int *__seed) __attribute__ ((__nothrow__ , __leaf__));







extern double drand48 (void) __attribute__ ((__nothrow__ , __leaf__));
extern double erand48 (unsigned short int __xsubi[3]) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));


extern long int lrand48 (void) __attribute__ ((__nothrow__ , __leaf__));
extern long int nrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));


extern long int mrand48 (void) __attribute__ ((__nothrow__ , __leaf__));
extern long int jrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));


extern void srand48 (long int __seedval) __attribute__ ((__nothrow__ , __leaf__));
extern unsigned short int *seed48 (unsigned short int __seed16v[3])
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern void lcong48 (unsigned short int __param[7]) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));





struct drand48_data
  {
    unsigned short int __x[3];
    unsigned short int __old_x[3];
    unsigned short int __c;
    unsigned short int __init;
    unsigned long long int __a;
  };


extern int drand48_r (struct drand48_data *__restrict __buffer,
		      double *__restrict __result) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern int erand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      double *__restrict __result) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern int lrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern int nrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern int mrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern int jrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));

extern int seed48_r (unsigned short int __seed16v[3],
		     struct drand48_data *__buffer) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));

extern int lcong48_r (unsigned short int __param[7],
		      struct drand48_data *__buffer)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));









extern void *malloc (size_t __size) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) ;

extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) ;










extern void *realloc (void *__ptr, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__warn_unused_result__));

extern void free (void *__ptr) __attribute__ ((__nothrow__ , __leaf__));




extern void cfree (void *__ptr) __attribute__ ((__nothrow__ , __leaf__));


# 1 "/usr/include/alloca.h" 1 3






















# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 1 3





































# 50 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3











# 69 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 80 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 87 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 103 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3






# 25 "/usr/include/alloca.h" 2 3







extern void *alloca (size_t __size) __attribute__ ((__nothrow__ , __leaf__));







# 492 "/usr/include/stdlib.h" 2 3





extern void *valloc (size_t __size) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) ;




extern int posix_memalign (void **__memptr, size_t __alignment, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1))) ;




extern void *aligned_alloc (size_t __alignment, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__))  __attribute__ ((__malloc__, __alloc_size__ (2)));




extern void abort (void) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));



extern int atexit (void (*__func) (void)) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));







extern int at_quick_exit (void (*__func) (void)) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));







extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));






extern void exit (int __status) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));





extern void quick_exit (int __status) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));







extern void _Exit (int __status) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));






extern char *getenv (const char *__name) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1))) ;


# 572 "/usr/include/stdlib.h" 3





extern int putenv (char *__string) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));





extern int setenv (const char *__name, const char *__value, int __replace)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));


extern int unsetenv (const char *__name) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));






extern int clearenv (void) __attribute__ ((__nothrow__ , __leaf__));










extern char *mktemp (char *__template) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));













extern int mkstemp (char *__template) __attribute__ ((__nonnull__ (1))) ;
# 632 "/usr/include/stdlib.h" 3









extern int mkstemps (char *__template, int __suffixlen) __attribute__ ((__nonnull__ (1))) ;
# 655 "/usr/include/stdlib.h" 3







extern char *mkdtemp (char *__template) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1))) ;


# 709 "/usr/include/stdlib.h" 3







extern int system (const char *__command) ;



# 726 "/usr/include/stdlib.h" 3







extern char *realpath (const char *__restrict __name,
		       char *__restrict __resolved) __attribute__ ((__nothrow__ , __leaf__)) ;






typedef int (*__compar_fn_t) (const void *, const void *);

# 750 "/usr/include/stdlib.h" 3




extern void *bsearch (const void *__key, const void *__base,
		      size_t __nmemb, size_t __size, __compar_fn_t __compar)
     __attribute__ ((__nonnull__ (1, 2, 5))) ;



extern void qsort (void *__base, size_t __nmemb, size_t __size,
		   __compar_fn_t __compar) __attribute__ ((__nonnull__ (1, 4)));








extern int abs (int __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
extern long int labs (long int __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;



__extension__ extern long long int llabs (long long int __x)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;







extern div_t div (int __numer, int __denom)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
extern ldiv_t ldiv (long int __numer, long int __denom)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;




__extension__ extern lldiv_t lldiv (long long int __numer,
				    long long int __denom)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;












extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4))) ;




extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4))) ;




extern char *gcvt (double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3))) ;




extern char *qecvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qfcvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3))) ;




extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4, 5)));

extern int qecvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int qfcvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (3, 4, 5)));







extern int mblen (const char *__s, size_t __n) __attribute__ ((__nothrow__ , __leaf__)) ;


extern int mbtowc (wchar_t *__restrict __pwc,
		   const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__ , __leaf__)) ;


extern int wctomb (char *__s, wchar_t __wchar) __attribute__ ((__nothrow__ , __leaf__)) ;



extern size_t mbstowcs (wchar_t *__restrict  __pwcs,
			const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__ , __leaf__));

extern size_t wcstombs (char *__restrict __s,
			const wchar_t *__restrict __pwcs, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__));








extern int rpmatch (const char *__response) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1))) ;










extern int getsubopt (char **__restrict __optionp,
		      char *const *__restrict __tokens,
		      char **__restrict __valuep)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2, 3))) ;
















# 931 "/usr/include/stdlib.h" 3

# 942 "/usr/include/stdlib.h" 3





extern int getloadavg (double __loadavg[], int __nelem)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));


# 1 "/usr/include/bits/stdlib-float.h" 1 3
























extern __inline __attribute__ ((__gnu_inline__)) double
__attribute__ ((__nothrow__ , __leaf__)) atof (const char *__nptr)
{
  return strtod (__nptr, (char **) ((void*)0));
}

# 952 "/usr/include/stdlib.h" 2 3


# 960 "/usr/include/stdlib.h" 3






# 52 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c" 2




















# 82 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/x86intrin.h" 1 3













# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 1 3








# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/wmmintrin.h" 1 3













# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/nmmintrin.h" 1 3














# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/smmintrin.h" 1 3













# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/tmmintrin.h" 1 3








# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/pmmintrin.h" 1 3












# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/emmintrin.h" 1 3


































# 42 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/emmintrin.h" 3






# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 1 3
















# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/mmintrin.h" 1 3

































# 41 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/mmintrin.h" 3

# 49 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/mmintrin.h" 3





# 77 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/mmintrin.h" 3




typedef union __declspec(align(8)) __declspec(intrin_type) __m64 {




    unsigned __int64    m64_u64;
    float               m64_f32[2];
    __int8              m64_i8[8];
    __int16             m64_i16[4];
    __int32             m64_i32[2];
    __int64             m64_i64;
    unsigned __int8     m64_u8[8];
    unsigned __int16    m64_u16[4];
    unsigned __int32    m64_u32[2];





    __int64 __m;
} __m64;








# 192 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/mmintrin.h" 3


# 251 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/mmintrin.h" 3






# 18 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 2 3

# 25 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3



# 55 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3
   typedef struct __declspec(align(16)) __declspec(intrin_type) __m128 {
    float               m128_f32[4];
   } __m128;















# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 1 3





































# 50 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3











# 69 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 80 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 87 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 103 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3






# 75 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 2 3
extern void*  _mm_malloc(size_t, size_t);
extern void   _mm_free(void *);


























# 116 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3



# 127 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3


# 136 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3

# 144 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3



































# 336 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3


# 360 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3














# 383 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3










# 400 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 3









































































# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/emmintrin.h" 1 3









# 477 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/xmmintrin.h" 2 3


# 49 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/emmintrin.h" 2 3





typedef struct __declspec(align(16)) __declspec(intrin_type) __m128d {
    double              m128d_f64[2];
} __m128d;
typedef union  __declspec(align(16)) __declspec(intrin_type) __m128i {





     __int64             m128i_gcc_compatibility[2];





    __int8              m128i_i8[16];
    __int16             m128i_i16[8];
    __int32             m128i_i32[4];
    __int64             m128i_i64[2];
    unsigned __int8     m128i_u8[16];
    unsigned __int16    m128i_u16[8];
    unsigned __int32    m128i_u32[4];
    unsigned __int64    m128i_u64[2];





    char c[16];
} __m128i;












# 443 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/emmintrin.h" 3


















# 14 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/pmmintrin.h" 2 3










# 50 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/pmmintrin.h" 3







extern void  _mm_monitor(void const *, unsigned, unsigned);



extern void  _mm_mwait(unsigned, unsigned);

# 10 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/tmmintrin.h" 2 3





# 92 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/tmmintrin.h" 3





# 15 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/smmintrin.h" 2 3















# 36 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/smmintrin.h" 3
































# 156 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/smmintrin.h" 3







# 170 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/smmintrin.h" 3












# 270 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/smmintrin.h" 3





# 16 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/nmmintrin.h" 2 3


























































# 128 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/nmmintrin.h" 3





# 15 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/wmmintrin.h" 2 3







# 70 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/wmmintrin.h" 3





# 10 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 2 3









# 26 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3
typedef union  __declspec(align(32)) __declspec(intrin_type) __m256 {
    float m256_f32[8];
} __m256;

typedef struct __declspec(align(32)) __declspec(intrin_type) __m256d {
    double m256d_f64[4];
} __m256d;

typedef union  __declspec(align(32)) __declspec(intrin_type) __m256i {





    __int64             m256i_gcc_compatibility[4];

    __int8              m256i_i8[32];
    __int16             m256i_i16[16];
    __int32             m256i_i32[8];
    __int64             m256i_i64[4];
    unsigned __int8     m256i_u8[32];
    unsigned __int16    m256i_u16[16];
    unsigned __int32    m256i_u32[8];
    unsigned __int64    m256i_u64[4];
} __m256i;




typedef int     __v2si __attribute__ ((__vector_size__ (8)));
typedef short   __v4hi __attribute__ ((__vector_size__ (8)));
typedef char    __v8qi __attribute__ ((__vector_size__ (8)));
typedef __int64 __v1di __attribute__ ((__vector_size__ (8)));
typedef float   __v2sf __attribute__ ((__vector_size__ (8)));

typedef float   __v4sf __attribute__ ((__vector_size__ (16)));
typedef double  __v2df __attribute__ ((__vector_size__ (16)));
typedef __int64 __v2di __attribute__ ((__vector_size__ (16)));
typedef int     __v4si __attribute__ ((__vector_size__ (16)));
typedef short   __v8hi __attribute__ ((__vector_size__ (16)));
typedef char    __v16qi __attribute__((__vector_size__ (16)));

typedef double  __v4df __attribute__ ((__vector_size__ (32)));
typedef float   __v8sf __attribute__ ((__vector_size__ (32)));
typedef __int64 __v4di __attribute__ ((__vector_size__ (32)));
typedef int     __v8si __attribute__ ((__vector_size__ (32)));
typedef short   __v16hi __attribute__((__vector_size__ (32)));
typedef char    __v32qi __attribute__((__vector_size__ (32)));





# 116 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




extern void  _allow_cpu_features(unsigned __int64);
extern int  _may_i_use_cpu_feature(unsigned __int64);
# 176 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




extern __int64  _rdtsc(void);
extern __int64  _rdpmc(int);


extern int  _bswap(int);


extern int  _bit_scan_forward(int);
extern int  _bit_scan_reverse(int);



extern unsigned char  _BitScanForward(unsigned __int32*,
                                                    unsigned __int32);
extern unsigned char  _BitScanReverse(unsigned __int32*,
                                                    unsigned __int32);



extern unsigned char  _BitScanForward64(unsigned __int32*,
                                                      unsigned __int64);
extern unsigned char  _BitScanReverse64(unsigned __int32*,
                                                      unsigned __int64);



extern unsigned char  _bittest(__int32 *, __int32);
extern unsigned char  _bittestandcomplement(__int32 *, __int32);
extern unsigned char  _bittestandreset(__int32 *, __int32);
extern unsigned char  _bittestandset(__int32 *, __int32);



extern unsigned char  _bittest64(__int64 *, __int64);
extern unsigned char  _bittestandcomplement64(__int64*, __int64);
extern unsigned char  _bittestandreset64(__int64 *, __int64);
extern unsigned char  _bittestandset64(__int64 *, __int64);




extern int  _popcnt32(int);


extern unsigned short  _rotwl(unsigned short, int);
extern unsigned short  _rotwr(unsigned short, int);


extern unsigned int  _rotl(unsigned int, int);
extern unsigned int  _rotr(unsigned int, int);


extern unsigned long  _lrotl(unsigned long, int);
extern unsigned long  _lrotr(unsigned long, int);

extern unsigned __int64  _rotl64(unsigned __int64, int);
extern unsigned __int64  _rotr64(unsigned __int64, int);

# 458 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




# 477 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




# 491 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




# 510 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




# 533 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3


# 1208 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3





























# 1244 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3

# 1252 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3

# 1260 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3

# 1422 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3

# 1439 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3

# 1569 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3










# 1603 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3

# 1733 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3





















# 2338 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




extern unsigned int      _bextr_u32(unsigned int,
                                                  unsigned int,
                                                  unsigned int);
extern unsigned int      _bextr2_u32(unsigned int,
                                                   unsigned int);
extern unsigned int      _blsi_u32(unsigned int);
extern unsigned int      _blsmsk_u32(unsigned int);
extern unsigned int      _blsr_u32(unsigned int);
extern unsigned int      _bzhi_u32(unsigned int,
                                                 unsigned int);
extern unsigned int      _pext_u32(unsigned int,
                                                 unsigned int);
extern unsigned int      _pdep_u32(unsigned int,
                                                 unsigned int);
extern unsigned int      _andn_u32(unsigned int,
                                                 unsigned int);

# 2365 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3


extern unsigned __int64  _bextr_u64(unsigned __int64,
                                                  unsigned int,
                                                  unsigned int);
extern unsigned __int64  _bextr2_u64(unsigned __int64,
                                                   unsigned __int64);
extern unsigned __int64  _blsi_u64(unsigned __int64);
extern unsigned __int64  _blsmsk_u64(unsigned __int64);
extern unsigned __int64  _blsr_u64(unsigned __int64);
extern unsigned __int64  _bzhi_u64(unsigned __int64,
                                                 unsigned int);
extern unsigned __int64  _pext_u64(unsigned __int64,
                                                 unsigned __int64);
extern unsigned __int64  _pdep_u64(unsigned __int64,
                                                 unsigned __int64);
extern unsigned __int64  _andn_u64(unsigned __int64,
                                                 unsigned __int64);

# 2391 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3







extern unsigned int      _lzcnt_u32(unsigned int);

extern unsigned __int64  _lzcnt_u64(unsigned __int64);









extern unsigned int      _tzcnt_u32(unsigned int);

extern unsigned __int64  _tzcnt_u64(unsigned __int64);







extern void  _invpcid(unsigned int  ,
                                    void *  );





# 2435 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3

extern unsigned int      _xbegin(void);
extern void              _xend(void);
extern void              _xabort(const unsigned int);
extern unsigned char     _xtest(void);








extern int  _rdseed16_step(unsigned short *);
extern int  _rdseed32_step(unsigned int *);
extern int  _rdseed64_step(unsigned __int64 *);





extern unsigned char  _addcarry_u32(unsigned char  ,
                                                  unsigned int  ,
                                                  unsigned int  ,
                                                  unsigned int *  );

extern unsigned char  _addcarry_u64(unsigned char  ,
                                                  unsigned __int64  ,
                                                  unsigned __int64  ,
                                                  unsigned __int64 *  );




extern unsigned char  _subborrow_u32(unsigned char  ,
                                                   unsigned int  ,
                                                   unsigned int  ,
                                                   unsigned int *  );

extern unsigned char  _subborrow_u64(unsigned char  ,
                                                   unsigned __int64  ,
                                                   unsigned __int64  ,
                                                   unsigned __int64 *  );





extern unsigned char  _addcarryx_u32(unsigned char  ,
                                                   unsigned int  ,
                                                   unsigned int  ,
                                                   unsigned int *  );

extern unsigned char  _addcarryx_u64(unsigned char  ,
                                                   unsigned __int64  ,
                                                   unsigned __int64  ,
                                                   unsigned __int64 *  );

# 2583 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 3




extern void *  _bnd_set_ptr_bounds(const void *, size_t);
extern void *  _bnd_narrow_ptr_bounds(const void *, const void *,
                                                    size_t);
extern void *  _bnd_copy_ptr_bounds(const void *, const void *);
extern void *  _bnd_init_ptr_bounds(const void *);
extern void  _bnd_store_ptr_bounds(const void **, const void *);
extern void  _bnd_chk_ptr_lbounds(const void *);
extern void  _bnd_chk_ptr_ubounds(const void *);
extern void  _bnd_chk_ptr_bounds(const void *, size_t);
extern const void *  _bnd_get_ptr_lbound(const void *);
extern const void *  _bnd_get_ptr_ubound(const void *);





# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 1 3


































typedef unsigned char       __mmask8;
typedef unsigned short      __mmask16;
typedef unsigned int        __mmask32;
typedef unsigned __int64    __mmask64;



typedef __mmask16 __mmask;

# 56 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

typedef union __declspec(align(64)) __declspec(intrin_type) __m512 {
    float       __m512_f32[16];
} __m512;

typedef union __declspec(align(64)) __declspec(intrin_type) __m512d {
    double      __m512d_f64[8];
} __m512d;

typedef union __declspec(align(64)) __declspec(intrin_type) __m512i {





    __int64             m512i_gcc_compatibility[8];

    __int8              m512i_i8[64];
    __int16             m512i_i16[32];
    __int32             m512i_i32[16];
    __int64             m512i_i64[8];
    unsigned __int8     m512i_u8[64];
    unsigned __int16    m512i_u16[32];
    unsigned __int32    m512i_u32[16];
    unsigned __int64    m512i_u64[8];
    int                 __m512i_i32[16];
} __m512i;










# 101 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







typedef enum {
    _MM_SWIZ_REG_NONE,

    _MM_SWIZ_REG_CDAB,
    _MM_SWIZ_REG_BADC,
    _MM_SWIZ_REG_AAAA,
    _MM_SWIZ_REG_BBBB,
    _MM_SWIZ_REG_CCCC,
    _MM_SWIZ_REG_DDDD,
    _MM_SWIZ_REG_DACB
} _MM_SWIZZLE_ENUM;


typedef enum {
    _MM_BROADCAST32_NONE,

    _MM_BROADCAST_1X16,
    _MM_BROADCAST_4X16
} _MM_BROADCAST32_ENUM;


typedef enum {
    _MM_BROADCAST64_NONE,

    _MM_BROADCAST_1X8,
    _MM_BROADCAST_4X8
} _MM_BROADCAST64_ENUM;






typedef enum {
    _MM_ROUND_MODE_NEAREST,
    _MM_ROUND_MODE_DOWN,
    _MM_ROUND_MODE_UP,
    _MM_ROUND_MODE_TOWARD_ZERO,
    _MM_ROUND_MODE_DEFAULT
} _MM_ROUND_MODE_ENUM;


typedef enum {
    _MM_EXPADJ_NONE,
    _MM_EXPADJ_4,
    _MM_EXPADJ_5,
    _MM_EXPADJ_8,
    _MM_EXPADJ_16,
    _MM_EXPADJ_24,
    _MM_EXPADJ_31,
    _MM_EXPADJ_32
} _MM_EXP_ADJ_ENUM;


typedef enum {
    _MM_SCALE_1 = 1,
    _MM_SCALE_2 = 2,
    _MM_SCALE_4 = 4,
    _MM_SCALE_8 = 8
} _MM_INDEX_SCALE_ENUM;







typedef enum {
    _MM_PERM_AAAA = 0x00, _MM_PERM_AAAB = 0x01, _MM_PERM_AAAC = 0x02,
    _MM_PERM_AAAD = 0x03, _MM_PERM_AABA = 0x04, _MM_PERM_AABB = 0x05,
    _MM_PERM_AABC = 0x06, _MM_PERM_AABD = 0x07, _MM_PERM_AACA = 0x08,
    _MM_PERM_AACB = 0x09, _MM_PERM_AACC = 0x0A, _MM_PERM_AACD = 0x0B,
    _MM_PERM_AADA = 0x0C, _MM_PERM_AADB = 0x0D, _MM_PERM_AADC = 0x0E,
    _MM_PERM_AADD = 0x0F, _MM_PERM_ABAA = 0x10, _MM_PERM_ABAB = 0x11,
    _MM_PERM_ABAC = 0x12, _MM_PERM_ABAD = 0x13, _MM_PERM_ABBA = 0x14,
    _MM_PERM_ABBB = 0x15, _MM_PERM_ABBC = 0x16, _MM_PERM_ABBD = 0x17,
    _MM_PERM_ABCA = 0x18, _MM_PERM_ABCB = 0x19, _MM_PERM_ABCC = 0x1A,
    _MM_PERM_ABCD = 0x1B, _MM_PERM_ABDA = 0x1C, _MM_PERM_ABDB = 0x1D,
    _MM_PERM_ABDC = 0x1E, _MM_PERM_ABDD = 0x1F, _MM_PERM_ACAA = 0x20,
    _MM_PERM_ACAB = 0x21, _MM_PERM_ACAC = 0x22, _MM_PERM_ACAD = 0x23,
    _MM_PERM_ACBA = 0x24, _MM_PERM_ACBB = 0x25, _MM_PERM_ACBC = 0x26,
    _MM_PERM_ACBD = 0x27, _MM_PERM_ACCA = 0x28, _MM_PERM_ACCB = 0x29,
    _MM_PERM_ACCC = 0x2A, _MM_PERM_ACCD = 0x2B, _MM_PERM_ACDA = 0x2C,
    _MM_PERM_ACDB = 0x2D, _MM_PERM_ACDC = 0x2E, _MM_PERM_ACDD = 0x2F,
    _MM_PERM_ADAA = 0x30, _MM_PERM_ADAB = 0x31, _MM_PERM_ADAC = 0x32,
    _MM_PERM_ADAD = 0x33, _MM_PERM_ADBA = 0x34, _MM_PERM_ADBB = 0x35,
    _MM_PERM_ADBC = 0x36, _MM_PERM_ADBD = 0x37, _MM_PERM_ADCA = 0x38,
    _MM_PERM_ADCB = 0x39, _MM_PERM_ADCC = 0x3A, _MM_PERM_ADCD = 0x3B,
    _MM_PERM_ADDA = 0x3C, _MM_PERM_ADDB = 0x3D, _MM_PERM_ADDC = 0x3E,
    _MM_PERM_ADDD = 0x3F, _MM_PERM_BAAA = 0x40, _MM_PERM_BAAB = 0x41,
    _MM_PERM_BAAC = 0x42, _MM_PERM_BAAD = 0x43, _MM_PERM_BABA = 0x44,
    _MM_PERM_BABB = 0x45, _MM_PERM_BABC = 0x46, _MM_PERM_BABD = 0x47,
    _MM_PERM_BACA = 0x48, _MM_PERM_BACB = 0x49, _MM_PERM_BACC = 0x4A,
    _MM_PERM_BACD = 0x4B, _MM_PERM_BADA = 0x4C, _MM_PERM_BADB = 0x4D,
    _MM_PERM_BADC = 0x4E, _MM_PERM_BADD = 0x4F, _MM_PERM_BBAA = 0x50,
    _MM_PERM_BBAB = 0x51, _MM_PERM_BBAC = 0x52, _MM_PERM_BBAD = 0x53,
    _MM_PERM_BBBA = 0x54, _MM_PERM_BBBB = 0x55, _MM_PERM_BBBC = 0x56,
    _MM_PERM_BBBD = 0x57, _MM_PERM_BBCA = 0x58, _MM_PERM_BBCB = 0x59,
    _MM_PERM_BBCC = 0x5A, _MM_PERM_BBCD = 0x5B, _MM_PERM_BBDA = 0x5C,
    _MM_PERM_BBDB = 0x5D, _MM_PERM_BBDC = 0x5E, _MM_PERM_BBDD = 0x5F,
    _MM_PERM_BCAA = 0x60, _MM_PERM_BCAB = 0x61, _MM_PERM_BCAC = 0x62,
    _MM_PERM_BCAD = 0x63, _MM_PERM_BCBA = 0x64, _MM_PERM_BCBB = 0x65,
    _MM_PERM_BCBC = 0x66, _MM_PERM_BCBD = 0x67, _MM_PERM_BCCA = 0x68,
    _MM_PERM_BCCB = 0x69, _MM_PERM_BCCC = 0x6A, _MM_PERM_BCCD = 0x6B,
    _MM_PERM_BCDA = 0x6C, _MM_PERM_BCDB = 0x6D, _MM_PERM_BCDC = 0x6E,
    _MM_PERM_BCDD = 0x6F, _MM_PERM_BDAA = 0x70, _MM_PERM_BDAB = 0x71,
    _MM_PERM_BDAC = 0x72, _MM_PERM_BDAD = 0x73, _MM_PERM_BDBA = 0x74,
    _MM_PERM_BDBB = 0x75, _MM_PERM_BDBC = 0x76, _MM_PERM_BDBD = 0x77,
    _MM_PERM_BDCA = 0x78, _MM_PERM_BDCB = 0x79, _MM_PERM_BDCC = 0x7A,
    _MM_PERM_BDCD = 0x7B, _MM_PERM_BDDA = 0x7C, _MM_PERM_BDDB = 0x7D,
    _MM_PERM_BDDC = 0x7E, _MM_PERM_BDDD = 0x7F, _MM_PERM_CAAA = 0x80,
    _MM_PERM_CAAB = 0x81, _MM_PERM_CAAC = 0x82, _MM_PERM_CAAD = 0x83,
    _MM_PERM_CABA = 0x84, _MM_PERM_CABB = 0x85, _MM_PERM_CABC = 0x86,
    _MM_PERM_CABD = 0x87, _MM_PERM_CACA = 0x88, _MM_PERM_CACB = 0x89,
    _MM_PERM_CACC = 0x8A, _MM_PERM_CACD = 0x8B, _MM_PERM_CADA = 0x8C,
    _MM_PERM_CADB = 0x8D, _MM_PERM_CADC = 0x8E, _MM_PERM_CADD = 0x8F,
    _MM_PERM_CBAA = 0x90, _MM_PERM_CBAB = 0x91, _MM_PERM_CBAC = 0x92,
    _MM_PERM_CBAD = 0x93, _MM_PERM_CBBA = 0x94, _MM_PERM_CBBB = 0x95,
    _MM_PERM_CBBC = 0x96, _MM_PERM_CBBD = 0x97, _MM_PERM_CBCA = 0x98,
    _MM_PERM_CBCB = 0x99, _MM_PERM_CBCC = 0x9A, _MM_PERM_CBCD = 0x9B,
    _MM_PERM_CBDA = 0x9C, _MM_PERM_CBDB = 0x9D, _MM_PERM_CBDC = 0x9E,
    _MM_PERM_CBDD = 0x9F, _MM_PERM_CCAA = 0xA0, _MM_PERM_CCAB = 0xA1,
    _MM_PERM_CCAC = 0xA2, _MM_PERM_CCAD = 0xA3, _MM_PERM_CCBA = 0xA4,
    _MM_PERM_CCBB = 0xA5, _MM_PERM_CCBC = 0xA6, _MM_PERM_CCBD = 0xA7,
    _MM_PERM_CCCA = 0xA8, _MM_PERM_CCCB = 0xA9, _MM_PERM_CCCC = 0xAA,
    _MM_PERM_CCCD = 0xAB, _MM_PERM_CCDA = 0xAC, _MM_PERM_CCDB = 0xAD,
    _MM_PERM_CCDC = 0xAE, _MM_PERM_CCDD = 0xAF, _MM_PERM_CDAA = 0xB0,
    _MM_PERM_CDAB = 0xB1, _MM_PERM_CDAC = 0xB2, _MM_PERM_CDAD = 0xB3,
    _MM_PERM_CDBA = 0xB4, _MM_PERM_CDBB = 0xB5, _MM_PERM_CDBC = 0xB6,
    _MM_PERM_CDBD = 0xB7, _MM_PERM_CDCA = 0xB8, _MM_PERM_CDCB = 0xB9,
    _MM_PERM_CDCC = 0xBA, _MM_PERM_CDCD = 0xBB, _MM_PERM_CDDA = 0xBC,
    _MM_PERM_CDDB = 0xBD, _MM_PERM_CDDC = 0xBE, _MM_PERM_CDDD = 0xBF,
    _MM_PERM_DAAA = 0xC0, _MM_PERM_DAAB = 0xC1, _MM_PERM_DAAC = 0xC2,
    _MM_PERM_DAAD = 0xC3, _MM_PERM_DABA = 0xC4, _MM_PERM_DABB = 0xC5,
    _MM_PERM_DABC = 0xC6, _MM_PERM_DABD = 0xC7, _MM_PERM_DACA = 0xC8,
    _MM_PERM_DACB = 0xC9, _MM_PERM_DACC = 0xCA, _MM_PERM_DACD = 0xCB,
    _MM_PERM_DADA = 0xCC, _MM_PERM_DADB = 0xCD, _MM_PERM_DADC = 0xCE,
    _MM_PERM_DADD = 0xCF, _MM_PERM_DBAA = 0xD0, _MM_PERM_DBAB = 0xD1,
    _MM_PERM_DBAC = 0xD2, _MM_PERM_DBAD = 0xD3, _MM_PERM_DBBA = 0xD4,
    _MM_PERM_DBBB = 0xD5, _MM_PERM_DBBC = 0xD6, _MM_PERM_DBBD = 0xD7,
    _MM_PERM_DBCA = 0xD8, _MM_PERM_DBCB = 0xD9, _MM_PERM_DBCC = 0xDA,
    _MM_PERM_DBCD = 0xDB, _MM_PERM_DBDA = 0xDC, _MM_PERM_DBDB = 0xDD,
    _MM_PERM_DBDC = 0xDE, _MM_PERM_DBDD = 0xDF, _MM_PERM_DCAA = 0xE0,
    _MM_PERM_DCAB = 0xE1, _MM_PERM_DCAC = 0xE2, _MM_PERM_DCAD = 0xE3,
    _MM_PERM_DCBA = 0xE4, _MM_PERM_DCBB = 0xE5, _MM_PERM_DCBC = 0xE6,
    _MM_PERM_DCBD = 0xE7, _MM_PERM_DCCA = 0xE8, _MM_PERM_DCCB = 0xE9,
    _MM_PERM_DCCC = 0xEA, _MM_PERM_DCCD = 0xEB, _MM_PERM_DCDA = 0xEC,
    _MM_PERM_DCDB = 0xED, _MM_PERM_DCDC = 0xEE, _MM_PERM_DCDD = 0xEF,
    _MM_PERM_DDAA = 0xF0, _MM_PERM_DDAB = 0xF1, _MM_PERM_DDAC = 0xF2,
    _MM_PERM_DDAD = 0xF3, _MM_PERM_DDBA = 0xF4, _MM_PERM_DDBB = 0xF5,
    _MM_PERM_DDBC = 0xF6, _MM_PERM_DDBD = 0xF7, _MM_PERM_DDCA = 0xF8,
    _MM_PERM_DDCB = 0xF9, _MM_PERM_DDCC = 0xFA, _MM_PERM_DDCD = 0xFB,
    _MM_PERM_DDDA = 0xFC, _MM_PERM_DDDB = 0xFD, _MM_PERM_DDDC = 0xFE,
    _MM_PERM_DDDD = 0xFF
} _MM_PERM_ENUM;



















typedef enum {

    _MM_UPCONV_PS_NONE,
    _MM_UPCONV_PS_FLOAT16,
    _MM_UPCONV_PS_UINT8,
    _MM_UPCONV_PS_SINT8,
    _MM_UPCONV_PS_UINT16,
    _MM_UPCONV_PS_SINT16

} _MM_UPCONV_PS_ENUM;

# 308 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




typedef enum {

    _MM_UPCONV_EPI32_NONE,
    _MM_UPCONV_EPI32_UINT8,
    _MM_UPCONV_EPI32_SINT8,
    _MM_UPCONV_EPI32_UINT16,
    _MM_UPCONV_EPI32_SINT16

} _MM_UPCONV_EPI32_ENUM;

# 333 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 340 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3



typedef enum {
    _MM_UPCONV_PD_NONE
} _MM_UPCONV_PD_ENUM;

# 362 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




typedef enum {
    _MM_UPCONV_EPI64_NONE
} _MM_UPCONV_EPI64_ENUM;

# 407 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3



typedef enum {

    _MM_DOWNCONV_PS_NONE,
    _MM_DOWNCONV_PS_FLOAT16,
    _MM_DOWNCONV_PS_UINT8,
    _MM_DOWNCONV_PS_SINT8,
    _MM_DOWNCONV_PS_UINT16,
    _MM_DOWNCONV_PS_SINT16

} _MM_DOWNCONV_PS_ENUM;



typedef enum {
    _MM_DOWNCONV_EPI32_NONE,
    _MM_DOWNCONV_EPI32_UINT8,
    _MM_DOWNCONV_EPI32_SINT8,
    _MM_DOWNCONV_EPI32_UINT16,
    _MM_DOWNCONV_EPI32_SINT16
} _MM_DOWNCONV_EPI32_ENUM;



typedef enum {
    _MM_DOWNCONV_PD_NONE
} _MM_DOWNCONV_PD_ENUM;



typedef enum {
    _MM_DOWNCONV_EPI64_NONE
} _MM_DOWNCONV_EPI64_ENUM;

# 480 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 514 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 538 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 648 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 673 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 745 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 788 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






typedef enum {
    _MM_CMPINT_EQ,
    _MM_CMPINT_LT,
    _MM_CMPINT_LE,
    _MM_CMPINT_UNUSED,
    _MM_CMPINT_NE,
    _MM_CMPINT_NLT,

    _MM_CMPINT_NLE

} _MM_CMPINT_ENUM;

# 813 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 838 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 846 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 871 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 878 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 908 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 921 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 951 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 964 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 1005 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 1038 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 1056 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 1107 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






































# 1192 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




































# 1243 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3










# 1299 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3








































# 1386 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3













































# 1443 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3














# 1465 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






typedef enum {
    _MM_MANT_NORM_1_2,
    _MM_MANT_NORM_p5_2,
    _MM_MANT_NORM_p5_1,
    _MM_MANT_NORM_p75_1p5
} _MM_MANTISSA_NORM_ENUM;

typedef enum {
    _MM_MANT_SIGN_src,
    _MM_MANT_SIGN_zero,
    _MM_MANT_SIGN_nan
} _MM_MANTISSA_SIGN_ENUM;

# 1500 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3













# 1596 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1603 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1610 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1617 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1624 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1631 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1638 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1645 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1652 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3


# 1719 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1726 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 1733 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

































































# 1808 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3












# 1831 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3













# 1860 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3












# 1882 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3












# 1904 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3












# 1926 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3












# 1948 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3












# 1970 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






























# 2011 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3
























# 2093 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 2111 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

































# 2157 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3













# 2196 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3












# 2224 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3















# 2252 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3















# 2281 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3



























# 2314 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3



















































# 2373 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 2390 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 2404 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3











# 2421 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 2437 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3









# 2476 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3


































# 2516 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3















# 2860 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 2930 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






























































# 3012 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3











# 3031 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 3061 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3


# 3176 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 3193 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 3210 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3235 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3243 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3268 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3340 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3347 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3355 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3362 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3370 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 3381 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 3600 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3607 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3615 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3622 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3630 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3637 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3645 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3652 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3


# 3661 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3668 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3676 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3683 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3691 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3698 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3706 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3713 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3735 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3742 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3750 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3757 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3909 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3916 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3924 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 3931 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4094 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4102 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4110 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4118 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4131 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4138 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4146 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4154 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4163 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4171 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4179 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4187 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4196 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4204 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4212 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4219 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4227 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4235 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4243 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4251 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4259 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4267 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4275 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4283 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4291 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4298 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4306 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4313 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3















































































































# 4431 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 4444 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 4498 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4507 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4520 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4529 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4546 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4554 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4562 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4570 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4632 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4642 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4653 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4663 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4679 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 4699 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 4720 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3













# 4749 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3













# 4788 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4797 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





# 4815 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3








# 4829 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4843 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3








# 4857 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4866 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3









# 4888 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3








# 4902 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4916 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3








# 4930 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3









































# 4981 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 4991 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5003 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5013 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5024 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5034 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5046 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5056 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5067 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5077 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5100 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5111 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5121 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5144 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5170 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3



































































# 5301 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5311 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5321 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5331 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5338 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5345 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5355 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5365 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5378 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5385 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5392 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5427 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5443 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5474 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5488 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5502 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5520 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 5546 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 5603 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5610 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5617 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5624 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5631 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5638 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5645 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5652 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5659 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5666 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 5673 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 5733 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 6341 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6366 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6374 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6399 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6407 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6432 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6440 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6465 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6473 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6498 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6506 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6531 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6539 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6564 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6614 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6639 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 6670 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6677 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6702 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6709 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6734 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 6765 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6772 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6797 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6804 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6829 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 6860 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6867 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6892 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6899 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6924 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3







# 6955 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6962 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6987 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 6994 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7019 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7422 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7430 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7445 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7453 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7498 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7506 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7521 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7529 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7546 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7554 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7571 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7579 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7627 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7635 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7650 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7658 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7673 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7681 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7696 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7704 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7721 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7729 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7744 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7752 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3

# 7774 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 8740 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 8803 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 8820 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 8891 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3









# 8909 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3









# 10346 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 10386 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3




# 10548 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3





typedef __m128i __m128bh;
typedef __m256i __m256bh;
typedef __m512i __m512bh;

typedef int __tile;

# 11302 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/zmmintrin.h" 3






# 2604 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/immintrin.h" 2 3

# 15 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/x86intrin.h" 2 3

# 86 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c" 2



















# 1 "/usr/include/stdio.h" 1 3






























# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 1 3





































# 50 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3











# 69 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 80 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 87 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 103 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3






# 34 "/usr/include/stdio.h" 2 3










struct _IO_FILE;



typedef struct _IO_FILE FILE;















typedef struct _IO_FILE __FILE;









# 1 "/usr/include/libio.h" 1 3































# 1 "/usr/include/_G_config.h" 1 3








# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 1 3





































# 50 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3











# 69 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 80 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 87 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3

# 103 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stddef.h" 3






# 16 "/usr/include/_G_config.h" 2 3
# 1 "/usr/include/wchar.h" 1 3





























# 78 "/usr/include/wchar.h" 3




typedef struct
{
  int __count;
  union
  {

    unsigned int __wch;



    char __wchb[4];
  } __value;
} __mbstate_t;






# 894 "/usr/include/wchar.h" 3





# 21 "/usr/include/_G_config.h" 2 3
typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;
# 43 "/usr/include/_G_config.h" 3















# 33 "/usr/include/libio.h" 2 3

# 47 "/usr/include/libio.h" 3


# 1 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stdarg.h" 1 3




































# 132 "/gpfs20/shared/software/intel/toolkit/compiler/2021.4.0/linux/bin/intel64/../../compiler/include/icc/stdarg.h" 3


typedef __builtin_va_list va_list;

















typedef __builtin_va_list __gnuc_va_list;

# 51 "/usr/include/libio.h" 2 3











# 77 "/usr/include/libio.h" 3

# 86 "/usr/include/libio.h" 3







# 112 "/usr/include/libio.h" 3

# 124 "/usr/include/libio.h" 3


# 143 "/usr/include/libio.h" 3


struct _IO_jump_t;  struct _IO_FILE;


# 155 "/usr/include/libio.h" 3
typedef void _IO_lock_t;





struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;



  int _pos;
# 178 "/usr/include/libio.h" 3
};


enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};

# 245 "/usr/include/libio.h" 3

struct _IO_FILE {
  int _flags;




  char* _IO_read_ptr;
  char* _IO_read_end;
  char* _IO_read_base;
  char* _IO_write_base;
  char* _IO_write_ptr;
  char* _IO_write_end;
  char* _IO_buf_base;
  char* _IO_buf_end;

  char *_IO_save_base;
  char *_IO_backup_base;
  char *_IO_save_end;

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;



  int _flags2;

  __off_t _old_offset;



  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];



  _IO_lock_t *_lock;
# 294 "/usr/include/libio.h" 3
  __off64_t _offset;
# 303 "/usr/include/libio.h" 3
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;

  int _mode;

  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];

};


typedef struct _IO_FILE _IO_FILE;


struct _IO_FILE_plus;

extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;
# 333 "/usr/include/libio.h" 3






typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);







typedef __ssize_t __io_write_fn (void *__cookie, const char *__buf,
				 size_t __n);







typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);


typedef int __io_close_fn (void *__cookie);


# 385 "/usr/include/libio.h" 3






extern int __underflow (_IO_FILE *);
extern int __uflow (_IO_FILE *);
extern int __overflow (_IO_FILE *, int);












# 417 "/usr/include/libio.h" 3

# 431 "/usr/include/libio.h" 3




extern int _IO_getc (_IO_FILE *__fp);
extern int _IO_putc (int __c, _IO_FILE *__fp);
extern int _IO_feof (_IO_FILE *__fp) __attribute__ ((__nothrow__ , __leaf__));
extern int _IO_ferror (_IO_FILE *__fp) __attribute__ ((__nothrow__ , __leaf__));

extern int _IO_peekc_locked (_IO_FILE *__fp);





extern void _IO_flockfile (_IO_FILE *) __attribute__ ((__nothrow__ , __leaf__));
extern void _IO_funlockfile (_IO_FILE *) __attribute__ ((__nothrow__ , __leaf__));
extern int _IO_ftrylockfile (_IO_FILE *) __attribute__ ((__nothrow__ , __leaf__));

# 464 "/usr/include/libio.h" 3

extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
			__gnuc_va_list, int *__restrict);
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
			 __gnuc_va_list);
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t);
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t);

extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int);
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int);

extern void _IO_free_backup_area (_IO_FILE *) __attribute__ ((__nothrow__ , __leaf__));

# 521 "/usr/include/libio.h" 3









# 75 "/usr/include/stdio.h" 2 3




typedef __gnuc_va_list va_list;
# 86 "/usr/include/stdio.h" 3

# 100 "/usr/include/stdio.h" 3










typedef _G_fpos_t fpos_t;





























# 147 "/usr/include/stdio.h" 3

















# 1 "/usr/include/bits/stdio_lim.h" 1 3


























# 34 "/usr/include/bits/stdio_lim.h" 3






# 165 "/usr/include/stdio.h" 2 3



extern struct _IO_FILE *stdin;
extern struct _IO_FILE *stdout;
extern struct _IO_FILE *stderr;







extern int remove (const char *__filename) __attribute__ ((__nothrow__ , __leaf__));

extern int rename (const char *__old, const char *__new) __attribute__ ((__nothrow__ , __leaf__));




extern int renameat (int __oldfd, const char *__old, int __newfd,
		     const char *__new) __attribute__ ((__nothrow__ , __leaf__));








extern FILE *tmpfile (void) ;
# 203 "/usr/include/stdio.h" 3






extern char *tmpnam (char *__s) __attribute__ ((__nothrow__ , __leaf__)) ;





extern char *tmpnam_r (char *__s) __attribute__ ((__nothrow__ , __leaf__)) ;











extern char *tempnam (const char *__dir, const char *__pfx)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) ;








extern int fclose (FILE *__stream);




extern int fflush (FILE *__stream);









extern int fflush_unlocked (FILE *__stream);


# 264 "/usr/include/stdio.h" 3








extern FILE *fopen (const char *__restrict __filename,
		    const char *__restrict __modes) ;




extern FILE *freopen (const char *__restrict __filename,
		      const char *__restrict __modes,
		      FILE *__restrict __stream) ;
# 295 "/usr/include/stdio.h" 3

# 303 "/usr/include/stdio.h" 3



extern FILE *fdopen (int __fd, const char *__modes) __attribute__ ((__nothrow__ , __leaf__)) ;


# 316 "/usr/include/stdio.h" 3



extern FILE *fmemopen (void *__s, size_t __len, const char *__modes)
  __attribute__ ((__nothrow__ , __leaf__)) ;




extern FILE *open_memstream (char **__bufloc, size_t *__sizeloc) __attribute__ ((__nothrow__ , __leaf__)) ;






extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__ ((__nothrow__ , __leaf__));



extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
		    int __modes, size_t __n) __attribute__ ((__nothrow__ , __leaf__));





extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
		       size_t __size) __attribute__ ((__nothrow__ , __leaf__));


extern void setlinebuf (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__));








extern int fprintf (FILE *__restrict __stream,
		    const char *__restrict __format, ...);




extern int printf (const char *__restrict __format, ...);

extern int sprintf (char *__restrict __s,
		    const char *__restrict __format, ...) __attribute__ ((__nothrow__));





extern int vfprintf (FILE *__restrict __s, const char *__restrict __format,
		     __gnuc_va_list __arg);




extern int vprintf (const char *__restrict __format, __gnuc_va_list __arg);

extern int vsprintf (char *__restrict __s, const char *__restrict __format,
		     __gnuc_va_list __arg) __attribute__ ((__nothrow__));





extern int snprintf (char *__restrict __s, size_t __maxlen,
		     const char *__restrict __format, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 4)));

extern int vsnprintf (char *__restrict __s, size_t __maxlen,
		      const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 0)));



# 409 "/usr/include/stdio.h" 3



extern int vdprintf (int __fd, const char *__restrict __fmt,
		     __gnuc_va_list __arg)
     __attribute__ ((__format__ (__printf__, 2, 0)));
extern int dprintf (int __fd, const char *__restrict __fmt, ...)
     __attribute__ ((__format__ (__printf__, 2, 3)));








extern int fscanf (FILE *__restrict __stream,
		   const char *__restrict __format, ...) ;




extern int scanf (const char *__restrict __format, ...) ;

extern int sscanf (const char *__restrict __s,
		   const char *__restrict __format, ...) __attribute__ ((__nothrow__ , __leaf__));








extern int fscanf (FILE *__restrict __stream, const char *__restrict __format, ...) __asm__ ("" "__isoc99_fscanf") ;


extern int scanf (const char *__restrict __format, ...) __asm__ ("" "__isoc99_scanf") ;

extern int sscanf (const char *__restrict __s, const char *__restrict __format, ...) __asm__ ("" "__isoc99_sscanf") __attribute__ ((__nothrow__ , __leaf__));
# 462 "/usr/include/stdio.h" 3









extern int vfscanf (FILE *__restrict __s, const char *__restrict __format,
		    __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;





extern int vscanf (const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;


extern int vsscanf (const char *__restrict __s,
		    const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__format__ (__scanf__, 2, 0)));








extern int vfscanf (FILE *__restrict __s, const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vfscanf")



     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
extern int vscanf (const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vscanf")

     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
extern int vsscanf (const char *__restrict __s, const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vsscanf") __attribute__ ((__nothrow__ , __leaf__))



     __attribute__ ((__format__ (__scanf__, 2, 0)));
# 521 "/usr/include/stdio.h" 3










extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);





extern int getchar (void);











extern int getc_unlocked (FILE *__stream);
extern int getchar_unlocked (void);









extern int fgetc_unlocked (FILE *__stream);











extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);





extern int putchar (int __c);













extern int fputc_unlocked (int __c, FILE *__stream);







extern int putc_unlocked (int __c, FILE *__stream);
extern int putchar_unlocked (int __c);






extern int getw (FILE *__stream);


extern int putw (int __w, FILE *__stream);








extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
     ;

# 640 "/usr/include/stdio.h" 3


# 652 "/usr/include/stdio.h" 3













extern __ssize_t __getdelim (char **__restrict __lineptr,
			       size_t *__restrict __n, int __delimiter,
			       FILE *__restrict __stream) ;
extern __ssize_t getdelim (char **__restrict __lineptr,
			     size_t *__restrict __n, int __delimiter,
			     FILE *__restrict __stream) ;







extern __ssize_t getline (char **__restrict __lineptr,
			    size_t *__restrict __n,
			    FILE *__restrict __stream) ;








extern int fputs (const char *__restrict __s, FILE *__restrict __stream);





extern int puts (const char *__s);






extern int ungetc (int __c, FILE *__stream);






extern size_t fread (void *__restrict __ptr, size_t __size,
		     size_t __n, FILE *__restrict __stream) ;




extern size_t fwrite (const void *__restrict __ptr, size_t __size,
		      size_t __n, FILE *__restrict __s);


# 729 "/usr/include/stdio.h" 3








extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
			      size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite_unlocked (const void *__restrict __ptr, size_t __size,
			       size_t __n, FILE *__restrict __stream);








extern int fseek (FILE *__stream, long int __off, int __whence);




extern long int ftell (FILE *__stream) ;




extern void rewind (FILE *__stream);













extern int fseeko (FILE *__stream, __off_t __off, int __whence);




extern __off_t ftello (FILE *__stream) ;
# 791 "/usr/include/stdio.h" 3







extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);




extern int fsetpos (FILE *__stream, const fpos_t *__pos);
# 815 "/usr/include/stdio.h" 3


# 823 "/usr/include/stdio.h" 3



extern void clearerr (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__));

extern int feof (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__)) ;

extern int ferror (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__)) ;




extern void clearerr_unlocked (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__));
extern int feof_unlocked (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__)) ;
extern int ferror_unlocked (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__)) ;








extern void perror (const char *__s);






# 1 "/usr/include/bits/sys_errlist.h" 1 3

























extern int sys_nerr;
extern const char *const sys_errlist[];
# 854 "/usr/include/stdio.h" 2 3




extern int fileno (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__)) ;




extern int fileno_unlocked (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__)) ;









extern FILE *popen (const char *__command, const char *__modes) ;





extern int pclose (FILE *__stream);





extern char *ctermid (char *__s) __attribute__ ((__nothrow__ , __leaf__));









# 907 "/usr/include/stdio.h" 3






extern void flockfile (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__));



extern int ftrylockfile (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__)) ;


extern void funlockfile (FILE *__stream) __attribute__ ((__nothrow__ , __leaf__));


# 930 "/usr/include/stdio.h" 3



# 1 "/usr/include/bits/stdio.h" 1 3


































extern __inline __attribute__ ((__gnu_inline__)) int
vprintf (const char *__restrict __fmt, __gnuc_va_list __arg)
{
  return vfprintf (stdout, __fmt, __arg);
}



extern __inline __attribute__ ((__gnu_inline__)) int
getchar (void)
{
  return _IO_getc (stdin);
}




extern __inline __attribute__ ((__gnu_inline__)) int
fgetc_unlocked (FILE *__fp)
{
  return (__builtin_expect (((__fp)->_IO_read_ptr >= (__fp)->_IO_read_end), 0) ? __uflow (__fp) : *(unsigned char *) (__fp)->_IO_read_ptr++);
}





extern __inline __attribute__ ((__gnu_inline__)) int
getc_unlocked (FILE *__fp)
{
  return (__builtin_expect (((__fp)->_IO_read_ptr >= (__fp)->_IO_read_end), 0) ? __uflow (__fp) : *(unsigned char *) (__fp)->_IO_read_ptr++);
}


extern __inline __attribute__ ((__gnu_inline__)) int
getchar_unlocked (void)
{
  return (__builtin_expect (((stdin)->_IO_read_ptr >= (stdin)->_IO_read_end), 0) ? __uflow (stdin) : *(unsigned char *) (stdin)->_IO_read_ptr++);
}




extern __inline __attribute__ ((__gnu_inline__)) int
putchar (int __c)
{
  return _IO_putc (__c, stdout);
}




extern __inline __attribute__ ((__gnu_inline__)) int
fputc_unlocked (int __c, FILE *__stream)
{
  return (__builtin_expect (((__stream)->_IO_write_ptr >= (__stream)->_IO_write_end), 0) ? __overflow (__stream, (unsigned char) (__c)) : (unsigned char) (*(__stream)->_IO_write_ptr++ = (__c)));
}





extern __inline __attribute__ ((__gnu_inline__)) int
putc_unlocked (int __c, FILE *__stream)
{
  return (__builtin_expect (((__stream)->_IO_write_ptr >= (__stream)->_IO_write_end), 0) ? __overflow (__stream, (unsigned char) (__c)) : (unsigned char) (*(__stream)->_IO_write_ptr++ = (__c)));
}


extern __inline __attribute__ ((__gnu_inline__)) int
putchar_unlocked (int __c)
{
  return (__builtin_expect (((stdout)->_IO_write_ptr >= (stdout)->_IO_write_end), 0) ? __overflow (stdout, (unsigned char) (__c)) : (unsigned char) (*(stdout)->_IO_write_ptr++ = (__c)));
}



# 120 "/usr/include/bits/stdio.h" 3




extern __inline __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ , __leaf__)) feof_unlocked (FILE *__stream)
{
  return (((__stream)->_flags & 0x10) != 0);
}


extern __inline __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ , __leaf__)) ferror_unlocked (FILE *__stream)
{
  return (((__stream)->_flags & 0x20) != 0);
}








# 167 "/usr/include/bits/stdio.h" 3

# 188 "/usr/include/bits/stdio.h" 3


# 935 "/usr/include/stdio.h" 2 3
# 942 "/usr/include/stdio.h" 3





# 106 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c" 2





































































# 214 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 238 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 275 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 353 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 382 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 410 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"



# 466 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"



# 479 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 492 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 501 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 516 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 528 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 539 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 550 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
__attribute__((always_inline)) static void hh_trafo_kernel_16_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

	float s);
# 560 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 571 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 582 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 593 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
__attribute__((always_inline)) static void hh_trafo_kernel_32_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

	float s);
# 603 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 614 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 625 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 636 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_48_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

	float s);
# 647 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 658 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 669 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 680 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_64_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

	float s);
# 691 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 702 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 713 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 724 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_80_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

	float s);
# 735 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 746 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 757 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 768 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_96_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

	float s);
# 779 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

void double_hh_trafo_real_AVX512_2hv_single (float* q, float* hh, int* pnb, int* pnq, int* pldq, int* pldh);

























































































































































































































































































































































































































































































































































































































































































































































































































































void double_hh_trafo_real_AVX512_2hv_single (float* q, float* hh, int* pnb, int* pnq, int* pldq, int* pldh)
{
  int i;
  int nb = *pnb;
  int nq = *pldq;
  int ldq = *pldq;
  int ldh = *pldh;
  int worked_on;

  worked_on = 0;

# 1630 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1644 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1658 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"




  float s = hh[(ldh)+1]*1.0f;


# 1689 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1768 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


  #pragma ivdep

  for (i = 2; i < nb; i++)
    {

      s += hh[i-1] * hh[(i+ldh)];


# 1788 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1810 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    }




# 1828 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1841 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1854 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


  for (i = 0; i < nq - 48; i+= 64 )
    {
      hh_trafo_kernel_64_AVX512_2hv_single (&q[i], hh, nb, ldq, ldh, s);
      worked_on += 64;
    }

  if (nq == i)
    {
      return;
    }

# 1876 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1885 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1894 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

  if (nq-i == 48)
    {
      hh_trafo_kernel_48_AVX512_2hv_single (&q[i], hh, nb, ldq, ldh, s);
      worked_on += 48;
    }

# 1910 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1919 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1928 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


  if (nq-i == 32)
    {
      hh_trafo_kernel_32_AVX512_2hv_single (&q[i], hh, nb, ldq, ldh, s);
      worked_on += 32;
    }

# 1945 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1954 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 1963 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
  if (nq-i == 16)
    {
      hh_trafo_kernel_16_AVX512_2hv_single (&q[i], hh, nb, ldq, ldh, s);
      worked_on += 16;
    }

# 2023 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"



# 2169 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 2292 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 2300 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
}

# 2311 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 2320 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 2329 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 2345 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
__attribute__((always_inline)) static void hh_trafo_kernel_96_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

               float s)
# 2355 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
  {





# 2368 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    int i;

# 2381 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 2394 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 2403 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"






        __m512 sign = (__m512)_mm512_set1_epi32(0x80000000);



# 2421 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 x1 = _mm512_load_ps(&q[ldq]);
    __m512 x2 = _mm512_load_ps(&q[ldq+16]);
    __m512 x3 = _mm512_load_ps(&q[ldq+2*16]);
    __m512 x4 = _mm512_load_ps(&q[ldq+3*16]);
    __m512 x5 = _mm512_load_ps(&q[ldq+4*16]);
    __m512 x6 = _mm512_load_ps(&q[ldq+5*16]);


    __m512 h1 = _mm512_set1_ps(hh[ldh+1]);
# 2438 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 h2;

    __m512 q1 = _mm512_load_ps(q);
    __m512 y1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
    __m512 q2 = _mm512_load_ps(&q[16]);
    __m512 y2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
    __m512 q3 = _mm512_load_ps(&q[2*16]);
    __m512 y3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
    __m512 q4 = _mm512_load_ps(&q[3*16]);
    __m512 y4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
    __m512 q5 = _mm512_load_ps(&q[4*16]);
    __m512 y5 = _mm512_fmadd_round_ps((x5), (h1), (q5), 0x04);
    __m512 q6 = _mm512_load_ps(&q[5*16]);
    __m512 y6 = _mm512_fmadd_round_ps((x6), (h1), (q6), 0x04);
# 2468 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 2647 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 3016 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    for(i = 2; i < nb; i++)
      {


        h1 = _mm512_set1_ps(hh[i-(2-1)]);
        h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 3033 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

        q1 = _mm512_load_ps(&q[i*ldq]);
        q2 = _mm512_load_ps(&q[(i*ldq)+16]);
        q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);
        q4 = _mm512_load_ps(&q[(i*ldq)+3*16]);
        q5 = _mm512_load_ps(&q[(i*ldq)+4*16]);
        q6 = _mm512_load_ps(&q[(i*ldq)+5*16]);


        x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
        y1 = _mm512_fmadd_round_ps((q1), (h2), (y1), 0x04);
        x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
        y2 = _mm512_fmadd_round_ps((q2), (h2), (y2), 0x04);
        x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);
        y3 = _mm512_fmadd_round_ps((q3), (h2), (y3), 0x04);
        x4 = _mm512_fmadd_round_ps((q4), (h1), (x4), 0x04);
        y4 = _mm512_fmadd_round_ps((q4), (h2), (y4), 0x04);
        x5 = _mm512_fmadd_round_ps((q5), (h1), (x5), 0x04);
        y5 = _mm512_fmadd_round_ps((q5), (h2), (y5), 0x04);
        x6 = _mm512_fmadd_round_ps((q6), (h1), (x6), 0x04);
        y6 = _mm512_fmadd_round_ps((q6), (h2), (y6), 0x04);
# 3068 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 3127 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 3186 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
      }

    h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 3196 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    q1 = _mm512_load_ps(&q[nb*ldq]);
    q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
    q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);
    q4 = _mm512_load_ps(&q[(nb*ldq)+3*16]);
    q5 = _mm512_load_ps(&q[(nb*ldq)+4*16]);
    q6 = _mm512_load_ps(&q[(nb*ldq)+5*16]);

    x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
    x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
    x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);
    x4 = _mm512_fmadd_round_ps((q4), (h1), (x4), 0x04);
    x5 = _mm512_fmadd_round_ps((q5), (h1), (x5), 0x04);
    x6 = _mm512_fmadd_round_ps((q6), (h1), (x6), 0x04);
# 3218 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 3378 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 3735 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 3751 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 tau1 = _mm512_set1_ps(hh[0]);

    __m512 tau2 = _mm512_set1_ps(hh[ldh]);
# 3764 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 vs = _mm512_set1_ps(s);
# 3794 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 3838 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 3881 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 3900 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau1, sign);








   x1 = _mm512_mul_ps(  x1, h1);
   x2 = _mm512_mul_ps(  x2, h1);
   x3 = _mm512_mul_ps(  x3, h1);
   x4 = _mm512_mul_ps(  x4, h1);
   x5 = _mm512_mul_ps(  x5, h1);
   x6 = _mm512_mul_ps(  x6, h1);










# 3936 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau2, sign);


   h2 = _mm512_mul_ps(  h1, vs);










   y1 = _mm512_fmadd_round_ps((y1), (h1), (_mm512_mul_ps( x1,h2)), 0x04);
   y2 = _mm512_fmadd_round_ps((y2), (h1), (_mm512_mul_ps( x2,h2)), 0x04);
   y3 = _mm512_fmadd_round_ps((y3), (h1), (_mm512_mul_ps( x3,h2)), 0x04);
   y4 = _mm512_fmadd_round_ps((y4), (h1), (_mm512_mul_ps( x4,h2)), 0x04);
   y5 = _mm512_fmadd_round_ps((y5), (h1), (_mm512_mul_ps( x5,h2)), 0x04);
   y6 = _mm512_fmadd_round_ps((y6), (h1), (_mm512_mul_ps( x6,h2)), 0x04);
# 3967 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 4028 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 4077 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[0]);

   q1 = _mm512_add_ps(  q1, y1);
# 4088 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[0], q1);
   q2 = _mm512_load_ps(&q[16]);

   q2 = _mm512_add_ps(  q2, y2);
# 4099 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[16], q2);
   q3 = _mm512_load_ps(&q[2*16]);

   q3 = _mm512_add_ps(  q3, y3);
# 4110 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[2*16], q3);
   q4 = _mm512_load_ps(&q[3*16]);

   q4 = _mm512_add_ps(  q4, y4);
# 4121 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[3*16], q4);
   q5 = _mm512_load_ps(&q[4*16]);

   q5 = _mm512_add_ps(  q5, y5);
# 4132 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[4*16], q5);
   q6 = _mm512_load_ps(&q[5*16]);

   q6 = _mm512_add_ps(  q6, y6);
# 4143 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[5*16], q6);



   h2 = _mm512_set1_ps(hh[ldh+1]);
# 4155 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[ldq]);
   q2 = _mm512_load_ps(&q[ldq+16]);
   q3 = _mm512_load_ps(&q[ldq+2*16]);
   q4 = _mm512_load_ps(&q[ldq+3*16]);
   q5 = _mm512_load_ps(&q[ldq+4*16]);
   q6 = _mm512_load_ps(&q[ldq+5*16]);

   q1 = _mm512_add_ps(  q1, _mm512_fmadd_round_ps((y1), (h2), (x1), 0x04));
   q2 = _mm512_add_ps(  q2, _mm512_fmadd_round_ps((y2), (h2), (x2), 0x04));
   q3 = _mm512_add_ps(  q3, _mm512_fmadd_round_ps((y3), (h2), (x3), 0x04));
   q4 = _mm512_add_ps(  q4, _mm512_fmadd_round_ps((y4), (h2), (x4), 0x04));
   q5 = _mm512_add_ps(  q5, _mm512_fmadd_round_ps((y5), (h2), (x5), 0x04));
   q6 = _mm512_add_ps(  q6, _mm512_fmadd_round_ps((y6), (h2), (x6), 0x04));
# 4177 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[ldq], q1);
   _mm512_store_ps(&q[ldq+16], q2);
   _mm512_store_ps(&q[ldq+2*16], q3);
   _mm512_store_ps(&q[ldq+3*16], q4);
   _mm512_store_ps(&q[ldq+4*16], q5);
   _mm512_store_ps(&q[ldq+5*16], q6);


# 4409 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 4903 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   for (i = 2; i < nb; i++)
   {

     h1 = _mm512_set1_ps(hh[i-(2-1)]);
     h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 4918 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     q1 = _mm512_load_ps(&q[i*ldq]);
     q2 = _mm512_load_ps(&q[(i*ldq)+16]);
     q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);
     q4 = _mm512_load_ps(&q[(i*ldq)+3*16]);
     q5 = _mm512_load_ps(&q[(i*ldq)+4*16]);
     q6 = _mm512_load_ps(&q[(i*ldq)+5*16]);



     q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
     q1 = _mm512_fmadd_round_ps((y1), (h2), (q1), 0x04);
     q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
     q2 = _mm512_fmadd_round_ps((y2), (h2), (q2), 0x04);
     q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
     q3 = _mm512_fmadd_round_ps((y3), (h2), (q3), 0x04);
     q4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
     q4 = _mm512_fmadd_round_ps((y4), (h2), (q4), 0x04);
     q5 = _mm512_fmadd_round_ps((x5), (h1), (q5), 0x04);
     q5 = _mm512_fmadd_round_ps((y5), (h2), (q5), 0x04);
     q6 = _mm512_fmadd_round_ps((x6), (h1), (q6), 0x04);
     q6 = _mm512_fmadd_round_ps((y6), (h2), (q6), 0x04);
# 4949 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5041 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5097 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     _mm512_store_ps(&q[i*ldq], q1);
     _mm512_store_ps(&q[(i*ldq)+16], q2);
     _mm512_store_ps(&q[(i*ldq)+2*16], q3);
     _mm512_store_ps(&q[(i*ldq)+3*16], q4);
     _mm512_store_ps(&q[(i*ldq)+4*16], q5);
     _mm512_store_ps(&q[(i*ldq)+5*16], q6);

   }

   h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 5115 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[nb*ldq]);
   q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
   q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);
   q4 = _mm512_load_ps(&q[(nb*ldq)+3*16]);
   q5 = _mm512_load_ps(&q[(nb*ldq)+4*16]);
   q6 = _mm512_load_ps(&q[(nb*ldq)+5*16]);




   q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
   q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
   q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
   q4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
   q5 = _mm512_fmadd_round_ps((x5), (h1), (q5), 0x04);
   q6 = _mm512_fmadd_round_ps((x6), (h1), (q6), 0x04);
# 5141 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5216 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5271 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[nb*ldq], q1);
   _mm512_store_ps(&q[(nb*ldq)+16], q2);
   _mm512_store_ps(&q[(nb*ldq)+2*16], q3);
   _mm512_store_ps(&q[(nb*ldq)+3*16], q4);
   _mm512_store_ps(&q[(nb*ldq)+4*16], q5);
   _mm512_store_ps(&q[(nb*ldq)+5*16], q6);

# 5504 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5613 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
}

# 5624 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5633 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5642 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 5658 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
__attribute__((always_inline)) static void hh_trafo_kernel_80_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

               float s)
# 5668 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
  {





# 5681 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    int i;
# 5693 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 5706 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5715 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"






        __m512 sign = (__m512)_mm512_set1_epi32(0x80000000);



# 5733 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 x1 = _mm512_load_ps(&q[ldq]);
    __m512 x2 = _mm512_load_ps(&q[ldq+16]);
    __m512 x3 = _mm512_load_ps(&q[ldq+2*16]);
    __m512 x4 = _mm512_load_ps(&q[ldq+3*16]);
    __m512 x5 = _mm512_load_ps(&q[ldq+4*16]);


    __m512 h1 = _mm512_set1_ps(hh[ldh+1]);
# 5749 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
    __m512 h2;


    __m512 q1 = _mm512_load_ps(q);
    __m512 y1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
    __m512 q2 = _mm512_load_ps(&q[16]);
    __m512 y2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
    __m512 q3 = _mm512_load_ps(&q[2*16]);
    __m512 y3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
    __m512 q4 = _mm512_load_ps(&q[3*16]);
    __m512 y4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
    __m512 q5 = _mm512_load_ps(&q[4*16]);
    __m512 y5 = _mm512_fmadd_round_ps((x5), (h1), (q5), 0x04);
# 5775 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 5930 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 6257 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    for(i = 2; i < nb; i++)
      {

        h1 = _mm512_set1_ps(hh[i-(2-1)]);
        h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 6273 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

        q1 = _mm512_load_ps(&q[i*ldq]);
        q2 = _mm512_load_ps(&q[(i*ldq)+16]);
        q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);
        q4 = _mm512_load_ps(&q[(i*ldq)+3*16]);
        q5 = _mm512_load_ps(&q[(i*ldq)+4*16]);

        x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
        y1 = _mm512_fmadd_round_ps((q1), (h2), (y1), 0x04);
        x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
        y2 = _mm512_fmadd_round_ps((q2), (h2), (y2), 0x04);
        x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);
        y3 = _mm512_fmadd_round_ps((q3), (h2), (y3), 0x04);
        x4 = _mm512_fmadd_round_ps((q4), (h1), (x4), 0x04);
        y4 = _mm512_fmadd_round_ps((q4), (h2), (y4), 0x04);
        x5 = _mm512_fmadd_round_ps((q5), (h1), (x5), 0x04);
        y5 = _mm512_fmadd_round_ps((q5), (h2), (y5), 0x04);
# 6302 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 6357 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 6412 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
      }

    h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 6422 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    q1 = _mm512_load_ps(&q[nb*ldq]);
    q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
    q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);
    q4 = _mm512_load_ps(&q[(nb*ldq)+3*16]);
    q5 = _mm512_load_ps(&q[(nb*ldq)+4*16]);

    x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
    x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
    x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);
    x4 = _mm512_fmadd_round_ps((q4), (h1), (x4), 0x04);
    x5 = _mm512_fmadd_round_ps((q5), (h1), (x5), 0x04);
# 6441 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 6589 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 6919 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 6935 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 tau1 = _mm512_set1_ps(hh[0]);

    __m512 tau2 = _mm512_set1_ps(hh[ldh]);
# 6948 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 vs = _mm512_set1_ps(s);
# 6978 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 7022 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 7065 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 7084 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau1, sign);









   x1 = _mm512_mul_ps(  x1, h1);
   x2 = _mm512_mul_ps(  x2, h1);
   x3 = _mm512_mul_ps(  x3, h1);
   x4 = _mm512_mul_ps(  x4, h1);
   x5 = _mm512_mul_ps(  x5, h1);










# 7120 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau2, sign);


   h2 = _mm512_mul_ps(  h1, vs);










   y1 = _mm512_fmadd_round_ps((y1), (h1), (_mm512_mul_ps( x1,h2)), 0x04);
   y2 = _mm512_fmadd_round_ps((y2), (h1), (_mm512_mul_ps( x2,h2)), 0x04);
   y3 = _mm512_fmadd_round_ps((y3), (h1), (_mm512_mul_ps( x3,h2)), 0x04);
   y4 = _mm512_fmadd_round_ps((y4), (h1), (_mm512_mul_ps( x4,h2)), 0x04);
   y5 = _mm512_fmadd_round_ps((y5), (h1), (_mm512_mul_ps( x5,h2)), 0x04);
# 7149 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 7204 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 7249 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[0]);

   q1 = _mm512_add_ps(  q1, y1);
# 7260 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[0], q1);
   q2 = _mm512_load_ps(&q[16]);

   q2 = _mm512_add_ps(  q2, y2);
# 7271 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[16], q2);
   q3 = _mm512_load_ps(&q[2*16]);

   q3 = _mm512_add_ps(  q3, y3);
# 7282 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[2*16], q3);
   q4 = _mm512_load_ps(&q[3*16]);

   q4 = _mm512_add_ps(  q4, y4);
# 7293 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[3*16], q4);
   q5 = _mm512_load_ps(&q[4*16]);

   q5 = _mm512_add_ps(  q5, y5);
# 7304 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[4*16], q5);



   h2 = _mm512_set1_ps(hh[ldh+1]);
# 7316 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[ldq]);
   q2 = _mm512_load_ps(&q[ldq+16]);
   q3 = _mm512_load_ps(&q[ldq+2*16]);
   q4 = _mm512_load_ps(&q[ldq+3*16]);
   q5 = _mm512_load_ps(&q[ldq+4*16]);

   q1 = _mm512_add_ps(  q1, _mm512_fmadd_round_ps((y1), (h2), (x1), 0x04));
   q2 = _mm512_add_ps(  q2, _mm512_fmadd_round_ps((y2), (h2), (x2), 0x04));
   q3 = _mm512_add_ps(  q3, _mm512_fmadd_round_ps((y3), (h2), (x3), 0x04));
   q4 = _mm512_add_ps(  q4, _mm512_fmadd_round_ps((y4), (h2), (x4), 0x04));
   q5 = _mm512_add_ps(  q5, _mm512_fmadd_round_ps((y5), (h2), (x5), 0x04));
# 7335 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[ldq], q1);
   _mm512_store_ps(&q[ldq+16], q2);
   _mm512_store_ps(&q[ldq+2*16], q3);
   _mm512_store_ps(&q[ldq+3*16], q4);
   _mm512_store_ps(&q[ldq+4*16], q5);


# 7545 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 7995 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   for (i = 2; i < nb; i++)
   {

     h1 = _mm512_set1_ps(hh[i-(2-1)]);
     h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 8010 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     q1 = _mm512_load_ps(&q[i*ldq]);
     q2 = _mm512_load_ps(&q[(i*ldq)+16]);
     q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);
     q4 = _mm512_load_ps(&q[(i*ldq)+3*16]);
     q5 = _mm512_load_ps(&q[(i*ldq)+4*16]);



     q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
     q1 = _mm512_fmadd_round_ps((y1), (h2), (q1), 0x04);
     q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
     q2 = _mm512_fmadd_round_ps((y2), (h2), (q2), 0x04);
     q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
     q3 = _mm512_fmadd_round_ps((y3), (h2), (q3), 0x04);
     q4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
     q4 = _mm512_fmadd_round_ps((y4), (h2), (q4), 0x04);
     q5 = _mm512_fmadd_round_ps((x5), (h1), (q5), 0x04);
     q5 = _mm512_fmadd_round_ps((y5), (h2), (q5), 0x04);
# 8037 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8121 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8174 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     _mm512_store_ps(&q[i*ldq], q1);
     _mm512_store_ps(&q[(i*ldq)+16], q2);
     _mm512_store_ps(&q[(i*ldq)+2*16], q3);
     _mm512_store_ps(&q[(i*ldq)+3*16], q4);
     _mm512_store_ps(&q[(i*ldq)+4*16], q5);

   }

   h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 8191 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[nb*ldq]);
   q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
   q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);
   q4 = _mm512_load_ps(&q[(nb*ldq)+3*16]);
   q5 = _mm512_load_ps(&q[(nb*ldq)+4*16]);




   q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
   q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
   q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
   q4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
   q5 = _mm512_fmadd_round_ps((x5), (h1), (q5), 0x04);
# 8214 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8284 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8335 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[nb*ldq], q1);
   _mm512_store_ps(&q[(nb*ldq)+16], q2);
   _mm512_store_ps(&q[(nb*ldq)+2*16], q3);
   _mm512_store_ps(&q[(nb*ldq)+3*16], q4);
   _mm512_store_ps(&q[(nb*ldq)+4*16], q5);

# 8548 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8647 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
}


# 8659 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8668 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8677 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"









# 8692 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_64_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

               float s)
# 8703 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
  {





# 8716 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    int i;
# 8728 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 8741 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8750 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"






        __m512 sign = (__m512)_mm512_set1_epi32(0x80000000);



# 8768 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 x1 = _mm512_load_ps(&q[ldq]);
    __m512 x2 = _mm512_load_ps(&q[ldq+16]);
    __m512 x3 = _mm512_load_ps(&q[ldq+2*16]);
    __m512 x4 = _mm512_load_ps(&q[ldq+3*16]);


    __m512 h1 = _mm512_set1_ps(hh[ldh+1]);
# 8783 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
    __m512 h2;


    __m512 q1 = _mm512_load_ps(q);
    __m512 y1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
    __m512 q2 = _mm512_load_ps(&q[16]);
    __m512 y2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
    __m512 q3 = _mm512_load_ps(&q[2*16]);
    __m512 y3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
    __m512 q4 = _mm512_load_ps(&q[3*16]);
    __m512 y4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
# 8805 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 8936 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 9218 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    for(i = 2; i < nb; i++)
      {

        h1 = _mm512_set1_ps(hh[i-(2-1)]);
        h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 9233 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

        q1 = _mm512_load_ps(&q[i*ldq]);
        q2 = _mm512_load_ps(&q[(i*ldq)+16]);
        q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);
        q4 = _mm512_load_ps(&q[(i*ldq)+3*16]);


        x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
        y1 = _mm512_fmadd_round_ps((q1), (h2), (y1), 0x04);
        x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
        y2 = _mm512_fmadd_round_ps((q2), (h2), (y2), 0x04);
        x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);
        y3 = _mm512_fmadd_round_ps((q3), (h2), (y3), 0x04);
        x4 = _mm512_fmadd_round_ps((q4), (h1), (x4), 0x04);
        y4 = _mm512_fmadd_round_ps((q4), (h2), (y4), 0x04);
# 9258 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 9358 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
      }

    h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 9368 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    q1 = _mm512_load_ps(&q[nb*ldq]);
    q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
    q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);
    q4 = _mm512_load_ps(&q[(nb*ldq)+3*16]);


    x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
    x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
    x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);
    x4 = _mm512_fmadd_round_ps((q4), (h1), (x4), 0x04);
# 9385 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 9521 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 9823 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 9839 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 tau1 = _mm512_set1_ps(hh[0]);

    __m512 tau2 = _mm512_set1_ps(hh[ldh]);
# 9852 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 vs = _mm512_set1_ps(s);
# 9882 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 9926 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 9969 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 9988 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau1, sign);









   x1 = _mm512_mul_ps(  x1, h1);
   x2 = _mm512_mul_ps(  x2, h1);
   x3 = _mm512_mul_ps(  x3, h1);
   x4 = _mm512_mul_ps(  x4, h1);










# 10023 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau2, sign);



   h2 = _mm512_mul_ps(  h1, vs);










   y1 = _mm512_fmadd_round_ps((y1), (h1), (_mm512_mul_ps( x1,h2)), 0x04);
   y2 = _mm512_fmadd_round_ps((y2), (h1), (_mm512_mul_ps( x2,h2)), 0x04);
   y3 = _mm512_fmadd_round_ps((y3), (h1), (_mm512_mul_ps( x3,h2)), 0x04);
   y4 = _mm512_fmadd_round_ps((y4), (h1), (_mm512_mul_ps( x4,h2)), 0x04);
# 10051 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 10100 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 10141 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[0]);
   q2 = _mm512_load_ps(&q[16]);
   q3 = _mm512_load_ps(&q[2*16]);
   q4 = _mm512_load_ps(&q[3*16]);


   q1 = _mm512_add_ps(  q1, y1);
   q2 = _mm512_add_ps(  q2, y2);
   q3 = _mm512_add_ps(  q3, y3);
   q4 = _mm512_add_ps(  q4, y4);
# 10165 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[0], q1);
   _mm512_store_ps(&q[16], q2);
   _mm512_store_ps(&q[2*16], q3);
   _mm512_store_ps(&q[3*16], q4);



   h2 = _mm512_set1_ps(hh[ldh+1]);
# 10181 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[ldq]);
   q2 = _mm512_load_ps(&q[ldq+16]);
   q3 = _mm512_load_ps(&q[ldq+2*16]);
   q4 = _mm512_load_ps(&q[ldq+3*16]);


   q1 = _mm512_add_ps(  q1, _mm512_fmadd_round_ps((y1), (h2), (x1), 0x04));
   q2 = _mm512_add_ps(  q2, _mm512_fmadd_round_ps((y2), (h2), (x2), 0x04));
   q3 = _mm512_add_ps(  q3, _mm512_fmadd_round_ps((y3), (h2), (x3), 0x04));
   q4 = _mm512_add_ps(  q4, _mm512_fmadd_round_ps((y4), (h2), (x4), 0x04));
# 10198 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[ldq], q1);
   _mm512_store_ps(&q[ldq+16], q2);
   _mm512_store_ps(&q[ldq+2*16], q3);
   _mm512_store_ps(&q[ldq+3*16], q4);


# 10390 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 10799 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   for (i = 2; i < nb; i++)
   {

     h1 = _mm512_set1_ps(hh[i-(2-1)]);
     h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 10814 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     q1 = _mm512_load_ps(&q[i*ldq]);
     q2 = _mm512_load_ps(&q[(i*ldq)+16]);
     q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);
     q4 = _mm512_load_ps(&q[(i*ldq)+3*16]);



     q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
     q1 = _mm512_fmadd_round_ps((y1), (h2), (q1), 0x04);
     q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
     q2 = _mm512_fmadd_round_ps((y2), (h2), (q2), 0x04);
     q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
     q3 = _mm512_fmadd_round_ps((y3), (h2), (q3), 0x04);
     q4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
     q4 = _mm512_fmadd_round_ps((y4), (h2), (q4), 0x04);
# 10837 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 10913 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 10960 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     _mm512_store_ps(&q[i*ldq], q1);
     _mm512_store_ps(&q[(i*ldq)+16], q2);
     _mm512_store_ps(&q[(i*ldq)+2*16], q3);
     _mm512_store_ps(&q[(i*ldq)+3*16], q4);

   }

   h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 10976 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[nb*ldq]);
   q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
   q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);
   q4 = _mm512_load_ps(&q[(nb*ldq)+3*16]);




   q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
   q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
   q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
   q4 = _mm512_fmadd_round_ps((x4), (h1), (q4), 0x04);
# 10996 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11060 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11107 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[nb*ldq], q1);
   _mm512_store_ps(&q[(nb*ldq)+16], q2);
   _mm512_store_ps(&q[(nb*ldq)+2*16], q3);
   _mm512_store_ps(&q[(nb*ldq)+3*16], q4);

# 11300 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


# 11390 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
}

# 11401 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11410 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11419 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"









# 11434 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_48_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

               float s)
# 11445 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
  {





# 11458 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    int i;
# 11470 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 11483 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11492 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"






        __m512 sign = (__m512)_mm512_set1_epi32(0x80000000);



# 11510 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 x1 = _mm512_load_ps(&q[ldq]);
    __m512 x2 = _mm512_load_ps(&q[ldq+16]);
    __m512 x3 = _mm512_load_ps(&q[ldq+2*16]);


    __m512 h1 = _mm512_set1_ps(hh[ldh+1]);
# 11524 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
    __m512 h2;

    __m512 q1 = _mm512_load_ps(q);
    __m512 q2 = _mm512_load_ps(&q[16]);
    __m512 q3 = _mm512_load_ps(&q[2*16]);


    __m512 y1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
    __m512 y2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
    __m512 y3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
# 11540 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11647 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11884 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    for(i = 2; i < nb; i++)
      {

        h1 = _mm512_set1_ps(hh[i-(2-1)]);
        h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 11900 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

        q1 = _mm512_load_ps(&q[i*ldq]);
        q2 = _mm512_load_ps(&q[(i*ldq)+16]);
        q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);


        x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
        y1 = _mm512_fmadd_round_ps((q1), (h2), (y1), 0x04);
        x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
        y2 = _mm512_fmadd_round_ps((q2), (h2), (y2), 0x04);
        x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);
        y3 = _mm512_fmadd_round_ps((q3), (h2), (y3), 0x04);
# 11920 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 11967 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 12013 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
      }

    h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 12023 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    q1 = _mm512_load_ps(&q[nb*ldq]);
    q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
    q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);


    x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
    x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
    x3 = _mm512_fmadd_round_ps((q3), (h1), (x3), 0x04);






# 12160 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 12435 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 12451 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 tau1 = _mm512_set1_ps(hh[0]);
    __m512 tau2 = _mm512_set1_ps(hh[ldh]);
# 12463 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 vs = _mm512_set1_ps(s);
# 12493 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 12536 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 12579 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 12598 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau1, sign);









   x1 = _mm512_mul_ps(  x1, h1);
   x2 = _mm512_mul_ps(  x2, h1);
   x3 = _mm512_mul_ps(  x3, h1);










# 12632 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau2, sign);


   h2 = _mm512_mul_ps(  h1, vs);











   y1 = _mm512_fmadd_round_ps((y1), (h1), (_mm512_mul_ps( x1,h2)), 0x04);
   y2 = _mm512_fmadd_round_ps((y2), (h1), (_mm512_mul_ps( x2,h2)), 0x04);
   y3 = _mm512_fmadd_round_ps((y3), (h1), (_mm512_mul_ps( x3,h2)), 0x04);
# 12658 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 12701 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 12738 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[0]);

   q1 = _mm512_add_ps(  q1, y1);
# 12749 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[0], q1);
   q2 = _mm512_load_ps(&q[16]);

   q2 = _mm512_add_ps(  q2, y2);
# 12760 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[16], q2);
   q3 = _mm512_load_ps(&q[2*16]);

   q3 = _mm512_add_ps(  q3, y3);
# 12771 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[2*16], q3);



   h2 = _mm512_set1_ps(hh[ldh+1]);
# 12784 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[ldq]);
   q2 = _mm512_load_ps(&q[ldq+16]);
   q3 = _mm512_load_ps(&q[ldq+2*16]);

   q1 = _mm512_add_ps(  q1, _mm512_fmadd_round_ps((y1), (h2), (x1), 0x04));
   q2 = _mm512_add_ps(  q2, _mm512_fmadd_round_ps((y2), (h2), (x2), 0x04));
   q3 = _mm512_add_ps(  q3, _mm512_fmadd_round_ps((y3), (h2), (x3), 0x04));






   _mm512_store_ps(&q[ldq], q1);
   _mm512_store_ps(&q[ldq+16], q2);
   _mm512_store_ps(&q[ldq+2*16], q3);



# 12968 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13333 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   for (i = 2; i < nb; i++)
   {

     h1 = _mm512_set1_ps(hh[i-(2-1)]);
     h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 13348 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     q1 = _mm512_load_ps(&q[i*ldq]);
     q2 = _mm512_load_ps(&q[(i*ldq)+16]);
     q3 = _mm512_load_ps(&q[(i*ldq)+2*16]);



     q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
     q1 = _mm512_fmadd_round_ps((y1), (h2), (q1), 0x04);
     q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
     q2 = _mm512_fmadd_round_ps((y2), (h2), (q2), 0x04);
     q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
     q3 = _mm512_fmadd_round_ps((y3), (h2), (q3), 0x04);
# 13367 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13435 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13478 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
     _mm512_store_ps(&q[i*ldq], q1);
     _mm512_store_ps(&q[(i*ldq)+16], q2);
     _mm512_store_ps(&q[(i*ldq)+2*16], q3);

   }

   h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 13492 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[nb*ldq]);
   q2 = _mm512_load_ps(&q[(nb*ldq)+16]);
   q3 = _mm512_load_ps(&q[(nb*ldq)+2*16]);




   q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
   q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
   q3 = _mm512_fmadd_round_ps((x3), (h1), (q3), 0x04);
# 13509 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13567 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13611 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[nb*ldq], q1);
   _mm512_store_ps(&q[(nb*ldq)+16], q2);
   _mm512_store_ps(&q[(nb*ldq)+2*16], q3);

# 13785 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13864 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
}


# 13878 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13887 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13896 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"









# 13911 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_32_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

               float s)
# 13922 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
  {





# 13935 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    int i;
# 13947 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 13960 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 13969 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"






        __m512 sign = (__m512)_mm512_set1_epi32(0x80000000);



# 13987 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 x1 = _mm512_load_ps(&q[ldq]);
    __m512 x2 = _mm512_load_ps(&q[ldq+16]);


    __m512 h1 = _mm512_set1_ps(hh[ldh+1]);
# 14000 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 h2;

    __m512 q1 = _mm512_load_ps(q);
    __m512 y1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
    __m512 q2 = _mm512_load_ps(&q[16]);
    __m512 y2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
# 14014 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 14097 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 14290 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    for(i = 2; i < nb; i++)
      {

        h1 = _mm512_set1_ps(hh[i-(2-1)]);
        h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 14305 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

        q1 = _mm512_load_ps(&q[i*ldq]);
        q2 = _mm512_load_ps(&q[(i*ldq)+16]);

        x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
        y1 = _mm512_fmadd_round_ps((q1), (h2), (y1), 0x04);
        x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);
        y2 = _mm512_fmadd_round_ps((q2), (h2), (y2), 0x04);
# 14319 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 14362 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 14404 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
      }

    h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 14414 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    q1 = _mm512_load_ps(&q[nb*ldq]);
    q2 = _mm512_load_ps(&q[(nb*ldq)+16]);

    x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
    x2 = _mm512_fmadd_round_ps((q2), (h1), (x2), 0x04);





# 14537 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 14782 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 14798 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 tau1 = _mm512_set1_ps(hh[0]);
    __m512 tau2 = _mm512_set1_ps(hh[ldh]);
# 14810 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 vs = _mm512_set1_ps(s);
# 14840 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 14883 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 14926 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 14945 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau1, sign);









   x1 = _mm512_mul_ps(  x1, h1);
   x2 = _mm512_mul_ps(  x2, h1);










# 14978 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau2, sign);


   h2 = _mm512_mul_ps(  h1, vs);










   y1 = _mm512_fmadd_round_ps((y1), (h1), (_mm512_mul_ps( x1,h2)), 0x04);
   y2 = _mm512_fmadd_round_ps((y2), (h1), (_mm512_mul_ps( x2,h2)), 0x04);






# 15038 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 15071 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[0]);

   q1 = _mm512_add_ps(  q1, y1);
# 15082 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[0], q1);
   q2 = _mm512_load_ps(&q[16]);

   q2 = _mm512_add_ps(  q2, y2);
# 15093 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[16], q2);



   h2 = _mm512_set1_ps(hh[ldh+1]);
# 15105 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


   q1 = _mm512_load_ps(&q[ldq]);
   q1 = _mm512_add_ps(  q1, _mm512_fmadd_round_ps((y1), (h2), (x1), 0x04));
   _mm512_store_ps(&q[ldq], q1);
   q2 = _mm512_load_ps(&q[ldq+16]);
   q2 = _mm512_add_ps(  q2, _mm512_fmadd_round_ps((y2), (h2), (x2), 0x04));
   _mm512_store_ps(&q[ldq+16], q2);
# 15122 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 15267 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 15581 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   for (i = 2; i < nb; i++)
   {

     h1 = _mm512_set1_ps(hh[i-(2-1)]);
     h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 15596 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     q1 = _mm512_load_ps(&q[i*ldq]);
     q2 = _mm512_load_ps(&q[(i*ldq)+16]);



     q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
     q1 = _mm512_fmadd_round_ps((y1), (h2), (q1), 0x04);
     q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);
     q2 = _mm512_fmadd_round_ps((y2), (h2), (q2), 0x04);






# 15671 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 15709 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     _mm512_store_ps(&q[i*ldq], q1);
     _mm512_store_ps(&q[(i*ldq)+16], q2);

   }

   h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 15723 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[nb*ldq]);
   q2 = _mm512_load_ps(&q[(nb*ldq)+16]);




   q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
   q2 = _mm512_fmadd_round_ps((x2), (h1), (q2), 0x04);






# 15789 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 15828 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[nb*ldq], q1);
   _mm512_store_ps(&q[(nb*ldq)+16], q2);

# 15984 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16053 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

}

# 16067 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16076 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16085 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"











# 16102 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

__attribute__((always_inline)) static void hh_trafo_kernel_16_AVX512_2hv_single (float* q, float* hh, int nb, int ldq, int ldh,

               float s)
# 16113 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
  {





# 16126 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
    int i;
# 16137 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 16150 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16159 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"






        __m512 sign = (__m512)_mm512_set1_epi32(0x80000000);



# 16177 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 x1 = _mm512_load_ps(&q[ldq]);


    __m512 h1 = _mm512_set1_ps(hh[ldh+1]);
# 16189 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    __m512 h2;

    __m512 q1 = _mm512_load_ps(q);
    __m512 y1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);






# 16258 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16407 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

    for(i = 2; i < nb; i++)
      {

        h1 = _mm512_set1_ps(hh[i-(2-1)]);
        h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 16422 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


        q1 = _mm512_load_ps(&q[i*ldq]);
        x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);
        y1 = _mm512_fmadd_round_ps((q1), (h2), (y1), 0x04);






# 16470 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16508 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
      }

    h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 16518 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    q1 = _mm512_load_ps(&q[nb*ldq]);
    x1 = _mm512_fmadd_round_ps((q1), (h1), (x1), 0x04);





# 16626 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16844 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"





# 16860 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"



    __m512 tau1 = _mm512_set1_ps(hh[0]);
    __m512 tau2 = _mm512_set1_ps(hh[ldh]);
# 16873 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    __m512 vs = _mm512_set1_ps(s);
# 16903 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16946 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 16989 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"










# 17008 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau1, sign);








   x1 = _mm512_mul_ps(  x1, h1);










# 17039 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


    h1 = _mm512_xor_ps(tau2, sign);


   h2 = _mm512_mul_ps(  h1, vs);










   y1 = _mm512_fmadd_round_ps((y1), (h1), (_mm512_mul_ps( x1,h2)), 0x04);





# 17091 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 17122 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[0]);

   q1 = _mm512_add_ps(  q1, y1);
# 17133 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"
   _mm512_store_ps(&q[0], q1);



   h2 = _mm512_set1_ps(hh[ldh+1]);
# 17145 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"


   q1 = _mm512_load_ps(&q[ldq]);
   q1 = _mm512_add_ps(  q1, _mm512_fmadd_round_ps((y1), (h2), (x1), 0x04));
   _mm512_store_ps(&q[ldq], q1);
# 17156 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 17281 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 17549 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   for (i = 2; i < nb; i++)
   {

     h1 = _mm512_set1_ps(hh[i-(2-1)]);
     h2 = _mm512_set1_ps(hh[ldh+i-(2-2)]);
# 17564 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     q1 = _mm512_load_ps(&q[i*ldq]);



     q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);
     q1 = _mm512_fmadd_round_ps((y1), (h2), (q1), 0x04);





# 17627 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 17663 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

     _mm512_store_ps(&q[i*ldq], q1);

   }

   h1 = _mm512_set1_ps(hh[nb-(2-1)]);
# 17676 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   q1 = _mm512_load_ps(&q[nb*ldq]);




   q1 = _mm512_fmadd_round_ps((x1), (h1), (q1), 0x04);





# 17733 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 17768 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

   _mm512_store_ps(&q[nb*ldq], q1);

# 17906 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

# 17964 "../src/elpa2/kernels/real_128bit_256bit_512bit_BLOCK_template.c"

}

# 55 "../src/elpa2/kernels/real_avx512_2hv_single_precision.c" 2
