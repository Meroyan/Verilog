-makelib ies_lib/xil_defaultlib -sv \
  "E:/Software/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "E:/Software/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_2 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../pipeline_cpu_optimize.srcs/sources_1/ip/inst_rom/sim/inst_rom.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

