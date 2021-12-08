read_hdl ../hdl/ml_accelerator.v ../hdl/gin.v ../hdl/gin_bus.v ../hdl/pe.v ../hdl/multiplier.v ../hdl/accumulator.v ../hdl/fifo.v ../hdl/multicast_controller.v
set_db library /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
set_db lef_library /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
elaborate
current_design ml_accelerator
read_sdc ./ml_accelerator.sdc
syn_generic
syn_map
syn_opt
report_timing > timing.rpt
report_area > area.rpt
write_hdl > ../hdl/syn_ml_accelerator.v
quit
