#pragma once

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


/*! \brief generic C method for elpa_set
 *
 *  \details
 *  \param  handle  handle of the ELPA object for which a key/value pair should be set
 *  \param  name    the name of the key
 *  \param  value   integer/double value to be set for the key
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_set(elpa_t handle, const char *name, int value, int *error)
	{
	elpa_set_integer(handle, name, value, error);
	}
inline void elpa_set(elpa_t handle, const char *name, double value, int *error)
	{
	elpa_set_double(handle, name, value, error);
	}
#else
#define elpa_set(e, name, value, error) _Generic((value), \
                int: \
                  elpa_set_integer, \
                \
                double: \
                  elpa_set_double \
        )(e, name, value, error)
#endif

/*! \brief generic C method for elpa_get
 *
 *  \details
 *  \param  handle  handle of the ELPA object for which a key/value pair should be queried
 *  \param  name    the name of the key
 *  \param  value   integer/double value to be queried
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_get(elpa_t handle, const char *name, int *value, int *error)
	{
	elpa_get_integer(handle, name, value, error);
	}
inline void elpa_get(elpa_t handle, const char *name, double *value, int *error)
	{
	elpa_get_double(handle, name, value, error);
	}
#else
#define elpa_get(e, name, value, error) _Generic((value), \
                int*: \
                  elpa_get_integer, \
                \
                double*: \
                  elpa_get_double \
        )(e, name, value, error)
#endif

/*! \brief generic C method for elpa_eigenvectors
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  a       float/double float complex/double complex pointer to matrix a
 *  \param  ev      on return: float/double pointer to eigenvalues
 *  \param  q       on return: float/double float complex/double complex pointer to eigenvectors
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_eigenvectors(const elpa_t handle, double *a, double *ev, double *q, int *error)
	{
	elpa_eigenvectors_a_h_a_d(handle, a, ev, q, error);
	}

inline void elpa_eigenvectors(const elpa_t handle, float  *a, float  *ev, float  *q, int *error)
	{
	elpa_eigenvectors_a_h_a_f(handle, a, ev, q, error);
	}

inline void elpa_eigenvectors(const elpa_t handle, std::complex<double> *a, double *ev, std::complex<double> *q, int *error)
	{
	elpa_eigenvectors_a_h_a_dc(handle, a, ev, q, error);
	}

inline void elpa_eigenvectors(const elpa_t handle, std::complex<float>  *a, float  *ev, std::complex<float>  *q, int *error)
	{
	elpa_eigenvectors_a_h_a_fc(handle, a, ev, q, error);
	}
#else
#define elpa_eigenvectors(handle, a, ev, q, error) _Generic((a), \
                double*: \
                  elpa_eigenvectors_a_h_a_d, \
                \
                float*: \
                  elpa_eigenvectors_a_h_a_f, \
                \
                double complex*: \
                  elpa_eigenvectors_a_h_a_dc, \
                \
                float complex*: \
                  elpa_eigenvectors_a_h_a_fc \
        )(handle, a, ev, q, error)
#endif

/*! \brief generic C method for elpa_skew_eigenvectors
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  a       float/double float complex/double complex pointer to matrix a
 *  \param  ev      on return: float/double pointer to eigenvalues
 *  \param  q       on return: float/double float complex/double complex pointer to eigenvectors
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_skew_eigenvectors(const elpa_t handle, double *a, double *ev, double *q, int *error)
	{
	elpa_skew_eigenvectors_a_h_a_d(handle, a, ev, q, error);
	}

inline void elpa_skew_eigenvectors(const elpa_t handle, float  *a, float  *ev, float  *q, int *error)
	{
	elpa_skew_eigenvectors_a_h_a_f(handle, a, ev, q, error);
	}
#else
#define elpa_skew_eigenvectors(handle, a, ev, q, error) _Generic((a), \
                double*: \
                  elpa_skew_eigenvectors_a_h_a_d, \
                \
                float*: \
                  elpa_skew_eigenvectors_a_h_a_f \
        )(handle, a, ev, q, error)
#endif


/*! \brief generic C method for elpa_generalized_eigenvectors
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  a       float/double float complex/double complex pointer to matrix a
 *  \param  b       float/double float complex/double complex pointer to matrix b
 *  \param  ev      on return: float/double pointer to eigenvalues
 *  \param  q       on return: float/double float complex/double complex pointer to eigenvectors
 *  \param  is_already_decomposed   set to 1, if b already decomposed by previous call to elpa_generalized
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_generalized_eigenvectors(elpa_t handle, double *a, double *b, double *ev, double *q, int is_already_decomposed, int *error)
	{
	elpa_generalized_eigenvectors_d(handle, a, b, ev, q, is_already_decomposed, error);
	}

inline void elpa_generalized_eigenvectors(elpa_t handle, float  *a, float  *b, float  *ev, float  *q, int is_already_decomposed, int *error)
	{
	elpa_generalized_eigenvectors_f(handle, a, b, ev, q, is_already_decomposed, error);
	}

inline void elpa_generalized_eigenvectors(elpa_t handle, std::complex<double> *a, std::complex<double> *b, double *ev, std::complex<double> *q, int is_already_decomposed, int *error)
	{
	elpa_generalized_eigenvectors_dc(handle, a, b, ev, q, is_already_decomposed, error);
	}

inline void elpa_generalized_eigenvectors(elpa_t handle, std::complex<float>  *a, std::complex<float>  *b, float  *ev, std::complex<float>  *q, int is_already_decomposed, int *error)
	{
	elpa_generalized_eigenvectors_fc(handle, a, b, ev, q, is_already_decomposed, error);
	}
#else
#define elpa_generalized_eigenvectors(handle, a, b, ev, q, is_already_decomposed, error) _Generic((a), \
                double*: \
                  elpa_generalized_eigenvectors_d, \
                \
                float*: \
                  elpa_generalized_eigenvectors_f, \
                \
                double complex*: \
                  elpa_generalized_eigenvectors_dc, \
                \
                float complex*: \
                  elpa_generalized_eigenvectors_fc \
        )(handle, a, b, ev, q, is_already_decomposed, error)
#endif

/*! \brief generic C method for elpa_eigenvalues
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  a       float/double float complex/double complex pointer to matrix a
 *  \param  ev      on return: float/double pointer to eigenvalues
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_eigenvalues(elpa_t handle, double *a, double *ev, int *error)
	{
	elpa_eigenvalues_a_h_a_d(handle, a, ev, error);
	}
inline void elpa_eigenvalues(elpa_t handle, float  *a, float  *ev, int *error)
	{
	elpa_eigenvalues_a_h_a_f(handle, a, ev, error);
	}
inline void elpa_eigenvalues(elpa_t handle, std::complex<double> *a, double *ev, int *error)
	{
	elpa_eigenvalues_a_h_a_dc(handle, a, ev, error);
	}
inline void elpa_eigenvalues(elpa_t handle, std::complex<float>  *a, float  *ev, int *error)
	{
	elpa_eigenvalues_a_h_a_fc(handle, a, ev, error);
	}
#else
#define elpa_eigenvalues(handle, a, ev, error) _Generic((a), \
                double*: \
                  elpa_eigenvalues_a_h_a_d, \
                \
                float*: \
                  elpa_eigenvalues_a_h_a_f, \
                \
                double complex*: \
                  elpa_eigenvalues_a_h_a_dc, \
                \
                float complex*: \
                  elpa_eigenvalues_a_h_a_fc \
        )(handle, a, ev, error)
#endif

/*! \brief generic C method for elpa_skew_eigenvalues
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  a       float/double float complex/double complex pointer to matrix a
 *  \param  ev      on return: float/double pointer to eigenvalues
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_skew_eigenvalues(elpa_t handle, double *a, double *ev, int *error)
	{
	elpa_eigenvalues_a_h_a_d(handle, a, ev, error);
	}
inline void elpa_skew_eigenvalues(elpa_t handle, float  *a, float  *ev, int *error)
	{
	elpa_eigenvalues_a_h_a_f(handle, a, ev, error);
	}
#else
#define elpa_skew_eigenvalues(handle, a, ev, error) _Generic((a), \
                double*: \
                  elpa_skew_eigenvalues_a_h_a_d, \
                \
                float*: \
                  elpa_skew_eigenvalues_a_h_a_f, \
        )(handle, a, ev, error)
#endif

/*  \brief generic C method for elpa_cholesky
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  a       float/double float complex/double complex pointer to matrix a, for which
 *                  the cholesky factorizaion will be computed
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_cholesky(elpa_t handle, double *a, int *error)
	{
	elpa_cholesky_a_h_a_d(handle, a, error);
	}
inline void elpa_cholesky(elpa_t handle, float  *a, int *error)
	{
	elpa_cholesky_a_h_a_f(handle, a, error);
	}
inline void elpa_cholesky(elpa_t handle, std::complex<double> *a, int *error)
	{
	elpa_cholesky_a_h_a_dc(handle, a, error);
	}
inline void elpa_cholesky(elpa_t handle, std::complex<float>  *a, int *error)
	{
	elpa_cholesky_a_h_a_fc(handle, a, error);
	}
#else
#define elpa_cholesky(handle, a, error) _Generic((a), \
                double*: \
                  elpa_cholesky_a_h_a_d, \
                \
                float*: \
                  elpa_cholesky_a_h_a_f, \
                \
                double complex*: \
                  elpa_cholesky_a_h_a_dc, \
                \
                float complex*: \
                  elpa_cholesky_a_h_a_fc \
        )(handle, a, error)
#endif

/*! \brief generic C method for elpa_hermitian_multiply
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  uplo_a  descriptor for matrix a
 *  \param  uplo_c  descriptor for matrix c
 *  \param  ncb     int
 *  \param  a       float/double float complex/double complex pointer to matrix a
 *  \param  b       float/double float complex/double complex pointer to matrix b
 *  \param  nrows_b number of rows for matrix b
 *  \param  ncols_b number of cols for matrix b
 *  \param  c       float/double float complex/double complex pointer to matrix c
 *  \param  nrows_c number of rows for matrix c
 *  \param  ncols_c number of cols for matrix c
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_hermitian_multiply(elpa_t handle, char uplo_a, char uplo_c, int ncb, double *a, double *b, int nrows_b, int ncols_b, double *c, int nrows_c, int ncols_c, int *error)
	{
	elpa_hermitian_multiply_a_h_a_d(handle, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, c, nrows_c, ncols_c, error);
	}
inline void elpa_hermitian_multiply(elpa_t handle, char uplo_a, char uplo_c, int ncb, float  *a, float  *b, int nrows_b, int ncols_b, float  *c, int nrows_c, int ncols_c, int *error)
	{
	elpa_hermitian_multiply_a_h_a_f(handle, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, c, nrows_c, ncols_c, error);
	}
inline void elpa_hermitian_multiply(elpa_t handle, char uplo_a, char uplo_c, int ncb, std::complex<double> *a, std::complex<double> *b, int nrows_b, int ncols_b, std::complex<double> *c, int nrows_c, int ncols_c, int *error)
	{
	elpa_hermitian_multiply_a_h_a_dc(handle, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, c, nrows_c, ncols_c, error);
	}
inline void elpa_hermitian_multiply(elpa_t handle, char uplo_a, char uplo_c, int ncb, std::complex<float>  *a, std::complex<float>  *b, int nrows_b, int ncols_b, std::complex<float>  *c, int nrows_c, int ncols_c, int *error)
	{
	elpa_hermitian_multiply_a_h_a_fc(handle, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, c, nrows_c, ncols_c, error);
	}
#else
#define elpa_hermitian_multiply(handle, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, c, nrows_c, ncols_c, error) _Generic((a), \
                double*: \
                  elpa_hermitian_multiply_a_h_a_d, \
                \
                float*: \
                  elpa_hermitian_multiply_a_h_a_f, \
                \
                double complex*: \
                  elpa_hermitian_multiply_a_h_a_dc, \
                \
                float complex*: \
                  elpa_hermitian_multiply_a_h_a_fc \
        )(handle, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, c, nrows_c, ncols_c, error)
#endif

/*! \brief generic C method for elpa_invert_triangular
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param  a       float/double float complex/double complex pointer to matrix a, which
 *                  should be inverted
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_invert_triangular(elpa_t handle, double *a, int *error)
	{
	elpa_invert_trm_a_h_a_d(handle, a, error);
	}
inline void elpa_invert_triangular(elpa_t handle, float  *a, int *error)
	{
	elpa_invert_trm_a_h_a_f(handle, a, error);
	}
inline void elpa_invert_triangular(elpa_t handle, std::complex<double> *a, int *error)
	{
	elpa_invert_trm_a_h_a_dc(handle, a, error);
	}
inline void elpa_invert_triangular(elpa_t handle, std::complex<float>  *a, int *error)
	{
	elpa_invert_trm_a_h_a_fc(handle, a, error);
	}
#else
#define elpa_invert_triangular(handle, a, error) _Generic((a), \
                double*: \
                  elpa_invert_trm_a_h_a_d, \
                \
                float*: \
                  elpa_invert_trm_a_h_a_f, \
                \
                double complex*: \
                  elpa_invert_trm_a_h_a_dc, \
                \
                float complex*: \
                  elpa_invert_trm_a_h_a_fc \
        )(handle, a, error)
#endif

/*! \brief generic C method for elpa_solve_tridiagonal
 *
 *  \details
 *  \param  handle  handle of the ELPA object, which defines the problem
 *  \param d        float/double pointer to array d;  on input diagonal elements of tridiagonal matrix,
 *                                                    on return the eigenvalues in ascending order
 *  \param e        float/double pointer to array e; on input subdiagonal elements of matrix, on return destroyed
 *  \param q        on return float/double pointer to eigenvectors
 *  \param  error   on return the error code, which can be queried with elpa_strerr()
 *  \result void
 */
#ifdef __cplusplus
inline void elpa_solve_tridiagonal(elpa_t handle, double *d, double *e, double *q, int *error)
	{
	elpa_solve_tridiagonal_d(handle, d, e, q, error);
	}
inline void elpa_solve_tridiagonal(elpa_t handle, float  *d, float  *e, float  *q, int *error)
	{
	elpa_solve_tridiagonal_f(handle, d, e, q, error);
	}
#else
#define elpa_solve_tridiagonal(handle, d, e, q, error) _Generic((d), \
                double*: \
                  elpa_solve_tridiagonal_d, \
                \
                float*: \
                  elpa_solve_tridiagonal_f \
        )(handle, d, e, q, error)
#endif
