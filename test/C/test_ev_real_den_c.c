/* Copyright (c) 2015-2021, the ELSI team.
   All rights reserved.

   This file is part of ELSI and is distributed under the BSD 3-clause license,
   which may be found in the LICENSE file in the ELSI root directory. */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>
#include <elsi.h>

void test_ev_real_den_c(MPI_Comm comm,
                        int solver,
                        char *h_file,
                        char *s_file) {

   int n_proc;
   int n_prow;
   int n_pcol;
   int myid;
   int blacs_ctxt;
   int blk;
   int l_row;
   int l_col;
   int l_size;
   int n_basis;
   int n_states;
   int format;
   int parallel;
   int tmp;
   int i;

   double n_electrons;
   double *h;
   double *s;
   double *eval;
   double *evec;
   double e_ref;
   double e_test;
   double e_tol;

   MPI_Fint comm_f;
   elsi_handle eh;
   elsi_rw_handle rwh;

   e_ref = -2564.61963724048;
   e_tol = 0.00000001;

   MPI_Comm_size(comm,&n_proc);
   MPI_Comm_rank(comm,&myid);

   // Fortran communicator
   comm_f = MPI_Comm_c2f(comm);

   // Parameters
   blk = 16;
   format = 0; // BLACS_DENSE

   tmp = (int) round(sqrt((double) n_proc));
   for (n_pcol=tmp; n_pcol>1; n_pcol--) {
	if (n_proc%n_pcol == 0) {
	break;
	}
   }
   n_prow = n_proc/n_pcol;

   // Set up BLACS
   blacs_ctxt = Csys2blacs_handle(comm);
   Cblacs_gridinit(&blacs_ctxt,"R",n_prow,n_pcol);

   // Read H and S matrices
   c_elsi_init_rw(&rwh,0,1,0,0.0);
   c_elsi_set_rw_mpi(rwh,comm_f);
   c_elsi_set_rw_blacs(rwh,blacs_ctxt,blk);

   c_elsi_read_mat_dim(rwh,h_file,&n_electrons,&n_basis,&l_row,&l_col);

   l_size = l_row * l_col;
   h = malloc(l_size * sizeof(double));
   s = malloc(l_size * sizeof(double));
   evec = malloc(l_size * sizeof(double));
   eval = malloc(n_basis * sizeof(double));

   c_elsi_read_mat_real(rwh,h_file,h);
   c_elsi_read_mat_real(rwh,s_file,s);

   c_elsi_finalize_rw(rwh);

   if (n_electrons > n_basis) {
       n_states = n_basis;
   }
   else {
       n_states = n_electrons;
   }


   // Initialize ELSI
   if (n_proc == 1) {
       parallel = 0; // Test SINGLE_PROC mode

       c_elsi_init(&eh,solver,parallel,format,n_basis,n_electrons,n_states);
   }
   else {
       parallel = 1; // Test MULTI_PROC mode

       c_elsi_init(&eh,solver,parallel,format,n_basis,n_electrons,n_states);
       c_elsi_set_mpi(eh,comm_f);
       c_elsi_set_blacs(eh,blacs_ctxt,blk);
   }

   // Customize ELSI
   c_elsi_set_output(eh,2);
   c_elsi_set_chase_tol(eh,1e-10);
   c_elsi_set_chase_cholqr(eh, 0);

   // Call ELSI eigensolver
   c_elsi_ev_real(eh,h,s,eval,evec);

   // Finalize ELSI
   c_elsi_finalize(eh);

   e_test = 0.0;
   for (i=0; i<n_states; i++) {
        e_test += 2.0*eval[i];
   }

   if (myid == 0) {
       if (fabs(e_test-e_ref) < e_tol) {
           printf("  Passed.\n");
       }else{
           printf("  not Passed: %f\n", fabs(e_test-e_ref));
       }
   }

   free(h);
   free(s);
   free(evec);
   free(eval);

   Cblacs_gridexit(blacs_ctxt);

   return;
}
