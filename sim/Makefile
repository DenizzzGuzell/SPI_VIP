dirs := agents env tb
dir_agents := ../agents
dir_env := ../env
dir_test := ../test
dir_tb := ../tb
dir_design := ../design

COVERAGE ?= yes
GUI ?= yes

#UVM_LIB_PATH = ${VCS_HOME}/etc/uvm-1.1
#SIMULATOR = VCS

VLOG = vlogan
VLOG_OPTS = -nc -sverilog -full64 -ntb_opts uvm-1.1 +define+UVM_HDL_MAX_WIDTH=128 -sva_bind_enable +define+ASSERT_ON

VCS = vcs
VCS_OPTS = -nc -full64 -sverilog -ntb_opts uvm-1.1 -debug_access+all+f -lca -Mdir=LIBS/csrc +warn=all +lint=all,noVCDE,noNS +vcs+vcdpluson -sva_bind_enable

SIMV_OPTS = +UVM_NO_RELNOTES +ntb_random_seed_automatic -gui

TEST_NAME ?= spi_wr_test

ifeq ($(COVERAGE),yes)
	VCS_OPTS+=-cm line
	SIMV_OPTS+=-cm line
endif

ifeq ($(GUI)),yes)
	SIMV_OPTS+=-gui
endif

all : clean compile elab run

compile:
	mkdir LIBS
	$(VLOG) $(VLOG_OPTS)
	$(VLOG) $(VLOG_OPTS) +incdir+$(dir_agents) $(dir_agents)/spi_agent_pkg.sv
	$(VLOG) $(VLOG_OPTS) +incdir+$(dir_env) $(dir_env)/spi_env_pkg.sv
	$(VLOG) $(VLOG_OPTS) +incdir+$(dir_test) $(dir_test)/spi_test_lib_pkg.sv
	$(VLOG) $(VLOG_OPTS) $(dir_agents)/spi_interface.sv
	$(VLOG) $(VLOG_OPTS) $(dir_agents)/spi_driver_BFM.sv
	$(VLOG) $(VLOG_OPTS) $(dir_agents)/spi_monitor_BFM.sv
	$(VLOG) $(VLOG_OPTS) -timescale=1ns/10ps ${dir_tb}/spi_tb_top.sv
	vhdlan -nc -full64 $(dir_design)/spi_slave.vhd
elab:
	$(VCS) $(VCS_OPTS) spi_tb_top -l comp.log

#comp:
#	vlogan -sverilog -ntb_opts uvm-1.1
#	vlogan -sverilog -ntb_opts uvm-1.1 $(dir_agents)/clk_rst_agent_pkg.sv $(dir_env)/clk_rst_env_pkg.sv $(dir_test)/clk_rst_test_lib_pkg.sv \
#	${dir_tb}/hld_top.sv ${dir_test}/clk_rst_default_test.svh -kdb +incdir+$(dir_agents) +incdir+$(dir_env) +incdir+$(dir_test) +incdir+$(dir_tb)	vcs -sverilog -timescale=1ns/1ps -debug_access+all +vpi -ntb_opts uvm-1.1 work.tb work.test -l comp_log

run: test

test:
	 ./simv $(SIMV_OPTS) +UVM_TESTNAME=$(TEST_NAME) -l simv.log

clean:
	rm -rf AN.DB csrc simv* ucli* LIBS *.log 64






