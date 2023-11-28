elpa_dir=/scratch1/05979/uthpala/elpa-2023.05.001/build_generic
for file in \
  aligned_mem.f90                       \
  check_for_gpu.f90                     \
  mod_elpa_multiply_a_b.F90            \
  elpa1_auxiliary.f90                   \
  mod_vendor_agnostic_layer_utilities.F90 \
  elpa1_compute_private.f90             \
  elpa1.f90                             \
  elpa2_compute.f90                     \
  elpa2_determine_workload.f90          \
  elpa2.f90                             \
  mod_gpu_setup.F90                     \
  elpa_abstract_impl.f90                \
  mod_openmp_offload.F90                \
  mod_sycl.F90                          \
  elpa_api.f90                          \
  elpa_autotune_impl.f90                \
  elpa_constants.f90                    \
  elpa.f90                              \
  elpa_impl.f90                         \
  elpa_utilities.f90                    \
  ftimings.f90                          \
  ftimings_type.f90                     \
  ftimings_value.f90                    \
  mod_blas_interfaces.f90               \
  mod_elpa_skewsymmetric_blas.f90       \
  mod_omp.f90                           \
  mod_pack_unpack_cpu.f90               \
  mod_pack_unpack_gpu.f90               \
  mod_precision.f90                     \
  mod_redist_band.f90                   \
  mod_scalapack_interfaces.f90          \
  mod_vendor_agnostic_layer.f90         \
  mod_vendor_agnostic_general_layer.F90 \
  mod_vendor_agnostic_blas_layer.F90    \
  mod_vendor_agnostic_solver_layer.F90  \
  matrix_plot.f90                       \
  merge_recursive.f90                   \
  merge_systems.f90                     \
  distribute_global_column.f90          \
  single_hh_trafo_real.f90              \
  global_product.f90                    \
  global_gather.f90                     \
  resort_ev.f90                         \
  transform_columns.f90                 \
  check_monotony.f90                    \
  add_tmp.f90                           \
  v_add_s.f90                           \
  solve_secular_equation.f90            \
  mod_invert_trm_gpu.F90                \
  mod_cholesky_gpu.F90                  \
  elpa_cholesky.f90                     \
  elpa_invert_trm.f90                   \
  solve_tridi.f90                       \
  mod_thread_affinity.f90               \
  elpa_pdgeqrf.f90                      \
  elpa_pdlarfb.f90                      \
  qr_utils.f90                          \
  elpa_qrkernels.f90                    \
  tests_variable_definitions.f90
do
prefix=${file%.*}
echo $prefix
origin_file=`ls $elpa_dir/*$prefix.F90* | tail -n 1`
cp $origin_file $file
done
cp $elpa_dir/config.h .

elpa_dir=/scratch1/05979/uthpala/elpa-2023.05.001/build_generic
 for file in \
   mod_cuda_stub.f90 \
   mod_hip_stub.f90 \
   interface_c_cuda_kernel_stub.f90 \
   interface_c_sycl_kernel_stub.F90   \
   interface_c_gpu_kernel_stub.f90 \
   interface_c_hip_kernel_stub.f90 \
   test_gpu_vendor_agnostic_layer_stub.f90 \
   cholesky_cuda_stub.f90 \
   invert_trm_cuda_stub.f90
 do
 prefix=${file%_stub.*}
 echo $prefix
 origin_file=`ls $elpa_dir/*$prefix.F90* | tail -n 1`
 echo $origin_file
 cp $origin_file $file
 done
cp $elpa_dir/cannon.c .
cp $elpa_dir/check_thread_affinity.c .
cp $elpa_dir/elpa_index.c .

elpa_dir=/scratch1/05979/uthpala/elpa-2023.05.001/build_cuda
for file in \
  mod_cuda.f90 \
  interface_c_cuda_kernel.f90 \
  interface_c_gpu_kernel.f90 \
  test_gpu_vendor_agnostic_layer.f90 \
  cholesky_cuda.f90 \
  invert_trm_cuda.f90 \
  test_cuda.f90
do
prefix=${file%.*}
echo $prefix
origin_file=`ls $elpa_dir/*$prefix.F90* | tail -n 1`
#echo $origin_file
cp $origin_file $file
done


elpa_dir=/scratch1/05979/uthpala/elpa-2023.05.001/src
for file in \
  elpa_c_interface.c
do
echo $file
origin_file=`ls $elpa_dir/$file | tail -n 1`
#echo $origin_file
cp $origin_file $file
done
cp $elpa_dir/elpa_index.h .

elpa_dir=/scratch1/05979/uthpala/elpa-2023.05.001/src/ftimings
for file in \
  highwater_mark.c \
  resident_set_size.c \
  time.c \
  virtual_memory.c
do
echo $file
origin_file=`ls $elpa_dir/$file | tail -n 1`
#echo $origin_file
cp $origin_file $file
done

elpa_dir=/scratch1/05979/uthpala/elpa-2023.05.001/elpa
mkdir elpa
cp $elpa_dir/elpa_constants.h.in elpa
cp $elpa_dir/elpa.h elpa
cp $elpa_dir/elpa_generic.h elpa
cp $elpa_dir/elpa_explicit_name.h elpa

cp ../../ELPA/src/mod_mpi.f90 .
cp ../../ELPA/src/mod_mpifh.f90 .

elpa_dir=/scratch1/05979/uthpala/elpa-2023.05.001/build_generic
elpa_dir_avx=/scratch1/05979/uthpala/elpa-2023.05.001/build_avx
elpa_dir_avx2=/scratch1/05979/uthpala/elpa-2023.05.001/build_avx2
elpa_dir_avx512=/scratch1/05979/uthpala/elpa-2023.05.001/build_avx512
elpa_dir_cuda=/scratch1/05979/uthpala/elpa-2023.05.001/build_cuda

origin_file=`ls $elpa_dir/*mod_compute_hh_trafo* | tail -n 1`
cp $origin_file mod_compute_hh_trafo.f90

origin_file=`ls $elpa_dir_avx/*mod_compute_hh_trafo* | tail -n 1`
cp $origin_file mod_compute_hh_trafo_avx.f90

origin_file=`ls $elpa_dir_avx2/*mod_compute_hh_trafo* | tail -n 1`
cp $origin_file mod_compute_hh_trafo_avx2.f90

origin_file=`ls $elpa_dir_avx512/*mod_compute_hh_trafo* | tail -n 1`
cp $origin_file mod_compute_hh_trafo_avx512.f90

origin_file=`ls $elpa_dir_cuda/*mod_compute_hh_trafo* | tail -n 1`
cp $origin_file mod_compute_hh_trafo_cuda.f90

origin_file=`ls $elpa_dir/*elpa_generated_fortran_interfaces* | tail -n 1`
cp $origin_file elpa_generated_fortran_interfaces.f90

origin_file=`ls $elpa_dir_avx/*elpa_generated_fortran_interfaces* | tail -n 1`
cp $origin_file elpa_generated_fortran_interfaces_avx.f90

origin_file=`ls $elpa_dir_avx2/*elpa_generated_fortran_interfaces* | tail -n 1`
cp $origin_file elpa_generated_fortran_interfaces_avx2.f90

origin_file=`ls $elpa_dir_avx512/*elpa_generated_fortran_interfaces* | tail -n 1`
cp $origin_file elpa_generated_fortran_interfaces_avx512.f90

origin_file=`ls $elpa_dir_cuda/*elpa_generated_fortran_interfaces* | tail -n 1`
cp $origin_file elpa_generated_fortran_interfaces_cuda.f90


origin_file=`ls $elpa_dir_cuda/*mod_cuda* | tail -n 1`
cp $origin_file mod_cuda.f90

cp $elpa_dir_cuda/config-f90.h .

elpa_dir_cuda_src=/scratch1/05979/uthpala/elpa-2023.05.001/src/GPU/CUDA
cp $elpa_dir_cuda_src/*.cu .

elpa_dir_elpa=/scratch1/05979/uthpala/elpa-2023.05.001/build_generic/elpa
cp -r $elpa_dir_elpa .

mkdir kernels

origin_file=`ls $elpa_dir/*kernels_complex* | tail -n 1`
cp $origin_file kernels/kernels_complex.f90

origin_file=`ls $elpa_dir/*kernels_real* | tail -n 1`
cp $origin_file kernels/kernels_real.f90

cp $elpa_dir_avx/{complex_avx_1hv_double_precision.c,complex_avx_1hv_single_precision.c,real_avx_2hv_double_precision.c,real_avx_2hv_single_precision.c} kernels
cp $elpa_dir_avx2/{complex_avx2_1hv_double_precision.c,complex_avx2_1hv_single_precision.c,real_avx2_2hv_double_precision.c,real_avx2_2hv_single_precision.c} kernels
cp $elpa_dir_avx512/{complex_avx512_1hv_double_precision.c,complex_avx512_1hv_single_precision.c,real_avx512_2hv_double_precision.c,real_avx512_2hv_single_precision.c} kernels

cp $elpa_dir_cuda/../src/GPU/CUDA/elpa_index_nvidia_gpu.cu  .
cp $elpa_dir_cuda/../src/GPU/CUDA/cudaFunctions.cu  .
cp $elpa_dir_cuda/../src/GPU/CUDA/cuUtils.cu  .
cp $elpa_dir_cuda/../src/GPU/CUDA/cuUtils_template.cu  .
cp $elpa_dir_cuda/../src/elpa2/GPU/CUDA/ev_tridi_band_nvidia_gpu_real.cu  .
cp $elpa_dir_cuda/../src/elpa2/GPU/CUDA/ev_tridi_band_nvidia_gpu_complex.cu  .
cp $elpa_dir_cuda/../src/invert_trm/GPU/CUDA/elpa_invert_trm_cuda.cu  .
cp $elpa_dir_cuda/../src/cholesky/GPU/CUDA/elpa_cholesky_cuda.cu  .
