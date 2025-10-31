# Toolchain Configuration
XVLOG := xvlog.bat
XELAB := xelab.bat
XSIM := xsim.bat

MODULE := tb_rca

# Sources Configuration
SOURCES := \
	src/rca.sv \
	test/rca_tb.sv \
	src/cla.sv \
	test/cla_tb.sv

# Root Task
all: simulate

build:
	mkdir build

# Compile Task
.PHONY: compile
compile: build
	cd build
	$(XVLOG) -sv $(SOURCES) --relax

# Elaborate Task
.PHONY: elaborate
elaborate: compile
	cd build
	$(XELAB) work.$(MODULE) -s tb_sim --relax -debug all

# Simulate Task
.PHONY: simulate
simulate: elaborate
	cd build
	$(XSIM) tb_sim -R --tclbatch ./tcl/run.tcl