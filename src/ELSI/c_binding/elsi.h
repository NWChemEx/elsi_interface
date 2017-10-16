/*
 Copyright (c) 2015-2017, the ELSI team. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  * Neither the name of the "ELectronic Structure Infrastructure" project nor
    the names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef ELSI_H_INCLUDED
#define ELSI_H_INCLUDED

#include <complex.h>

#define DECLARE_HANDLE(name) struct name##__ { int unused; }; \
                             typedef struct name##__ *name

DECLARE_HANDLE(elsi_handle);
DECLARE_HANDLE(elsi_rw_handle);

#ifdef __cplusplus
extern "C"{
#endif

void c_elsi_init(elsi_handle *handle_c,
                 int solver,
                 int parallel_mode,
                 int matrix_format,
                 int n_basis,
                 double n_electron,
                 int n_state);

void c_elsi_set_mpi(elsi_handle handle_c,
                    int mpi_comm);

void c_elsi_set_mpi_global(elsi_handle handle_c,
                           int mpi_comm_global);

void c_elsi_set_spin(elsi_handle handle_c,
                     int n_spin,
                     int i_spin);

void c_elsi_set_kpoint(elsi_handle handle_c,
                       int n_kpt,
                       int i_kpt,
                       double weight);

void c_elsi_set_blacs(elsi_handle handle_c,
                      int blacs_ctxt,
                      int block_size);

void c_elsi_set_csc(elsi_handle handle_c,
                    int nnz,
                    int nnz_l,
                    int n_lcol,
                    int *row_ind,
                    int *col_ptr);

void c_elsi_finalize(elsi_handle handle_c);

void c_elsi_ev_real(elsi_handle handle_c,
                    double *ham,
                    double *ovlp,
                    double *eval,
                    double *evec);

void c_elsi_ev_complex(elsi_handle handle_c,
                       double _Complex *ham,
                       double _Complex *ovlp,
                       double *eval,
                       double _Complex *evec);

void c_elsi_ev_real_sparse(elsi_handle handle_c,
                           double *ham,
                           double *ovlp,
                           double *eval,
                           double *evec);

void c_elsi_ev_complex_sparse(elsi_handle handle_c,
                              double _Complex *ham,
                              double _Complex *ovlp,
                              double *eval,
                              double _Complex *evec);

void c_elsi_dm_real(elsi_handle handle_c,
                    double *ham,
                    double *ovlp,
                    double *dm,
                    double *energy);

void c_elsi_dm_complex(elsi_handle handle_c,
                       double _Complex *ham,
                       double _Complex *ovlp,
                       double _Complex *dm,
                       double *energy);

void c_elsi_dm_real_sparse(elsi_handle handle_c,
                           double *ham,
                           double *ovlp,
                           double *dm,
                           double *energy);

void c_elsi_dm_complex_sparse(elsi_handle handle_c,
                              double _Complex *ham,
                              double _Complex *ovlp,
                              double _Complex *dm,
                              double *energy);

void c_elsi_set_output(elsi_handle handle_c,
                       int out_level);

void c_elsi_set_unit_ovlp(elsi_handle handle_c,
                          int unit_ovlp);

void c_elsi_set_zero_def(elsi_handle handle_c,
                         double zero_def);

void c_elsi_set_sing_check(elsi_handle handle_c,
                           int sing_check);

void c_elsi_set_sing_tol(elsi_handle handle_c,
                         double sing_tol);

void c_elsi_set_sing_stop(elsi_handle handle_c,
                          int sing_stop);

void c_elsi_set_uplo(elsi_handle handle_c,
                     int uplo);

void c_elsi_set_elpa_solver(elsi_handle handle_c,
                            int elpa_solver);

void c_elsi_set_elpa_n_single(elsi_handle handle_c,
                              int n_single);

void c_elsi_set_omm_flavor(elsi_handle handle_c,
                           int omm_flavor);

void c_elsi_set_omm_n_elpa(elsi_handle handle_c,
                           int n_elpa);

void c_elsi_set_omm_tol(elsi_handle handle_c,
                        double min_tol);

void c_elsi_set_omm_ev_shift(elsi_handle handle_c,
                             double ev_shift);

void c_elsi_set_omm_psp(elsi_handle handle_c,
                        int use_psp);

void c_elsi_set_pexsi_n_mu(elsi_handle handle_c,
                           int n_mu);

void c_elsi_set_pexsi_n_pole(elsi_handle handle_c,
                             int n_pole);

void c_elsi_set_pexsi_np_per_pole(elsi_handle handle_c,
                                  int np_per_pole);

void c_elsi_set_pexsi_np_symbo(elsi_handle handle_c,
                               int np_symbo);

void c_elsi_set_pexsi_temp(elsi_handle handle_c,
                           double temp);

void c_elsi_set_pexsi_gap(elsi_handle handle_c,
                          double gap);

void c_elsi_set_pexsi_delta_e(elsi_handle handle_c,
                              double delta_e);

void c_elsi_set_pexsi_mu_min(elsi_handle handle_c,
                             double mu_min);

void c_elsi_set_pexsi_mu_max(elsi_handle handle_c,
                             double mu_max);

void c_elsi_set_pexsi_inertia_tol(elsi_handle handle_c,
                                  double inertia_tol);

void c_elsi_set_chess_erf_decay(elsi_handle handle_c,
                                double decay);

void c_elsi_set_chess_erf_decay_min(elsi_handle handle_c,
                                    double decay_min);

void c_elsi_set_chess_erf_decay_max(elsi_handle handle_c,
                                    double decay_max);

void c_elsi_set_chess_ev_ham_min(elsi_handle handle_c,
                                 double ev_min);

void c_elsi_set_chess_ev_ham_max(elsi_handle handle_c,
                                 double ev_max);

void c_elsi_set_chess_ev_ovlp_min(elsi_handle handle_c,
                                  double ev_min);

void c_elsi_set_chess_ev_ovlp_max(elsi_handle handle_c,
                                  double ev_max);

void c_elsi_set_sips_n_elpa(elsi_handle handle_c,
                            int n_elpa);

void c_elsi_set_sips_slice_type(elsi_handle handle_c,
                                int inertia_tol);

void c_elsi_set_sips_n_slice(elsi_handle handle_c,
                             int n_slice);

void c_elsi_set_sips_inertia(elsi_handle handle_c,
                             int do_inertia);

void c_elsi_set_sips_left_bound(elsi_handle handle_c,
                                int left_bound);

void c_elsi_set_sips_slice_buf(elsi_handle handle_c,
                               double slice_buffer);

void c_elsi_set_sips_ev_min(elsi_handle handle_c,
                            double ev_min);

void c_elsi_set_sips_ev_max(elsi_handle handle_c,
                            double ev_max);

void c_elsi_set_mu_broaden_scheme(elsi_handle handle_c,
                                  int broaden_scheme);

void c_elsi_set_mu_broaden_width(elsi_handle handle_c,
                                 double broaden_width);

void c_elsi_set_mu_tol(elsi_handle handle_c,
                       double mu_tol);

void c_elsi_set_mu_spin_degen(elsi_handle handle_c,
                              double spin_degen);

void c_elsi_get_pexsi_mu_min(elsi_handle handle_c,
                             double *mu_min);

void c_elsi_get_pexsi_mu_max(elsi_handle handle_c,
                             double *mu_max);

void c_elsi_get_ovlp_sing(elsi_handle handle_c,
                          int *ovlp_sing);

void c_elsi_get_n_sing(elsi_handle handle_c,
                       int *n_sing);

void c_elsi_get_mu(elsi_handle handle_c,
                   double *mu);

void c_elsi_get_edm_real(elsi_handle handle_c,
                         double *edm);

void c_elsi_get_edm_complex(elsi_handle handle_c,
                            double _Complex *edm);

void c_elsi_get_edm_real_sparse(elsi_handle handle_c,
                                double *edm);

void c_elsi_get_edm_complex_sparse(elsi_handle handle_c,
                                   double _Complex *edm);

void c_elsi_init_rw(elsi_rw_handle *handle_c,
                    int rw_task,
                    int parallel_mode,
                    int file_format,
                    int n_basis,
                    double n_electron);

void c_elsi_set_rw_mpi(elsi_rw_handle handle_c,
                       int mpi_comm);

void c_elsi_set_rw_blacs(elsi_rw_handle handle_c,
                         int blacs_ctxt,
                         int block_size);

void c_elsi_set_rw_csc(elsi_rw_handle handle_c,
                       int nnz,
                       int nnz_l,
                       int n_lcol);

void c_elsi_finalize_rw(elsi_rw_handle handle_c);

void c_elsi_set_rw_output(elsi_rw_handle handle_c,
                          int out_level);

void c_elsi_set_rw_zero_def(elsi_rw_handle handle_c,
                            double zero_def);

void c_elsi_read_mat_dim(elsi_rw_handle handle_c,
                         char *name_c,
                         double *n_electrons,
                         int *n_basis,
                         int *n_lrow,
                         int *n_lcol);

void c_elsi_read_mat_dim_sparse(elsi_rw_handle handle_c,
                                char *name_c,
                                double *n_electrons,
                                int *n_basis,
                                int *nnz_g,
                                int *nnz_l,
                                int *n_lcol);

void c_elsi_read_mat_real(elsi_rw_handle handle_c,
                          char *name_c,
                          double *mat);

void c_elsi_read_mat_real_sparse(elsi_rw_handle handle_c,
                                 char *name_c,
                                 int *row_ind,
                                 int *col_ptr,
                                 double *mat);

void c_elsi_write_mat_real(elsi_rw_handle handle_c,
                           char *name_c,
                           double *mat);

void c_elsi_write_mat_real_sparse(elsi_rw_handle handle_c,
                                  char *name_c,
                                  int *row_ind,
                                  int *col_ptr,
                                  double *mat);

void c_elsi_read_mat_complex(elsi_rw_handle handle_c,
                             char *name_c,
                             double _Complex *mat);

void c_elsi_read_mat_complex_sparse(elsi_rw_handle handle_c,
                                    char *name_c,
                                    int *row_ind,
                                    int *col_ptr,
                                    double _Complex *mat);

void c_elsi_write_mat_complex(elsi_rw_handle handle_c,
                              char *name_c,
                              double _Complex *mat);

void c_elsi_write_mat_complex_sparse(elsi_rw_handle handle_c,
                                     char *name_c,
                                     int *row_ind,
                                     int *col_ptr,
                                     double _Complex *mat);

#ifdef __cplusplus
}
#endif

#endif
