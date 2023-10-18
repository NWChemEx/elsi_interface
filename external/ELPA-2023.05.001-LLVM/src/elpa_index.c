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



# 1 "../src/elpa_index.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 378 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "../src/elpa_index.c" 2
# 48 "../src/elpa_index.c"
# 1 "/usr/include/assert.h" 1 3 4
# 36 "/usr/include/assert.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 345 "/usr/include/features.h" 3 4
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 346 "/usr/include/features.h" 2 3 4
# 375 "/usr/include/features.h" 3 4
# 1 "/usr/include/sys/cdefs.h" 1 3 4
# 392 "/usr/include/sys/cdefs.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 393 "/usr/include/sys/cdefs.h" 2 3 4
# 376 "/usr/include/features.h" 2 3 4
# 399 "/usr/include/features.h" 3 4
# 1 "/usr/include/gnu/stubs.h" 1 3 4
# 10 "/usr/include/gnu/stubs.h" 3 4
# 1 "/usr/include/gnu/stubs-64.h" 1 3 4
# 11 "/usr/include/gnu/stubs.h" 2 3 4
# 400 "/usr/include/features.h" 2 3 4
# 37 "/usr/include/assert.h" 2 3 4
# 68 "/usr/include/assert.h" 3 4
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ )) __attribute__ ((__noreturn__));


extern void __assert_perror_fail (int __errnum, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ )) __attribute__ ((__noreturn__));




extern void __assert (const char *__assertion, const char *__file, int __line)
     __attribute__ ((__nothrow__ )) __attribute__ ((__noreturn__));
# 49 "../src/elpa_index.c" 2
# 1 "/usr/include/stdio.h" 1 3 4
# 33 "/usr/include/stdio.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 1 3 4
# 62 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 3 4
typedef long unsigned int size_t;
# 34 "/usr/include/stdio.h" 2 3 4

# 1 "/usr/include/bits/types.h" 1 3 4
# 27 "/usr/include/bits/types.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 28 "/usr/include/bits/types.h" 2 3 4


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
# 130 "/usr/include/bits/types.h" 3 4
# 1 "/usr/include/bits/typesizes.h" 1 3 4
# 131 "/usr/include/bits/types.h" 2 3 4


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
# 36 "/usr/include/stdio.h" 2 3 4








struct _IO_FILE;



typedef struct _IO_FILE FILE;
# 64 "/usr/include/stdio.h" 3 4
typedef struct _IO_FILE __FILE;
# 74 "/usr/include/stdio.h" 3 4
# 1 "/usr/include/libio.h" 1 3 4
# 32 "/usr/include/libio.h" 3 4
# 1 "/usr/include/_G_config.h" 1 3 4
# 15 "/usr/include/_G_config.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 1 3 4
# 16 "/usr/include/_G_config.h" 2 3 4




# 1 "/usr/include/wchar.h" 1 3 4
# 82 "/usr/include/wchar.h" 3 4
typedef struct
{
  int __count;
  union
  {

    unsigned int __wch;



    char __wchb[4];
  } __value;
} __mbstate_t;
# 21 "/usr/include/_G_config.h" 2 3 4
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
# 33 "/usr/include/libio.h" 2 3 4
# 50 "/usr/include/libio.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stdarg.h" 1 3 4
# 30 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 51 "/usr/include/libio.h" 2 3 4
# 145 "/usr/include/libio.h" 3 4
struct _IO_jump_t; struct _IO_FILE;
# 155 "/usr/include/libio.h" 3 4
typedef void _IO_lock_t;





struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;



  int _pos;
# 178 "/usr/include/libio.h" 3 4
};


enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};
# 246 "/usr/include/libio.h" 3 4
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
# 294 "/usr/include/libio.h" 3 4
  __off64_t _offset;
# 303 "/usr/include/libio.h" 3 4
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
# 339 "/usr/include/libio.h" 3 4
typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);







typedef __ssize_t __io_write_fn (void *__cookie, const char *__buf,
     size_t __n);







typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);


typedef int __io_close_fn (void *__cookie);
# 391 "/usr/include/libio.h" 3 4
extern int __underflow (_IO_FILE *);
extern int __uflow (_IO_FILE *);
extern int __overflow (_IO_FILE *, int);
# 435 "/usr/include/libio.h" 3 4
extern int _IO_getc (_IO_FILE *__fp);
extern int _IO_putc (int __c, _IO_FILE *__fp);
extern int _IO_feof (_IO_FILE *__fp) __attribute__ ((__nothrow__ ));
extern int _IO_ferror (_IO_FILE *__fp) __attribute__ ((__nothrow__ ));

extern int _IO_peekc_locked (_IO_FILE *__fp);





extern void _IO_flockfile (_IO_FILE *) __attribute__ ((__nothrow__ ));
extern void _IO_funlockfile (_IO_FILE *) __attribute__ ((__nothrow__ ));
extern int _IO_ftrylockfile (_IO_FILE *) __attribute__ ((__nothrow__ ));
# 465 "/usr/include/libio.h" 3 4
extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
   __gnuc_va_list, int *__restrict);
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
    __gnuc_va_list);
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t);
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t);

extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int);
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int);

extern void _IO_free_backup_area (_IO_FILE *) __attribute__ ((__nothrow__ ));
# 75 "/usr/include/stdio.h" 2 3 4




typedef __gnuc_va_list va_list;
# 90 "/usr/include/stdio.h" 3 4
typedef __off_t off_t;
# 102 "/usr/include/stdio.h" 3 4
typedef __ssize_t ssize_t;







typedef _G_fpos_t fpos_t;
# 164 "/usr/include/stdio.h" 3 4
# 1 "/usr/include/bits/stdio_lim.h" 1 3 4
# 165 "/usr/include/stdio.h" 2 3 4



extern struct _IO_FILE *stdin;
extern struct _IO_FILE *stdout;
extern struct _IO_FILE *stderr;







extern int remove (const char *__filename) __attribute__ ((__nothrow__ ));

extern int rename (const char *__old, const char *__new) __attribute__ ((__nothrow__ ));




extern int renameat (int __oldfd, const char *__old, int __newfd,
       const char *__new) __attribute__ ((__nothrow__ ));
# 195 "/usr/include/stdio.h" 3 4
extern FILE *tmpfile (void) ;
# 209 "/usr/include/stdio.h" 3 4
extern char *tmpnam (char *__s) __attribute__ ((__nothrow__ )) ;





extern char *tmpnam_r (char *__s) __attribute__ ((__nothrow__ )) ;
# 227 "/usr/include/stdio.h" 3 4
extern char *tempnam (const char *__dir, const char *__pfx)
     __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__)) ;
# 237 "/usr/include/stdio.h" 3 4
extern int fclose (FILE *__stream);




extern int fflush (FILE *__stream);
# 252 "/usr/include/stdio.h" 3 4
extern int fflush_unlocked (FILE *__stream);
# 272 "/usr/include/stdio.h" 3 4
extern FILE *fopen (const char *__restrict __filename,
      const char *__restrict __modes) ;




extern FILE *freopen (const char *__restrict __filename,
        const char *__restrict __modes,
        FILE *__restrict __stream) ;
# 306 "/usr/include/stdio.h" 3 4
extern FILE *fdopen (int __fd, const char *__modes) __attribute__ ((__nothrow__ )) ;
# 319 "/usr/include/stdio.h" 3 4
extern FILE *fmemopen (void *__s, size_t __len, const char *__modes)
  __attribute__ ((__nothrow__ )) ;




extern FILE *open_memstream (char **__bufloc, size_t *__sizeloc) __attribute__ ((__nothrow__ )) ;






extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__ ((__nothrow__ ));



extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
      int __modes, size_t __n) __attribute__ ((__nothrow__ ));





extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
         size_t __size) __attribute__ ((__nothrow__ ));


extern void setlinebuf (FILE *__stream) __attribute__ ((__nothrow__ ));
# 356 "/usr/include/stdio.h" 3 4
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
# 412 "/usr/include/stdio.h" 3 4
extern int vdprintf (int __fd, const char *__restrict __fmt,
       __gnuc_va_list __arg)
     __attribute__ ((__format__ (__printf__, 2, 0)));
extern int dprintf (int __fd, const char *__restrict __fmt, ...)
     __attribute__ ((__format__ (__printf__, 2, 3)));
# 425 "/usr/include/stdio.h" 3 4
extern int fscanf (FILE *__restrict __stream,
     const char *__restrict __format, ...) ;




extern int scanf (const char *__restrict __format, ...) ;

extern int sscanf (const char *__restrict __s,
     const char *__restrict __format, ...) __attribute__ ((__nothrow__ ));
# 443 "/usr/include/stdio.h" 3 4
extern int fscanf (FILE *__restrict __stream, const char *__restrict __format, ...) __asm__ ("" "__isoc99_fscanf") ;


extern int scanf (const char *__restrict __format, ...) __asm__ ("" "__isoc99_scanf") ;

extern int sscanf (const char *__restrict __s, const char *__restrict __format, ...) __asm__ ("" "__isoc99_sscanf") __attribute__ ((__nothrow__ ));
# 471 "/usr/include/stdio.h" 3 4
extern int vfscanf (FILE *__restrict __s, const char *__restrict __format,
      __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;





extern int vscanf (const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;


extern int vsscanf (const char *__restrict __s,
      const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__ )) __attribute__ ((__format__ (__scanf__, 2, 0)));
# 494 "/usr/include/stdio.h" 3 4
extern int vfscanf (FILE *__restrict __s, const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vfscanf")



     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
extern int vscanf (const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vscanf")

     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
extern int vsscanf (const char *__restrict __s, const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vsscanf") __attribute__ ((__nothrow__ ))



     __attribute__ ((__format__ (__scanf__, 2, 0)));
# 531 "/usr/include/stdio.h" 3 4
extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);





extern int getchar (void);
# 550 "/usr/include/stdio.h" 3 4
extern int getc_unlocked (FILE *__stream);
extern int getchar_unlocked (void);
# 561 "/usr/include/stdio.h" 3 4
extern int fgetc_unlocked (FILE *__stream);
# 573 "/usr/include/stdio.h" 3 4
extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);





extern int putchar (int __c);
# 594 "/usr/include/stdio.h" 3 4
extern int fputc_unlocked (int __c, FILE *__stream);







extern int putc_unlocked (int __c, FILE *__stream);
extern int putchar_unlocked (int __c);






extern int getw (FILE *__stream);


extern int putw (int __w, FILE *__stream);
# 622 "/usr/include/stdio.h" 3 4
extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
          ;
# 665 "/usr/include/stdio.h" 3 4
extern __ssize_t __getdelim (char **__restrict __lineptr,
          size_t *__restrict __n, int __delimiter,
          FILE *__restrict __stream) ;
extern __ssize_t getdelim (char **__restrict __lineptr,
        size_t *__restrict __n, int __delimiter,
        FILE *__restrict __stream) ;







extern __ssize_t getline (char **__restrict __lineptr,
       size_t *__restrict __n,
       FILE *__restrict __stream) ;
# 689 "/usr/include/stdio.h" 3 4
extern int fputs (const char *__restrict __s, FILE *__restrict __stream);





extern int puts (const char *__s);






extern int ungetc (int __c, FILE *__stream);






extern size_t fread (void *__restrict __ptr, size_t __size,
       size_t __n, FILE *__restrict __stream) ;




extern size_t fwrite (const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s);
# 737 "/usr/include/stdio.h" 3 4
extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
         size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite_unlocked (const void *__restrict __ptr, size_t __size,
          size_t __n, FILE *__restrict __stream);
# 749 "/usr/include/stdio.h" 3 4
extern int fseek (FILE *__stream, long int __off, int __whence);




extern long int ftell (FILE *__stream) ;




extern void rewind (FILE *__stream);
# 773 "/usr/include/stdio.h" 3 4
extern int fseeko (FILE *__stream, __off_t __off, int __whence);




extern __off_t ftello (FILE *__stream) ;
# 798 "/usr/include/stdio.h" 3 4
extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);




extern int fsetpos (FILE *__stream, const fpos_t *__pos);
# 826 "/usr/include/stdio.h" 3 4
extern void clearerr (FILE *__stream) __attribute__ ((__nothrow__ ));

extern int feof (FILE *__stream) __attribute__ ((__nothrow__ )) ;

extern int ferror (FILE *__stream) __attribute__ ((__nothrow__ )) ;




extern void clearerr_unlocked (FILE *__stream) __attribute__ ((__nothrow__ ));
extern int feof_unlocked (FILE *__stream) __attribute__ ((__nothrow__ )) ;
extern int ferror_unlocked (FILE *__stream) __attribute__ ((__nothrow__ )) ;
# 846 "/usr/include/stdio.h" 3 4
extern void perror (const char *__s);






# 1 "/usr/include/bits/sys_errlist.h" 1 3 4
# 26 "/usr/include/bits/sys_errlist.h" 3 4
extern int sys_nerr;
extern const char *const sys_errlist[];
# 854 "/usr/include/stdio.h" 2 3 4




extern int fileno (FILE *__stream) __attribute__ ((__nothrow__ )) ;




extern int fileno_unlocked (FILE *__stream) __attribute__ ((__nothrow__ )) ;
# 873 "/usr/include/stdio.h" 3 4
extern FILE *popen (const char *__command, const char *__modes) ;





extern int pclose (FILE *__stream);





extern char *ctermid (char *__s) __attribute__ ((__nothrow__ ));
# 913 "/usr/include/stdio.h" 3 4
extern void flockfile (FILE *__stream) __attribute__ ((__nothrow__ ));



extern int ftrylockfile (FILE *__stream) __attribute__ ((__nothrow__ )) ;


extern void funlockfile (FILE *__stream) __attribute__ ((__nothrow__ ));
# 934 "/usr/include/stdio.h" 3 4
# 1 "/usr/include/bits/stdio.h" 1 3 4
# 35 "/usr/include/bits/stdio.h" 3 4
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
# 124 "/usr/include/bits/stdio.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ )) feof_unlocked (FILE *__stream)
{
  return (((__stream)->_flags & 0x10) != 0);
}


extern __inline __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ )) ferror_unlocked (FILE *__stream)
{
  return (((__stream)->_flags & 0x20) != 0);
}
# 935 "/usr/include/stdio.h" 2 3 4
# 50 "../src/elpa_index.c" 2
# 1 "/usr/include/stdlib.h" 1 3 4
# 32 "/usr/include/stdlib.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 1 3 4
# 90 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 3 4
typedef int wchar_t;
# 33 "/usr/include/stdlib.h" 2 3 4








# 1 "/usr/include/bits/waitflags.h" 1 3 4
# 42 "/usr/include/stdlib.h" 2 3 4
# 1 "/usr/include/bits/waitstatus.h" 1 3 4
# 64 "/usr/include/bits/waitstatus.h" 3 4
# 1 "/usr/include/endian.h" 1 3 4
# 36 "/usr/include/endian.h" 3 4
# 1 "/usr/include/bits/endian.h" 1 3 4
# 37 "/usr/include/endian.h" 2 3 4
# 60 "/usr/include/endian.h" 3 4
# 1 "/usr/include/bits/byteswap.h" 1 3 4
# 28 "/usr/include/bits/byteswap.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 29 "/usr/include/bits/byteswap.h" 2 3 4






# 1 "/usr/include/bits/byteswap-16.h" 1 3 4
# 36 "/usr/include/bits/byteswap.h" 2 3 4
# 61 "/usr/include/endian.h" 2 3 4
# 65 "/usr/include/bits/waitstatus.h" 2 3 4

union wait
  {
    int w_status;
    struct
      {

 unsigned int __w_termsig:7;
 unsigned int __w_coredump:1;
 unsigned int __w_retcode:8;
 unsigned int:16;







      } __wait_terminated;
    struct
      {

 unsigned int __w_stopval:8;
 unsigned int __w_stopsig:8;
 unsigned int:16;






      } __wait_stopped;
  };
# 43 "/usr/include/stdlib.h" 2 3 4
# 67 "/usr/include/stdlib.h" 3 4
typedef union
  {
    union wait *__uptr;
    int *__iptr;
  } __WAIT_STATUS __attribute__ ((__transparent_union__));
# 97 "/usr/include/stdlib.h" 3 4
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
# 139 "/usr/include/stdlib.h" 3 4
extern size_t __ctype_get_mb_cur_max (void) __attribute__ ((__nothrow__ )) ;




extern double atof (const char *__nptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;

extern int atoi (const char *__nptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;

extern long int atol (const char *__nptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;





__extension__ extern long long int atoll (const char *__nptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;





extern double strtod (const char *__restrict __nptr,
        char **__restrict __endptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));





extern float strtof (const char *__restrict __nptr,
       char **__restrict __endptr) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));

extern long double strtold (const char *__restrict __nptr,
       char **__restrict __endptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));





extern long int strtol (const char *__restrict __nptr,
   char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));

extern unsigned long int strtoul (const char *__restrict __nptr,
      char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));




__extension__
extern long long int strtoq (const char *__restrict __nptr,
        char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));

__extension__
extern unsigned long long int strtouq (const char *__restrict __nptr,
           char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));





__extension__
extern long long int strtoll (const char *__restrict __nptr,
         char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));

__extension__
extern unsigned long long int strtoull (const char *__restrict __nptr,
     char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));
# 277 "/usr/include/stdlib.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ )) atoi (const char *__nptr)
{
  return (int) strtol (__nptr, (char **) ((void*)0), 10);
}
extern __inline __attribute__ ((__gnu_inline__)) long int
__attribute__ ((__nothrow__ )) atol (const char *__nptr)
{
  return strtol (__nptr, (char **) ((void*)0), 10);
}




__extension__ extern __inline __attribute__ ((__gnu_inline__)) long long int
__attribute__ ((__nothrow__ )) atoll (const char *__nptr)
{
  return strtoll (__nptr, (char **) ((void*)0), 10);
}
# 305 "/usr/include/stdlib.h" 3 4
extern char *l64a (long int __n) __attribute__ ((__nothrow__ )) ;


extern long int a64l (const char *__s)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;




# 1 "/usr/include/sys/types.h" 1 3 4
# 33 "/usr/include/sys/types.h" 3 4
typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;




typedef __loff_t loff_t;



typedef __ino_t ino_t;
# 60 "/usr/include/sys/types.h" 3 4
typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __uid_t uid_t;
# 98 "/usr/include/sys/types.h" 3 4
typedef __pid_t pid_t;





typedef __id_t id_t;
# 115 "/usr/include/sys/types.h" 3 4
typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;





typedef __key_t key_t;
# 132 "/usr/include/sys/types.h" 3 4
# 1 "/usr/include/time.h" 1 3 4
# 59 "/usr/include/time.h" 3 4
typedef __clock_t clock_t;
# 75 "/usr/include/time.h" 3 4
typedef __time_t time_t;
# 91 "/usr/include/time.h" 3 4
typedef __clockid_t clockid_t;
# 103 "/usr/include/time.h" 3 4
typedef __timer_t timer_t;
# 133 "/usr/include/sys/types.h" 2 3 4
# 146 "/usr/include/sys/types.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 1 3 4
# 147 "/usr/include/sys/types.h" 2 3 4



typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;
# 194 "/usr/include/sys/types.h" 3 4
typedef int int8_t __attribute__ ((__mode__ (__QI__)));
typedef int int16_t __attribute__ ((__mode__ (__HI__)));
typedef int int32_t __attribute__ ((__mode__ (__SI__)));
typedef int int64_t __attribute__ ((__mode__ (__DI__)));


typedef unsigned int u_int8_t __attribute__ ((__mode__ (__QI__)));
typedef unsigned int u_int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int u_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int u_int64_t __attribute__ ((__mode__ (__DI__)));

typedef int register_t __attribute__ ((__mode__ (__word__)));
# 219 "/usr/include/sys/types.h" 3 4
# 1 "/usr/include/sys/select.h" 1 3 4
# 30 "/usr/include/sys/select.h" 3 4
# 1 "/usr/include/bits/select.h" 1 3 4
# 22 "/usr/include/bits/select.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 23 "/usr/include/bits/select.h" 2 3 4
# 31 "/usr/include/sys/select.h" 2 3 4


# 1 "/usr/include/bits/sigset.h" 1 3 4
# 23 "/usr/include/bits/sigset.h" 3 4
typedef int __sig_atomic_t;




typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;
# 34 "/usr/include/sys/select.h" 2 3 4



typedef __sigset_t sigset_t;





# 1 "/usr/include/time.h" 1 3 4
# 120 "/usr/include/time.h" 3 4
struct timespec
  {
    __time_t tv_sec;
    __syscall_slong_t tv_nsec;
  };
# 44 "/usr/include/sys/select.h" 2 3 4

# 1 "/usr/include/bits/time.h" 1 3 4
# 30 "/usr/include/bits/time.h" 3 4
struct timeval
  {
    __time_t tv_sec;
    __suseconds_t tv_usec;
  };
# 46 "/usr/include/sys/select.h" 2 3 4


typedef __suseconds_t suseconds_t;





typedef long int __fd_mask;
# 64 "/usr/include/sys/select.h" 3 4
typedef struct
  {






    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];


  } fd_set;






typedef __fd_mask fd_mask;
# 106 "/usr/include/sys/select.h" 3 4
extern int select (int __nfds, fd_set *__restrict __readfds,
     fd_set *__restrict __writefds,
     fd_set *__restrict __exceptfds,
     struct timeval *__restrict __timeout);
# 118 "/usr/include/sys/select.h" 3 4
extern int pselect (int __nfds, fd_set *__restrict __readfds,
      fd_set *__restrict __writefds,
      fd_set *__restrict __exceptfds,
      const struct timespec *__restrict __timeout,
      const __sigset_t *__restrict __sigmask);
# 220 "/usr/include/sys/types.h" 2 3 4


# 1 "/usr/include/sys/sysmacros.h" 1 3 4
# 31 "/usr/include/sys/sysmacros.h" 3 4
__extension__
extern unsigned int gnu_dev_major (unsigned long long int __dev)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__));
__extension__
extern unsigned int gnu_dev_minor (unsigned long long int __dev)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__));
__extension__
extern unsigned long long int gnu_dev_makedev (unsigned int __major,
            unsigned int __minor)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


__extension__ extern __inline __attribute__ ((__gnu_inline__)) __attribute__ ((__const__)) unsigned int
__attribute__ ((__nothrow__ )) gnu_dev_major (unsigned long long int __dev)
{
  return ((__dev >> 8) & 0xfff) | ((unsigned int) (__dev >> 32) & ~0xfff);
}

__extension__ extern __inline __attribute__ ((__gnu_inline__)) __attribute__ ((__const__)) unsigned int
__attribute__ ((__nothrow__ )) gnu_dev_minor (unsigned long long int __dev)
{
  return (__dev & 0xff) | ((unsigned int) (__dev >> 12) & ~0xff);
}

__extension__ extern __inline __attribute__ ((__gnu_inline__)) __attribute__ ((__const__)) unsigned long long int
__attribute__ ((__nothrow__ )) gnu_dev_makedev (unsigned int __major, unsigned int __minor)
{
  return ((__minor & 0xff) | ((__major & 0xfff) << 8)
   | (((unsigned long long int) (__minor & ~0xff)) << 12)
   | (((unsigned long long int) (__major & ~0xfff)) << 32));
}
# 223 "/usr/include/sys/types.h" 2 3 4





typedef __blksize_t blksize_t;






typedef __blkcnt_t blkcnt_t;



typedef __fsblkcnt_t fsblkcnt_t;



typedef __fsfilcnt_t fsfilcnt_t;
# 270 "/usr/include/sys/types.h" 3 4
# 1 "/usr/include/bits/pthreadtypes.h" 1 3 4
# 21 "/usr/include/bits/pthreadtypes.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 22 "/usr/include/bits/pthreadtypes.h" 2 3 4
# 60 "/usr/include/bits/pthreadtypes.h" 3 4
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
# 90 "/usr/include/bits/pthreadtypes.h" 3 4
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
# 125 "/usr/include/bits/pthreadtypes.h" 3 4
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
# 212 "/usr/include/bits/pthreadtypes.h" 3 4
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
# 271 "/usr/include/sys/types.h" 2 3 4
# 315 "/usr/include/stdlib.h" 2 3 4






extern long int random (void) __attribute__ ((__nothrow__ ));


extern void srandom (unsigned int __seed) __attribute__ ((__nothrow__ ));





extern char *initstate (unsigned int __seed, char *__statebuf,
   size_t __statelen) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));



extern char *setstate (char *__statebuf) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));







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
       int32_t *__restrict __result) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));

extern int srandom_r (unsigned int __seed, struct random_data *__buf)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));

extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
   size_t __statelen,
   struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2, 4)));

extern int setstate_r (char *__restrict __statebuf,
         struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));






extern int rand (void) __attribute__ ((__nothrow__ ));

extern void srand (unsigned int __seed) __attribute__ ((__nothrow__ ));




extern int rand_r (unsigned int *__seed) __attribute__ ((__nothrow__ ));







extern double drand48 (void) __attribute__ ((__nothrow__ ));
extern double erand48 (unsigned short int __xsubi[3]) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern long int lrand48 (void) __attribute__ ((__nothrow__ ));
extern long int nrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern long int mrand48 (void) __attribute__ ((__nothrow__ ));
extern long int jrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern void srand48 (long int __seedval) __attribute__ ((__nothrow__ ));
extern unsigned short int *seed48 (unsigned short int __seed16v[3])
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));
extern void lcong48 (unsigned short int __param[7]) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));





struct drand48_data
  {
    unsigned short int __x[3];
    unsigned short int __old_x[3];
    unsigned short int __c;
    unsigned short int __init;
    unsigned long long int __a;
  };


extern int drand48_r (struct drand48_data *__restrict __buffer,
        double *__restrict __result) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));
extern int erand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        double *__restrict __result) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int lrand48_r (struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));
extern int nrand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int mrand48_r (struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));
extern int jrand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));

extern int seed48_r (unsigned short int __seed16v[3],
       struct drand48_data *__buffer) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));

extern int lcong48_r (unsigned short int __param[7],
        struct drand48_data *__buffer)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));
# 465 "/usr/include/stdlib.h" 3 4
extern void *malloc (size_t __size) __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__)) ;

extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__)) ;
# 479 "/usr/include/stdlib.h" 3 4
extern void *realloc (void *__ptr, size_t __size)
     __attribute__ ((__nothrow__ )) __attribute__ ((__warn_unused_result__));

extern void free (void *__ptr) __attribute__ ((__nothrow__ ));




extern void cfree (void *__ptr) __attribute__ ((__nothrow__ ));



# 1 "/usr/include/alloca.h" 1 3 4
# 24 "/usr/include/alloca.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 1 3 4
# 25 "/usr/include/alloca.h" 2 3 4







extern void *alloca (size_t __size) __attribute__ ((__nothrow__ ));
# 492 "/usr/include/stdlib.h" 2 3 4





extern void *valloc (size_t __size) __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__)) ;




extern int posix_memalign (void **__memptr, size_t __alignment, size_t __size)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1))) ;




extern void *aligned_alloc (size_t __alignment, size_t __size)
     __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__, __alloc_size__ (2)));




extern void abort (void) __attribute__ ((__nothrow__ )) __attribute__ ((__noreturn__));



extern int atexit (void (*__func) (void)) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));







extern int at_quick_exit (void (*__func) (void)) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));







extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));






extern void exit (int __status) __attribute__ ((__nothrow__ )) __attribute__ ((__noreturn__));





extern void quick_exit (int __status) __attribute__ ((__nothrow__ )) __attribute__ ((__noreturn__));







extern void _Exit (int __status) __attribute__ ((__nothrow__ )) __attribute__ ((__noreturn__));






extern char *getenv (const char *__name) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1))) ;
# 577 "/usr/include/stdlib.h" 3 4
extern int putenv (char *__string) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));





extern int setenv (const char *__name, const char *__value, int __replace)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));


extern int unsetenv (const char *__name) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));






extern int clearenv (void) __attribute__ ((__nothrow__ ));
# 605 "/usr/include/stdlib.h" 3 4
extern char *mktemp (char *__template) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));
# 619 "/usr/include/stdlib.h" 3 4
extern int mkstemp (char *__template) __attribute__ ((__nonnull__ (1))) ;
# 641 "/usr/include/stdlib.h" 3 4
extern int mkstemps (char *__template, int __suffixlen) __attribute__ ((__nonnull__ (1))) ;
# 662 "/usr/include/stdlib.h" 3 4
extern char *mkdtemp (char *__template) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1))) ;
# 716 "/usr/include/stdlib.h" 3 4
extern int system (const char *__command) ;
# 733 "/usr/include/stdlib.h" 3 4
extern char *realpath (const char *__restrict __name,
         char *__restrict __resolved) __attribute__ ((__nothrow__ )) ;






typedef int (*__compar_fn_t) (const void *, const void *);
# 754 "/usr/include/stdlib.h" 3 4
extern void *bsearch (const void *__key, const void *__base,
        size_t __nmemb, size_t __size, __compar_fn_t __compar)
     __attribute__ ((__nonnull__ (1, 2, 5))) ;



extern void qsort (void *__base, size_t __nmemb, size_t __size,
     __compar_fn_t __compar) __attribute__ ((__nonnull__ (1, 4)));
# 770 "/usr/include/stdlib.h" 3 4
extern int abs (int __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)) ;
extern long int labs (long int __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)) ;



__extension__ extern long long int llabs (long long int __x)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__)) ;







extern div_t div (int __numer, int __denom)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__)) ;
extern ldiv_t ldiv (long int __numer, long int __denom)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__)) ;




__extension__ extern lldiv_t lldiv (long long int __numer,
        long long int __denom)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__)) ;
# 807 "/usr/include/stdlib.h" 3 4
extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4))) ;




extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4))) ;




extern char *gcvt (double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3))) ;




extern char *qecvt (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qfcvt (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3))) ;




extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign, char *__restrict __buf,
     size_t __len) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign, char *__restrict __buf,
     size_t __len) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4, 5)));

extern int qecvt_r (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign,
      char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int qfcvt_r (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign,
      char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3, 4, 5)));







extern int mblen (const char *__s, size_t __n) __attribute__ ((__nothrow__ )) ;


extern int mbtowc (wchar_t *__restrict __pwc,
     const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__ )) ;


extern int wctomb (char *__s, wchar_t __wchar) __attribute__ ((__nothrow__ )) ;



extern size_t mbstowcs (wchar_t *__restrict __pwcs,
   const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__ ));

extern size_t wcstombs (char *__restrict __s,
   const wchar_t *__restrict __pwcs, size_t __n)
     __attribute__ ((__nothrow__ ));
# 884 "/usr/include/stdlib.h" 3 4
extern int rpmatch (const char *__response) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1))) ;
# 895 "/usr/include/stdlib.h" 3 4
extern int getsubopt (char **__restrict __optionp,
        char *const *__restrict __tokens,
        char **__restrict __valuep)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2, 3))) ;
# 947 "/usr/include/stdlib.h" 3 4
extern int getloadavg (double __loadavg[], int __nelem)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


# 1 "/usr/include/bits/stdlib-float.h" 1 3 4
# 25 "/usr/include/bits/stdlib-float.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) double
__attribute__ ((__nothrow__ )) atof (const char *__nptr)
{
  return strtod (__nptr, (char **) ((void*)0));
}
# 952 "/usr/include/stdlib.h" 2 3 4
# 51 "../src/elpa_index.c" 2
# 1 "../elpa/elpa.h" 1



# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/limits.h" 1 3
# 52 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/limits.h" 3
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/limits.h" 1 3
# 21 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/limits.h" 3
# 1 "/usr/include/limits.h" 1 3 4
# 144 "/usr/include/limits.h" 3 4
# 1 "/usr/include/bits/posix1_lim.h" 1 3 4
# 160 "/usr/include/bits/posix1_lim.h" 3 4
# 1 "/usr/include/bits/local_lim.h" 1 3 4
# 38 "/usr/include/bits/local_lim.h" 3 4
# 1 "/usr/include/linux/limits.h" 1 3 4
# 39 "/usr/include/bits/local_lim.h" 2 3 4
# 161 "/usr/include/bits/posix1_lim.h" 2 3 4
# 145 "/usr/include/limits.h" 2 3 4



# 1 "/usr/include/bits/posix2_lim.h" 1 3 4
# 149 "/usr/include/limits.h" 2 3 4
# 22 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/limits.h" 2 3
# 53 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/limits.h" 2 3
# 5 "../elpa/elpa.h" 2
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 1 3
# 25 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 3
# 1 "/usr/include/complex.h" 1 3 4
# 28 "/usr/include/complex.h" 3 4
# 1 "/usr/include/bits/mathdef.h" 1 3 4
# 29 "/usr/include/complex.h" 2 3 4
# 75 "/usr/include/complex.h" 3 4
# 1 "/usr/include/bits/cmathcalls.h" 1 3 4
# 53 "/usr/include/bits/cmathcalls.h" 3 4
extern double _Complex cacos (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __cacos (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex casin (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __casin (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex catan (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __catan (double _Complex __z) __attribute__ ((__nothrow__ ));


extern double _Complex ccos (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __ccos (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex csin (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __csin (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex ctan (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __ctan (double _Complex __z) __attribute__ ((__nothrow__ ));





extern double _Complex cacosh (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __cacosh (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex casinh (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __casinh (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex catanh (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __catanh (double _Complex __z) __attribute__ ((__nothrow__ ));


extern double _Complex ccosh (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __ccosh (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex csinh (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __csinh (double _Complex __z) __attribute__ ((__nothrow__ ));

extern double _Complex ctanh (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __ctanh (double _Complex __z) __attribute__ ((__nothrow__ ));





extern double _Complex cexp (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __cexp (double _Complex __z) __attribute__ ((__nothrow__ ));


extern double _Complex clog (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __clog (double _Complex __z) __attribute__ ((__nothrow__ ));
# 101 "/usr/include/bits/cmathcalls.h" 3 4
extern double _Complex cpow (double _Complex __x, double _Complex __y) __attribute__ ((__nothrow__ )); extern double _Complex __cpow (double _Complex __x, double _Complex __y) __attribute__ ((__nothrow__ ));


extern double _Complex csqrt (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __csqrt (double _Complex __z) __attribute__ ((__nothrow__ ));





extern double cabs (double _Complex __z) __attribute__ ((__nothrow__ )); extern double __cabs (double _Complex __z) __attribute__ ((__nothrow__ ));


extern double carg (double _Complex __z) __attribute__ ((__nothrow__ )); extern double __carg (double _Complex __z) __attribute__ ((__nothrow__ ));


extern double _Complex conj (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __conj (double _Complex __z) __attribute__ ((__nothrow__ ));


extern double _Complex cproj (double _Complex __z) __attribute__ ((__nothrow__ )); extern double _Complex __cproj (double _Complex __z) __attribute__ ((__nothrow__ ));





extern double cimag (double _Complex __z) __attribute__ ((__nothrow__ )); extern double __cimag (double _Complex __z) __attribute__ ((__nothrow__ ));


extern double creal (double _Complex __z) __attribute__ ((__nothrow__ )); extern double __creal (double _Complex __z) __attribute__ ((__nothrow__ ));
# 76 "/usr/include/complex.h" 2 3 4
# 85 "/usr/include/complex.h" 3 4
# 1 "/usr/include/bits/cmathcalls.h" 1 3 4
# 53 "/usr/include/bits/cmathcalls.h" 3 4
extern float _Complex cacosf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __cacosf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex casinf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __casinf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex catanf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __catanf (float _Complex __z) __attribute__ ((__nothrow__ ));


extern float _Complex ccosf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __ccosf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex csinf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __csinf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex ctanf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __ctanf (float _Complex __z) __attribute__ ((__nothrow__ ));





extern float _Complex cacoshf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __cacoshf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex casinhf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __casinhf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex catanhf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __catanhf (float _Complex __z) __attribute__ ((__nothrow__ ));


extern float _Complex ccoshf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __ccoshf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex csinhf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __csinhf (float _Complex __z) __attribute__ ((__nothrow__ ));

extern float _Complex ctanhf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __ctanhf (float _Complex __z) __attribute__ ((__nothrow__ ));





extern float _Complex cexpf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __cexpf (float _Complex __z) __attribute__ ((__nothrow__ ));


extern float _Complex clogf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __clogf (float _Complex __z) __attribute__ ((__nothrow__ ));
# 101 "/usr/include/bits/cmathcalls.h" 3 4
extern float _Complex cpowf (float _Complex __x, float _Complex __y) __attribute__ ((__nothrow__ )); extern float _Complex __cpowf (float _Complex __x, float _Complex __y) __attribute__ ((__nothrow__ ));


extern float _Complex csqrtf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __csqrtf (float _Complex __z) __attribute__ ((__nothrow__ ));





extern float cabsf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float __cabsf (float _Complex __z) __attribute__ ((__nothrow__ ));


extern float cargf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float __cargf (float _Complex __z) __attribute__ ((__nothrow__ ));


extern float _Complex conjf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __conjf (float _Complex __z) __attribute__ ((__nothrow__ ));


extern float _Complex cprojf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float _Complex __cprojf (float _Complex __z) __attribute__ ((__nothrow__ ));





extern float cimagf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float __cimagf (float _Complex __z) __attribute__ ((__nothrow__ ));


extern float crealf (float _Complex __z) __attribute__ ((__nothrow__ )); extern float __crealf (float _Complex __z) __attribute__ ((__nothrow__ ));
# 86 "/usr/include/complex.h" 2 3 4
# 104 "/usr/include/complex.h" 3 4
# 1 "/usr/include/bits/cmathcalls.h" 1 3 4
# 53 "/usr/include/bits/cmathcalls.h" 3 4
extern long double _Complex cacosl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __cacosl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex casinl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __casinl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex catanl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __catanl (long double _Complex __z) __attribute__ ((__nothrow__ ));


extern long double _Complex ccosl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __ccosl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex csinl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __csinl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex ctanl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __ctanl (long double _Complex __z) __attribute__ ((__nothrow__ ));





extern long double _Complex cacoshl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __cacoshl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex casinhl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __casinhl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex catanhl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __catanhl (long double _Complex __z) __attribute__ ((__nothrow__ ));


extern long double _Complex ccoshl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __ccoshl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex csinhl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __csinhl (long double _Complex __z) __attribute__ ((__nothrow__ ));

extern long double _Complex ctanhl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __ctanhl (long double _Complex __z) __attribute__ ((__nothrow__ ));





extern long double _Complex cexpl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __cexpl (long double _Complex __z) __attribute__ ((__nothrow__ ));


extern long double _Complex clogl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __clogl (long double _Complex __z) __attribute__ ((__nothrow__ ));
# 101 "/usr/include/bits/cmathcalls.h" 3 4
extern long double _Complex cpowl (long double _Complex __x, long double _Complex __y) __attribute__ ((__nothrow__ )); extern long double _Complex __cpowl (long double _Complex __x, long double _Complex __y) __attribute__ ((__nothrow__ ));


extern long double _Complex csqrtl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __csqrtl (long double _Complex __z) __attribute__ ((__nothrow__ ));





extern long double cabsl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double __cabsl (long double _Complex __z) __attribute__ ((__nothrow__ ));


extern long double cargl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double __cargl (long double _Complex __z) __attribute__ ((__nothrow__ ));


extern long double _Complex conjl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __conjl (long double _Complex __z) __attribute__ ((__nothrow__ ));


extern long double _Complex cprojl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double _Complex __cprojl (long double _Complex __z) __attribute__ ((__nothrow__ ));





extern long double cimagl (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double __cimagl (long double _Complex __z) __attribute__ ((__nothrow__ ));


extern long double creall (long double _Complex __z) __attribute__ ((__nothrow__ )); extern long double __creall (long double _Complex __z) __attribute__ ((__nothrow__ ));
# 105 "/usr/include/complex.h" 2 3 4
# 26 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 2 3
# 40 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 3
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math_common_define.h" 1 3
# 41 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 2 3
# 93 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 3
                extern double _Complex cis( double __x );
                extern float _Complex cisf( float __x );
                extern long double _Complex cisl( long double __x );
                extern double _Complex cisd( double __x );
                extern float _Complex cisdf( float __x );
                extern long double _Complex cisdl( long double __x );







                extern double _Complex cexp2( double _Complex __z );
                extern float _Complex cexp2f( float _Complex __z );
                extern long double _Complex cexp2l( long double _Complex __z );
                extern double _Complex cexp10( double _Complex __z );
                extern float _Complex cexp10f( float _Complex __z );
                extern long double _Complex cexp10l( long double _Complex __z );
# 133 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 3
                extern double _Complex clog2( double _Complex __z );
                extern float _Complex clog2f( float _Complex __z );
                extern long double _Complex clog2l( long double _Complex __z );
                extern double _Complex clog10( double _Complex __z );
                extern float _Complex clog10f( float _Complex __z );
                extern long double _Complex clog10l( long double _Complex __z );
# 222 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 3
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math_common_undefine.h" 1 3
# 223 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/complex.h" 2 3
# 6 "../elpa/elpa.h" 2

# 1 "./elpa/elpa_version.h" 1
# 8 "../elpa/elpa.h" 2

struct elpa_struct;
typedef struct elpa_struct *elpa_t;

struct elpa_autotune_struct;
typedef struct elpa_autotune_struct *elpa_autotune_t;


# 1 "./elpa/elpa_constants.h" 1
# 17 "./elpa/elpa_constants.h"
enum MATRIX_LAYOUTS {
 COLUMN_MAJOR_ORDER = 1, ROW_MAJOR_ORDER = 2,
};
# 28 "./elpa/elpa_constants.h"
enum ELPA_SOLVERS {
        ELPA_SOLVER_1STAGE = 1, ELPA_SOLVER_2STAGE = 2,
};
# 83 "./elpa/elpa_constants.h"
enum ELPA_REAL_KERNELS {
        ELPA_2STAGE_REAL_GENERIC = 1, ELPA_2STAGE_REAL_GENERIC_SIMPLE = 2, ELPA_2STAGE_REAL_BGP = 3, ELPA_2STAGE_REAL_BGQ = 4, ELPA_2STAGE_REAL_SSE_ASSEMBLY = 5, ELPA_2STAGE_REAL_SSE_BLOCK2 = 6, ELPA_2STAGE_REAL_SSE_BLOCK4 = 7, ELPA_2STAGE_REAL_SSE_BLOCK6 = 8, ELPA_2STAGE_REAL_AVX_BLOCK2 = 9, ELPA_2STAGE_REAL_AVX_BLOCK4 = 10, ELPA_2STAGE_REAL_AVX_BLOCK6 = 11, ELPA_2STAGE_REAL_AVX2_BLOCK2 = 12, ELPA_2STAGE_REAL_AVX2_BLOCK4 = 13, ELPA_2STAGE_REAL_AVX2_BLOCK6 = 14, ELPA_2STAGE_REAL_AVX512_BLOCK2 = 15, ELPA_2STAGE_REAL_AVX512_BLOCK4 = 16, ELPA_2STAGE_REAL_AVX512_BLOCK6 = 17, ELPA_2STAGE_REAL_NVIDIA_GPU = 18, ELPA_2STAGE_REAL_AMD_GPU = 19, ELPA_2STAGE_REAL_INTEL_GPU_SYCL = 20, ELPA_2STAGE_REAL_SPARC64_BLOCK2 = 21, ELPA_2STAGE_REAL_SPARC64_BLOCK4 = 22, ELPA_2STAGE_REAL_SPARC64_BLOCK6 = 23, ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK2 = 24, ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK4 = 25, ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK6 = 26, ELPA_2STAGE_REAL_VSX_BLOCK2 = 27, ELPA_2STAGE_REAL_VSX_BLOCK4 = 28, ELPA_2STAGE_REAL_VSX_BLOCK6 = 29, ELPA_2STAGE_REAL_SVE128_BLOCK2 = 30, ELPA_2STAGE_REAL_SVE128_BLOCK4 = 31, ELPA_2STAGE_REAL_SVE128_BLOCK6 = 32, ELPA_2STAGE_REAL_SVE256_BLOCK2 = 33, ELPA_2STAGE_REAL_SVE256_BLOCK4 = 34, ELPA_2STAGE_REAL_SVE256_BLOCK6 = 35, ELPA_2STAGE_REAL_SVE512_BLOCK2 = 36, ELPA_2STAGE_REAL_SVE512_BLOCK4 = 37, ELPA_2STAGE_REAL_SVE512_BLOCK6 = 38, ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK4 = 39, ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK6 = 40, ELPA_2STAGE_REAL_NVIDIA_SM80_GPU = 41, ELPA_2STAGE_REAL_INVALID = -1, ELPA_2STAGE_REAL_DEFAULT = 1,
};
# 120 "./elpa/elpa_constants.h"
enum ELPA_COMPLEX_KERNELS {
        ELPA_2STAGE_COMPLEX_GENERIC = 1, ELPA_2STAGE_COMPLEX_GENERIC_SIMPLE = 2, ELPA_2STAGE_COMPLEX_BGP = 3, ELPA_2STAGE_COMPLEX_BGQ = 4, ELPA_2STAGE_COMPLEX_SSE_ASSEMBLY = 5, ELPA_2STAGE_COMPLEX_SSE_BLOCK1 = 6, ELPA_2STAGE_COMPLEX_SSE_BLOCK2 = 7, ELPA_2STAGE_COMPLEX_AVX_BLOCK1 = 8, ELPA_2STAGE_COMPLEX_AVX_BLOCK2 = 9, ELPA_2STAGE_COMPLEX_AVX2_BLOCK1 = 10, ELPA_2STAGE_COMPLEX_AVX2_BLOCK2 = 11, ELPA_2STAGE_COMPLEX_AVX512_BLOCK1 = 12, ELPA_2STAGE_COMPLEX_AVX512_BLOCK2 = 13, ELPA_2STAGE_COMPLEX_SVE128_BLOCK1 = 14, ELPA_2STAGE_COMPLEX_SVE128_BLOCK2 = 15, ELPA_2STAGE_COMPLEX_SVE256_BLOCK1 = 16, ELPA_2STAGE_COMPLEX_SVE256_BLOCK2 = 17, ELPA_2STAGE_COMPLEX_SVE512_BLOCK1 = 18, ELPA_2STAGE_COMPLEX_SVE512_BLOCK2 = 19, ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK1 = 20, ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK2 = 21, ELPA_2STAGE_COMPLEX_NVIDIA_GPU = 22, ELPA_2STAGE_COMPLEX_AMD_GPU = 23, ELPA_2STAGE_COMPLEX_INTEL_GPU_SYCL = 24, ELPA_2STAGE_COMPLEX_NVIDIA_SM80_GPU = 25, ELPA_2STAGE_COMPLEX_INVALID = -1, ELPA_2STAGE_COMPLEX_DEFAULT = 1,
};
# 144 "./elpa/elpa_constants.h"
enum ELPA_ERRORS {
        ELPA_OK = 0, ELPA_ERROR = -1, ELPA_ERROR_ENTRY_NOT_FOUND = -2, ELPA_ERROR_ENTRY_INVALID_VALUE = -3, ELPA_ERROR_ENTRY_ALREADY_SET = -4, ELPA_ERROR_ENTRY_NO_STRING_REPRESENTATION = -5, ELPA_ERROR_SETUP = -6, ELPA_ERROR_CRITICAL = -7, ELPA_ERROR_API_VERSION = -8, ELPA_ERROR_AUTOTUNE_API_VERSION = -9, ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED = -10, ELPA_ERROR_ENTRY_READONLY = -11, ELPA_ERROR_CANNOT_OPEN_FILE = -12, ELPA_ERROR_DURING_COMPUTATION = -13,
};

enum ELPA_CONSTANTS {
        ELPA_2STAGE_NUMBER_OF_COMPLEX_KERNELS = (0 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1),
        ELPA_2STAGE_NUMBER_OF_REAL_KERNELS = (0 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1),
};
# 177 "./elpa/elpa_constants.h"
enum ELPA_AUTOTUNE_LEVELS {
        ELPA_AUTOTUNE_NOT_TUNABLE = 0, ELPA_AUTOTUNE_GPU = 1, ELPA2_AUTOTUNE_KERNEL = 2, ELPA_AUTOTUNE_OPENMP = 3, ELPA_AUTOTUNE_TRANSPOSE_VECTORS = 4, ELPA2_AUTOTUNE_FULL_TO_BAND = 5, ELPA2_AUTOTUNE_BAND_TO_TRIDI = 6, ELPA_AUTOTUNE_SOLVE = 7, ELPA2_AUTOTUNE_TRIDI_TO_BAND = 8, ELPA2_AUTOTUNE_BAND_TO_FULL = 9, ELPA2_AUTOTUNE_MAIN = 10, ELPA1_AUTOTUNE_FULL_TO_TRIDI = 11, ELPA1_AUTOTUNE_TRIDI_TO_FULL = 12, ELPA_AUTOTUNE_MPI = 13, ELPA_AUTOTUNE_FAST = 14, ELPA_AUTOTUNE_MEDIUM = 15, ELPA2_AUTOTUNE_BAND_TO_FULL_BLOCKING = 16, ELPA1_AUTOTUNE_MAX_STORED_ROWS = 17, ELPA2_AUTOTUNE_TRIDI_TO_BAND_STRIPEWIDTH = 18, ELPA_AUTOTUNE_EXTENSIVE = 19,
};
# 188 "./elpa/elpa_constants.h"
enum ELPA_AUTOTUNE_DOMAINS {
        ELPA_AUTOTUNE_DOMAIN_REAL = 1, ELPA_AUTOTUNE_DOMAIN_COMPLEX = 2, ELPA_AUTOTUNE_DOMAIN_ANY = 3,
};
# 200 "./elpa/elpa_constants.h"
enum ELPA_AUTOTUNE_PARTS {
        ELPA_AUTOTUNE_PART_NONE = 0, ELPA_AUTOTUNE_PART_ANY = 1, ELPA_AUTOTUNE_PART_GENERALIZED = 2, ELPA_AUTOTUNE_PART_ELPA1 = 3, ELPA_AUTOTUNE_PART_ELPA2 = 4,
};
# 17 "../elpa/elpa.h" 2
# 1 "./elpa/elpa_generated_c_api.h" 1
# 18 "../elpa/elpa.h" 2
# 1 "./elpa/elpa_generated.h" 1
# 26 "./elpa/elpa_generated.h"
 void elpa_load_settings(elpa_t handle, const char *filename, int *error);





 void elpa_print_settings(elpa_t handle, int *error);





 void elpa_store_settings(elpa_t handle, const char *filename, int *error);
# 50 "./elpa/elpa_generated.h"
 int elpa_setup(elpa_t handle);
# 60 "./elpa/elpa_generated.h"
 void elpa_set_integer(elpa_t handle, const char *name, int value, int *error);
# 70 "./elpa/elpa_generated.h"
 void elpa_get_integer(elpa_t handle, const char *name, int *value, int *error);
# 80 "./elpa/elpa_generated.h"
 void elpa_set_float(elpa_t handle, const char *name, float value, int *error);
# 90 "./elpa/elpa_generated.h"
 void elpa_get_float(elpa_t handle, const char *name, float *value, int *error);
# 100 "./elpa/elpa_generated.h"
 void elpa_set_double(elpa_t handle, const char *name, double value, int *error);
# 110 "./elpa/elpa_generated.h"
 void elpa_get_double(elpa_t handle, const char *name, double *value, int *error);





 void elpa_autotune_set_api_version(elpa_t handle, int api_version, int *error);







 elpa_autotune_t elpa_autotune_setup(elpa_t handle, int level, int domain, int *error);







 int elpa_autotune_step(elpa_t handle, elpa_autotune_t autotune_handle, int *error);







 void elpa_autotune_print_state(elpa_t handle, elpa_autotune_t autotune_handle, int *error);







 void elpa_autotune_save_state(elpa_t handle, elpa_autotune_t autotune_handle, const char *filename, int *error);







 void elpa_autotune_load_state(elpa_t handle, elpa_autotune_t autotune_handle, const char *filename, int *error);







 void elpa_autotune_set_best(elpa_t handle, elpa_autotune_t autotune_handle, int *error);







 void elpa_autotune_print_best(elpa_t handle, elpa_autotune_t autotune_handle, int *error);

 void elpa_hermitian_multiply_a_h_a_d(elpa_t handle, char uplo_a, char uplo_c, int ncb, double *a, double *b, int nrows_b, int ncols_b, double *c, int nrows_c, int ncols_c, int *error);
 void elpa_hermitian_multiply_a_h_a_f(elpa_t handle, char uplo_a, char uplo_c, int ncb, float *a, float *b, int nrows_b, int ncols_b, float *c, int nrows_c, int ncols_c, int *error);
 void elpa_hermitian_multiply_a_h_a_dc(elpa_t handle, char uplo_a, char uplo_c, int ncb, double _Complex *a, double _Complex *b, int nrows_b, int ncols_b, double _Complex *c, int nrows_c, int ncols_c, int *error);
 void elpa_hermitian_multiply_a_h_a_fc(elpa_t handle, char uplo_a, char uplo_c, int ncb, float _Complex *a, float _Complex *b, int nrows_b, int ncols_b, float _Complex *c, int nrows_c, int ncols_c, int *error);
 void elpa_hermitian_multiply_d_ptr_d(elpa_t handle, char uplo_a, char uplo_c, int ncb, double *a, double *b, int nrows_b, int ncols_b, double *c, int nrows_c, int ncols_c, int *error);
 void elpa_hermitian_multiply_d_ptr_f(elpa_t handle, char uplo_a, char uplo_c, int ncb, float *a, float *b, int nrows_b, int ncols_b, float *c, int nrows_c, int ncols_c, int *error);
 void elpa_hermitian_multiply_d_ptr_dc(elpa_t handle, char uplo_a, char uplo_c, int ncb, double _Complex *a, double _Complex *b, int nrows_b, int ncols_b, double _Complex *c, int nrows_c, int ncols_c, int *error);
 void elpa_hermitian_multiply_d_ptr_fc(elpa_t handle, char uplo_a, char uplo_c, int ncb, float _Complex *a, float _Complex *b, int nrows_b, int ncols_b, float _Complex *c, int nrows_c, int ncols_c, int *error);
 void elpa_cholesky_a_h_a_d(elpa_t handle, double *a, int *error);
 void elpa_cholesky_a_h_a_f(elpa_t handle, float *a, int *error);
 void elpa_cholesky_a_h_a_dc(elpa_t handle, double _Complex *a, int *error);
 void elpa_cholesky_a_h_a_fc(elpa_t handle, float _Complex *a, int *error);
 void elpa_cholesky_d_ptr_d(elpa_t handle, double *a, int *error);
 void elpa_cholesky_d_ptr_f(elpa_t handle, float *a, int *error);
 void elpa_cholesky_d_ptr_dc(elpa_t handle, double _Complex *a, int *error);
 void elpa_cholesky_d_ptr_fc(elpa_t handle, float _Complex *a, int *error);
 void elpa_invert_trm_a_h_a_d(elpa_t handle, double *a, int *error);
 void elpa_invert_trm_a_h_a_f(elpa_t handle, float *a, int *error);
 void elpa_invert_trm_a_h_a_dc(elpa_t handle, double _Complex *a, int *error);
 void elpa_invert_trm_a_h_a_fc(elpa_t handle, float _Complex *a, int *error);
 void elpa_invert_trm_d_ptr_d(elpa_t handle, double *a, int *error);
 void elpa_invert_trm_d_ptr_f(elpa_t handle, float *a, int *error);
 void elpa_invert_trm_d_ptr_dc(elpa_t handle, double _Complex *a, int *error);
 void elpa_invert_trm_d_ptr_fc(elpa_t handle, float _Complex *a, int *error);
 void elpa_solve_tridiagonal_d(elpa_t handle, double *d, double *e, double *q, int *error);
 void elpa_solve_tridiagonal_f(elpa_t handle, float *d, float *e, float *q, int *error);

 void elpa_eigenvectors_a_h_a_d(elpa_t handle, double *a, double *ev, double *q, int *error);
 void elpa_eigenvectors_a_h_a_f(elpa_t handle, float *a, float *ev, float *q, int *error);
 void elpa_eigenvectors_a_h_a_dc(elpa_t handle, double _Complex *a, double *ev, double _Complex *q, int *error);
 void elpa_eigenvectors_a_h_a_fc(elpa_t handle, float _Complex *a, float *ev, float _Complex *q, int *error);
 void elpa_eigenvectors_d_ptr_d(elpa_t handle, double *a, double *ev, double *q, int *error);
 void elpa_eigenvectors_d_ptr_f(elpa_t handle, float *a, float *ev, float *q, int *error);
 void elpa_eigenvectors_d_ptr_dc(elpa_t handle, double _Complex *a, double *ev, double _Complex *q, int *error);
 void elpa_eigenvectors_d_ptr_fc(elpa_t handle, float _Complex *a, float *ev, float _Complex *q, int *error);
 void elpa_skew_eigenvectors_a_h_a_d(elpa_t handle, double *a, double *ev, double *q, int *error);
 void elpa_skew_eigenvectors_a_h_a_f(elpa_t handle, float *a, float *ev, float *q, int *error);
 void elpa_skew_eigenvectors_d_ptr_d(elpa_t handle, double *a, double *ev, double *q, int *error);
 void elpa_skew_eigenvectors_d_ptr_f(elpa_t handle, float *a, float *ev, float *q, int *error);
 void elpa_eigenvalues_a_h_a_d(elpa_t handle, double *a, double *ev, int *error);
 void elpa_eigenvalues_a_h_a_f(elpa_t handle, float *a, float *ev, int *error);
 void elpa_eigenvalues_a_h_a_dc(elpa_t handle, double _Complex *a, double *ev, int *error);
 void elpa_eigenvalues_a_h_a_fc(elpa_t handle, float _Complex *a, float *ev, int *error);
 void elpa_eigenvalues_d_ptr_d(elpa_t handle, double *a, double *ev, int *error);
 void elpa_eigenvalues_d_ptr_f(elpa_t handle, float *a, float *ev, int *error);
 void elpa_eigenvalues_d_ptr_dc(elpa_t handle, double _Complex *a, double *ev, int *error);
 void elpa_eigenvalues_d_ptr_fc(elpa_t handle, float _Complex *a, float *ev, int *error);
 void elpa_skew_eigenvalues_a_h_a_d(elpa_t handle, double *a, double *ev, int *error);
 void elpa_skew_eigenvalues_a_h_a_f(elpa_t handle, float *a, float *ev, int *error);
 void elpa_skew_eigenvalues_d_ptr_d(elpa_t handle, double *a, double *ev, int *error);
 void elpa_skew_eigenvalues_d_ptr_f(elpa_t handle, float *a, float *ev, int *error);

 void elpa_generalized_eigenvectors_d(elpa_t handle, double *a, double *b, double *ev, double *q,
 int is_already_decomposed, int *error);
 void elpa_generalized_eigenvectors_f(elpa_t handle, float *a, float *b, float *ev, float *q,
 int is_already_decomposed, int *error);
 void elpa_generalized_eigenvectors_dc(elpa_t handle, double _Complex *a, double _Complex *b, double *ev, double _Complex *q,
 int is_already_decomposed, int *error);
 void elpa_generalized_eigenvectors_fc(elpa_t handle, float _Complex *a, float _Complex *b, float *ev, float _Complex *q,
 int is_already_decomposed, int *error);
 void elpa_generalized_eigenvalues_d(elpa_t handle, double *a, double *b, double *ev,
 int is_already_decomposed, int *error);
 void elpa_generalized_eigenvalues_f(elpa_t handle, float *a, float *b, float *ev,
 int is_already_decomposed, int *error);
 void elpa_generalized_eigenvalues_dc(elpa_t handle, double _Complex *a, double _Complex *b, double *ev,
 int is_already_decomposed, int *error);
 void elpa_generalized_eigenvalues_fc(elpa_t handle, float _Complex *a, float _Complex *b, float *ev,
 int is_already_decomposed, int *error);

 int elpa_init(int api_version);
# 280 "./elpa/elpa_generated.h"
 elpa_t elpa_allocate(int *error);


 void elpa_deallocate(elpa_t handle, int *error);


 void elpa_autotune_deallocate(elpa_autotune_t handle, int *error);



 void elpa_uninit(int *error);
# 19 "../elpa/elpa.h" 2
# 1 "../elpa/elpa_generic.h" 1
# 20 "../elpa/elpa.h" 2
# 1 "../elpa/elpa_explicit_name.h" 1
# 49 "../elpa/elpa_explicit_name.h"
# 1 "../elpa/elpa.h" 1
# 50 "../elpa/elpa_explicit_name.h" 2
# 1 "./elpa/elpa_configured_options.h" 1
# 51 "../elpa/elpa_explicit_name.h" 2
# 65 "../elpa/elpa_explicit_name.h"
void elpa_eigenvectors_double(elpa_t handle, double *a, double *ev, double *q, int *error);
void elpa_eigenvectors_float(elpa_t handle, float *a, float *ev, float *q, int *error);
void elpa_eigenvectors_double_complex(elpa_t handle, double _Complex *a, double *ev, double _Complex *q, int *error);
void elpa_eigenvectors_float_complex(elpa_t handle, float _Complex *a, float *ev, float _Complex *q, int *error);

void elpa_skew_eigenvectors_double(elpa_t handle, double *a, double *ev, double *q, int *error);
void elpa_skew_eigenvectors_float(elpa_t handle, float *a, float *ev, float *q, int *error);

void elpa_skew_eigenvectors_double(elpa_t handle, double *a, double *ev, double *q, int *error);
void elpa_skew_eigenvectors_float(elpa_t handle, float *a, float *ev, float *q, int *error);

void elpa_eigenvalues_double(elpa_t handle, double *a, double *ev, int *error);
void elpa_eigenvalues_float(elpa_t handle, float *a, float *ev, int *error);
void elpa_eigenvalues_double_complex(elpa_t handle, double _Complex *a, double *ev, int *error);
void elpa_eigenvalues_float_complex(elpa_t handle, float _Complex *a, float *ev, int *error);

void elpa_skew_eigenvalues_double(elpa_t handle, double *a, double *ev, int *error);
void elpa_skew_eigenvalues_float(elpa_t handle, float *a, float *ev, int *error);

void elpa_skew_eigenvalues_double(elpa_t handle, double *a, double *ev, int *error);
void elpa_skew_eigenvalues_float(elpa_t handle, float *a, float *ev, int *error);

void elpa_cholesky_double(elpa_t handle, double *a, int *error);
void elpa_cholesky_float(elpa_t handle, float *a, int *error);
void elpa_cholesky_double_complex(elpa_t handle, double _Complex *a, int *error);
void elpa_cholesky_float_complex(elpa_t handle, float _Complex *a, int *error);

void elpa_hermitian_multiply_double(elpa_t handle, char uplo_a, char uplo_c, int ncb, double *a, double *b, int nrows_b, int ncols_b, double *c, int nrows_c, int ncols_c, int *error);
void elpa_hermitian_multiply_float(elpa_t handle, char uplo_a, char uplo_c, int ncb, float *a, float *b, int nrows_b, int ncols_b, float *c, int nrows_c, int ncols_c, int *error);
void elpa_hermitian_multiply_double_complex(elpa_t handle, char uplo_a, char uplo_c, int ncb, double _Complex *a, double _Complex *b, int nrows_b, int ncols_b, double _Complex *c, int nrows_c, int ncols_c, int *error);
void elpa_hermitian_multiply_float_complex(elpa_t handle, char uplo_a, char uplo_c, int ncb, float _Complex *a, float _Complex *b, int nrows_b, int ncols_b, float _Complex *c, int nrows_c, int ncols_c, int *error);

void elpa_invert_triangular_double(elpa_t handle, double *a, int *error);
void elpa_invert_triangular_float(elpa_t handle, float *a, int *error);
void elpa_invert_triangular_double_complex(elpa_t handle, double _Complex *a, int *error);
void elpa_invert_triangular_float_complex(elpa_t handle, float _Complex *a, int *error);
# 21 "../elpa/elpa.h" 2




const char *elpa_strerr(int elpa_error);
# 52 "../src/elpa_index.c" 2
# 1 "../src/elpa_index.h" 1
# 53 "../src/elpa_index.h"
# 1 "/usr/include/string.h" 1 3 4
# 32 "/usr/include/string.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 1 3 4
# 33 "/usr/include/string.h" 2 3 4
# 42 "/usr/include/string.h" 3 4
extern void *memcpy (void *__restrict __dest, const void *__restrict __src,
       size_t __n) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern void *memmove (void *__dest, const void *__src, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));






extern void *memccpy (void *__restrict __dest, const void *__restrict __src,
        int __c, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));





extern void *memset (void *__s, int __c, size_t __n) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int memcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 92 "/usr/include/string.h" 3 4
extern void *memchr (const void *__s, int __c, size_t __n)
      __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 125 "/usr/include/string.h" 3 4
extern char *strcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));

extern char *strncpy (char *__restrict __dest,
        const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern char *strcat (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));

extern char *strncat (char *__restrict __dest, const char *__restrict __src,
        size_t __n) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int strcmp (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));

extern int strncmp (const char *__s1, const char *__s2, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern int strcoll (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));

extern size_t strxfrm (char *__restrict __dest,
         const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));






# 1 "/usr/include/xlocale.h" 1 3 4
# 27 "/usr/include/xlocale.h" 3 4
typedef struct __locale_struct
{

  struct __locale_data *__locales[13];


  const unsigned short int *__ctype_b;
  const int *__ctype_tolower;
  const int *__ctype_toupper;


  const char *__names[13];
} *__locale_t;


typedef __locale_t locale_t;
# 160 "/usr/include/string.h" 2 3 4


extern int strcoll_l (const char *__s1, const char *__s2, __locale_t __l)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2, 3)));

extern size_t strxfrm_l (char *__dest, const char *__src, size_t __n,
    __locale_t __l) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2, 4)));





extern char *strdup (const char *__s)
     __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));






extern char *strndup (const char *__string, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));
# 232 "/usr/include/string.h" 3 4
extern char *strchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 259 "/usr/include/string.h" 3 4
extern char *strrchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 281 "/usr/include/string.h" 3 4
extern size_t strcspn (const char *__s, const char *__reject)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern size_t strspn (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 311 "/usr/include/string.h" 3 4
extern char *strpbrk (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 338 "/usr/include/string.h" 3 4
extern char *strstr (const char *__haystack, const char *__needle)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));




extern char *strtok (char *__restrict __s, const char *__restrict __delim)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));




extern char *__strtok_r (char *__restrict __s,
    const char *__restrict __delim,
    char **__restrict __save_ptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2, 3)));

extern char *strtok_r (char *__restrict __s, const char *__restrict __delim,
         char **__restrict __save_ptr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2, 3)));
# 395 "/usr/include/string.h" 3 4
extern size_t strlen (const char *__s)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));





extern size_t strnlen (const char *__string, size_t __maxlen)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));





extern char *strerror (int __errnum) __attribute__ ((__nothrow__ ));
# 423 "/usr/include/string.h" 3 4
extern int strerror_r (int __errnum, char *__buf, size_t __buflen) __asm__ ("" "__xpg_strerror_r") __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));
# 441 "/usr/include/string.h" 3 4
extern char *strerror_l (int __errnum, __locale_t __l) __attribute__ ((__nothrow__ ));





extern void __bzero (void *__s, size_t __n) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));



extern void bcopy (const void *__src, void *__dest, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern void bzero (void *__s, size_t __n) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int bcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 485 "/usr/include/string.h" 3 4
extern char *index (const char *__s, int __c)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 513 "/usr/include/string.h" 3 4
extern char *rindex (const char *__s, int __c)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));




extern int ffs (int __i) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));
# 532 "/usr/include/string.h" 3 4
extern int strcasecmp (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern int strncasecmp (const char *__s1, const char *__s2, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 555 "/usr/include/string.h" 3 4
extern char *strsep (char **__restrict __stringp,
       const char *__restrict __delim)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));




extern char *strsignal (int __sig) __attribute__ ((__nothrow__ ));


extern char *__stpcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));



extern char *__stpncpy (char *__restrict __dest,
   const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpncpy (char *__restrict __dest,
        const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));
# 630 "/usr/include/string.h" 3 4
# 1 "/usr/include/bits/string.h" 1 3 4
# 631 "/usr/include/string.h" 2 3 4


# 1 "/usr/include/bits/string2.h" 1 3 4
# 393 "/usr/include/bits/string2.h" 3 4
extern void *__rawmemchr (const void *__s, int __c);
# 968 "/usr/include/bits/string2.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) size_t __strcspn_c1 (const char *__s, int __reject);
extern __inline __attribute__ ((__gnu_inline__)) size_t
__strcspn_c1 (const char *__s, int __reject)
{
  size_t __result = 0;
  while (__s[__result] != '\0' && __s[__result] != __reject)
    ++__result;
  return __result;
}

extern __inline __attribute__ ((__gnu_inline__)) size_t __strcspn_c2 (const char *__s, int __reject1,
         int __reject2);
extern __inline __attribute__ ((__gnu_inline__)) size_t
__strcspn_c2 (const char *__s, int __reject1, int __reject2)
{
  size_t __result = 0;
  while (__s[__result] != '\0' && __s[__result] != __reject1
  && __s[__result] != __reject2)
    ++__result;
  return __result;
}

extern __inline __attribute__ ((__gnu_inline__)) size_t __strcspn_c3 (const char *__s, int __reject1,
         int __reject2, int __reject3);
extern __inline __attribute__ ((__gnu_inline__)) size_t
__strcspn_c3 (const char *__s, int __reject1, int __reject2,
       int __reject3)
{
  size_t __result = 0;
  while (__s[__result] != '\0' && __s[__result] != __reject1
  && __s[__result] != __reject2 && __s[__result] != __reject3)
    ++__result;
  return __result;
}
# 1044 "/usr/include/bits/string2.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) size_t __strspn_c1 (const char *__s, int __accept);
extern __inline __attribute__ ((__gnu_inline__)) size_t
__strspn_c1 (const char *__s, int __accept)
{
  size_t __result = 0;

  while (__s[__result] == __accept)
    ++__result;
  return __result;
}

extern __inline __attribute__ ((__gnu_inline__)) size_t __strspn_c2 (const char *__s, int __accept1,
        int __accept2);
extern __inline __attribute__ ((__gnu_inline__)) size_t
__strspn_c2 (const char *__s, int __accept1, int __accept2)
{
  size_t __result = 0;

  while (__s[__result] == __accept1 || __s[__result] == __accept2)
    ++__result;
  return __result;
}

extern __inline __attribute__ ((__gnu_inline__)) size_t __strspn_c3 (const char *__s, int __accept1,
        int __accept2, int __accept3);
extern __inline __attribute__ ((__gnu_inline__)) size_t
__strspn_c3 (const char *__s, int __accept1, int __accept2, int __accept3)
{
  size_t __result = 0;

  while (__s[__result] == __accept1 || __s[__result] == __accept2
  || __s[__result] == __accept3)
    ++__result;
  return __result;
}
# 1120 "/usr/include/bits/string2.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) char *__strpbrk_c2 (const char *__s, int __accept1,
        int __accept2);
extern __inline __attribute__ ((__gnu_inline__)) char *
__strpbrk_c2 (const char *__s, int __accept1, int __accept2)
{

  while (*__s != '\0' && *__s != __accept1 && *__s != __accept2)
    ++__s;
  return *__s == '\0' ? ((void*)0) : (char *) (size_t) __s;
}

extern __inline __attribute__ ((__gnu_inline__)) char *__strpbrk_c3 (const char *__s, int __accept1,
        int __accept2, int __accept3);
extern __inline __attribute__ ((__gnu_inline__)) char *
__strpbrk_c3 (const char *__s, int __accept1, int __accept2, int __accept3)
{

  while (*__s != '\0' && *__s != __accept1 && *__s != __accept2
  && *__s != __accept3)
    ++__s;
  return *__s == '\0' ? ((void*)0) : (char *) (size_t) __s;
}
# 1170 "/usr/include/bits/string2.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) char *__strtok_r_1c (char *__s, char __sep, char **__nextp);
extern __inline __attribute__ ((__gnu_inline__)) char *
__strtok_r_1c (char *__s, char __sep, char **__nextp)
{
  char *__result;
  if (__s == ((void*)0))
    __s = *__nextp;
  while (*__s == __sep)
    ++__s;
  __result = ((void*)0);
  if (*__s != '\0')
    {
      __result = __s++;
      while (*__s != '\0')
 if (*__s++ == __sep)
   {
     __s[-1] = '\0';
     break;
   }
    }
  *__nextp = __s;
  return __result;
}
# 1202 "/usr/include/bits/string2.h" 3 4
extern char *__strsep_g (char **__stringp, const char *__delim);
# 1220 "/usr/include/bits/string2.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) char *__strsep_1c (char **__s, char __reject);
extern __inline __attribute__ ((__gnu_inline__)) char *
__strsep_1c (char **__s, char __reject)
{
  char *__retval = *__s;
  if (__retval != ((void*)0) && (*__s = (__extension__ (__builtin_constant_p (__reject) && !__builtin_constant_p (__retval) && (__reject) == '\0' ? (char *) __rawmemchr (__retval, __reject) : __builtin_strchr (__retval, __reject)))) != ((void*)0))
    *(*__s)++ = '\0';
  return __retval;
}

extern __inline __attribute__ ((__gnu_inline__)) char *__strsep_2c (char **__s, char __reject1, char __reject2);
extern __inline __attribute__ ((__gnu_inline__)) char *
__strsep_2c (char **__s, char __reject1, char __reject2)
{
  char *__retval = *__s;
  if (__retval != ((void*)0))
    {
      char *__cp = __retval;
      while (1)
 {
   if (*__cp == '\0')
     {
       __cp = ((void*)0);
   break;
     }
   if (*__cp == __reject1 || *__cp == __reject2)
     {
       *__cp++ = '\0';
       break;
     }
   ++__cp;
 }
      *__s = __cp;
    }
  return __retval;
}

extern __inline __attribute__ ((__gnu_inline__)) char *__strsep_3c (char **__s, char __reject1, char __reject2,
       char __reject3);
extern __inline __attribute__ ((__gnu_inline__)) char *
__strsep_3c (char **__s, char __reject1, char __reject2, char __reject3)
{
  char *__retval = *__s;
  if (__retval != ((void*)0))
    {
      char *__cp = __retval;
      while (1)
 {
   if (*__cp == '\0')
     {
       __cp = ((void*)0);
   break;
     }
   if (*__cp == __reject1 || *__cp == __reject2 || *__cp == __reject3)
     {
       *__cp++ = '\0';
       break;
     }
   ++__cp;
 }
      *__s = __cp;
    }
  return __retval;
}
# 1301 "/usr/include/bits/string2.h" 3 4
extern char *__strdup (const char *__string) __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__));
# 1320 "/usr/include/bits/string2.h" 3 4
extern char *__strndup (const char *__string, size_t __n)
     __attribute__ ((__nothrow__ )) __attribute__ ((__malloc__));
# 634 "/usr/include/string.h" 2 3 4
# 54 "../src/elpa_index.h" 2
# 1 "/usr/include/search.h" 1 3 4
# 25 "/usr/include/search.h" 3 4
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/lib/clang/16/include/stddef.h" 1 3 4
# 26 "/usr/include/search.h" 2 3 4
# 44 "/usr/include/search.h" 3 4
extern void insque (void *__elem, void *__prev) __attribute__ ((__nothrow__ ));


extern void remque (void *__elem) __attribute__ ((__nothrow__ ));
# 62 "/usr/include/search.h" 3 4
typedef enum
  {
    FIND,
    ENTER
  }
ACTION;

typedef struct entry
  {
    char *key;
    void *data;
  }
ENTRY;


struct _ENTRY;
# 87 "/usr/include/search.h" 3 4
extern ENTRY *hsearch (ENTRY __item, ACTION __action) __attribute__ ((__nothrow__ ));


extern int hcreate (size_t __nel) __attribute__ ((__nothrow__ ));


extern void hdestroy (void) __attribute__ ((__nothrow__ ));
# 118 "/usr/include/search.h" 3 4
typedef enum
{
  preorder,
  postorder,
  endorder,
  leaf
}
VISIT;



extern void *tsearch (const void *__key, void **__rootp,
        __compar_fn_t __compar);



extern void *tfind (const void *__key, void *const *__rootp,
      __compar_fn_t __compar);


extern void *tdelete (const void *__restrict __key,
        void **__restrict __rootp,
        __compar_fn_t __compar);



typedef void (*__action_fn_t) (const void *__nodep, VISIT __value,
          int __level);




extern void twalk (const void *__root, __action_fn_t __action);
# 164 "/usr/include/search.h" 3 4
extern void *lfind (const void *__key, const void *__base,
      size_t *__nmemb, size_t __size, __compar_fn_t __compar);



extern void *lsearch (const void *__key, void *__base,
        size_t *__nmemb, size_t __size, __compar_fn_t __compar);
# 55 "../src/elpa_index.h" 2
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 1 3
# 191 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
# 1 "/usr/include/math.h" 1 3 4
# 33 "/usr/include/math.h" 3 4
# 1 "/usr/include/bits/huge_val.h" 1 3 4
# 34 "/usr/include/math.h" 2 3 4

# 1 "/usr/include/bits/huge_valf.h" 1 3 4
# 36 "/usr/include/math.h" 2 3 4
# 1 "/usr/include/bits/huge_vall.h" 1 3 4
# 37 "/usr/include/math.h" 2 3 4


# 1 "/usr/include/bits/inf.h" 1 3 4
# 40 "/usr/include/math.h" 2 3 4


# 1 "/usr/include/bits/nan.h" 1 3 4
# 43 "/usr/include/math.h" 2 3 4



# 1 "/usr/include/bits/mathdef.h" 1 3 4
# 28 "/usr/include/bits/mathdef.h" 3 4
typedef float float_t;
typedef double double_t;
# 47 "/usr/include/math.h" 2 3 4
# 70 "/usr/include/math.h" 3 4
# 1 "/usr/include/bits/mathcalls.h" 1 3 4
# 54 "/usr/include/bits/mathcalls.h" 3 4
extern double acos (double __x) __attribute__ ((__nothrow__ )); extern double __acos (double __x) __attribute__ ((__nothrow__ ));

extern double asin (double __x) __attribute__ ((__nothrow__ )); extern double __asin (double __x) __attribute__ ((__nothrow__ ));

extern double atan (double __x) __attribute__ ((__nothrow__ )); extern double __atan (double __x) __attribute__ ((__nothrow__ ));

extern double atan2 (double __y, double __x) __attribute__ ((__nothrow__ )); extern double __atan2 (double __y, double __x) __attribute__ ((__nothrow__ ));


extern double cos (double __x) __attribute__ ((__nothrow__ )); extern double __cos (double __x) __attribute__ ((__nothrow__ ));

extern double sin (double __x) __attribute__ ((__nothrow__ )); extern double __sin (double __x) __attribute__ ((__nothrow__ ));

extern double tan (double __x) __attribute__ ((__nothrow__ )); extern double __tan (double __x) __attribute__ ((__nothrow__ ));




extern double cosh (double __x) __attribute__ ((__nothrow__ )); extern double __cosh (double __x) __attribute__ ((__nothrow__ ));

extern double sinh (double __x) __attribute__ ((__nothrow__ )); extern double __sinh (double __x) __attribute__ ((__nothrow__ ));

extern double tanh (double __x) __attribute__ ((__nothrow__ )); extern double __tanh (double __x) __attribute__ ((__nothrow__ ));
# 88 "/usr/include/bits/mathcalls.h" 3 4
extern double acosh (double __x) __attribute__ ((__nothrow__ )); extern double __acosh (double __x) __attribute__ ((__nothrow__ ));

extern double asinh (double __x) __attribute__ ((__nothrow__ )); extern double __asinh (double __x) __attribute__ ((__nothrow__ ));

extern double atanh (double __x) __attribute__ ((__nothrow__ )); extern double __atanh (double __x) __attribute__ ((__nothrow__ ));







extern double exp (double __x) __attribute__ ((__nothrow__ )); extern double __exp (double __x) __attribute__ ((__nothrow__ ));


extern double frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ )); extern double __frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ ));


extern double ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ )); extern double __ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ ));


extern double log (double __x) __attribute__ ((__nothrow__ )); extern double __log (double __x) __attribute__ ((__nothrow__ ));


extern double log10 (double __x) __attribute__ ((__nothrow__ )); extern double __log10 (double __x) __attribute__ ((__nothrow__ ));


extern double modf (double __x, double *__iptr) __attribute__ ((__nothrow__ )); extern double __modf (double __x, double *__iptr) __attribute__ ((__nothrow__ ))
     __attribute__ ((__nonnull__ (2)));
# 129 "/usr/include/bits/mathcalls.h" 3 4
extern double expm1 (double __x) __attribute__ ((__nothrow__ )); extern double __expm1 (double __x) __attribute__ ((__nothrow__ ));


extern double log1p (double __x) __attribute__ ((__nothrow__ )); extern double __log1p (double __x) __attribute__ ((__nothrow__ ));


extern double logb (double __x) __attribute__ ((__nothrow__ )); extern double __logb (double __x) __attribute__ ((__nothrow__ ));






extern double exp2 (double __x) __attribute__ ((__nothrow__ )); extern double __exp2 (double __x) __attribute__ ((__nothrow__ ));


extern double log2 (double __x) __attribute__ ((__nothrow__ )); extern double __log2 (double __x) __attribute__ ((__nothrow__ ));
# 154 "/usr/include/bits/mathcalls.h" 3 4
extern double pow (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __pow (double __x, double __y) __attribute__ ((__nothrow__ ));


extern double sqrt (double __x) __attribute__ ((__nothrow__ )); extern double __sqrt (double __x) __attribute__ ((__nothrow__ ));





extern double hypot (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __hypot (double __x, double __y) __attribute__ ((__nothrow__ ));






extern double cbrt (double __x) __attribute__ ((__nothrow__ )); extern double __cbrt (double __x) __attribute__ ((__nothrow__ ));
# 179 "/usr/include/bits/mathcalls.h" 3 4
extern double ceil (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __ceil (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double fabs (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __fabs (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double floor (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __floor (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double fmod (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __fmod (double __x, double __y) __attribute__ ((__nothrow__ ));




extern int __isinf (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int __finite (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));





extern int isinf (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int finite (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double drem (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __drem (double __x, double __y) __attribute__ ((__nothrow__ ));



extern double significand (double __x) __attribute__ ((__nothrow__ )); extern double __significand (double __x) __attribute__ ((__nothrow__ ));





extern double copysign (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __copysign (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));






extern double nan (const char *__tagb) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __nan (const char *__tagb) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));





extern int __isnan (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern int isnan (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double j0 (double) __attribute__ ((__nothrow__ )); extern double __j0 (double) __attribute__ ((__nothrow__ ));
extern double j1 (double) __attribute__ ((__nothrow__ )); extern double __j1 (double) __attribute__ ((__nothrow__ ));
extern double jn (int, double) __attribute__ ((__nothrow__ )); extern double __jn (int, double) __attribute__ ((__nothrow__ ));
extern double y0 (double) __attribute__ ((__nothrow__ )); extern double __y0 (double) __attribute__ ((__nothrow__ ));
extern double y1 (double) __attribute__ ((__nothrow__ )); extern double __y1 (double) __attribute__ ((__nothrow__ ));
extern double yn (int, double) __attribute__ ((__nothrow__ )); extern double __yn (int, double) __attribute__ ((__nothrow__ ));






extern double erf (double) __attribute__ ((__nothrow__ )); extern double __erf (double) __attribute__ ((__nothrow__ ));
extern double erfc (double) __attribute__ ((__nothrow__ )); extern double __erfc (double) __attribute__ ((__nothrow__ ));
extern double lgamma (double) __attribute__ ((__nothrow__ )); extern double __lgamma (double) __attribute__ ((__nothrow__ ));






extern double tgamma (double) __attribute__ ((__nothrow__ )); extern double __tgamma (double) __attribute__ ((__nothrow__ ));





extern double gamma (double) __attribute__ ((__nothrow__ )); extern double __gamma (double) __attribute__ ((__nothrow__ ));






extern double lgamma_r (double, int *__signgamp) __attribute__ ((__nothrow__ )); extern double __lgamma_r (double, int *__signgamp) __attribute__ ((__nothrow__ ));







extern double rint (double __x) __attribute__ ((__nothrow__ )); extern double __rint (double __x) __attribute__ ((__nothrow__ ));


extern double nextafter (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __nextafter (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));

extern double nexttoward (double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __nexttoward (double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern double remainder (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __remainder (double __x, double __y) __attribute__ ((__nothrow__ ));



extern double scalbn (double __x, int __n) __attribute__ ((__nothrow__ )); extern double __scalbn (double __x, int __n) __attribute__ ((__nothrow__ ));



extern int ilogb (double __x) __attribute__ ((__nothrow__ )); extern int __ilogb (double __x) __attribute__ ((__nothrow__ ));




extern double scalbln (double __x, long int __n) __attribute__ ((__nothrow__ )); extern double __scalbln (double __x, long int __n) __attribute__ ((__nothrow__ ));



extern double nearbyint (double __x) __attribute__ ((__nothrow__ )); extern double __nearbyint (double __x) __attribute__ ((__nothrow__ ));



extern double round (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __round (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern double trunc (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __trunc (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));




extern double remquo (double __x, double __y, int *__quo) __attribute__ ((__nothrow__ )); extern double __remquo (double __x, double __y, int *__quo) __attribute__ ((__nothrow__ ));






extern long int lrint (double __x) __attribute__ ((__nothrow__ )); extern long int __lrint (double __x) __attribute__ ((__nothrow__ ));
extern long long int llrint (double __x) __attribute__ ((__nothrow__ )); extern long long int __llrint (double __x) __attribute__ ((__nothrow__ ));



extern long int lround (double __x) __attribute__ ((__nothrow__ )); extern long int __lround (double __x) __attribute__ ((__nothrow__ ));
extern long long int llround (double __x) __attribute__ ((__nothrow__ )); extern long long int __llround (double __x) __attribute__ ((__nothrow__ ));



extern double fdim (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __fdim (double __x, double __y) __attribute__ ((__nothrow__ ));


extern double fmax (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __fmax (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double fmin (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __fmin (double __x, double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern int __fpclassify (double __value) __attribute__ ((__nothrow__ ))
     __attribute__ ((__const__));


extern int __signbit (double __value) __attribute__ ((__nothrow__ ))
     __attribute__ ((__const__));



extern double fma (double __x, double __y, double __z) __attribute__ ((__nothrow__ )); extern double __fma (double __x, double __y, double __z) __attribute__ ((__nothrow__ ));
# 364 "/usr/include/bits/mathcalls.h" 3 4
extern double scalb (double __x, double __n) __attribute__ ((__nothrow__ )); extern double __scalb (double __x, double __n) __attribute__ ((__nothrow__ ));
# 71 "/usr/include/math.h" 2 3 4
# 89 "/usr/include/math.h" 3 4
# 1 "/usr/include/bits/mathcalls.h" 1 3 4
# 54 "/usr/include/bits/mathcalls.h" 3 4
extern float acosf (float __x) __attribute__ ((__nothrow__ )); extern float __acosf (float __x) __attribute__ ((__nothrow__ ));

extern float asinf (float __x) __attribute__ ((__nothrow__ )); extern float __asinf (float __x) __attribute__ ((__nothrow__ ));

extern float atanf (float __x) __attribute__ ((__nothrow__ )); extern float __atanf (float __x) __attribute__ ((__nothrow__ ));

extern float atan2f (float __y, float __x) __attribute__ ((__nothrow__ )); extern float __atan2f (float __y, float __x) __attribute__ ((__nothrow__ ));


extern float cosf (float __x) __attribute__ ((__nothrow__ )); extern float __cosf (float __x) __attribute__ ((__nothrow__ ));

extern float sinf (float __x) __attribute__ ((__nothrow__ )); extern float __sinf (float __x) __attribute__ ((__nothrow__ ));

extern float tanf (float __x) __attribute__ ((__nothrow__ )); extern float __tanf (float __x) __attribute__ ((__nothrow__ ));




extern float coshf (float __x) __attribute__ ((__nothrow__ )); extern float __coshf (float __x) __attribute__ ((__nothrow__ ));

extern float sinhf (float __x) __attribute__ ((__nothrow__ )); extern float __sinhf (float __x) __attribute__ ((__nothrow__ ));

extern float tanhf (float __x) __attribute__ ((__nothrow__ )); extern float __tanhf (float __x) __attribute__ ((__nothrow__ ));
# 88 "/usr/include/bits/mathcalls.h" 3 4
extern float acoshf (float __x) __attribute__ ((__nothrow__ )); extern float __acoshf (float __x) __attribute__ ((__nothrow__ ));

extern float asinhf (float __x) __attribute__ ((__nothrow__ )); extern float __asinhf (float __x) __attribute__ ((__nothrow__ ));

extern float atanhf (float __x) __attribute__ ((__nothrow__ )); extern float __atanhf (float __x) __attribute__ ((__nothrow__ ));







extern float expf (float __x) __attribute__ ((__nothrow__ )); extern float __expf (float __x) __attribute__ ((__nothrow__ ));


extern float frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__ )); extern float __frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__ ));


extern float ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__ )); extern float __ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__ ));


extern float logf (float __x) __attribute__ ((__nothrow__ )); extern float __logf (float __x) __attribute__ ((__nothrow__ ));


extern float log10f (float __x) __attribute__ ((__nothrow__ )); extern float __log10f (float __x) __attribute__ ((__nothrow__ ));


extern float modff (float __x, float *__iptr) __attribute__ ((__nothrow__ )); extern float __modff (float __x, float *__iptr) __attribute__ ((__nothrow__ ))
     __attribute__ ((__nonnull__ (2)));
# 129 "/usr/include/bits/mathcalls.h" 3 4
extern float expm1f (float __x) __attribute__ ((__nothrow__ )); extern float __expm1f (float __x) __attribute__ ((__nothrow__ ));


extern float log1pf (float __x) __attribute__ ((__nothrow__ )); extern float __log1pf (float __x) __attribute__ ((__nothrow__ ));


extern float logbf (float __x) __attribute__ ((__nothrow__ )); extern float __logbf (float __x) __attribute__ ((__nothrow__ ));






extern float exp2f (float __x) __attribute__ ((__nothrow__ )); extern float __exp2f (float __x) __attribute__ ((__nothrow__ ));


extern float log2f (float __x) __attribute__ ((__nothrow__ )); extern float __log2f (float __x) __attribute__ ((__nothrow__ ));
# 154 "/usr/include/bits/mathcalls.h" 3 4
extern float powf (float __x, float __y) __attribute__ ((__nothrow__ )); extern float __powf (float __x, float __y) __attribute__ ((__nothrow__ ));


extern float sqrtf (float __x) __attribute__ ((__nothrow__ )); extern float __sqrtf (float __x) __attribute__ ((__nothrow__ ));





extern float hypotf (float __x, float __y) __attribute__ ((__nothrow__ )); extern float __hypotf (float __x, float __y) __attribute__ ((__nothrow__ ));






extern float cbrtf (float __x) __attribute__ ((__nothrow__ )); extern float __cbrtf (float __x) __attribute__ ((__nothrow__ ));
# 179 "/usr/include/bits/mathcalls.h" 3 4
extern float ceilf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __ceilf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern float fabsf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __fabsf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern float floorf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __floorf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern float fmodf (float __x, float __y) __attribute__ ((__nothrow__ )); extern float __fmodf (float __x, float __y) __attribute__ ((__nothrow__ ));




extern int __isinff (float __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int __finitef (float __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));





extern int isinff (float __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int finitef (float __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern float dremf (float __x, float __y) __attribute__ ((__nothrow__ )); extern float __dremf (float __x, float __y) __attribute__ ((__nothrow__ ));



extern float significandf (float __x) __attribute__ ((__nothrow__ )); extern float __significandf (float __x) __attribute__ ((__nothrow__ ));





extern float copysignf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __copysignf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));






extern float nanf (const char *__tagb) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __nanf (const char *__tagb) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));





extern int __isnanf (float __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern int isnanf (float __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern float j0f (float) __attribute__ ((__nothrow__ )); extern float __j0f (float) __attribute__ ((__nothrow__ ));
extern float j1f (float) __attribute__ ((__nothrow__ )); extern float __j1f (float) __attribute__ ((__nothrow__ ));
extern float jnf (int, float) __attribute__ ((__nothrow__ )); extern float __jnf (int, float) __attribute__ ((__nothrow__ ));
extern float y0f (float) __attribute__ ((__nothrow__ )); extern float __y0f (float) __attribute__ ((__nothrow__ ));
extern float y1f (float) __attribute__ ((__nothrow__ )); extern float __y1f (float) __attribute__ ((__nothrow__ ));
extern float ynf (int, float) __attribute__ ((__nothrow__ )); extern float __ynf (int, float) __attribute__ ((__nothrow__ ));






extern float erff (float) __attribute__ ((__nothrow__ )); extern float __erff (float) __attribute__ ((__nothrow__ ));
extern float erfcf (float) __attribute__ ((__nothrow__ )); extern float __erfcf (float) __attribute__ ((__nothrow__ ));
extern float lgammaf (float) __attribute__ ((__nothrow__ )); extern float __lgammaf (float) __attribute__ ((__nothrow__ ));






extern float tgammaf (float) __attribute__ ((__nothrow__ )); extern float __tgammaf (float) __attribute__ ((__nothrow__ ));





extern float gammaf (float) __attribute__ ((__nothrow__ )); extern float __gammaf (float) __attribute__ ((__nothrow__ ));






extern float lgammaf_r (float, int *__signgamp) __attribute__ ((__nothrow__ )); extern float __lgammaf_r (float, int *__signgamp) __attribute__ ((__nothrow__ ));







extern float rintf (float __x) __attribute__ ((__nothrow__ )); extern float __rintf (float __x) __attribute__ ((__nothrow__ ));


extern float nextafterf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __nextafterf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));

extern float nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern float remainderf (float __x, float __y) __attribute__ ((__nothrow__ )); extern float __remainderf (float __x, float __y) __attribute__ ((__nothrow__ ));



extern float scalbnf (float __x, int __n) __attribute__ ((__nothrow__ )); extern float __scalbnf (float __x, int __n) __attribute__ ((__nothrow__ ));



extern int ilogbf (float __x) __attribute__ ((__nothrow__ )); extern int __ilogbf (float __x) __attribute__ ((__nothrow__ ));




extern float scalblnf (float __x, long int __n) __attribute__ ((__nothrow__ )); extern float __scalblnf (float __x, long int __n) __attribute__ ((__nothrow__ ));



extern float nearbyintf (float __x) __attribute__ ((__nothrow__ )); extern float __nearbyintf (float __x) __attribute__ ((__nothrow__ ));



extern float roundf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __roundf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern float truncf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __truncf (float __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));




extern float remquof (float __x, float __y, int *__quo) __attribute__ ((__nothrow__ )); extern float __remquof (float __x, float __y, int *__quo) __attribute__ ((__nothrow__ ));






extern long int lrintf (float __x) __attribute__ ((__nothrow__ )); extern long int __lrintf (float __x) __attribute__ ((__nothrow__ ));
extern long long int llrintf (float __x) __attribute__ ((__nothrow__ )); extern long long int __llrintf (float __x) __attribute__ ((__nothrow__ ));



extern long int lroundf (float __x) __attribute__ ((__nothrow__ )); extern long int __lroundf (float __x) __attribute__ ((__nothrow__ ));
extern long long int llroundf (float __x) __attribute__ ((__nothrow__ )); extern long long int __llroundf (float __x) __attribute__ ((__nothrow__ ));



extern float fdimf (float __x, float __y) __attribute__ ((__nothrow__ )); extern float __fdimf (float __x, float __y) __attribute__ ((__nothrow__ ));


extern float fmaxf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __fmaxf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern float fminf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern float __fminf (float __x, float __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern int __fpclassifyf (float __value) __attribute__ ((__nothrow__ ))
     __attribute__ ((__const__));


extern int __signbitf (float __value) __attribute__ ((__nothrow__ ))
     __attribute__ ((__const__));



extern float fmaf (float __x, float __y, float __z) __attribute__ ((__nothrow__ )); extern float __fmaf (float __x, float __y, float __z) __attribute__ ((__nothrow__ ));
# 364 "/usr/include/bits/mathcalls.h" 3 4
extern float scalbf (float __x, float __n) __attribute__ ((__nothrow__ )); extern float __scalbf (float __x, float __n) __attribute__ ((__nothrow__ ));
# 90 "/usr/include/math.h" 2 3 4
# 133 "/usr/include/math.h" 3 4
# 1 "/usr/include/bits/mathcalls.h" 1 3 4
# 54 "/usr/include/bits/mathcalls.h" 3 4
extern long double acosl (long double __x) __attribute__ ((__nothrow__ )); extern long double __acosl (long double __x) __attribute__ ((__nothrow__ ));

extern long double asinl (long double __x) __attribute__ ((__nothrow__ )); extern long double __asinl (long double __x) __attribute__ ((__nothrow__ ));

extern long double atanl (long double __x) __attribute__ ((__nothrow__ )); extern long double __atanl (long double __x) __attribute__ ((__nothrow__ ));

extern long double atan2l (long double __y, long double __x) __attribute__ ((__nothrow__ )); extern long double __atan2l (long double __y, long double __x) __attribute__ ((__nothrow__ ));


extern long double cosl (long double __x) __attribute__ ((__nothrow__ )); extern long double __cosl (long double __x) __attribute__ ((__nothrow__ ));

extern long double sinl (long double __x) __attribute__ ((__nothrow__ )); extern long double __sinl (long double __x) __attribute__ ((__nothrow__ ));

extern long double tanl (long double __x) __attribute__ ((__nothrow__ )); extern long double __tanl (long double __x) __attribute__ ((__nothrow__ ));




extern long double coshl (long double __x) __attribute__ ((__nothrow__ )); extern long double __coshl (long double __x) __attribute__ ((__nothrow__ ));

extern long double sinhl (long double __x) __attribute__ ((__nothrow__ )); extern long double __sinhl (long double __x) __attribute__ ((__nothrow__ ));

extern long double tanhl (long double __x) __attribute__ ((__nothrow__ )); extern long double __tanhl (long double __x) __attribute__ ((__nothrow__ ));
# 88 "/usr/include/bits/mathcalls.h" 3 4
extern long double acoshl (long double __x) __attribute__ ((__nothrow__ )); extern long double __acoshl (long double __x) __attribute__ ((__nothrow__ ));

extern long double asinhl (long double __x) __attribute__ ((__nothrow__ )); extern long double __asinhl (long double __x) __attribute__ ((__nothrow__ ));

extern long double atanhl (long double __x) __attribute__ ((__nothrow__ )); extern long double __atanhl (long double __x) __attribute__ ((__nothrow__ ));







extern long double expl (long double __x) __attribute__ ((__nothrow__ )); extern long double __expl (long double __x) __attribute__ ((__nothrow__ ));


extern long double frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__ )); extern long double __frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__ ));


extern long double ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__ )); extern long double __ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__ ));


extern long double logl (long double __x) __attribute__ ((__nothrow__ )); extern long double __logl (long double __x) __attribute__ ((__nothrow__ ));


extern long double log10l (long double __x) __attribute__ ((__nothrow__ )); extern long double __log10l (long double __x) __attribute__ ((__nothrow__ ));


extern long double modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__ )); extern long double __modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__ ))
     __attribute__ ((__nonnull__ (2)));
# 129 "/usr/include/bits/mathcalls.h" 3 4
extern long double expm1l (long double __x) __attribute__ ((__nothrow__ )); extern long double __expm1l (long double __x) __attribute__ ((__nothrow__ ));


extern long double log1pl (long double __x) __attribute__ ((__nothrow__ )); extern long double __log1pl (long double __x) __attribute__ ((__nothrow__ ));


extern long double logbl (long double __x) __attribute__ ((__nothrow__ )); extern long double __logbl (long double __x) __attribute__ ((__nothrow__ ));






extern long double exp2l (long double __x) __attribute__ ((__nothrow__ )); extern long double __exp2l (long double __x) __attribute__ ((__nothrow__ ));


extern long double log2l (long double __x) __attribute__ ((__nothrow__ )); extern long double __log2l (long double __x) __attribute__ ((__nothrow__ ));
# 154 "/usr/include/bits/mathcalls.h" 3 4
extern long double powl (long double __x, long double __y) __attribute__ ((__nothrow__ )); extern long double __powl (long double __x, long double __y) __attribute__ ((__nothrow__ ));


extern long double sqrtl (long double __x) __attribute__ ((__nothrow__ )); extern long double __sqrtl (long double __x) __attribute__ ((__nothrow__ ));





extern long double hypotl (long double __x, long double __y) __attribute__ ((__nothrow__ )); extern long double __hypotl (long double __x, long double __y) __attribute__ ((__nothrow__ ));






extern long double cbrtl (long double __x) __attribute__ ((__nothrow__ )); extern long double __cbrtl (long double __x) __attribute__ ((__nothrow__ ));
# 179 "/usr/include/bits/mathcalls.h" 3 4
extern long double ceill (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __ceill (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern long double fabsl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __fabsl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern long double floorl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __floorl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern long double fmodl (long double __x, long double __y) __attribute__ ((__nothrow__ )); extern long double __fmodl (long double __x, long double __y) __attribute__ ((__nothrow__ ));




extern int __isinfl (long double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int __finitel (long double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));





extern int isinfl (long double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int finitel (long double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern long double dreml (long double __x, long double __y) __attribute__ ((__nothrow__ )); extern long double __dreml (long double __x, long double __y) __attribute__ ((__nothrow__ ));



extern long double significandl (long double __x) __attribute__ ((__nothrow__ )); extern long double __significandl (long double __x) __attribute__ ((__nothrow__ ));





extern long double copysignl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __copysignl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));






extern long double nanl (const char *__tagb) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __nanl (const char *__tagb) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));





extern int __isnanl (long double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern int isnanl (long double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern long double j0l (long double) __attribute__ ((__nothrow__ )); extern long double __j0l (long double) __attribute__ ((__nothrow__ ));
extern long double j1l (long double) __attribute__ ((__nothrow__ )); extern long double __j1l (long double) __attribute__ ((__nothrow__ ));
extern long double jnl (int, long double) __attribute__ ((__nothrow__ )); extern long double __jnl (int, long double) __attribute__ ((__nothrow__ ));
extern long double y0l (long double) __attribute__ ((__nothrow__ )); extern long double __y0l (long double) __attribute__ ((__nothrow__ ));
extern long double y1l (long double) __attribute__ ((__nothrow__ )); extern long double __y1l (long double) __attribute__ ((__nothrow__ ));
extern long double ynl (int, long double) __attribute__ ((__nothrow__ )); extern long double __ynl (int, long double) __attribute__ ((__nothrow__ ));






extern long double erfl (long double) __attribute__ ((__nothrow__ )); extern long double __erfl (long double) __attribute__ ((__nothrow__ ));
extern long double erfcl (long double) __attribute__ ((__nothrow__ )); extern long double __erfcl (long double) __attribute__ ((__nothrow__ ));
extern long double lgammal (long double) __attribute__ ((__nothrow__ )); extern long double __lgammal (long double) __attribute__ ((__nothrow__ ));






extern long double tgammal (long double) __attribute__ ((__nothrow__ )); extern long double __tgammal (long double) __attribute__ ((__nothrow__ ));





extern long double gammal (long double) __attribute__ ((__nothrow__ )); extern long double __gammal (long double) __attribute__ ((__nothrow__ ));






extern long double lgammal_r (long double, int *__signgamp) __attribute__ ((__nothrow__ )); extern long double __lgammal_r (long double, int *__signgamp) __attribute__ ((__nothrow__ ));







extern long double rintl (long double __x) __attribute__ ((__nothrow__ )); extern long double __rintl (long double __x) __attribute__ ((__nothrow__ ));


extern long double nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));

extern long double nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern long double remainderl (long double __x, long double __y) __attribute__ ((__nothrow__ )); extern long double __remainderl (long double __x, long double __y) __attribute__ ((__nothrow__ ));



extern long double scalbnl (long double __x, int __n) __attribute__ ((__nothrow__ )); extern long double __scalbnl (long double __x, int __n) __attribute__ ((__nothrow__ ));



extern int ilogbl (long double __x) __attribute__ ((__nothrow__ )); extern int __ilogbl (long double __x) __attribute__ ((__nothrow__ ));




extern long double scalblnl (long double __x, long int __n) __attribute__ ((__nothrow__ )); extern long double __scalblnl (long double __x, long int __n) __attribute__ ((__nothrow__ ));



extern long double nearbyintl (long double __x) __attribute__ ((__nothrow__ )); extern long double __nearbyintl (long double __x) __attribute__ ((__nothrow__ ));



extern long double roundl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __roundl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern long double truncl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __truncl (long double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));




extern long double remquol (long double __x, long double __y, int *__quo) __attribute__ ((__nothrow__ )); extern long double __remquol (long double __x, long double __y, int *__quo) __attribute__ ((__nothrow__ ));






extern long int lrintl (long double __x) __attribute__ ((__nothrow__ )); extern long int __lrintl (long double __x) __attribute__ ((__nothrow__ ));
extern long long int llrintl (long double __x) __attribute__ ((__nothrow__ )); extern long long int __llrintl (long double __x) __attribute__ ((__nothrow__ ));



extern long int lroundl (long double __x) __attribute__ ((__nothrow__ )); extern long int __lroundl (long double __x) __attribute__ ((__nothrow__ ));
extern long long int llroundl (long double __x) __attribute__ ((__nothrow__ )); extern long long int __llroundl (long double __x) __attribute__ ((__nothrow__ ));



extern long double fdiml (long double __x, long double __y) __attribute__ ((__nothrow__ )); extern long double __fdiml (long double __x, long double __y) __attribute__ ((__nothrow__ ));


extern long double fmaxl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __fmaxl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern long double fminl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern long double __fminl (long double __x, long double __y) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));



extern int __fpclassifyl (long double __value) __attribute__ ((__nothrow__ ))
     __attribute__ ((__const__));


extern int __signbitl (long double __value) __attribute__ ((__nothrow__ ))
     __attribute__ ((__const__));



extern long double fmal (long double __x, long double __y, long double __z) __attribute__ ((__nothrow__ )); extern long double __fmal (long double __x, long double __y, long double __z) __attribute__ ((__nothrow__ ));
# 364 "/usr/include/bits/mathcalls.h" 3 4
extern long double scalbl (long double __x, long double __n) __attribute__ ((__nothrow__ )); extern long double __scalbl (long double __x, long double __n) __attribute__ ((__nothrow__ ));
# 134 "/usr/include/math.h" 2 3 4
# 149 "/usr/include/math.h" 3 4
extern int signgam;
# 190 "/usr/include/math.h" 3 4
enum
  {
    FP_NAN =

      0,
    FP_INFINITE =

      1,
    FP_ZERO =

      2,
    FP_SUBNORMAL =

      3,
    FP_NORMAL =

      4
  };
# 288 "/usr/include/math.h" 3 4
typedef enum
{
  _IEEE_ = -1,
  _SVID_,
  _XOPEN_,
  _POSIX_,
  _ISOC_
} _LIB_VERSION_TYPE;




extern _LIB_VERSION_TYPE _LIB_VERSION;
# 313 "/usr/include/math.h" 3 4
struct exception

  {
    int type;
    char *name;
    double arg1;
    double arg2;
    double retval;
  };




extern int matherr (struct exception *__exc);
# 413 "/usr/include/math.h" 3 4
# 1 "/usr/include/bits/mathinline.h" 1 3 4
# 126 "/usr/include/bits/mathinline.h" 3 4
extern __inline __attribute__ ((__always_inline__)) __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ )) __signbitf (float __x)
{

  int __m;
  __asm ("pmovmskb %1, %0" : "=r" (__m) : "x" (__x));
  return (__m & 0x8) != 0;




}
extern __inline __attribute__ ((__always_inline__)) __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ )) __signbit (double __x)
{

  int __m;
  __asm ("pmovmskb %1, %0" : "=r" (__m) : "x" (__x));
  return (__m & 0x80) != 0;




}
extern __inline __attribute__ ((__always_inline__)) __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ )) __signbitl (long double __x)
{
  __extension__ union { long double __l; int __i[3]; } __u = { __l: __x };
  return (__u.__i[2] & 0x8000) != 0;
}
# 414 "/usr/include/math.h" 2 3 4
# 192 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 2 3
# 248 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math_common_define.h" 1 3
# 249 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 2 3
# 401 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
            extern int fpclassifyf ( float __x ) ;

            extern int fpclassify ( double __x ) ;

            extern int fpclassifyd ( double __x ) ;
            extern int fpclassifyl ( long double __x ) ;

            extern int isinff ( float __x ) ;

            extern int isinf ( double __x ) ;

            extern int isinfd ( double __x ) ;
            extern int isinfl ( long double __x ) ;

            extern int isnanf ( float __x ) ;

            extern int isnan ( double __x ) ;

            extern int isnand ( double __x ) ;
            extern int isnanl ( long double __x ) ;

            extern int isnormalf ( float __x ) ;

            extern int isnormal ( double __x ) ;

            extern int isnormald ( double __x ) ;
            extern int isnormall ( long double __x ) ;

            extern int isfinitef ( float __x ) ;

            extern int isfinite ( double __x ) ;

            extern int isfinited ( double __x ) ;
            extern int isfinitel ( long double __x ) ;

            extern int finitef ( float __x ) ;

            extern int finite ( double __x ) ;

            extern int finited ( double __x ) ;
            extern int finitel ( long double __x ) ;

            extern int signbitf ( float __x ) ;

            extern int signbit ( double __x ) ;

            extern int signbitd ( double __x ) ;
            extern int signbitl ( long double __x ) ;



            extern int __fpclassifyf ( float __x ) ;
            extern int __fpclassify ( double __x ) ;
            extern int __fpclassifyd ( double __x ) ;
            extern int __fpclassifyl ( long double __x ) ;


        extern int __isinff ( float __x ) ;
        extern int __isinf ( double __x ) ;
        extern int __isinfd ( double __x ) ;
        extern int __isinfl ( long double __x ) ;

        extern int __isnanf ( float __x ) ;
        extern int __isnan ( double __x ) ;
        extern int __isnand ( double __x ) ;
        extern int __isnanl ( long double __x ) ;

        extern int __isnormalf ( float __x ) ;
        extern int __isnormal ( double __x ) ;
        extern int __isnormald ( double __x ) ;
        extern int __isnormall ( long double __x ) ;

        extern int __isfinitef ( float __x ) ;
        extern int __isfinite ( double __x ) ;
        extern int __isfinited ( double __x ) ;
        extern int __isfinitel ( long double __x ) ;

        extern int __finitef ( float __x ) ;
        extern int __finite ( double __x ) ;
        extern int __finited ( double __x ) ;
        extern int __finitel ( long double __x ) ;

        extern int __signbitf ( float __x ) ;
        extern int __signbit ( double __x ) ;
        extern int __signbitd ( double __x ) ;
        extern int __signbitl ( long double __x ) ;
# 551 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
        extern int isgreaterf( float __xf, float __yf );

        extern int isgreater( double __xd, double __yd );

        extern int isgreaterl( long double __xl, long double __yl );
        extern int __isgreaterf( float __xf, float __yf );
        extern int __isgreater( double __xd, double __yd );
        extern int __isgreaterl( long double __xl, long double __yl );

        extern int isgreaterequalf( float __xf, float __yf );

        extern int isgreaterequal( double __xd, double __yd );

        extern int isgreaterequall( long double __xl, long double __yl );
        extern int __isgreaterequalf( float __xf, float __yf );
        extern int __isgreaterequal( double __xd, double __yd );
        extern int __isgreaterequall( long double __xl, long double __yl );

        extern int islessf( float __xf, float __yf );

        extern int isless( double __xd, double __yd );

        extern int islessl( long double __xl, long double __yl );
        extern int __islessf( float __xf, float __yf );
        extern int __isless( double __xd, double __yd );
        extern int __islessl( long double __xl, long double __yl );

        int islessequalf( float __xf, float __yf );

        extern int islessequal( double __xd, double __yd );

        extern int islessequall( long double __xl, long double __yl );
        extern int __islessequalf( float __xf, float __yf );
        extern int __islessequal( double __xd, double __yd );
        extern int __islessequall( long double __xl, long double __yl );

        extern int islessgreaterf( float __xf, float __yf );

        extern int islessgreater( double __xd, double __yd );

        extern int islessgreaterl( long double __xl, long double __yl );
        extern int __islessgreaterf( float __xf, float __yf );
        extern int __islessgreater( double __xd, double __yd );
        extern int __islessgreaterl( long double __xl, long double __yl );

        extern int isunorderedf( float __xf, float __yf );

        extern int isunordered( double __xd, double __yd );

        extern int isunorderedl( long double __xl, long double __yl );
        extern int __isunorderedf( float __xf, float __yf );
        extern int __isunordered( double __xd, double __yd );
        extern int __isunorderedl( long double __xl, long double __yl );
# 798 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
        extern double gamma( double __x );
        extern float gammaf( float __x );

        extern double lgamma_r(double __x, int *__signgam);
        extern float lgammaf_r( float __x, int *__signgam );


        extern double gamma_r( double __x, int *__signgam );
        extern float gammaf_r( float __x, int *__signgam );
# 1055 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
        typedef struct ____exception {
            int type;
            const char *name;
            double arg1;
            double arg2;
            double retval;
        } ___exception;
# 1076 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
        typedef struct ____exceptionf {
            int type;
            const char *name;
            float arg1;
            float arg2;
            float retval;
        } ___exceptionf;

        typedef struct ____exceptionl {
            int type;
            const char *name;
            long double arg1;
            long double arg2;
            long double retval;
        } ___exceptionl;




        extern int matherrf( struct ____exceptionf *__e );
        extern int matherrl( struct ____exceptionl *__e );
# 1116 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
        typedef int ( *___pmatherr )( struct ____exception *__e );
        typedef int ( *___pmatherrf )( struct ____exceptionf *__e );
        typedef int ( *___pmatherrl )( struct ____exceptionl *__e );

        extern ___pmatherr __libm_setusermatherr( ___pmatherr __user_matherr );
        extern ___pmatherrf __libm_setusermatherrf( ___pmatherrf __user_matherrf );
        extern ___pmatherrl __libm_setusermatherrl( ___pmatherrl __user_matherrl );
# 1152 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 3
        extern _LIB_VERSION_TYPE _LIB_VERSIONIMF;
# 1 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math_common_undefine.h" 1 3
# 1154 "/opt/intel/oneapi/compiler/2023.1.0/linux/bin-llvm/../compiler/include/math.h" 2 3
# 56 "../src/elpa_index.h" 2

# 1 "./config.h" 1
# 58 "../src/elpa_index.h" 2
# 71 "../src/elpa_index.h"
typedef struct elpa_index_struct* elpa_index_t;


typedef int (*elpa_index_cardinality_t)(elpa_index_t index);


typedef int (*elpa_index_enumerate_int_option_t)(elpa_index_t index, int i);


typedef int (*elpa_index_valid_int_t)(elpa_index_t index, int n, int new_value);
typedef int (*elpa_index_valid_float_t)(elpa_index_t index, int n, float new_value);
typedef int (*elpa_index_valid_double_t)(elpa_index_t index, int n, double new_value);


typedef const char* (*elpa_index_to_string_int_t)(int n);


typedef struct {
        char *name;
        char *description;
        char *env_default;
        char *env_force;
        int once;
        int readonly;
        int print_flag;
} elpa_index_entry_t;


typedef struct {
        elpa_index_entry_t base;
        int default_value;
        int autotune_level_old;
        int autotune_level;
        int autotune_domain;
 int autotune_part;
        elpa_index_valid_int_t valid;
        elpa_index_cardinality_t cardinality;
        elpa_index_enumerate_int_option_t enumerate;
        elpa_index_to_string_int_t to_string;
} elpa_index_int_entry_t;


typedef struct {
        elpa_index_entry_t base;
        float default_value;
        elpa_index_valid_float_t valid;
} elpa_index_float_entry_t;


typedef struct {
        elpa_index_entry_t base;
        double default_value;
        elpa_index_valid_double_t valid;
} elpa_index_double_entry_t;

enum NOTIFY_FLAGS {
        NOTIFY_ENV_DEFAULT = (1<<0),
        NOTIFY_ENV_FORCE = (1<<1),
};

enum PRINT_FLAGS {
        PRINT_STRUCTURE,
        PRINT_YES,
        PRINT_NO,
};

struct elpa_index_struct {






        struct { int *values; int *is_set; int *notified; } int_options; struct { float *values; int *is_set; int *notified; } float_options; struct { double *values; int *is_set; int *notified; } double_options;
};
# 156 "../src/elpa_index.h"
elpa_index_t elpa_index_instance();
# 167 "../src/elpa_index.h"
void elpa_index_free(elpa_index_t index);
# 186 "../src/elpa_index.h"
int elpa_index_get_int_value(elpa_index_t index, char *name, int *success);
# 201 "../src/elpa_index.h"
int elpa_index_set_int_value(elpa_index_t index, char *name, int value);
# 214 "../src/elpa_index.h"
int elpa_index_int_value_is_set(elpa_index_t index, char *name);
# 227 "../src/elpa_index.h"
int* elpa_index_get_int_loc(elpa_index_t index, char *name);
# 245 "../src/elpa_index.h"
float elpa_index_get_float_value(elpa_index_t index, char *name, int *success);
# 260 "../src/elpa_index.h"
int elpa_index_set_float_value(elpa_index_t index, char *name, float value);
# 274 "../src/elpa_index.h"
int elpa_index_float_value_is_set(elpa_index_t index, char *name);
# 287 "../src/elpa_index.h"
float* elpa_index_get_float_loc(elpa_index_t index, char *name);
# 305 "../src/elpa_index.h"
double elpa_index_get_double_value(elpa_index_t index, char *name, int *success);
# 320 "../src/elpa_index.h"
int elpa_index_set_double_value(elpa_index_t index, char *name, double value);
# 334 "../src/elpa_index.h"
int elpa_index_double_value_is_set(elpa_index_t index, char *name);
# 347 "../src/elpa_index.h"
double* elpa_index_get_double_loc(elpa_index_t index, char *name);
# 360 "../src/elpa_index.h"
int elpa_index_value_is_set(elpa_index_t index, char *name);
# 376 "../src/elpa_index.h"
int elpa_int_value_to_string(char *name, int value, const char **string);
# 391 "../src/elpa_index.h"
int elpa_int_value_to_strlen(char *name, int value);
# 406 "../src/elpa_index.h"
int elpa_index_int_value_to_strlen(elpa_index_t index, char *name);
# 421 "../src/elpa_index.h"
int elpa_int_string_to_value(char *name, char *string, int *value);
# 434 "../src/elpa_index.h"
int elpa_option_cardinality(char *name);
# 447 "../src/elpa_index.h"
int elpa_option_enumerate(char *name, int i);
# 463 "../src/elpa_index.h"
int elpa_index_int_is_valid(elpa_index_t index, char *name, int new_value);
# 478 "../src/elpa_index.h"
int elpa_index_autotune_cardinality(elpa_index_t index, int autotune_level, int autotune_domain);
# 497 "../src/elpa_index.h"
int elpa_index_autotune_cardinality_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part);
# 512 "../src/elpa_index.h"
int elpa_index_set_autotune_parameters(elpa_index_t index, int autotune_level, int autotune_domain, int n);
# 531 "../src/elpa_index.h"
int elpa_index_set_autotune_parameters_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part, int n);
# 546 "../src/elpa_index.h"
int elpa_index_print_autotune_parameters(elpa_index_t index, int autotune_level, int autotune_domain);
# 563 "../src/elpa_index.h"
int elpa_index_print_autotune_parameters_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part);
# 578 "../src/elpa_index.h"
int elpa_index_print_settings(elpa_index_t index, char* filename);
# 592 "../src/elpa_index.h"
int elpa_index_load_settings(elpa_index_t index, char* filename);
# 609 "../src/elpa_index.h"
int elpa_index_print_autotune_state(elpa_index_t index, int autotune_level, int autotune_domain, int min_loc,
                                    double min_val, int current, int cardinality, char* filename);
# 633 "../src/elpa_index.h"
int elpa_index_print_autotune_state_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part, int min_loc,
                                    double min_val, int current, int cardinality, int solver, char* filename);
# 651 "../src/elpa_index.h"
int elpa_index_load_autotune_state(elpa_index_t index, int* autotune_level, int* autotune_domain, int* min_loc,
                                    double* min_val, int* current, int* cardinality, char* filename);

int elpa_index_is_printing_mpi_rank(elpa_index_t index);
# 53 "../src/elpa_index.c" 2

# 1 "./config.h" 1
# 55 "../src/elpa_index.c" 2





int max_threads_glob;
int max_threads_glob_1;
int set_max_threads_glob=0;
int set_max_threads_glob_1=0;



int const default_max_stored_rows = 256;


static int enumerate_identity(elpa_index_t index, int i);
static int cardinality_bool(elpa_index_t index);
static int valid_bool(elpa_index_t index, int n, int new_value);

static int number_of_matrix_layouts(elpa_index_t index);
static int matrix_layout_enumerate(elpa_index_t index, int i);
static int matrix_layout_is_valid(elpa_index_t index, int n, int new_value);
static const char* elpa_matrix_layout_name(int layout);

static int number_of_solvers(elpa_index_t index);
static int solver_enumerate(elpa_index_t index, int i);
static int solver_is_valid(elpa_index_t index, int n, int new_value);
static const char* elpa_solver_name(int solver);

static int number_of_real_kernels(elpa_index_t index);
static int real_kernel_enumerate(elpa_index_t index, int i);
static int real_kernel_is_valid(elpa_index_t index, int n, int new_value);
static const char *real_kernel_name(int kernel);

static int number_of_complex_kernels(elpa_index_t index);
static int complex_kernel_enumerate(elpa_index_t index, int i);
static int complex_kernel_is_valid(elpa_index_t index, int n, int new_value);
static const char *complex_kernel_name(int kernel);

static int band_to_full_cardinality(elpa_index_t index);
static int band_to_full_enumerate(elpa_index_t index, int i);
static int band_to_full_is_valid(elpa_index_t index, int n, int new_value);

static int stripewidth_real_cardinality(elpa_index_t index);
static int stripewidth_real_enumerate(elpa_index_t index, int i);
static int stripewidth_real_is_valid(elpa_index_t index, int n, int new_value);

static int internal_nblk_cardinality(elpa_index_t index);
static int internal_nblk_enumerate(elpa_index_t index, int i);
static int internal_nblk_is_valid(elpa_index_t index, int n, int new_value);

static int stripewidth_complex_cardinality(elpa_index_t index);
static int stripewidth_complex_enumerate(elpa_index_t index, int i);
static int stripewidth_complex_is_valid(elpa_index_t index, int n, int new_value);

static int omp_threads_cardinality(elpa_index_t index);
static int omp_threads_enumerate(elpa_index_t index, int i);
static int omp_threads_is_valid(elpa_index_t index, int n, int new_value);

static int max_stored_rows_cardinality(elpa_index_t index);
static int max_stored_rows_enumerate(elpa_index_t index, int i);
static int max_stored_rows_is_valid(elpa_index_t index, int n, int new_value);

static int min_tile_size_cardinality(elpa_index_t index);
static int min_tile_size_enumerate(elpa_index_t index, int i);
static int min_tile_size_is_valid(elpa_index_t index, int n, int new_value);
# 135 "../src/elpa_index.c"
static int use_gpu_id_cardinality(elpa_index_t index);
static int use_gpu_id_enumerate(elpa_index_t index, int i);
static int use_gpu_id_is_valid(elpa_index_t index, int n, int new_value);

static int valid_with_gpu(elpa_index_t index, int n, int new_value);
static int valid_with_gpu_elpa1(elpa_index_t index, int n, int new_value);
static int valid_with_gpu_elpa2(elpa_index_t index, int n, int new_value);

static int intermediate_bandwidth_cardinality(elpa_index_t index);
static int intermediate_bandwidth_enumerate(elpa_index_t index, int i);
static int intermediate_bandwidth_is_valid(elpa_index_t index, int n, int new_value);

static int cannon_buffer_size_cardinality(elpa_index_t index);
static int cannon_buffer_size_enumerate(elpa_index_t index, int i);
static int cannon_buffer_size_is_valid(elpa_index_t index, int n, int new_value);

static int na_is_valid(elpa_index_t index, int n, int new_value);
static int nev_is_valid(elpa_index_t index, int n, int new_value);
static int bw_is_valid(elpa_index_t index, int n, int new_value);
static int output_build_config_is_valid(elpa_index_t index, int n, int new_value);
static int nvidia_gpu_is_valid(elpa_index_t index, int n, int new_value);
static int amd_gpu_is_valid(elpa_index_t index, int n, int new_value);
static int intel_gpu_is_valid(elpa_index_t index, int n, int new_value);
static int expose_all_sycl_devices_is_valid(elpa_index_t index, int n, int new_value);
static int nbc_is_valid(elpa_index_t index, int n, int new_value);
static int nbc_elpa1_is_valid(elpa_index_t index, int n, int new_value);
static int nbc_elpa2_is_valid(elpa_index_t index, int n, int new_value);
static int verbose_is_valid(elpa_index_t index, int n, int new_value);

static int is_positive(elpa_index_t index, int n, int new_value);

static int elpa_float_string_to_value(char *name, char *string, float *value);
static int elpa_float_value_to_string(char *name, float value, const char **string);

static int elpa_double_string_to_value(char *name, char *string, double *value);
static int elpa_double_value_to_string(char *name, double value, const char **string);
# 224 "../src/elpa_index.c"
static const elpa_index_int_entry_t int_entries[] = {
        { .base = { .name = "na", .description = "Global matrix has size (na * na)", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "na", .env_force = "ELPA_FORCE_" "na", .print_flag = PRINT_STRUCTURE, }, .valid = na_is_valid, },
        { .base = { .name = "nev", .description = "Number of eigenvectors to be computed, 0 <= nev <= na", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nev", .env_force = "ELPA_FORCE_" "nev", .print_flag = PRINT_STRUCTURE, }, .valid = nev_is_valid, },
        { .base = { .name = "nblk", .description = "Block size of scalapack block-cyclic distribution", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nblk", .env_force = "ELPA_FORCE_" "nblk", .print_flag = PRINT_STRUCTURE, }, .valid = is_positive, },
        { .base = { .name = "local_nrows", .description = "Number of matrix rows stored on this process", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "local_nrows", .env_force = "ELPA_FORCE_" "local_nrows", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "local_ncols", .description = "Number of matrix columns stored on this process", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "local_ncols", .env_force = "ELPA_FORCE_" "local_ncols", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "process_row", .description = "Process row number in the 2D domain decomposition", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "process_row", .env_force = "ELPA_FORCE_" "process_row", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "process_col", .description = "Process column number in the 2D domain decomposition", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "process_col", .env_force = "ELPA_FORCE_" "process_col", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "process_id", .description = "Process rank", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "process_id", .env_force = "ELPA_FORCE_" "process_id", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "num_process_rows", .description = "Number of process row number in the 2D domain decomposition", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "num_process_rows", .env_force = "ELPA_FORCE_" "num_process_rows", .print_flag = PRINT_STRUCTURE, }, .valid = ((void*)0), },
        { .base = { .name = "num_process_cols", .description = "Number of process column number in the 2D domain decomposition", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "num_process_cols", .env_force = "ELPA_FORCE_" "num_process_cols", .print_flag = PRINT_STRUCTURE, }, .valid = ((void*)0), },
        { .base = { .name = "num_processes", .description = "Total number of processes", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "num_processes", .env_force = "ELPA_FORCE_" "num_processes", .print_flag = PRINT_STRUCTURE, }, .valid = ((void*)0), },
        { .base = { .name = "bandwidth", .description = "If specified, a band matrix with this bandwidth is expected as input; bandwidth must be multiply of nblk and at least 2", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "bandwidth", .env_force = "ELPA_FORCE_" "bandwidth", .print_flag = PRINT_YES, }, .valid = bw_is_valid, },
        { .base = { .name = "mpi_comm_rows", .description = "Communicator for inter-row communication", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "mpi_comm_rows", .env_force = "ELPA_FORCE_" "mpi_comm_rows", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "mpi_comm_cols", .description = "Communicator for inter-column communication", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "mpi_comm_cols", .env_force = "ELPA_FORCE_" "mpi_comm_cols", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "mpi_comm_parent", .description = "Parent communicator", .once = 1, .readonly = 0, .env_default = "ELPA_DEFAULT_" "mpi_comm_parent", .env_force = "ELPA_FORCE_" "mpi_comm_parent", .print_flag = PRINT_NO, }, .valid = ((void*)0), },
        { .base = { .name = "blacs_context", .description = "BLACS context", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "blacs_context", .env_force = "ELPA_FORCE_" "blacs_context", .print_flag = PRINT_NO, }, },
        { .base = { .name = "verbose", .description = "ELPA API prints verbose messages", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "verbose", .env_force = "ELPA_FORCE_" "verbose", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = verbose_is_valid, .to_string = ((void*)0), },





 { .base = { .name = "matrix_order", .description = "Order of the matrix layout", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "matrix_order", .env_force = "ELPA_FORCE_" "matrix_order", .print_flag = PRINT_YES, }, .default_value = COLUMN_MAJOR_ORDER, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = number_of_matrix_layouts, .enumerate = matrix_layout_enumerate, .valid = matrix_layout_is_valid, .to_string = elpa_matrix_layout_name, },


        { .base = { .name = "solver", .description = "Solver to use", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "solver", .env_force = "ELPA_FORCE_" "solver", .print_flag = PRINT_YES, }, .default_value = ELPA_SOLVER_1STAGE, .autotune_level_old = ELPA_AUTOTUNE_FAST, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = number_of_solvers, .enumerate = solver_enumerate, .valid = solver_is_valid, .to_string = elpa_solver_name, },

 { .base = { .name = "use_gpu_id", .description = "Calling MPI task will use this gpu id", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "use_gpu_id", .env_force = "ELPA_FORCE_" "use_gpu_id", .print_flag = PRINT_YES, }, .default_value = -99, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = use_gpu_id_cardinality, .enumerate = use_gpu_id_enumerate, .valid = use_gpu_id_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "timings", .description = "Enable time measurement", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "timings", .env_force = "ELPA_FORCE_" "timings", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = 0, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },
        { .base = { .name = "debug", .description = "Emit verbose debugging messages", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "debug", .env_force = "ELPA_FORCE_" "debug", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = 0, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },
        { .base = { .name = "print_flops", .description = "Print FLOP rates on task 0", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "print_flops", .env_force = "ELPA_FORCE_" "print_flops", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = 0, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },
        { .base = { .name = "measure_performance", .description = "Also measure with flops (via papi) with the timings", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "measure_performance", .env_force = "ELPA_FORCE_" "measure_performance", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = 0, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },
        { .base = { .name = "check_pd", .description = "Check eigenvalues to be positive", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "check_pd", .env_force = "ELPA_FORCE_" "check_pd", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = 0, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },
        { .base = { .name = "output_pinning_information", .description = "Print the pinning information", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "output_pinning_information", .env_force = "ELPA_FORCE_" "output_pinning_information", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = 0, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },
        { .base = { .name = "cannon_for_generalized", .description = "Whether to use Cannons algorithm for the generalized EVP", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "cannon_for_generalized", .env_force = "ELPA_FORCE_" "cannon_for_generalized", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = 0, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },



        { .base = { .name = "qr", .description = "Use QR decomposition, only used for ELPA_SOLVER_2STAGE, real case", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "qr", .env_force = "ELPA_FORCE_" "qr", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_REAL, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_bool, },
        { .base = { .name = "cannon_buffer_size", .description = "Increasing the buffer size might make it faster, but costs memory", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "cannon_buffer_size", .env_force = "ELPA_FORCE_" "cannon_buffer_size", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = cannon_buffer_size_cardinality, .enumerate = cannon_buffer_size_enumerate, .valid = cannon_buffer_size_is_valid, .to_string = ((void*)0), },



        { .base = { .name = "nbc_row_global_gather", .description = "Use non blocking collectives for rows in global_gather", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_global_gather", .env_force = "ELPA_FORCE_" "nbc_row_global_gather", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_SOLVE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_global_gather", .description = "Use non blocking collectives for cols in global_gather", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_global_gather", .env_force = "ELPA_FORCE_" "nbc_col_global_gather", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_SOLVE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_global_product", .description = "Use non blocking collectives for rows in global_product", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_global_product", .env_force = "ELPA_FORCE_" "nbc_row_global_product", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_SOLVE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_global_product", .description = "Use non blocking collectives for cols in global_product", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_global_product", .env_force = "ELPA_FORCE_" "nbc_col_global_product", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_SOLVE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_solve_tridi", .description = "Use non blocking collectives in solve_tridi", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_solve_tridi", .env_force = "ELPA_FORCE_" "nbc_row_solve_tridi", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_SOLVE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_transpose_vectors", .description = "Use non blocking collectives for rows in transpose_vectors", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_transpose_vectors", .env_force = "ELPA_FORCE_" "nbc_row_transpose_vectors", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_TRANSPOSE_VECTORS, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_transpose_vectors", .description = "Use non blocking collectives for cols in transpose_vectors", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_transpose_vectors", .env_force = "ELPA_FORCE_" "nbc_col_transpose_vectors", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_TRANSPOSE_VECTORS, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_herm_allreduce", .description = "Use non blocking collectives for rows in herm_allreduce", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_herm_allreduce", .env_force = "ELPA_FORCE_" "nbc_row_herm_allreduce", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_FULL_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_COMPLEX, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_herm_allreduce", .description = "Use non blocking collectives for cols in herm_allreduce", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_herm_allreduce", .env_force = "ELPA_FORCE_" "nbc_col_herm_allreduce", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_FULL_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_COMPLEX, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_sym_allreduce", .description = "Use non blocking collectives for rows in sym_allreduce", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_sym_allreduce", .env_force = "ELPA_FORCE_" "nbc_row_sym_allreduce", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_FULL_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_REAL, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_sym_allreduce", .description = "Use non blocking collectives for cols in sym_allreduce", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_sym_allreduce", .env_force = "ELPA_FORCE_" "nbc_col_sym_allreduce", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_FULL_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_REAL, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_elpa1_full_to_tridi", .description = "Use non blocking collectives for rows in elpa1_tridiag", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_elpa1_full_to_tridi", .env_force = "ELPA_FORCE_" "nbc_row_elpa1_full_to_tridi", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA1_AUTOTUNE_FULL_TO_TRIDI, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA1, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa1_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_elpa1_full_to_tridi", .description = "Use non blocking collectives for cols in elpa1_tridiag", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_elpa1_full_to_tridi", .env_force = "ELPA_FORCE_" "nbc_col_elpa1_full_to_tridi", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA1_AUTOTUNE_FULL_TO_TRIDI, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA1, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa1_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_elpa1_tridi_to_full", .description = "Use non blocking collectives for rows in elpa1_tridi_to_full", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_elpa1_tridi_to_full", .env_force = "ELPA_FORCE_" "nbc_row_elpa1_tridi_to_full", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA1_AUTOTUNE_TRIDI_TO_FULL, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA1, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa1_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_elpa1_tridi_to_full", .description = "Use non blocking collectives for cols in elpa1_tridi_to_full", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_elpa1_tridi_to_full", .env_force = "ELPA_FORCE_" "nbc_col_elpa1_tridi_to_full", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA1_AUTOTUNE_TRIDI_TO_FULL, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA1, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa1_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_elpa2_full_to_band", .description = "Use non blocking collectives for rows in elpa2_bandred", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_elpa2_full_to_band", .env_force = "ELPA_FORCE_" "nbc_row_elpa2_full_to_band", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_FULL_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_elpa2_full_to_band", .description = "Use non blocking collectives for cols in elpa2_bandred", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_elpa2_full_to_band", .env_force = "ELPA_FORCE_" "nbc_col_elpa2_full_to_band", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_FULL_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_all_elpa2_band_to_tridi", .description = "Use non blocking collectives for comm_world in elpa2_band_to_tridi", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_all_elpa2_band_to_tridi", .env_force = "ELPA_FORCE_" "nbc_all_elpa2_band_to_tridi", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_BAND_TO_TRIDI, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_elpa2_tridi_to_band", .description = "Use non blocking collectives for rows in elpa2_tridi_to_band", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_elpa2_tridi_to_band", .env_force = "ELPA_FORCE_" "nbc_row_elpa2_tridi_to_band", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_TRIDI_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_elpa2_tridi_to_band", .description = "Use non blocking collectives for cols in elpa2_tridi_to_band", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_elpa2_tridi_to_band", .env_force = "ELPA_FORCE_" "nbc_col_elpa2_tridi_to_band", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_TRIDI_TO_BAND, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_row_elpa2_band_to_full", .description = "Use non blocking collectives for rows in elpa2_band_to_full", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_row_elpa2_band_to_full", .env_force = "ELPA_FORCE_" "nbc_row_elpa2_band_to_full", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_BAND_TO_FULL, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_col_elpa2_band_to_full", .description = "Use non blocking collectives for cols in elpa2_band_to_full", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_col_elpa2_band_to_full", .env_force = "ELPA_FORCE_" "nbc_col_elpa2_band_to_full", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_BAND_TO_FULL, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_all_elpa2_redist_band", .description = "Use non blocking collectives for comm_world in elpa2_redist_band", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_all_elpa2_redist_band", .env_force = "ELPA_FORCE_" "nbc_all_elpa2_redist_band", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_BAND_TO_TRIDI, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nbc_all_elpa2_main", .description = "Use non blocking collectives for comm_world in elpa2_main", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nbc_all_elpa2_main", .env_force = "ELPA_FORCE_" "nbc_all_elpa2_main", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA2_AUTOTUNE_MAIN, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nbc_elpa2_is_valid, .to_string = ((void*)0), },


        { .base = { .name = "gpu", .description = "Use Nvidia GPU acceleration", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu", .env_force = "ELPA_FORCE_" "gpu", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nvidia_gpu_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "nvidia-gpu", .description = "Use Nvidia GPU acceleration", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "nvidia-gpu", .env_force = "ELPA_FORCE_" "nvidia-gpu", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_FAST, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = nvidia_gpu_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "intel-gpu", .description = "Use INTEL GPU acceleration", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "intel-gpu", .env_force = "ELPA_FORCE_" "intel-gpu", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = intel_gpu_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "amd-gpu", .description = "Use AMD GPU acceleration", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "amd-gpu", .env_force = "ELPA_FORCE_" "amd-gpu", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = amd_gpu_is_valid, .to_string = ((void*)0), },


        { .base = { .name = "sycl_show_all_devices", .description = "Utilize ALL SYCL devices, not just level zero GPUs.", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "sycl_show_all_devices", .env_force = "ELPA_FORCE_" "sycl_show_all_devices", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = expose_all_sycl_devices_is_valid, .to_string = ((void*)0), },



        { .base = { .name = "gpu_hermitian_multiply", .description = "Use GPU acceleration for elpa_hermitian_multiply", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_hermitian_multiply", .env_force = "ELPA_FORCE_" "gpu_hermitian_multiply", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu, .to_string = ((void*)0), },

        { .base = { .name = "gpu_invert_trm", .description = "Use GPU acceleration for elpa_triangular", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_invert_trm", .env_force = "ELPA_FORCE_" "gpu_invert_trm", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu, .to_string = ((void*)0), },

        { .base = { .name = "gpu_cholesky", .description = "Use GPU acceleration for elpa_cholesky", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_cholesky", .env_force = "ELPA_FORCE_" "gpu_cholesky", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu, .to_string = ((void*)0), },

        { .base = { .name = "gpu_tridiag", .description = "Use GPU acceleration for ELPA1 tridiagonalization", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_tridiag", .env_force = "ELPA_FORCE_" "gpu_tridiag", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_MEDIUM, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA1, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu_elpa1, .to_string = ((void*)0), },

        { .base = { .name = "gpu_solve_tridi", .description = "Use GPU acceleration for ELPA solve tridi", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_solve_tridi", .env_force = "ELPA_FORCE_" "gpu_solve_tridi", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_MEDIUM, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu, .to_string = ((void*)0), },

        { .base = { .name = "gpu_trans_ev", .description = "Use GPU acceleration for ELPA1 trans ev", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_trans_ev", .env_force = "ELPA_FORCE_" "gpu_trans_ev", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_MEDIUM, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA1, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu_elpa1, .to_string = ((void*)0), },

        { .base = { .name = "gpu_bandred", .description = "Use GPU acceleration for ELPA2 band reduction", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_bandred", .env_force = "ELPA_FORCE_" "gpu_bandred", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_MEDIUM, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu_elpa2, .to_string = ((void*)0), },




        { .base = { .name = "gpu_trans_ev_tridi_to_band", .description = "Use GPU acceleration for ELPA2 trans_ev_tridi_to_band", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_trans_ev_tridi_to_band", .env_force = "ELPA_FORCE_" "gpu_trans_ev_tridi_to_band", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_MEDIUM, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu_elpa2, .to_string = ((void*)0), },

        { .base = { .name = "gpu_trans_ev_band_to_full", .description = "Use GPU acceleration for ELPA2 trans_ev_band_to_full", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "gpu_trans_ev_band_to_full", .env_force = "ELPA_FORCE_" "gpu_trans_ev_band_to_full", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_MEDIUM, .autotune_level = ELPA_AUTOTUNE_GPU, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = cardinality_bool, .enumerate = enumerate_identity, .valid = valid_with_gpu_elpa2, .to_string = ((void*)0), },


        { .base = { .name = "real_kernel", .description = "Real kernel to use if 'solver' is set to ELPA_SOLVER_2STAGE", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "real_kernel", .env_force = "ELPA_FORCE_" "real_kernel", .print_flag = PRINT_YES, }, .default_value = ELPA_2STAGE_REAL_DEFAULT, .autotune_level_old = ELPA_AUTOTUNE_FAST, .autotune_level = ELPA2_AUTOTUNE_KERNEL, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_REAL, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = number_of_real_kernels, .enumerate = real_kernel_enumerate, .valid = real_kernel_is_valid, .to_string = real_kernel_name, },

        { .base = { .name = "complex_kernel", .description = "Complex kernel to use if 'solver' is set to ELPA_SOLVER_2STAGE", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "complex_kernel", .env_force = "ELPA_FORCE_" "complex_kernel", .print_flag = PRINT_YES, }, .default_value = ELPA_2STAGE_COMPLEX_DEFAULT, .autotune_level_old = ELPA_AUTOTUNE_FAST, .autotune_level = ELPA2_AUTOTUNE_KERNEL, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_COMPLEX, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = number_of_complex_kernels, .enumerate = complex_kernel_enumerate, .valid = complex_kernel_is_valid, .to_string = complex_kernel_name, },






        { .base = { .name = "omp_threads", .description = "OpenMP threads used in ELPA, default 1", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "omp_threads", .env_force = "ELPA_FORCE_" "omp_threads", .print_flag = PRINT_YES, }, .default_value = 1, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_NONE, .cardinality = omp_threads_cardinality, .enumerate = omp_threads_enumerate, .valid = omp_threads_is_valid, .to_string = ((void*)0), },







        { .base = { .name = "internal_nblk", .description = "Internally used block size of scalapack block-cyclic distribution", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "internal_nblk", .env_force = "ELPA_FORCE_" "internal_nblk", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = internal_nblk_cardinality, .enumerate = internal_nblk_enumerate, .valid = internal_nblk_is_valid, .to_string = ((void*)0), },



        { .base = { .name = "min_tile_size", .description = "Minimal tile size used internally in elpa1_tridiag and elpa2_bandred", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "min_tile_size", .env_force = "ELPA_FORCE_" "min_tile_size", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_MEDIUM, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = min_tile_size_cardinality, .enumerate = min_tile_size_enumerate, .valid = min_tile_size_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "intermediate_bandwidth", .description = "Specifies the intermediate bandwidth in ELPA2 full->banded step. Must be a multiple of nblk", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "intermediate_bandwidth", .env_force = "ELPA_FORCE_" "intermediate_bandwidth", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = intermediate_bandwidth_cardinality, .enumerate = intermediate_bandwidth_enumerate, .valid = intermediate_bandwidth_is_valid, .to_string = ((void*)0), },



        { .base = { .name = "blocking_in_band_to_full", .description = "Loop blocking, default 3", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "blocking_in_band_to_full", .env_force = "ELPA_FORCE_" "blocking_in_band_to_full", .print_flag = PRINT_YES, }, .default_value = 3, .autotune_level_old = ELPA_AUTOTUNE_EXTENSIVE, .autotune_level = ELPA2_AUTOTUNE_BAND_TO_FULL_BLOCKING, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = band_to_full_cardinality, .enumerate = band_to_full_enumerate, .valid = band_to_full_is_valid, .to_string = ((void*)0), },


        { .base = { .name = "max_stored_rows", .description = "Maximum number of stored rows used in ELPA 1 backtransformation", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "max_stored_rows", .env_force = "ELPA_FORCE_" "max_stored_rows", .print_flag = PRINT_YES, }, .default_value = default_max_stored_rows, .autotune_level_old = ELPA_AUTOTUNE_EXTENSIVE, .autotune_level = ELPA1_AUTOTUNE_MAX_STORED_ROWS, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ELPA1, .cardinality = max_stored_rows_cardinality, .enumerate = max_stored_rows_enumerate, .valid = max_stored_rows_is_valid, .to_string = ((void*)0), },


        { .base = { .name = "stripewidth_real", .description = "Stripewidth_real, default 48. Must be a multiple of 4", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "stripewidth_real", .env_force = "ELPA_FORCE_" "stripewidth_real", .print_flag = PRINT_YES, }, .default_value = 48, .autotune_level_old = ELPA_AUTOTUNE_EXTENSIVE, .autotune_level = ELPA2_AUTOTUNE_TRIDI_TO_BAND_STRIPEWIDTH, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_REAL, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = stripewidth_real_cardinality, .enumerate = stripewidth_real_enumerate, .valid = stripewidth_real_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "stripewidth_complex", .description = "Stripewidth_complex, default 96. Must be a multiple of 8", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "stripewidth_complex", .env_force = "ELPA_FORCE_" "stripewidth_complex", .print_flag = PRINT_YES, }, .default_value = 96, .autotune_level_old = ELPA_AUTOTUNE_EXTENSIVE, .autotune_level = ELPA2_AUTOTUNE_TRIDI_TO_BAND_STRIPEWIDTH, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_COMPLEX, .autotune_part = ELPA_AUTOTUNE_PART_ELPA2, .cardinality = stripewidth_complex_cardinality, .enumerate = stripewidth_complex_enumerate, .valid = stripewidth_complex_is_valid, .to_string = ((void*)0), },

        { .base = { .name = "min_tile_size", .description = "Minimal tile size used internally in elpa1_tridiag and elpa2_bandred", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "min_tile_size", .env_force = "ELPA_FORCE_" "min_tile_size", .print_flag = PRINT_YES, }, .default_value = 0, .autotune_level_old = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_level = ELPA_AUTOTUNE_NOT_TUNABLE, .autotune_domain = ELPA_AUTOTUNE_DOMAIN_ANY, .autotune_part = ELPA_AUTOTUNE_PART_ANY, .cardinality = min_tile_size_cardinality, .enumerate = min_tile_size_enumerate, .valid = min_tile_size_is_valid, .to_string = ((void*)0), },

};
# 405 "../src/elpa_index.c"
static const elpa_index_float_entry_t float_entries[] = {
        { .base = { .name = "thres_pd_single", .description = "Threshold to define ill-conditioning, default 0.00001", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "thres_pd_single", .env_force = "ELPA_FORCE_" "thres_pd_single", .print_flag = PRINT_YES, }, .default_value = 0.00001, },
};
# 420 "../src/elpa_index.c"
static const elpa_index_double_entry_t double_entries[] = {
        { .base = { .name = "thres_pd_double", .description = "Threshold to define ill-conditioning, default 0.00001", .once = 0, .readonly = 0, .env_default = "ELPA_DEFAULT_" "thres_pd_double", .env_force = "ELPA_FORCE_" "thres_pd_double", .print_flag = PRINT_YES, }, .default_value = 0.00001, },
};

void elpa_index_free(elpa_index_t index) {





        free(index->int_options.values); free(index->int_options.is_set); free(index->int_options.notified); free(index->float_options.values); free(index->float_options.is_set); free(index->float_options.notified); free(index->double_options.values); free(index->double_options.is_set); free(index->double_options.notified);;

        free(index);
}

static int compar(const void *a, const void *b) {
        return __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (((elpa_index_int_entry_t *) a)->base.name) && __builtin_constant_p (((elpa_index_int_entry_t *) b)->base.name) && (__s1_len = strlen (((elpa_index_int_entry_t *) a)->base.name), __s2_len = strlen (((elpa_index_int_entry_t *) b)->base.name), (!((size_t)(const void *)((((elpa_index_int_entry_t *) a)->base.name) + 1) - (size_t)(const void *)(((elpa_index_int_entry_t *) a)->base.name) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((((elpa_index_int_entry_t *) b)->base.name) + 1) - (size_t)(const void *)(((elpa_index_int_entry_t *) b)->base.name) == 1) || __s2_len >= 4)) ? __builtin_strcmp (((elpa_index_int_entry_t *) a)->base.name, ((elpa_index_int_entry_t *) b)->base.name) : (__builtin_constant_p (((elpa_index_int_entry_t *) a)->base.name) && ((size_t)(const void *)((((elpa_index_int_entry_t *) a)->base.name) + 1) - (size_t)(const void *)(((elpa_index_int_entry_t *) a)->base.name) == 1) && (__s1_len = strlen (((elpa_index_int_entry_t *) a)->base.name), __s1_len < 4) ? (__builtin_constant_p (((elpa_index_int_entry_t *) b)->base.name) && ((size_t)(const void *)((((elpa_index_int_entry_t *) b)->base.name) + 1) - (size_t)(const void *)(((elpa_index_int_entry_t *) b)->base.name) == 1) ? __builtin_strcmp (((elpa_index_int_entry_t *) a)->base.name, ((elpa_index_int_entry_t *) b)->base.name) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (((elpa_index_int_entry_t *) b)->base.name); int __result = (((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) a)->base.name))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) a)->base.name))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) a)->base.name))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) a)->base.name))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (((elpa_index_int_entry_t *) b)->base.name) && ((size_t)(const void *)((((elpa_index_int_entry_t *) b)->base.name) + 1) - (size_t)(const void *)(((elpa_index_int_entry_t *) b)->base.name) == 1) && (__s2_len = strlen (((elpa_index_int_entry_t *) b)->base.name), __s2_len < 4) ? (__builtin_constant_p (((elpa_index_int_entry_t *) a)->base.name) && ((size_t)(const void *)((((elpa_index_int_entry_t *) a)->base.name) + 1) - (size_t)(const void *)(((elpa_index_int_entry_t *) a)->base.name) == 1) ? __builtin_strcmp (((elpa_index_int_entry_t *) a)->base.name, ((elpa_index_int_entry_t *) b)->base.name) : (__extension__ ({ const unsigned char *__s1 = (const unsigned char *) (const char *) (((elpa_index_int_entry_t *) a)->base.name); register int __result = __s1[0] - ((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) b)->base.name))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) b)->base.name))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) b)->base.name))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((const unsigned char *) (const char *) (((elpa_index_int_entry_t *) b)->base.name))[3]); } } __result; }))) : __builtin_strcmp (((elpa_index_int_entry_t *) a)->base.name, ((elpa_index_int_entry_t *) b)->base.name)))); });

}
# 452 "../src/elpa_index.c"
static int find_int_entry(char *name) { elpa_index_int_entry_t *entry; elpa_index_int_entry_t key = { .base = {.name = name} } ; size_t nmembers = (sizeof(int_entries)/sizeof(int_entries[0])); entry = lfind((const void*) &key, (const void *) int_entries, &nmembers, sizeof(elpa_index_int_entry_t), compar); if (entry) { return (entry - &int_entries[0]); } else { return -1; } } static int find_float_entry(char *name) { elpa_index_float_entry_t *entry; elpa_index_float_entry_t key = { .base = {.name = name} } ; size_t nmembers = (sizeof(float_entries)/sizeof(float_entries[0])); entry = lfind((const void*) &key, (const void *) float_entries, &nmembers, sizeof(elpa_index_float_entry_t), compar); if (entry) { return (entry - &float_entries[0]); } else { return -1; } } static int find_double_entry(char *name) { elpa_index_double_entry_t *entry; elpa_index_double_entry_t key = { .base = {.name = name} } ; size_t nmembers = (sizeof(double_entries)/sizeof(double_entries[0])); entry = lfind((const void*) &key, (const void *) double_entries, &nmembers, sizeof(elpa_index_double_entry_t), compar); if (entry) { return (entry - &double_entries[0]); } else { return -1; } }
# 487 "../src/elpa_index.c"
static int getenv_int(elpa_index_t index, const char *env_variable, enum NOTIFY_FLAGS notify_flag, int n, int *value, const char *error_string) { int err; char *env_value = getenv(env_variable); if (env_value) { err = elpa_int_string_to_value(int_entries[n].base.name, env_value, value); if (err != ELPA_OK) { fprintf(stderr, "ELPA: Error interpreting environment variable %s with value '%s': %s\n", int_entries[n].base.name, env_value, elpa_strerr(err)); } else { const char *value_string = ((void*)0); if (elpa_int_value_to_string(int_entries[n].base.name, *value, &value_string) == ELPA_OK) { if (!(index->int_options.notified[n] & notify_flag)) { if (elpa_index_is_printing_mpi_rank(index)) { if (elpa_index_int_value_is_set(index, "verbose")) { fprintf(stderr, "ELPA: %s '%s' is set to %s due to environment variable %s\n", error_string, int_entries[n].base.name, value_string, env_variable); } } index->int_options.notified[n] |= notify_flag; } } else { if (elpa_index_is_printing_mpi_rank(index)) { fprintf(stderr, "ELPA: %s '%s' is set to '" "%d" "' due to environment variable %s\n", error_string, int_entries[n].base.name, *value, env_variable); } } return 1; } } return 0; } static int getenv_float(elpa_index_t index, const char *env_variable, enum NOTIFY_FLAGS notify_flag, int n, float *value, const char *error_string) { int err; char *env_value = getenv(env_variable); if (env_value) { err = elpa_float_string_to_value(float_entries[n].base.name, env_value, value); if (err != ELPA_OK) { fprintf(stderr, "ELPA: Error interpreting environment variable %s with value '%s': %s\n", float_entries[n].base.name, env_value, elpa_strerr(err)); } else { const char *value_string = ((void*)0); if (elpa_float_value_to_string(float_entries[n].base.name, *value, &value_string) == ELPA_OK) { if (!(index->float_options.notified[n] & notify_flag)) { if (elpa_index_is_printing_mpi_rank(index)) { if (elpa_index_int_value_is_set(index, "verbose")) { fprintf(stderr, "ELPA: %s '%s' is set to %s due to environment variable %s\n", error_string, float_entries[n].base.name, value_string, env_variable); } } index->float_options.notified[n] |= notify_flag; } } else { if (elpa_index_is_printing_mpi_rank(index)) { fprintf(stderr, "ELPA: %s '%s' is set to '" "%g" "' due to environment variable %s\n", error_string, float_entries[n].base.name, *value, env_variable); } } return 1; } } return 0; } static int getenv_double(elpa_index_t index, const char *env_variable, enum NOTIFY_FLAGS notify_flag, int n, double *value, const char *error_string) { int err; char *env_value = getenv(env_variable); if (env_value) { err = elpa_double_string_to_value(double_entries[n].base.name, env_value, value); if (err != ELPA_OK) { fprintf(stderr, "ELPA: Error interpreting environment variable %s with value '%s': %s\n", double_entries[n].base.name, env_value, elpa_strerr(err)); } else { const char *value_string = ((void*)0); if (elpa_double_value_to_string(double_entries[n].base.name, *value, &value_string) == ELPA_OK) { if (!(index->double_options.notified[n] & notify_flag)) { if (elpa_index_is_printing_mpi_rank(index)) { if (elpa_index_int_value_is_set(index, "verbose")) { fprintf(stderr, "ELPA: %s '%s' is set to %s due to environment variable %s\n", error_string, double_entries[n].base.name, value_string, env_variable); } } index->double_options.notified[n] |= notify_flag; } } else { if (elpa_index_is_printing_mpi_rank(index)) { fprintf(stderr, "ELPA: %s '%s' is set to '" "%g" "' due to environment variable %s\n", error_string, double_entries[n].base.name, *value, env_variable); } } return 1; } } return 0; }
# 516 "../src/elpa_index.c"
int elpa_index_get_int_value(elpa_index_t index, char *name, int *error) { int ret; if (sizeof(int_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_int_entry(name); if (n >= 0) { int from_env = 0; if (!int_entries[n].base.once && !int_entries[n].base.readonly) { from_env = getenv_int(index, int_entries[n].base.env_force, NOTIFY_ENV_FORCE, n, &ret, "Option"); } if (!from_env) { ret = index->int_options.values[n]; } if (error != ((void*)0)) { *error = ELPA_OK; } return ret; } else { if (error != ((void*)0)) { *error = ELPA_ERROR_ENTRY_NOT_FOUND; } return -1; } } float elpa_index_get_float_value(elpa_index_t index, char *name, int *error) { float ret; if (sizeof(float_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_float_entry(name); if (n >= 0) { int from_env = 0; if (!float_entries[n].base.once && !float_entries[n].base.readonly) { from_env = getenv_float(index, float_entries[n].base.env_force, NOTIFY_ENV_FORCE, n, &ret, "Option"); } if (!from_env) { ret = index->float_options.values[n]; } if (error != ((void*)0)) { *error = ELPA_OK; } return ret; } else { if (error != ((void*)0)) { *error = ELPA_ERROR_ENTRY_NOT_FOUND; } return (__builtin_nanf ("")); } } double elpa_index_get_double_value(elpa_index_t index, char *name, int *error) { double ret; if (sizeof(double_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_double_entry(name); if (n >= 0) { int from_env = 0; if (!double_entries[n].base.once && !double_entries[n].base.readonly) { from_env = getenv_double(index, double_entries[n].base.env_force, NOTIFY_ENV_FORCE, n, &ret, "Option"); } if (!from_env) { ret = index->double_options.values[n]; } if (error != ((void*)0)) { *error = ELPA_OK; } return ret; } else { if (error != ((void*)0)) { *error = ELPA_ERROR_ENTRY_NOT_FOUND; } return (__builtin_nanf ("")); } }
# 531 "../src/elpa_index.c"
int* elpa_index_get_int_loc(elpa_index_t index, char *name) { if (sizeof(int_entries) == 0) { return ((void*)0); } int n = find_int_entry(name); if (n >= 0) { return &index->int_options.values[n]; } else { return ((void*)0); } } float* elpa_index_get_float_loc(elpa_index_t index, char *name) { if (sizeof(float_entries) == 0) { return ((void*)0); } int n = find_float_entry(name); if (n >= 0) { return &index->float_options.values[n]; } else { return ((void*)0); } } double* elpa_index_get_double_loc(elpa_index_t index, char *name) { if (sizeof(double_entries) == 0) { return ((void*)0); } int n = find_double_entry(name); if (n >= 0) { return &index->double_options.values[n]; } else { return ((void*)0); } }
# 558 "../src/elpa_index.c"
int elpa_index_set_int_value(elpa_index_t index, char *name, int value) { if (sizeof(int_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_int_entry(name); if (n < 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; }; if (int_entries[n].valid != ((void*)0)) { if(!int_entries[n].valid(index, n, value)) { return ELPA_ERROR_ENTRY_INVALID_VALUE; }; } if (int_entries[n].base.once & index->int_options.is_set[n]) { return ELPA_ERROR_ENTRY_ALREADY_SET; } if (int_entries[n].base.readonly) { return ELPA_ERROR_ENTRY_READONLY; } index->int_options.values[n] = value; index->int_options.is_set[n] = 1; return ELPA_OK; } int elpa_index_set_float_value(elpa_index_t index, char *name, float value) { if (sizeof(float_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_float_entry(name); if (n < 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; }; if (float_entries[n].valid != ((void*)0)) { if(!float_entries[n].valid(index, n, value)) { return ELPA_ERROR_ENTRY_INVALID_VALUE; }; } if (float_entries[n].base.once & index->float_options.is_set[n]) { return ELPA_ERROR_ENTRY_ALREADY_SET; } if (float_entries[n].base.readonly) { return ELPA_ERROR_ENTRY_READONLY; } index->float_options.values[n] = value; index->float_options.is_set[n] = 1; return ELPA_OK; } int elpa_index_set_double_value(elpa_index_t index, char *name, double value) { if (sizeof(double_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_double_entry(name); if (n < 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; }; if (double_entries[n].valid != ((void*)0)) { if(!double_entries[n].valid(index, n, value)) { return ELPA_ERROR_ENTRY_INVALID_VALUE; }; } if (double_entries[n].base.once & index->double_options.is_set[n]) { return ELPA_ERROR_ENTRY_ALREADY_SET; } if (double_entries[n].base.readonly) { return ELPA_ERROR_ENTRY_READONLY; } index->double_options.values[n] = value; index->double_options.is_set[n] = 1; return ELPA_OK; }
# 574 "../src/elpa_index.c"
int elpa_index_set_from_load_int_value(elpa_index_t index, char *name, int value, int explicit) { if (sizeof(int_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_int_entry(name); if (n < 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; }; index->int_options.values[n] = value; if(explicit) index->int_options.is_set[n] = 1; return ELPA_OK; } int elpa_index_set_from_load_float_value(elpa_index_t index, char *name, float value, int explicit) { if (sizeof(float_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_float_entry(name); if (n < 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; }; index->float_options.values[n] = value; if(explicit) index->float_options.is_set[n] = 1; return ELPA_OK; } int elpa_index_set_from_load_double_value(elpa_index_t index, char *name, double value, int explicit) { if (sizeof(double_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_double_entry(name); if (n < 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; }; index->double_options.values[n] = value; if(explicit) index->double_options.is_set[n] = 1; return ELPA_OK; }
# 593 "../src/elpa_index.c"
int elpa_index_int_value_is_set(elpa_index_t index, char *name) { if (sizeof(int_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_int_entry(name); if (n >= 0) { if (index->int_options.is_set[n]) { return 1; } else { return 0; } } else { return ELPA_ERROR_ENTRY_NOT_FOUND; } } int elpa_index_float_value_is_set(elpa_index_t index, char *name) { if (sizeof(float_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_float_entry(name); if (n >= 0) { if (index->float_options.is_set[n]) { return 1; } else { return 0; } } else { return ELPA_ERROR_ENTRY_NOT_FOUND; } } int elpa_index_double_value_is_set(elpa_index_t index, char *name) { if (sizeof(double_entries) == 0) { return ELPA_ERROR_ENTRY_NOT_FOUND; } int n = find_double_entry(name); if (n >= 0) { if (index->double_options.is_set[n]) { return 1; } else { return 0; } } else { return ELPA_ERROR_ENTRY_NOT_FOUND; } }


int elpa_index_value_is_set(elpa_index_t index, char *name) {
        int res = ELPA_ERROR;







        res = elpa_index_int_value_is_set(index, name); if (res >= 0) { return res; } res = elpa_index_float_value_is_set(index, name); if (res >= 0) { return res; } res = elpa_index_double_value_is_set(index, name); if (res >= 0) { return res; }

        fprintf(stderr, "ELPA Error: Could not find entry '%s'\n", name);
        return res;
}

int elpa_index_int_is_valid(elpa_index_t index, char *name, int new_value) {
        int n = find_int_entry(name); if (n >= 0) { if (int_entries[n].valid == ((void*)0)) {


                        return ELPA_OK;
                } else {
                        return int_entries[n].valid(index, n, new_value) ? ELPA_OK : ELPA_ERROR;
                }
        }
        return ELPA_ERROR_ENTRY_NOT_FOUND;
}

int elpa_int_value_to_string(char *name, int value, const char **string) {
        int n = find_int_entry(name);
        if (n < 0) {
                return ELPA_ERROR_ENTRY_NOT_FOUND;
        }
        if (int_entries[n].to_string == ((void*)0)) {
                return ELPA_ERROR_ENTRY_NO_STRING_REPRESENTATION;
        }
        *string = int_entries[n].to_string(value);
        return ELPA_OK;
}


int elpa_int_value_to_strlen(char *name, int value) {
        const char *string = ((void*)0);
        elpa_int_value_to_string(name, value, &string);
        if (string == ((void*)0)) {
                return 0;
        } else {
                return strlen(string);
        }
}


int elpa_index_int_value_to_strlen(elpa_index_t index, char *name) {
        int n = find_int_entry(name);
        if (n < 0) {
                return 0;
        }
        return elpa_int_value_to_strlen(name, index->int_options.values[n]);
}


int elpa_int_string_to_value(char *name, char *string, int *value) {
        int n = find_int_entry(name);
        if (n < 0) {
                return ELPA_ERROR_ENTRY_NOT_FOUND;
        }

        if (int_entries[n].to_string == ((void*)0)) {
                int val, ret;
                ret = sscanf(string, "%d", &val);
                if (ret == 1) {
                        *value = val;
                        return ELPA_OK;
                } else {
                        return ELPA_ERROR_ENTRY_INVALID_VALUE;
                }
        }

        for (int i = 0; i < int_entries[n].cardinality(((void*)0)); i++) {
                int candidate = int_entries[n].enumerate(((void*)0), i);
                if (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (string) && __builtin_constant_p (int_entries[n].to_string(candidate)) && (__s1_len = strlen (string), __s2_len = strlen (int_entries[n].to_string(candidate)), (!((size_t)(const void *)((string) + 1) - (size_t)(const void *)(string) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((int_entries[n].to_string(candidate)) + 1) - (size_t)(const void *)(int_entries[n].to_string(candidate)) == 1) || __s2_len >= 4)) ? __builtin_strcmp (string, int_entries[n].to_string(candidate)) : (__builtin_constant_p (string) && ((size_t)(const void *)((string) + 1) - (size_t)(const void *)(string) == 1) && (__s1_len = strlen (string), __s1_len < 4) ? (__builtin_constant_p (int_entries[n].to_string(candidate)) && ((size_t)(const void *)((int_entries[n].to_string(candidate)) + 1) - (size_t)(const void *)(int_entries[n].to_string(candidate)) == 1) ? __builtin_strcmp (string, int_entries[n].to_string(candidate)) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (int_entries[n].to_string(candidate)); int __result = (((const unsigned char *) (const char *) (string))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (string))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (string))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (string))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (int_entries[n].to_string(candidate)) && ((size_t)(const void *)((int_entries[n].to_string(candidate)) + 1) - (size_t)(const void *)(int_entries[n].to_string(candidate)) == 1) && (__s2_len = strlen (int_entries[n].to_string(candidate)), __s2_len < 4) ? (__builtin_constant_p (string) && ((size_t)(const void *)((string) + 1) - (size_t)(const void *)(string) == 1) ? __builtin_strcmp (string, int_entries[n].to_string(candidate)) : (__extension__ ({ const unsigned char *__s1 = (const unsigned char *) (const char *) (string); register int __result = __s1[0] - ((const unsigned char *) (const char *) (int_entries[n].to_string(candidate)))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((const unsigned char *) (const char *) (int_entries[n].to_string(candidate)))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((const unsigned char *) (const char *) (int_entries[n].to_string(candidate)))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((const unsigned char *) (const char *) (int_entries[n].to_string(candidate)))[3]); } } __result; }))) : __builtin_strcmp (string, int_entries[n].to_string(candidate))))); }) == 0) {
                        *value = candidate;
                        return ELPA_OK;
                }
        }
        return ELPA_ERROR_ENTRY_INVALID_VALUE;
}

int elpa_float_string_to_value(char *name, char *string, float *value) {
        float val;
        int ret = sscanf(string, "%lf", &val);
        if (ret == 1) {
                *value = val;
                return ELPA_OK;
        } else {

                fprintf(stderr, "ELPA: DEBUG: Could not parse float value '%s' for option '%s'\n", string, name);
                return ELPA_ERROR_ENTRY_INVALID_VALUE;
        }
}

int elpa_float_value_to_string(char *name, float value, const char **string) {
        return ELPA_ERROR_ENTRY_NO_STRING_REPRESENTATION;
}

int elpa_double_string_to_value(char *name, char *string, double *value) {
        double val;
        int ret = sscanf(string, "%lf", &val);
        if (ret == 1) {
                *value = val;
                return ELPA_OK;
        } else {

                fprintf(stderr, "ELPA: DEBUG: Could not parse double value '%s' for option '%s'\n", string, name);
                return ELPA_ERROR_ENTRY_INVALID_VALUE;
        }
}

int elpa_double_value_to_string(char *name, double value, const char **string) {
        return ELPA_ERROR_ENTRY_NO_STRING_REPRESENTATION;
}

int elpa_option_cardinality(char *name) {
        int n = find_int_entry(name);
        if (n < 0 || !int_entries[n].cardinality) {
                return ELPA_ERROR_ENTRY_NOT_FOUND;
        }
        return int_entries[n].cardinality(((void*)0));
}

int elpa_option_enumerate(char *name, int i) {
        int n = find_int_entry(name);
        if (n < 0 || !int_entries[n].enumerate) {
                return 0;
        }
        return int_entries[n].enumerate(((void*)0), i);
}



static int cardinality_bool(elpa_index_t index) {
        return 2;
}

static int valid_bool(elpa_index_t index, int n, int new_value) {
        return (0 <= new_value) && (new_value < 2);
}

static int enumerate_identity(elpa_index_t index, int i) {
        return i;
}
# 761 "../src/elpa_index.c"
static const char* elpa_matrix_layout_name(int layout) {
 switch(layout) {
  case 1: return "COLUMN_MAJOR_ORDER"; case 2: return "ROW_MAJOR_ORDER";
  default:
   return "(Invalid matrix layout)";
 }
}

static int number_of_matrix_layouts(elpa_index_t index) {
        return (0 +1 +1);
}

static int matrix_layout_enumerate(elpa_index_t index, int i) {
# 786 "../src/elpa_index.c"
        switch(i) {

                { const int array_of_size_value[1]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 1; } { const int array_of_size_value[2]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 2; }

                default:
                        return 0;
        }
}

static int matrix_layout_is_valid(elpa_index_t index, int n, int new_value) {
        switch(new_value) {
                case 1: return 1; case 2: return 1;
                default:
                        return 0;
        }
}

static const char* elpa_solver_name(int solver) {
        switch(solver) {
                case 1: return "ELPA_SOLVER_1STAGE"; case 2: return "ELPA_SOLVER_2STAGE";
                default:
                        return "(Invalid solver)";
        }
}

static int number_of_solvers(elpa_index_t index) {
        return (0 +1 +1);
}

static int solver_enumerate(elpa_index_t index, int i) {
# 828 "../src/elpa_index.c"
        switch(i) {

                { const int array_of_size_value[1]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 1; } { const int array_of_size_value[2]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 2; }

                default:
                        return 0;
        }
}


static int solver_is_valid(elpa_index_t index, int n, int new_value) {
        switch(new_value) {
                case 1: return 1; case 2: return 1;
                default:
                        return 0;
        }
}

static int number_of_real_kernels(elpa_index_t index) {
        return ELPA_2STAGE_NUMBER_OF_REAL_KERNELS;
}

static int real_kernel_enumerate(elpa_index_t index,int i) {
        switch(i) {

                { const int array_of_size_value[1]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 1; } { const int array_of_size_value[2]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 2; } { const int array_of_size_value[3]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 3; } { const int array_of_size_value[4]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 4; } { const int array_of_size_value[5]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 5; } { const int array_of_size_value[6]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 6; } { const int array_of_size_value[7]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 7; } { const int array_of_size_value[8]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 8; } { const int array_of_size_value[9]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 9; } { const int array_of_size_value[10]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 10; } { const int array_of_size_value[11]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 11; } { const int array_of_size_value[12]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 12; } { const int array_of_size_value[13]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 13; } { const int array_of_size_value[14]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 14; } { const int array_of_size_value[15]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 15; } { const int array_of_size_value[16]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 16; } { const int array_of_size_value[17]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 17; } { const int array_of_size_value[18]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 18; } { const int array_of_size_value[19]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 19; } { const int array_of_size_value[20]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 20; } { const int array_of_size_value[21]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 21; } { const int array_of_size_value[22]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 22; } { const int array_of_size_value[23]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 23; } { const int array_of_size_value[24]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 24; } { const int array_of_size_value[25]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 25; } { const int array_of_size_value[26]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 26; } { const int array_of_size_value[27]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 27; } { const int array_of_size_value[28]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 28; } { const int array_of_size_value[29]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 29; } { const int array_of_size_value[30]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 30; } { const int array_of_size_value[31]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 31; } { const int array_of_size_value[32]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 32; } { const int array_of_size_value[33]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 33; } { const int array_of_size_value[34]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 34; } { const int array_of_size_value[35]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 35; } { const int array_of_size_value[36]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 36; } { const int array_of_size_value[37]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 37; } { const int array_of_size_value[38]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 38; } { const int array_of_size_value[39]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 39; } { const int array_of_size_value[40]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 40; } { const int array_of_size_value[41]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(26 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(27 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(28 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(29 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(30 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(31 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(32 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(33 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(34 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(35 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(36 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(37 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(38 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(39 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(40 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(41 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 41; }

                default:
                        return 0;
        }
}

static const char *real_kernel_name(int kernel) {
        switch(kernel) {
                case 1: return "ELPA_2STAGE_REAL_GENERIC"; case 2: return "ELPA_2STAGE_REAL_GENERIC_SIMPLE"; case 3: return "ELPA_2STAGE_REAL_BGP"; case 4: return "ELPA_2STAGE_REAL_BGQ"; case 5: return "ELPA_2STAGE_REAL_SSE_ASSEMBLY"; case 6: return "ELPA_2STAGE_REAL_SSE_BLOCK2"; case 7: return "ELPA_2STAGE_REAL_SSE_BLOCK4"; case 8: return "ELPA_2STAGE_REAL_SSE_BLOCK6"; case 9: return "ELPA_2STAGE_REAL_AVX_BLOCK2"; case 10: return "ELPA_2STAGE_REAL_AVX_BLOCK4"; case 11: return "ELPA_2STAGE_REAL_AVX_BLOCK6"; case 12: return "ELPA_2STAGE_REAL_AVX2_BLOCK2"; case 13: return "ELPA_2STAGE_REAL_AVX2_BLOCK4"; case 14: return "ELPA_2STAGE_REAL_AVX2_BLOCK6"; case 15: return "ELPA_2STAGE_REAL_AVX512_BLOCK2"; case 16: return "ELPA_2STAGE_REAL_AVX512_BLOCK4"; case 17: return "ELPA_2STAGE_REAL_AVX512_BLOCK6"; case 18: return "ELPA_2STAGE_REAL_NVIDIA_GPU"; case 19: return "ELPA_2STAGE_REAL_AMD_GPU"; case 20: return "ELPA_2STAGE_REAL_INTEL_GPU_SYCL"; case 21: return "ELPA_2STAGE_REAL_SPARC64_BLOCK2"; case 22: return "ELPA_2STAGE_REAL_SPARC64_BLOCK4"; case 23: return "ELPA_2STAGE_REAL_SPARC64_BLOCK6"; case 24: return "ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK2"; case 25: return "ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK4"; case 26: return "ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK6"; case 27: return "ELPA_2STAGE_REAL_VSX_BLOCK2"; case 28: return "ELPA_2STAGE_REAL_VSX_BLOCK4"; case 29: return "ELPA_2STAGE_REAL_VSX_BLOCK6"; case 30: return "ELPA_2STAGE_REAL_SVE128_BLOCK2"; case 31: return "ELPA_2STAGE_REAL_SVE128_BLOCK4"; case 32: return "ELPA_2STAGE_REAL_SVE128_BLOCK6"; case 33: return "ELPA_2STAGE_REAL_SVE256_BLOCK2"; case 34: return "ELPA_2STAGE_REAL_SVE256_BLOCK4"; case 35: return "ELPA_2STAGE_REAL_SVE256_BLOCK6"; case 36: return "ELPA_2STAGE_REAL_SVE512_BLOCK2"; case 37: return "ELPA_2STAGE_REAL_SVE512_BLOCK4"; case 38: return "ELPA_2STAGE_REAL_SVE512_BLOCK6"; case 39: return "ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK4"; case 40: return "ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK6"; case 41: return "ELPA_2STAGE_REAL_NVIDIA_SM80_GPU";
                default:
                        return "(Invalid real kernel)";
        }
}
# 877 "../src/elpa_index.c"
static int real_kernel_is_valid(elpa_index_t index, int n, int new_value) {
        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        if (solver == ELPA_SOLVER_1STAGE) {
                return new_value == ELPA_2STAGE_REAL_DEFAULT;
        }
        int gpu_is_active = (elpa_index_get_int_value(index, "nvidia-gpu", ((void*)0)) || elpa_index_get_int_value(index, "gpu", ((void*)0)) || elpa_index_get_int_value(index, "amd-gpu", ((void*)0)) || elpa_index_get_int_value(index, "intel-gpu", ((void*)0)));
        switch(new_value) {
# 900 "../src/elpa_index.c"
                case 1: return 1 && (1 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 2: return 0 && (2 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 3: return 0 && (3 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 4: return 0 && (4 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 5: return 0 && (5 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 6: return 0 && (6 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 7: return 0 && (7 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 8: return 0 && (8 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 9: return 0 && (9 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 10: return 0 && (10 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 11: return 0 && (11 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 12: return 0 && (12 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 13: return 0 && (13 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 14: return 0 && (14 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 15: return 0 && (15 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 16: return 0 && (16 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 17: return 0 && (17 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 18: return 0 && (18 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 19: return 0 && (19 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 20: return 0 && (20 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 21: return 0 && (21 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 22: return 0 && (22 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 23: return 0 && (23 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 24: return 0 && (24 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 25: return 0 && (25 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 26: return 0 && (26 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 27: return 0 && (27 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 28: return 0 && (28 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 29: return 0 && (29 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 30: return 0 && (30 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 31: return 0 && (31 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 32: return 0 && (32 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 33: return 0 && (33 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 34: return 0 && (34 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 35: return 0 && (35 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 36: return 0 && (36 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 37: return 0 && (37 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 38: return 0 && (38 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 39: return 0 && (39 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 40: return 0 && (40 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1); case 41: return 0 && (41 == ELPA_2STAGE_REAL_NVIDIA_GPU ? gpu_is_active : 1);


                default:
                        return 0;
        }
}

static int number_of_complex_kernels(elpa_index_t index) {
        return ELPA_2STAGE_NUMBER_OF_COMPLEX_KERNELS;
}


static int complex_kernel_enumerate(elpa_index_t index,int i) {
        switch(i) {

                { const int array_of_size_value[1]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 1; } { const int array_of_size_value[2]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 2; } { const int array_of_size_value[3]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 3; } { const int array_of_size_value[4]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 4; } { const int array_of_size_value[5]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 5; } { const int array_of_size_value[6]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 6; } { const int array_of_size_value[7]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 7; } { const int array_of_size_value[8]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 8; } { const int array_of_size_value[9]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 9; } { const int array_of_size_value[10]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 10; } { const int array_of_size_value[11]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 11; } { const int array_of_size_value[12]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 12; } { const int array_of_size_value[13]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 13; } { const int array_of_size_value[14]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 14; } { const int array_of_size_value[15]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 15; } { const int array_of_size_value[16]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 16; } { const int array_of_size_value[17]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 17; } { const int array_of_size_value[18]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 18; } { const int array_of_size_value[19]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 19; } { const int array_of_size_value[20]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 20; } { const int array_of_size_value[21]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 21; } { const int array_of_size_value[22]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 22; } { const int array_of_size_value[23]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 23; } { const int array_of_size_value[24]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 24; } { const int array_of_size_value[25]; case 0 +(1 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(2 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(3 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(4 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(5 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(6 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(7 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(8 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(9 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(10 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(11 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(12 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(13 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(14 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(15 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(16 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(17 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(18 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(19 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(20 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(21 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(22 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(23 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(24 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1) +(25 >= sizeof(array_of_size_value)/sizeof(int) ? 0 : 1): return 25; }

                default:
                        return 0;
        }
}

static const char *complex_kernel_name(int kernel) {
        switch(kernel) {
                case 1: return "ELPA_2STAGE_COMPLEX_GENERIC"; case 2: return "ELPA_2STAGE_COMPLEX_GENERIC_SIMPLE"; case 3: return "ELPA_2STAGE_COMPLEX_BGP"; case 4: return "ELPA_2STAGE_COMPLEX_BGQ"; case 5: return "ELPA_2STAGE_COMPLEX_SSE_ASSEMBLY"; case 6: return "ELPA_2STAGE_COMPLEX_SSE_BLOCK1"; case 7: return "ELPA_2STAGE_COMPLEX_SSE_BLOCK2"; case 8: return "ELPA_2STAGE_COMPLEX_AVX_BLOCK1"; case 9: return "ELPA_2STAGE_COMPLEX_AVX_BLOCK2"; case 10: return "ELPA_2STAGE_COMPLEX_AVX2_BLOCK1"; case 11: return "ELPA_2STAGE_COMPLEX_AVX2_BLOCK2"; case 12: return "ELPA_2STAGE_COMPLEX_AVX512_BLOCK1"; case 13: return "ELPA_2STAGE_COMPLEX_AVX512_BLOCK2"; case 14: return "ELPA_2STAGE_COMPLEX_SVE128_BLOCK1"; case 15: return "ELPA_2STAGE_COMPLEX_SVE128_BLOCK2"; case 16: return "ELPA_2STAGE_COMPLEX_SVE256_BLOCK1"; case 17: return "ELPA_2STAGE_COMPLEX_SVE256_BLOCK2"; case 18: return "ELPA_2STAGE_COMPLEX_SVE512_BLOCK1"; case 19: return "ELPA_2STAGE_COMPLEX_SVE512_BLOCK2"; case 20: return "ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK1"; case 21: return "ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK2"; case 22: return "ELPA_2STAGE_COMPLEX_NVIDIA_GPU"; case 23: return "ELPA_2STAGE_COMPLEX_AMD_GPU"; case 24: return "ELPA_2STAGE_COMPLEX_INTEL_GPU_SYCL"; case 25: return "ELPA_2STAGE_COMPLEX_NVIDIA_SM80_GPU";
                default:
                        return "(Invalid complex kernel)";
        }
}
# 940 "../src/elpa_index.c"
static int complex_kernel_is_valid(elpa_index_t index, int n, int new_value) {
        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        if (solver == ELPA_SOLVER_1STAGE) {
                return new_value == ELPA_2STAGE_COMPLEX_DEFAULT;
        }
        int gpu_is_active = (elpa_index_get_int_value(index, "nvidia-gpu", ((void*)0)) || elpa_index_get_int_value(index, "amd-gpu", ((void*)0)) || elpa_index_get_int_value(index, "intel-gpu", ((void*)0)));
        switch(new_value) {
# 963 "../src/elpa_index.c"
                case 1: return 1 && (1 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 2: return 0 && (2 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 3: return 0 && (3 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 4: return 0 && (4 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 5: return 0 && (5 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 6: return 0 && (6 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 7: return 0 && (7 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 8: return 0 && (8 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 9: return 0 && (9 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 10: return 0 && (10 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 11: return 0 && (11 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 12: return 0 && (12 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 13: return 0 && (13 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 14: return 0 && (14 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 15: return 0 && (15 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 16: return 0 && (16 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 17: return 0 && (17 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 18: return 0 && (18 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 19: return 0 && (19 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 20: return 0 && (20 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 21: return 0 && (21 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 22: return 0 && (22 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 23: return 0 && (23 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 24: return 0 && (24 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1); case 25: return 0 && (25 == ELPA_2STAGE_COMPLEX_NVIDIA_GPU ? gpu_is_active : 1);


                default:
                        return 0;
        }
}

static const char* elpa_autotune_level_name(int level) {
        switch(level) {
                case 0: return "ELPA_AUTOTUNE_NOT_TUNABLE"; case 1: return "ELPA_AUTOTUNE_GPU"; case 2: return "ELPA2_AUTOTUNE_KERNEL"; case 3: return "ELPA_AUTOTUNE_OPENMP"; case 4: return "ELPA_AUTOTUNE_TRANSPOSE_VECTORS"; case 5: return "ELPA2_AUTOTUNE_FULL_TO_BAND"; case 6: return "ELPA2_AUTOTUNE_BAND_TO_TRIDI"; case 7: return "ELPA_AUTOTUNE_SOLVE"; case 8: return "ELPA2_AUTOTUNE_TRIDI_TO_BAND"; case 9: return "ELPA2_AUTOTUNE_BAND_TO_FULL"; case 10: return "ELPA2_AUTOTUNE_MAIN"; case 11: return "ELPA1_AUTOTUNE_FULL_TO_TRIDI"; case 12: return "ELPA1_AUTOTUNE_TRIDI_TO_FULL"; case 13: return "ELPA_AUTOTUNE_MPI"; case 14: return "ELPA_AUTOTUNE_FAST"; case 15: return "ELPA_AUTOTUNE_MEDIUM"; case 16: return "ELPA2_AUTOTUNE_BAND_TO_FULL_BLOCKING"; case 17: return "ELPA1_AUTOTUNE_MAX_STORED_ROWS"; case 18: return "ELPA2_AUTOTUNE_TRIDI_TO_BAND_STRIPEWIDTH"; case 19: return "ELPA_AUTOTUNE_EXTENSIVE";
                default:
                        return "(Invalid autotune level)";
        }
}

static const char* elpa_autotune_domain_name(int domain) {
        switch(domain) {
                case 1: return "ELPA_AUTOTUNE_DOMAIN_REAL"; case 2: return "ELPA_AUTOTUNE_DOMAIN_COMPLEX"; case 3: return "ELPA_AUTOTUNE_DOMAIN_ANY";
                default:
                        return "(Invalid autotune domain)";
        }
}

static const char* elpa_autotune_part_name(int part) {
        switch(part) {
                case 0: return "ELPA_AUTOTUNE_PART_NONE"; case 1: return "ELPA_AUTOTUNE_PART_ANY"; case 2: return "ELPA_AUTOTUNE_PART_GENERALIZED"; case 3: return "ELPA_AUTOTUNE_PART_ELPA1"; case 4: return "ELPA_AUTOTUNE_PART_ELPA2";
                default:
                        return "(Invalid autotune part)";
        }
}


static int na_is_valid(elpa_index_t index, int n, int new_value) {
        return new_value > 0;
}

static int nev_is_valid(elpa_index_t index, int n, int new_value) {
        if (!elpa_index_int_value_is_set(index, "na")) {
                return 0;
        }
        return 0 <= new_value && new_value <= elpa_index_get_int_value(index, "na", ((void*)0));
}

static int is_positive(elpa_index_t index, int n, int new_value) {
        return new_value > 0;
}

static int bw_is_valid(elpa_index_t index, int n, int new_value) {
        int na;
        if (elpa_index_int_value_is_set(index, "na") != 1) {
                return 0;
        }

        na = elpa_index_get_int_value(index, "na", ((void*)0));
        return (2 <= new_value) && (new_value < na);
}

static int output_build_config_is_valid(elpa_index_t index, int n, int new_value) {
        return new_value == 0 || new_value == 1;
}

static int nvidia_gpu_is_valid(elpa_index_t index, int n, int new_value) {



        return new_value == 0;

}

static int amd_gpu_is_valid(elpa_index_t index, int n, int new_value) {



        return new_value == 0;

}

static int intel_gpu_is_valid(elpa_index_t index, int n, int new_value) {



        return new_value == 0;

}

static int expose_all_sycl_devices_is_valid(elpa_index_t index, int n, int new_value) {



        return new_value == 0;

}

static int nbc_is_valid(elpa_index_t index, int n, int new_value) {
        return new_value == 0 || new_value == 1;
}

static int verbose_is_valid(elpa_index_t index, int n, int new_value) {
        return new_value == 0 || new_value == 1;
}

static int nbc_elpa1_is_valid(elpa_index_t index, int n, int new_value) {
        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        if (solver == ELPA_SOLVER_1STAGE) {
                return ((new_value == 0 ) || (new_value == 1));
        }
        else {
                return new_value == 0;
        }
}

static int nbc_elpa2_is_valid(elpa_index_t index, int n, int new_value) {
        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        if (solver == ELPA_SOLVER_2STAGE) {
                return ((new_value == 0 ) || (new_value == 1));
        }
        else {
                return new_value == 0;
        }
}

static int band_to_full_cardinality(elpa_index_t index) {
 return 10;
}
static int band_to_full_enumerate(elpa_index_t index, int i) {
 return i+1;
}

static int internal_nblk_is_valid(elpa_index_t index, int n, int new_value) {
        return (0 <= new_value);
}
static int internal_nblk_cardinality(elpa_index_t index) {
 return 9;
}

static int internal_nblk_enumerate(elpa_index_t index, int i) {
 switch(i) {
   case 0:
     return 2;
   case 1:
     return 4;
   case 2:
     return 8;
   case 3:
     return 16;
   case 4:
     return 32;
   case 5:
     return 64;
   case 6:
     return 128;
   case 7:
     return 256;
   case 8:
     return 1024;
 }
}


static int band_to_full_is_valid(elpa_index_t index, int n, int new_value) {
 int max_block=10;
        return (1 <= new_value) && (new_value <= max_block);
}

static int stripewidth_real_cardinality(elpa_index_t index) {
 return 17;
}

static int stripewidth_complex_cardinality(elpa_index_t index) {
 return 17;
}

static int stripewidth_real_enumerate(elpa_index_t index, int i) {
 switch(i) {
   case 0:
     return 32;
   case 1:
     return 36;
   case 2:
     return 40;
   case 3:
     return 44;
   case 4:
     return 48;
   case 5:
     return 52;
   case 6:
     return 56;
   case 7:
     return 60;
   case 8:
     return 64;
   case 9:
     return 68;
   case 10:
     return 72;
   case 11:
     return 76;
   case 12:
     return 80;
   case 13:
     return 84;
   case 14:
     return 88;
   case 15:
     return 92;
   case 16:
     return 96;
 }
}

static int stripewidth_complex_enumerate(elpa_index_t index, int i) {
 switch(i) {
   case 0:
     return 48;
   case 1:
     return 56;
   case 2:
     return 64;
   case 3:
     return 72;
   case 4:
     return 80;
   case 5:
     return 88;
   case 6:
     return 96;
   case 7:
     return 104;
   case 8:
     return 112;
   case 9:
     return 120;
   case 10:
     return 128;
   case 11:
     return 136;
   case 12:
     return 144;
   case 13:
     return 152;
   case 14:
     return 160;
   case 15:
     return 168;
   case 16:
     return 176;
 }
}

static int stripewidth_real_is_valid(elpa_index_t index, int n, int new_value) {
 return (32 <= new_value) && (new_value <= 96);
}

static int stripewidth_complex_is_valid(elpa_index_t index, int n, int new_value) {
 return (48 <= new_value) && (new_value <= 176);
}

static int omp_threads_cardinality(elpa_index_t index) {
 int max_threads;






 max_threads_glob = 1;
 set_max_threads_glob = 1;

 max_threads = max_threads_glob;
 return max_threads;
}

static int omp_threads_enumerate(elpa_index_t index, int i) {
        return i + 1;
}

static int omp_threads_is_valid(elpa_index_t index, int n, int new_value) {
        int max_threads;






 max_threads_glob_1 = 1;
 set_max_threads_glob_1 = 1;

 max_threads = max_threads_glob_1;
        return (1 <= new_value) && (new_value <= max_threads);
}


static int valid_with_gpu(elpa_index_t index, int n, int new_value) {
        int gpu_is_active = (elpa_index_get_int_value(index, "nvidia-gpu", ((void*)0)) || elpa_index_get_int_value(index, "gpu", ((void*)0)) || elpa_index_get_int_value(index, "amd-gpu", ((void*)0)) || elpa_index_get_int_value(index, "intel-gpu", ((void*)0)));
        if (gpu_is_active == 1) {
                return ((new_value == 0 ) || (new_value == 1));
        }
        else {
                return new_value == 0;
        }
}

static int valid_with_gpu_elpa1(elpa_index_t index, int n, int new_value) {
        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        int gpu_is_active = (elpa_index_get_int_value(index, "nvidia-gpu", ((void*)0)) || elpa_index_get_int_value(index, "gpu", ((void*)0)) || elpa_index_get_int_value(index, "amd-gpu", ((void*)0)) || elpa_index_get_int_value(index, "intel-gpu", ((void*)0)));
        if ( (solver == ELPA_SOLVER_1STAGE) && (gpu_is_active == 1) ) {
                return ((new_value == 0 ) || (new_value == 1));
        }
        else {
                return new_value == 0;
        }
}

static int valid_with_gpu_elpa2(elpa_index_t index, int n, int new_value) {
        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        int gpu_is_active = (elpa_index_get_int_value(index, "nvidia-gpu", ((void*)0)) || elpa_index_get_int_value(index, "gpu", ((void*)0)) || elpa_index_get_int_value(index, "amd-gpu", ((void*)0)) || elpa_index_get_int_value(index, "intel-gpu", ((void*)0)));
        if ( (solver == ELPA_SOLVER_2STAGE) && (gpu_is_active == 1) ) {
                return ((new_value == 0 ) || (new_value == 1));
        }
        else {
                return new_value == 0;
        }
}

static int max_stored_rows_cardinality(elpa_index_t index) {
 return 4;
}

static int max_stored_rows_enumerate(elpa_index_t index, int i) {
  switch(i) {
  case 0:
    return 64;
  case 1:
    return 128;
  case 2:
    return 256;
  case 3:
    return 512;
  }
}

static int max_stored_rows_is_valid(elpa_index_t index, int n, int new_value) {
        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        if (solver == ELPA_SOLVER_2STAGE) {
                return new_value == 15;
        } else {
                return (15 <= new_value) && (new_value <= 127);
        }
}

static int use_gpu_id_cardinality(elpa_index_t index) {
# 1352 "../src/elpa_index.c"
 return 0;

}

static int use_gpu_id_enumerate(elpa_index_t index, int i) {
        fprintf(stderr, "use_gpu_id_is_enumerate should never be called. please report this bug\n");
        return i;
}

static int use_gpu_id_is_valid(elpa_index_t index, int n, int new_value) {
# 1388 "../src/elpa_index.c"
 return 0 == 0;


}


static const int TILE_SIZE_STEP = 128;

static int min_tile_size_cardinality(elpa_index_t index) {
        int na;
        if(index == ((void*)0))
                return 0;
        if (elpa_index_int_value_is_set(index, "na") != 1) {
                return 0;
        }
        na = elpa_index_get_int_value(index, "na", ((void*)0));
        return na/TILE_SIZE_STEP;
}

static int min_tile_size_enumerate(elpa_index_t index, int i) {
        return (i+1) * TILE_SIZE_STEP;
}

static int min_tile_size_is_valid(elpa_index_t index, int n, int new_value) {
       return new_value % TILE_SIZE_STEP == 0;
}

static int intermediate_bandwidth_cardinality(elpa_index_t index) {
        int na, nblk;
        if(index == ((void*)0))
                return 0;
        if (elpa_index_int_value_is_set(index, "na") != 1) {
                return 0;
        }
        na = elpa_index_get_int_value(index, "na", ((void*)0));

        if (elpa_index_int_value_is_set(index, "nblk") != 1) {
                return 0;
        }
        nblk = elpa_index_get_int_value(index, "nblk", ((void*)0));

        return na/nblk;
}

static int intermediate_bandwidth_enumerate(elpa_index_t index, int i) {
        int nblk;
        if(index == ((void*)0))
                return 0;
        if (elpa_index_int_value_is_set(index, "nblk") != 1) {
                return 0;
        }
        nblk = elpa_index_get_int_value(index, "nblk", ((void*)0));

        return (i+1) * nblk;
}

static int intermediate_bandwidth_is_valid(elpa_index_t index, int n, int new_value) {
        int na, nblk;
        if (elpa_index_int_value_is_set(index, "na") != 1) {
                return 0;
        }
        na = elpa_index_get_int_value(index, "na", ((void*)0));

        if (elpa_index_int_value_is_set(index, "nblk") != 1) {
                return 0;
        }
        nblk = elpa_index_get_int_value(index, "nblk", ((void*)0));

        int solver = elpa_index_get_int_value(index, "solver", ((void*)0));
        if (solver == ELPA_SOLVER_1STAGE) {
                return new_value == nblk;
        } else {
                if((new_value <= 1 ) || (new_value > na ))
                  return 0;
                if(new_value % nblk != 0) {
                  fprintf(stderr, "intermediate bandwidth has to be multiple of nblk\n");
                  return 0;
                }
        }
}

static int cannon_buffer_size_cardinality(elpa_index_t index) {
        return 2;
}

static int cannon_buffer_size_enumerate(elpa_index_t index, int i) {
        int np_rows;
        if(index == ((void*)0))
                return 0;
        if (elpa_index_int_value_is_set(index, "num_process_rows") != 1) {
                return 0;
        }
        np_rows = elpa_index_get_int_value(index, "num_process_rows", ((void*)0));


        if(i == 0)
          return 0;
        else
          return np_rows - 1;
}

static int cannon_buffer_size_is_valid(elpa_index_t index, int n, int new_value) {
        int np_rows;
        if(index == ((void*)0))
                return 0;
        if (elpa_index_int_value_is_set(index, "num_process_rows") != 1) {
                return 0;
        }
        np_rows = elpa_index_get_int_value(index, "num_process_rows", ((void*)0));

        return ((new_value >= 0) && (new_value < np_rows));
}

elpa_index_t elpa_index_instance() {
        elpa_index_t index = (elpa_index_t) calloc(1, sizeof(struct elpa_index_struct));
# 1516 "../src/elpa_index.c"
        index->int_options.values = (int*) calloc((sizeof(int_entries)/sizeof(int_entries[0])), sizeof(int)); index->int_options.is_set = (int*) calloc((sizeof(int_entries)/sizeof(int_entries[0])), sizeof(int)); index->int_options.notified = (int*) calloc((sizeof(int_entries)/sizeof(int_entries[0])), sizeof(int)); for (int n = 0; n < (sizeof(int_entries)/sizeof(int_entries[0])); n++) { int default_value = int_entries[n].default_value; if (!int_entries[n].base.once && !int_entries[n].base.readonly) { getenv_int(index, int_entries[n].base.env_default, NOTIFY_ENV_DEFAULT, n, &default_value, "Default for option"); } index->int_options.values[n] = default_value; } index->float_options.values = (float*) calloc((sizeof(float_entries)/sizeof(float_entries[0])), sizeof(float)); index->float_options.is_set = (int*) calloc((sizeof(float_entries)/sizeof(float_entries[0])), sizeof(int)); index->float_options.notified = (int*) calloc((sizeof(float_entries)/sizeof(float_entries[0])), sizeof(int)); for (int n = 0; n < (sizeof(float_entries)/sizeof(float_entries[0])); n++) { float default_value = float_entries[n].default_value; if (!float_entries[n].base.once && !float_entries[n].base.readonly) { getenv_float(index, float_entries[n].base.env_default, NOTIFY_ENV_DEFAULT, n, &default_value, "Default for option"); } index->float_options.values[n] = default_value; } index->double_options.values = (double*) calloc((sizeof(double_entries)/sizeof(double_entries[0])), sizeof(double)); index->double_options.is_set = (int*) calloc((sizeof(double_entries)/sizeof(double_entries[0])), sizeof(int)); index->double_options.notified = (int*) calloc((sizeof(double_entries)/sizeof(double_entries[0])), sizeof(int)); for (int n = 0; n < (sizeof(double_entries)/sizeof(double_entries[0])); n++) { double default_value = double_entries[n].default_value; if (!double_entries[n].base.once && !double_entries[n].base.readonly) { getenv_double(index, double_entries[n].base.env_default, NOTIFY_ENV_DEFAULT, n, &default_value, "Default for option"); } index->double_options.values[n] = default_value; }

        return index;
}

static int is_tunable_but_overriden(elpa_index_t index, int i, int autotune_level_old, int autotune_domain) {
        return (int_entries[i].autotune_level_old != 0) &&
               (int_entries[i].autotune_level_old <= autotune_level_old) &&
               (int_entries[i].autotune_domain & autotune_domain) &&
               (index->int_options.is_set[i]);
}
static int is_tunable_but_overriden_new_stepping(elpa_index_t index, int i, int autotune_level, int autotune_domain, int autotune_part) {
        return (int_entries[i].autotune_level != 0) &&
               (int_entries[i].autotune_level == autotune_level) &&
               (int_entries[i].autotune_domain & autotune_domain) &&
               ((int_entries[i].autotune_part & autotune_part) || (int_entries[i].autotune_part == ELPA_AUTOTUNE_PART_ANY) ) &&
               (index->int_options.is_set[i]);
}

static int is_tunable(elpa_index_t index, int i, int autotune_level_old, int autotune_domain) {
        return (int_entries[i].autotune_level_old != 0) &&
               (int_entries[i].autotune_level_old <= autotune_level_old) &&
               (int_entries[i].autotune_domain & autotune_domain) &&
               (!index->int_options.is_set[i]);
}

static int is_tunable_new_stepping(elpa_index_t index, int i, int autotune_level, int autotune_domain, int autotune_part) {
        return (int_entries[i].autotune_level != 0) &&
               (int_entries[i].autotune_level == autotune_level) &&
               (int_entries[i].autotune_domain & autotune_domain) &&
               ((int_entries[i].autotune_part & autotune_part) || (int_entries[i].autotune_part == ELPA_AUTOTUNE_PART_ANY)) &&
               (!index->int_options.is_set[i]);
}

int elpa_index_autotune_cardinality(elpa_index_t index, int autotune_level_old, int autotune_domain) {
        long int N = 1;

        for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) { if (is_tunable(index, i, autotune_level_old, autotune_domain)) {

                        N *= int_entries[i].cardinality(index);
                }
        }
        return N;
}

int elpa_index_autotune_cardinality_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part) {
        int N = 0;
 int N_level[autotune_level+1];
 for (int i=0;i<autotune_level+1;i++){
   N_level[i] = 1;
 }

 for (int level = 1; level < autotune_level+1; level++) {
           for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) { if (is_tunable_new_stepping(index, i, level, autotune_domain, autotune_part)) {

                        N_level[level] *= int_entries[i].cardinality(index);
                   }
     }
     if (N_level[level] == 1) { N_level[level] = 0;}
          }
 for (int i=1;i<autotune_level+1;i++){
   N += N_level[i];
 }
        return N;
}

void elpa_index_print_int_parameter(elpa_index_t index, char* buff, int i)
{
        int value = index->int_options.values[i];
        sprintf(buff, "%s = ", int_entries[i].base.name);
        if (int_entries[i].to_string) {
                sprintf(buff, "%s%d -> %s\n", buff, value, int_entries[i].to_string(value));
        } else {
                sprintf(buff, "%s%d\n", buff, value);
        }
}

int elpa_index_set_autotune_parameters(elpa_index_t index, int autotune_level_old, int autotune_domain, int current) {
        int current_cpy = current;
        char buff[100];
        int debug = elpa_index_get_int_value(index, "debug", ((void*)0));


        for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
           if (is_tunable(index, i, autotune_level_old, autotune_domain)) {
               int value = int_entries[i].enumerate(index, current_cpy % int_entries[i].cardinality(index));


               if (int_entries[i].valid(index, i, value)) {
                  index->int_options.values[i] = value;
               } else {

                  return 0;
               }
               current_cpy /= int_entries[i].cardinality(index);
           }
        }

        if (debug == 1 && elpa_index_is_printing_mpi_rank(index)) {
                fprintf(stderr, "\n*** AUTOTUNING: setting a new combination of parameters, idx %d for level %s ***\n", current, elpa_autotune_level_name(autotune_level_old));
                elpa_index_print_autotune_parameters(index, autotune_level_old, autotune_domain);
                fprintf(stderr, "***\n\n");
        }


        return 1;
}

int elpa_index_set_autotune_parameters_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part, int current) {
        int current_cpy = current;
        char buff[100];
        int debug = elpa_index_get_int_value(index, "debug", ((void*)0));


        for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
           if (is_tunable_new_stepping(index, i, autotune_level, autotune_domain, autotune_part)) {
               int value = int_entries[i].enumerate(index, current_cpy % int_entries[i].cardinality(index));



               if (int_entries[i].valid(index, i, value)) {
                  index->int_options.values[i] = value;
               } else {

                  return 0;
               }
               current_cpy /= int_entries[i].cardinality(index);
           }
        }

        if (debug == 1 && elpa_index_is_printing_mpi_rank(index)) {
                fprintf(stderr, "\n*** AUTOTUNING: setting a new combination of parameters, idx %d for level %s ***\n", current, elpa_autotune_level_name(autotune_level));
                elpa_index_print_autotune_parameters_new_stepping(index, autotune_level, autotune_domain, autotune_part);
                fprintf(stderr, "***\n\n");
        }


        return 1;
}

int elpa_index_print_autotune_parameters(elpa_index_t index, int autotune_level_old, int autotune_domain) {
        char buff[100];
        if (elpa_index_is_printing_mpi_rank(index)) {
                for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                        if (is_tunable(index, i, autotune_level_old, autotune_domain)) {
                                elpa_index_print_int_parameter(index, buff, i);
                                fprintf(stderr, "%s", buff);
                        }
                }
        }
        return 1;
}

int elpa_index_print_autotune_parameters_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part) {
        char buff[100];
        if (elpa_index_is_printing_mpi_rank(index)) {
                for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                        if (is_tunable_new_stepping(index, i, autotune_level, autotune_domain, autotune_part)) {
                                elpa_index_print_int_parameter(index, buff, i);
                                fprintf(stderr, "%s", buff);
                        }
                }
        }
        return 1;
}

int elpa_index_print_autotune_state(elpa_index_t index, int autotune_level_old, int autotune_domain, int min_loc,
                                    double min_val, int current, int cardinality, char* file_name) {
        char buff[100];
        elpa_index_t index_best;
        int min_loc_cpy = min_loc;
        FILE *f;


        index_best = elpa_index_instance();

        if(min_loc_cpy > -1){
                for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                        if (is_tunable(index, i, autotune_level_old, autotune_domain)) {

                                int value = int_entries[i].enumerate(index, min_loc_cpy % int_entries[i].cardinality(index));

                                index_best->int_options.values[i] = value;
                                min_loc_cpy /= int_entries[i].cardinality(index);
                        }
                }
        }
        if (elpa_index_is_printing_mpi_rank(index)) {
                int output_to_file = (strlen(file_name) > 0);
                if(output_to_file) {
                        f = fopen(file_name, "w");
                        if(f == ((void*)0)){
                                fprintf(stderr, "Cannot open file %s in elpa_index_print_autotune_state\n", file_name);
                                return 0;
                        }
                }
                else {
                        f = stdout;
                }

                if(!output_to_file)
                        fprintf(f, "\n");
                fprintf(f, "*** AUTOTUNING STATE ***\n");
                fprintf(f, "** This is the state of the autotuning object for the current level %s\n",elpa_autotune_level_name(autotune_level_old));
                fprintf(f, "autotune_level = %d -> %s\n", autotune_level_old, elpa_autotune_level_name(autotune_level_old));
                fprintf(f, "autotune_domain = %d -> %s\n", autotune_domain, elpa_autotune_domain_name(autotune_domain));
                fprintf(f, "autotune_cardinality = %d\n", cardinality);
                fprintf(f, "current_idx = %d\n", current);
                fprintf(f, "best_idx = %d\n", min_loc);
                fprintf(f, "best_time = %g\n", min_val);
                if(min_loc_cpy > -1) {
                        fprintf(f, "** The following parameters are autotuned with so far the best values\n");
                        for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                                if (is_tunable(index, i, autotune_level_old, autotune_domain)) {
                                        elpa_index_print_int_parameter(index_best, buff, i);
                                        fprintf(f, "%s", buff);
                                }
                        }
                        fprintf(f, "** The following parameters would be autotuned on the selected autotuning level, but were overridden by the set() method\n");
                        for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                                if (is_tunable_but_overriden(index, i, autotune_level_old, autotune_domain)) {
                                        elpa_index_print_int_parameter(index, buff, i);
                                        fprintf(f, "%s", buff);
                                }
                        }
                }else{
                        fprintf(f, "** No output after first step\n");
                }
                fprintf(f, "*** END OF AUTOTUNING STATE ***\n");

                if(output_to_file)
                        fclose(f);
        }
        elpa_index_free(index_best);

        return 1;
}


int elpa_index_print_autotune_state_new_stepping(elpa_index_t index, int autotune_level, int autotune_domain, int autotune_part, int min_loc,
                                    double min_val, int current, int cardinality, int solver, char* file_name) {
        char buff[100];
        elpa_index_t index_best;
        int min_loc_cpy = min_loc;
        FILE *f;


        index_best = elpa_index_instance();

        if(min_loc_cpy > -1){
                for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                        if (is_tunable_new_stepping(index, i, autotune_level, autotune_domain, autotune_part)) {

                                int value = int_entries[i].enumerate(index, min_loc_cpy % int_entries[i].cardinality(index));

                                index_best->int_options.values[i] = value;
                                min_loc_cpy /= int_entries[i].cardinality(index);
                        }
                }
        }
        if (elpa_index_is_printing_mpi_rank(index)) {
                int output_to_file = (strlen(file_name) > 0);
                if(output_to_file) {
                        f = fopen(file_name, "w");
                        if(f == ((void*)0)){
                                fprintf(stderr, "Cannot open file %s in elpa_index_print_autotune_state\n", file_name);
                                return 0;
                        }
                }
                else {
                        f = stdout;
                }

                if(!output_to_file)
                        fprintf(f, "\n");
                fprintf(f, "*** AUTOTUNING STATE ***\n");
                fprintf(f, "** This is the state of the autotuning object for the current level %s and solver %s\n",elpa_autotune_level_name(autotune_level), elpa_solver_name(solver));
  fprintf(f, "solver = %d -> %s\n", solver, elpa_solver_name(solver));
                fprintf(f, "autotune_level = %d -> %s\n", autotune_level, elpa_autotune_level_name(autotune_level));
                fprintf(f, "autotune_domain = %d -> %s\n", autotune_domain, elpa_autotune_domain_name(autotune_domain));
                fprintf(f, "autotune_cardinality = %d\n", cardinality);
                fprintf(f, "current_idx = %d\n", current);
                fprintf(f, "best_idx = %d\n", min_loc);
                fprintf(f, "best_time = %g\n", min_val);
                if(min_loc_cpy > -1) {
                        fprintf(f, "** The following parameters are autotuned with so far the best values\n");
                        for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                                if (is_tunable_new_stepping(index, i, autotune_level, autotune_domain, autotune_part)) {
                                        elpa_index_print_int_parameter(index_best, buff, i);
                                        fprintf(f, "%s", buff);
                                }
                        }
                        fprintf(f, "** The following parameters would be autotuned on the selected autotuning level, but were overridden by the set() method\n");
                        for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                                if (is_tunable_but_overriden_new_stepping(index, i, autotune_level, autotune_domain, autotune_part)) {
                                        elpa_index_print_int_parameter(index, buff, i);
                                        fprintf(f, "%s", buff);
                                }
                        }
                }else{
                        fprintf(f, "** No output after first step\n");
                }
                fprintf(f, "*** END OF AUTOTUNING STATE ***\n");

                if(output_to_file)
                        fclose(f);
        }
        elpa_index_free(index_best);

        return 1;
}

const int LEN =1000;
# 1853 "../src/elpa_index.c"
static int load_int_line(FILE* f, const char* expected, int* val) { char line[LEN], s[LEN]; int error = 0; int n; if(fgets(line, LEN, f) == ((void*)0)){ fprintf(stderr, "Loading autotuning state error: line is not there\n"); error = 1; } else{ sscanf(line, "%s = " "%d" "\n", s, &n); if(__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (s) && __builtin_constant_p (expected) && (__s1_len = strlen (s), __s2_len = strlen (expected), (!((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) || __s2_len >= 4)) ? __builtin_strcmp (s, expected) : (__builtin_constant_p (s) && ((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) && (__s1_len = strlen (s), __s1_len < 4) ? (__builtin_constant_p (expected) && ((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) ? __builtin_strcmp (s, expected) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (expected); int __result = (((const unsigned char *) (const char *) (s))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (s))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (s))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (s))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (expected) && ((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) && (__s2_len = strlen (expected), __s2_len < 4) ? (__builtin_constant_p (s) && ((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) ? __builtin_strcmp (s, expected) : (__extension__ ({ const unsigned char *__s1 = (const unsigned char *) (const char *) (s); register int __result = __s1[0] - ((const unsigned char *) (const char *) (expected))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((const unsigned char *) (const char *) (expected))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((const unsigned char *) (const char *) (expected))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((const unsigned char *) (const char *) (expected))[3]); } } __result; }))) : __builtin_strcmp (s, expected)))); }) != 0){ fprintf(stderr, "Loading autotuning state error: expected %s, got %s\n", expected, s); error = 1; } else{ *val = n; } } if(error){ fprintf(stderr, "Autotuning state file corrupted\n"); return 0; } return 1; } static int load_float_line(FILE* f, const char* expected, float* val) { char line[LEN], s[LEN]; int error = 0; float n; if(fgets(line, LEN, f) == ((void*)0)){ fprintf(stderr, "Loading autotuning state error: line is not there\n"); error = 1; } else{ sscanf(line, "%s = " "%lg" "\n", s, &n); if(__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (s) && __builtin_constant_p (expected) && (__s1_len = strlen (s), __s2_len = strlen (expected), (!((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) || __s2_len >= 4)) ? __builtin_strcmp (s, expected) : (__builtin_constant_p (s) && ((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) && (__s1_len = strlen (s), __s1_len < 4) ? (__builtin_constant_p (expected) && ((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) ? __builtin_strcmp (s, expected) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (expected); int __result = (((const unsigned char *) (const char *) (s))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (s))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (s))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (s))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (expected) && ((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) && (__s2_len = strlen (expected), __s2_len < 4) ? (__builtin_constant_p (s) && ((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) ? __builtin_strcmp (s, expected) : (__extension__ ({ const unsigned char *__s1 = (const unsigned char *) (const char *) (s); register int __result = __s1[0] - ((const unsigned char *) (const char *) (expected))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((const unsigned char *) (const char *) (expected))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((const unsigned char *) (const char *) (expected))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((const unsigned char *) (const char *) (expected))[3]); } } __result; }))) : __builtin_strcmp (s, expected)))); }) != 0){ fprintf(stderr, "Loading autotuning state error: expected %s, got %s\n", expected, s); error = 1; } else{ *val = n; } } if(error){ fprintf(stderr, "Autotuning state file corrupted\n"); return 0; } return 1; } static int load_double_line(FILE* f, const char* expected, double* val) { char line[LEN], s[LEN]; int error = 0; double n; if(fgets(line, LEN, f) == ((void*)0)){ fprintf(stderr, "Loading autotuning state error: line is not there\n"); error = 1; } else{ sscanf(line, "%s = " "%lg" "\n", s, &n); if(__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (s) && __builtin_constant_p (expected) && (__s1_len = strlen (s), __s2_len = strlen (expected), (!((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) || __s2_len >= 4)) ? __builtin_strcmp (s, expected) : (__builtin_constant_p (s) && ((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) && (__s1_len = strlen (s), __s1_len < 4) ? (__builtin_constant_p (expected) && ((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) ? __builtin_strcmp (s, expected) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (expected); int __result = (((const unsigned char *) (const char *) (s))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (s))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (s))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (s))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (expected) && ((size_t)(const void *)((expected) + 1) - (size_t)(const void *)(expected) == 1) && (__s2_len = strlen (expected), __s2_len < 4) ? (__builtin_constant_p (s) && ((size_t)(const void *)((s) + 1) - (size_t)(const void *)(s) == 1) ? __builtin_strcmp (s, expected) : (__extension__ ({ const unsigned char *__s1 = (const unsigned char *) (const char *) (s); register int __result = __s1[0] - ((const unsigned char *) (const char *) (expected))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((const unsigned char *) (const char *) (expected))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((const unsigned char *) (const char *) (expected))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((const unsigned char *) (const char *) (expected))[3]); } } __result; }))) : __builtin_strcmp (s, expected)))); }) != 0){ fprintf(stderr, "Loading autotuning state error: expected %s, got %s\n", expected, s); error = 1; } else{ *val = n; } } if(error){ fprintf(stderr, "Autotuning state file corrupted\n"); return 0; } return 1; }

int elpa_index_load_autotune_state(elpa_index_t index, int* autotune_level_old, int* autotune_domain, int* min_loc,
                                    double* min_val, int* current, int* cardinality, char* file_name) {
        char line[LEN];
        FILE *f;



                f = fopen(file_name, "r");

                if (f == ((void*)0)) {
                        fprintf(stderr, "Cannont open file %s\n", file_name);
                        return(0);
                }


                if(fgets(line, LEN, f) == ((void*)0)) return 0;
                if(fgets(line, LEN, f) == ((void*)0)) return 0;
                if(! load_int_line(f, "autotune_level", autotune_level_old)) return 0;
                if(! load_int_line(f, "autotune_domain", autotune_domain)) return 0;
                if(! load_int_line(f, "autotune_cardinality", cardinality)) return 0;
                if(! load_int_line(f, "current_idx", current)) return 0;
                if(! load_int_line(f, "best_idx", min_loc)) return 0;
                if(! load_double_line(f, "best_time", min_val)) return 0;
                fclose(f);


        return 1;
}

const char STRUCTURE_PARAMETERS[] = "* Parameters describing structure of the computation:\n";
const char EXPLICIT_PARAMETERS[] = "* Parameters explicitly set by the user:\n";
const char DEFAULT_PARAMETERS[] = "* Parameters with default or environment value:\n";

int elpa_index_print_settings(elpa_index_t index, char *file_name) {
        const int LEN =10000;
        char out_structure[LEN], out_set[LEN], out_defaults[LEN], out_nowhere[LEN], buff[100];
        char (*out)[LEN];
        FILE *f;

        sprintf(out_structure, "%s", STRUCTURE_PARAMETERS);
        sprintf(out_set, "%s", EXPLICIT_PARAMETERS);
        sprintf(out_defaults, "%s", DEFAULT_PARAMETERS);
        sprintf(out_nowhere, "Not to be printed:\n");
        if(elpa_index_is_printing_mpi_rank(index)){
                for (int i = 0; i < (sizeof(int_entries)/sizeof(int_entries[0])); i++) {
                        if(int_entries[i].base.print_flag == PRINT_STRUCTURE) {
                                out = &out_structure;
                        } else if(int_entries[i].base.print_flag == PRINT_YES && index->int_options.is_set[i]) {
                                out = &out_set;
                        } else if(int_entries[i].base.print_flag == PRINT_YES && !index->int_options.is_set[i]) {
                                out = &out_defaults;
                        } else
                                out = &out_nowhere;
                        elpa_index_print_int_parameter(index, buff, i);
                        sprintf(*out, "%s%s", *out, buff);
                }
                int output_to_file = (strlen(file_name) > 0);
                if(output_to_file) {
                        f = fopen(file_name, "w");
                        if(f == ((void*)0)){
                                fprintf(stderr, "Cannot open file %s in elpa_index_print_settings\n", file_name);
                                return 0;
                        }
                }
                else {
                        f = stdout;
                }

                fprintf(f, "*** ELPA STATE ***\n");
                fprintf(f, "%s%s%s", out_structure, out_set, out_defaults);
                fprintf(f, "*** END OF ELPA STATE ***\n");
                if(output_to_file)
                        fclose(f);
        }

        return 1;
}

int elpa_index_load_settings(elpa_index_t index, char *file_name) {
        const int LEN = 1000;
        char line[LEN], s[LEN];
        int n;
        FILE *f;
        int skip, explicit;



                f = fopen(file_name, "r");

                if (f == ((void*)0)) {
                        fprintf(stderr, "Cannont open file %s\n", file_name);
                        return(0);
                }

                skip = 1;
                explicit = 0;

                while ((fgets(line, LEN, f)) != ((void*)0)) {
                        if(__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (line) && __builtin_constant_p (EXPLICIT_PARAMETERS) && (__s1_len = strlen (line), __s2_len = strlen (EXPLICIT_PARAMETERS), (!((size_t)(const void *)((line) + 1) - (size_t)(const void *)(line) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((EXPLICIT_PARAMETERS) + 1) - (size_t)(const void *)(EXPLICIT_PARAMETERS) == 1) || __s2_len >= 4)) ? __builtin_strcmp (line, EXPLICIT_PARAMETERS) : (__builtin_constant_p (line) && ((size_t)(const void *)((line) + 1) - (size_t)(const void *)(line) == 1) && (__s1_len = strlen (line), __s1_len < 4) ? (__builtin_constant_p (EXPLICIT_PARAMETERS) && ((size_t)(const void *)((EXPLICIT_PARAMETERS) + 1) - (size_t)(const void *)(EXPLICIT_PARAMETERS) == 1) ? __builtin_strcmp (line, EXPLICIT_PARAMETERS) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (EXPLICIT_PARAMETERS); int __result = (((const unsigned char *) (const char *) (line))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (line))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (line))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (line))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (EXPLICIT_PARAMETERS) && ((size_t)(const void *)((EXPLICIT_PARAMETERS) + 1) - (size_t)(const void *)(EXPLICIT_PARAMETERS) == 1) && (__s2_len = strlen (EXPLICIT_PARAMETERS), __s2_len < 4) ? (__builtin_constant_p (line) && ((size_t)(const void *)((line) + 1) - (size_t)(const void *)(line) == 1) ? __builtin_strcmp (line, EXPLICIT_PARAMETERS) : (__extension__ ({ const unsigned char *__s1 = (const unsigned char *) (const char *) (line); register int __result = __s1[0] - ((const unsigned char *) (const char *) (EXPLICIT_PARAMETERS))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((const unsigned char *) (const char *) (EXPLICIT_PARAMETERS))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((const unsigned char *) (const char *) (EXPLICIT_PARAMETERS))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((const unsigned char *) (const char *) (EXPLICIT_PARAMETERS))[3]); } } __result; }))) : __builtin_strcmp (line, EXPLICIT_PARAMETERS)))); }) == 0){
                                skip = 0;
                                explicit = 1;
                        }
                        if(__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (line) && __builtin_constant_p (DEFAULT_PARAMETERS) && (__s1_len = strlen (line), __s2_len = strlen (DEFAULT_PARAMETERS), (!((size_t)(const void *)((line) + 1) - (size_t)(const void *)(line) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((DEFAULT_PARAMETERS) + 1) - (size_t)(const void *)(DEFAULT_PARAMETERS) == 1) || __s2_len >= 4)) ? __builtin_strcmp (line, DEFAULT_PARAMETERS) : (__builtin_constant_p (line) && ((size_t)(const void *)((line) + 1) - (size_t)(const void *)(line) == 1) && (__s1_len = strlen (line), __s1_len < 4) ? (__builtin_constant_p (DEFAULT_PARAMETERS) && ((size_t)(const void *)((DEFAULT_PARAMETERS) + 1) - (size_t)(const void *)(DEFAULT_PARAMETERS) == 1) ? __builtin_strcmp (line, DEFAULT_PARAMETERS) : (__extension__ ({ const unsigned char *__s2 = (const unsigned char *) (const char *) (DEFAULT_PARAMETERS); int __result = (((const unsigned char *) (const char *) (line))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((const unsigned char *) (const char *) (line))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((const unsigned char *) (const char *) (line))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((const unsigned char *) (const char *) (line))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (DEFAULT_PARAMETERS) && ((size_t)(const void *)((DEFAULT_PARAMETERS) + 1) - (size_t)(const void *)(DEFAULT_PARAMETERS) == 1) && (__s2_len = strlen (DEFAULT_PARAMETERS), __s2_len < 4) ? (__builtin_constant_p (line) && ((size_t)(const void *)((line) + 1) - (size_t)(const void *)(line) == 1) ? __builtin_strcmp (line, DEFAULT_PARAMETERS) : (__extension__ ({ const unsigned char *__s1 = (const unsigned char *) (const char *) (line); register int __result = __s1[0] - ((const unsigned char *) (const char *) (DEFAULT_PARAMETERS))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((const unsigned char *) (const char *) (DEFAULT_PARAMETERS))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((const unsigned char *) (const char *) (DEFAULT_PARAMETERS))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((const unsigned char *) (const char *) (DEFAULT_PARAMETERS))[3]); } } __result; }))) : __builtin_strcmp (line, DEFAULT_PARAMETERS)))); }) == 0){
                                skip = 0;
                                explicit = 0;
                        }

                        if(line[0] != '\n' && line[0] != '*'){
                                sscanf(line, "%s = %d\n", s, &n);
                                if(! skip){
                                        int error = elpa_index_set_from_load_int_value(index, s, n, explicit);
                                }
                        }
                }
                fclose(f);


        return 1;
}


int elpa_index_is_printing_mpi_rank(elpa_index_t index)
{
  int process_id;
  if(elpa_index_int_value_is_set(index, "process_id")){
    process_id = elpa_index_get_int_value(index, "process_id", ((void*)0));
    return (process_id == 0);
  }
  if (elpa_index_int_value_is_set(index, "verbose")) {
    printf("Warning: process_id not set, printing on all MPI ranks. This can happen with legacy API.");
  }
  return 1;
}
