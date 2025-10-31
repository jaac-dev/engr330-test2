# Toolchain Configuration
XVLOG := xvlog.bat
XELAB := xelab.bat
XSIM := xsim.bat

# Sources Configuration
SOURCES := 

# Root Task
all: simulate

# Compile Task
.PHONY: compile
compile:
	$(XVLOG) -sv $(SOURCES) --relax

# Elaborate Task
.PHONY: elaborate
elaborate: compile
	$(XELAB) work.tb -s tb_sim --relax -debug all

# Simulate Task
.PHONY: simulate
simulate: elaborate
	$(XSIM) tb_sim -R --tclbatch ./tcl/run.tcl