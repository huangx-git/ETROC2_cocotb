help:
	@echo "INFO: make <tab> for targets"
.PHONY: help

#-- Dir setup -----------------------------------------------------------------
#LOCAL_WORKDIR ?= workdir

PWD = $(shell pwd)

#-- RTL tb --------------------------------------------------------------------
XCELIUM_FLAGS ?=
#XCELIUM_FLAGS += -gui # default w/out GUI
#XCELIUM_FLAGS += -timescale 1ns/1ps
XCELIUM_FLAGS += -debug
XCELIUM_FLAGS += -clean
XCELIUM_FLAGS += -neverwarn
XCELIUM_FLAGS += -access r
XCELIUM_FLAGS += -no_analogsolver
XCELIUM_FLAGS += -define SIM

XCELIUM_SRCS ?=
XCELIUM_SRCS += $(PWD)/../ETROC2/functional/PLL/model/ETROC1_HsLib.v
XCELIUM_SRCS += $(PDK_PATH)/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v
XCELIUM_SRCS += $(PWD)/../ETROC2/functional/peripheryTMR/model/customDigitalLib.v
XCELIUM_SRCS += $(PWD)/../ETROC2/functional/ETROC2/model/ETROC2_tb_include.vams

XCELIUM_INCDIRS ?=
XCELIUM_INCDIRS += -incdir $(PWD)/..
XCELIUM_INCDIRS += -incdir $(PWD)/../ETROC2/functional
XCELIUM_INCDIRS += -incdir $(PWD)/sv

sim-rtl: XCELIUM_FLAGS += -timescale 1ns/1ps
sim-rtl: XCELIUM_SRCS += $(PWD)/sv/IO_1P2V_C4_wrapper_tb.sv
sim-rtl:
ifeq ($(GUI), 1)
	xrun -gui $(XCELIUM_FLAGS) $(XCELIUM_INCDIRS) $(XCELIUM_SRCS)
else
	xrun $(XCELIUM_FLAGS) $(XCELIUM_INCDIRS) $(XCELIUM_SRCS)
endif
.PHONY: sim-rtl

clean-rtl:
	rm -rf log_run
	rm -rf trace_run
	rm -rf waves.shm
	rm -rf xcelium.d
	rm -rf xrun.history
	rm -f xrun.key
	rm -f xrun.log
.PHONY: clean-rtl

#-- cocotb --------------------------------------------------------------------
SIM ?= xcelium

export PYTHONPATH := $(PWD)/py:$(PYTHONPATH)

MODULE = main # Python tb
TOPLEVEL = ETROC2_tb # DUT

COVERAGE_FILE = coverage.ucdb

TOPLEVEL_LANG = verilog

# TODO make sure this really work
COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

EXTRA_ARGS =

SIM_ARGS =
ifeq ($(COV),1)
SIM_ARGS += -coverage all
endif

VERILOG_SOURCES = $(XCELIUM_SRCS)
VHDL_SOURCES =

clean-cocotb: clean
	rm -rf py/__pycache__
	rm -f *.vcd
	rm -f xrun_cocotb.history
	rm -f xrun_cocotb.log
	rm -f results.xml
	rm -f simvisdbutil.log
	rm -f simvision.svdu
.PHONY: clean-cocotb

# This seems to fix a bug in xcelium support
ifeq ($(SIM),xcelium)
EXTRA_ARGS ?=
EXTRA_ARGS += $(XCELIUM_INCDIRS)
EXTRA_ARGS += $(XCELIUM_FLAGS)
EXTRA_ARGS += +define+COCOTB_SIM
EXTRA_ARGS += -l xrun_cocotb.log
endif

ifeq ($(SIM),verilator)
EXTRA_ARGS = --timing
endif

show-coverage-results:
	@imc -load cov_work/scope/test
.PHONY: show-coverage-results

include $(shell cocotb-config --makefiles)/Makefile.sim

#------------------------------------------------------------------------------

ultraclean: clean-cocotb clean-rtl
	rm -f *.diag *.txt
	rm -rf .simvision
.PHONY: ultraclean

