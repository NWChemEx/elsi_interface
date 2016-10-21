SHELL = /bin/sh
OPTS  = $(FFLAGS_O)

ifeq ($(strip $(XLF)),yes)
  XLFPP = -WF,
endif

FPPFLAGS  = ${XLFPP}-DCONV
FPPFLAGS += ${XLFPP}-DPSP
FPPFLAGS += ${XLFPP}-DMPI
FPPFLAGS += ${XLFPP}-DLAP
FPPFLAGS += ${XLFPP}-DSLAP

PSPLIBNAME = libpspblas.a
PSPBUILDPATH = $(ROOTDIR)/build_psp

MSLIBNAME = libMatrixSwitch.a
MSBUILDPATH = $(ROOTDIR)/build_MatrixSwitch

OMMLIBNAME = libOMM.a
OMMBUILDPATH = $(ROOTDIR)/build_libOMM

BLASLIB = $(SCALAPACK_LDFLAGS)
LAPLIB = $(SCALAPACK_LDFLAGS)
SLAPLIB = $(SCALAPACK_LDFLAGS)