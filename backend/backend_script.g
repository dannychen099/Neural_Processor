#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Wed Dec  8 15:55:06 2021                
#                                                     
#######################################################

#@(#)CDS: Innovus v16.20-p002_1 (64bit) 11/08/2016 11:31 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 16.20-p002_1 NR161103-1425/16_20-UB (database version 2.30, 354.6.1) {superthreading v1.34}
#@(#)CDS: AAE 16.20-p004 (64bit) 11/08/2016 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 16.20-p008_1 () Oct 29 2016 08:26:57 ( )
#@(#)CDS: SYNTECH 16.20-p001_1 () Oct 27 2016 11:33:00 ( )
#@(#)CDS: CPE v16.20-p011
#@(#)CDS: IQRC/TQRC 15.2.5-s803 (64bit) Tue Sep 13 18:23:58 PDT 2016 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
set init_gnd_net VSS
set init_lef_file /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
set init_design_settop 0
set init_verilog ../hdl/syn_ml_accelerator.v
set init_mmmc_file ./ml_accelerator.view
set init_pwr_net VDD
init_design
setDesignMode -process 45
fit
setDrawView fplan
getIoFlowFlag
floorPlan -r 1.0 0.63 2 2 2 2
uiSetTool select
getIoFlowFlag
globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Left -layer 3 -spreadType center -spacing 0.42 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Left -layer 3 -spreadType center -spacing .56 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Left -layer 3 -spreadType center -spacing 0.56 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[0]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[1]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[2]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[3]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[4]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[5]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[6]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[7]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[8]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[9]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[10]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[11]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[12]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[13]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[14]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[15]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[16]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[17]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[18]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[19]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[20]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[21]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[22]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_filter[23]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[0]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[1]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[2]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[3]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[4]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[5]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[6]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[7]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[8]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[9]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[10]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[11]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[12]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[13]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[14]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[15]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[16]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[17]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[18]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[19]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[20]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[21]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[22]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {data_packet_ifmap[23]} -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 0.56 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 1 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
pan -80.358 -91.999
pan 35.674 11.640
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 1.12 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
pan -30.003 6.064
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 0.56 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 3 -spreadType center -spacing 0.56 -pin {{ofmap[0]} {ofmap[1]} {ofmap[2]} {ofmap[3]} {ofmap[4]} {ofmap[5]} {ofmap[6]} {ofmap[7]} {ofmap[8]} {ofmap[9]} {ofmap[10]} {ofmap[11]} {ofmap[12]} {ofmap[13]} {ofmap[14]} {ofmap[15]} {ofmap[16]} {ofmap[17]} {ofmap[18]} {ofmap[19]} {ofmap[20]} {ofmap[21]} {ofmap[22]} {ofmap[23]} {ofmap[24]} {ofmap[25]} {ofmap[26]} {ofmap[27]} {ofmap[28]} {ofmap[29]} {ofmap[30]} {ofmap[31]} {ofmap[32]} {ofmap[33]} {ofmap[34]} {ofmap[35]} {ofmap[36]} {ofmap[37]} {ofmap[38]} {ofmap[39]} {ofmap[40]} {ofmap[41]} {ofmap[42]} {ofmap[43]} {ofmap[44]} {ofmap[45]} {ofmap[46]} {ofmap[47]}}
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[0]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[1]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[2]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[3]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin clk -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin gin_enable_filter -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin gin_enable_ifmap -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin pe_reset -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin program -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin ready -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin rstb -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[0]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[1]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[2]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[3]} -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[0]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[1]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[2]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_ifmap[3]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin clk -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin gin_enable_filter -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin gin_enable_ifmap -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin pe_reset -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin program -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin ready -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin rstb -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[0]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[1]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[2]} -status unplaced -silent
setPtnPinStatus -cell ml_accelerator -pin {scan_chain_input_filter[3]} -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 1.0 -pin {{scan_chain_input_ifmap[0]} {scan_chain_input_ifmap[1]} {scan_chain_input_ifmap[2]} {scan_chain_input_ifmap[3]} clk gin_enable_filter gin_enable_ifmap pe_reset program ready rstb {scan_chain_input_filter[0]} {scan_chain_input_filter[1]} {scan_chain_input_filter[2]} {scan_chain_input_filter[3]}}
setPinAssignMode -pinEditInBatch true
editPin -use GROUND -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 80 -pin {VDD VSS}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 2 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 3 -pin {{data_packet_filter[0]} {data_packet_filter[1]} {data_packet_filter[2]} {data_packet_filter[3]} {data_packet_filter[4]} {data_packet_filter[5]} {data_packet_filter[6]} {data_packet_filter[7]} {data_packet_filter[8]} {data_packet_filter[9]} {data_packet_filter[10]} {data_packet_filter[11]} {data_packet_filter[12]} {data_packet_filter[13]} {data_packet_filter[14]} {data_packet_filter[15]} {data_packet_filter[16]} {data_packet_filter[17]} {data_packet_filter[18]} {data_packet_filter[19]} {data_packet_filter[20]} {data_packet_filter[21]} {data_packet_filter[22]} {data_packet_filter[23]} {data_packet_ifmap[0]} {data_packet_ifmap[1]} {data_packet_ifmap[2]} {data_packet_ifmap[3]} {data_packet_ifmap[4]} {data_packet_ifmap[5]} {data_packet_ifmap[6]} {data_packet_ifmap[7]} {data_packet_ifmap[8]} {data_packet_ifmap[9]} {data_packet_ifmap[10]} {data_packet_ifmap[11]} {data_packet_ifmap[12]} {data_packet_ifmap[13]} {data_packet_ifmap[14]} {data_packet_ifmap[15]} {data_packet_ifmap[16]} {data_packet_ifmap[17]} {data_packet_ifmap[18]} {data_packet_ifmap[19]} {data_packet_ifmap[20]} {data_packet_ifmap[21]} {data_packet_ifmap[22]} {data_packet_ifmap[23]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 3 -spreadType center -spacing 3 -pin {{ofmap[0]} {ofmap[1]} {ofmap[2]} {ofmap[3]} {ofmap[4]} {ofmap[5]} {ofmap[6]} {ofmap[7]} {ofmap[8]} {ofmap[9]} {ofmap[10]} {ofmap[11]} {ofmap[12]} {ofmap[13]} {ofmap[14]} {ofmap[15]} {ofmap[16]} {ofmap[17]} {ofmap[18]} {ofmap[19]} {ofmap[20]} {ofmap[21]} {ofmap[22]} {ofmap[23]} {ofmap[24]} {ofmap[25]} {ofmap[26]} {ofmap[27]} {ofmap[28]} {ofmap[29]} {ofmap[30]} {ofmap[31]} {ofmap[32]} {ofmap[33]} {ofmap[34]} {ofmap[35]} {ofmap[36]} {ofmap[37]} {ofmap[38]} {ofmap[39]} {ofmap[40]} {ofmap[41]} {ofmap[42]} {ofmap[43]} {ofmap[44]} {ofmap[45]} {ofmap[46]} {ofmap[47]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 3 -spreadType center -spacing 2 -pin {{ofmap[0]} {ofmap[1]} {ofmap[2]} {ofmap[3]} {ofmap[4]} {ofmap[5]} {ofmap[6]} {ofmap[7]} {ofmap[8]} {ofmap[9]} {ofmap[10]} {ofmap[11]} {ofmap[12]} {ofmap[13]} {ofmap[14]} {ofmap[15]} {ofmap[16]} {ofmap[17]} {ofmap[18]} {ofmap[19]} {ofmap[20]} {ofmap[21]} {ofmap[22]} {ofmap[23]} {ofmap[24]} {ofmap[25]} {ofmap[26]} {ofmap[27]} {ofmap[28]} {ofmap[29]} {ofmap[30]} {ofmap[31]} {ofmap[32]} {ofmap[33]} {ofmap[34]} {ofmap[35]} {ofmap[36]} {ofmap[37]} {ofmap[38]} {ofmap[39]} {ofmap[40]} {ofmap[41]} {ofmap[42]} {ofmap[43]} {ofmap[44]} {ofmap[45]} {ofmap[46]} {ofmap[47]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 3 -spreadType center -spacing 20 -pin {}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 10 -pin {clk gin_enable_filter gin_enable_ifmap pe_reset program ready rstb {scan_chain_input_filter[0]} {scan_chain_input_filter[1]} {scan_chain_input_filter[2]} {scan_chain_input_filter[3]} {scan_chain_input_ifmap[0]} {scan_chain_input_ifmap[1]} {scan_chain_input_ifmap[2]} {scan_chain_input_ifmap[3]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing -10.08 -pin {}
setPinAssignMode -pinEditInBatch false
saveDesign ml_accelerator_fl.enc
addRing -nets {VSS VDD} -type core_rings -follow io -layer {top metal5 bottom metal5 left metal4 right metal4} -width {top 1 bottom 1 left 1 right 1} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 0 bottom 0 left 0 right 0} -center 0 -extend_corner {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
addStripe -block_ring_top_layer_limit metal5 -max_same_layer_jog_length 1.6 -padcore_ring_bottom_layer_limit metal3 -set_to_set_distance 5 -stacked_via_top_layer metal10 -padcore_ring_top_layer_limit metal5 -spacing 1 -xleft_offset 1 -merge_stripes_value 0.095 -layer metal4 -block_ring_bottom_layer_limit metal3 -width 1 -nets {VSS VDD } -
addStripe -block_ring_top_layer_limit metal5 -max_same_layer_jog_length 1.6 -padcore_ring_bottom_layer_limit metal3 -set_to_set_distance 5 -stacked_via_top_layer metal10 -padcore_ring_top_layer_limit metal5 -spacing 1 -xleft_offset 1 -merge_stripes_value 0.095 -layer metal4 -block_ring_bottom_layer_limit metal3 -width 1 -nets {VSS VDD } -stacked_via_bottom_layer metal1
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { 1 10 } -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer 1 -allowLayerChange 1 -targetViaTopLayer 10 -crossoverViaTopLayer 10 -targetViaBottomLayer 1 -nets { VDD VSS }
saveDesign ml_accelerator_power.enc
editPowerVia -skip_via_on_pin Standardcell -bottom_layer metal1 -add_vias 1 -top_layer metal8
saveDesign ml_accelerator_power.enc
setEndCapMode -reset
setEndCapMode -boundary_tap false
setPlaceMode -reset
setPlaceMode -congEffort auto -timingDriven 1 -modulePlan 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 0 -placeIOPins 0 -moduleAwareSpare 0 -preserveRouting 0 -rmAffectedRouting 0 -checkRoute 0 -swapEEQ 0
setPlaceMode -fp false
placeDesign
timeDesign -preCTS -numPaths 200
optDesign -preCTS -numPaths 200
setDrawView place
pan 162.638 -7.136
pan -1.321 -0.449
pan -0.600 0.018
pan -0.767 0.026
pan -0.759 0.145
pan -152.297 -11.954
saveDesign ml_accelerator_pl.enc
setDrawView place
set_ccopt_property update_io_latency false
clockDesign -specFile Clock.ctstch -outDir clock_report
pan 79.690 -7.526
pan -55.354 -7.528
pan -55.671 55.351
pan 5.646 -13.175
checkPlace alu.checkPlace
timeDesign -postCTS -numPaths 200
timeDesign -postCTS -hold -numPaths 200
optDesign -postCTS -numPaths 200
optDesign -postCTS -hold -numPaths 200
timeDesign -postCTS -hold -numPaths 200
timeDesign -postCTS -numPaths 200
saveDesign ml_accelerator_clk.enc
getFillerMode -quie
getFillerMode -quiet
addFillerGap 0.6
addFiller -cell FILLCELL_X1 FILLCELL_X2 FILLCELL_X4 FILLCELL_X8 -prefix FILLER -markFixed
saveDesign ml_accelerator_powerroute_clk_filler.enc
setAnalysisMode -cppr none -clockGatingCheck true -timeBorrowing true -useOutputPinCap true -sequentialConstProp false -timingSelfLoopsNoSkew false -enableMultipleDriveNet true -clkSrcPath true -warn true -usefulSkew false -analysisType onChipVariation -log true
setNanoRouteMode -quiet -drouteFixAntenna false
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
setNanoRouteMode -quiet -routeTopRoutingLayer 6
routeDesign -globalDetail
pan 30.629 24.414
pan 41.282 7.546
pan -40.731 0.000
pan -90.762 0.000
saveDesign ml_accelerator_powerroute_clk_filler.enc
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 400 -prefix alu_conv_postRoute -outDir timingReports
clearClockDomains
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 400 -prefix alu_conv_postRoute -outDir timingReports
saveDesign ml_accelerator_final_layout.enc
saveNetlist -phys -includePowerGround phy_ml_accelerator.v -excludeLeafCell
saveNetlist nophy_ml_accelerator.v -excludeLeafCell
write_sdf ml_accelerator.sdf
verify_drc -report cnn.drc.rpt -limit 1000
verifyConnectivity -type all -error 1000 -warning 50
verifyProcessAntenna -reportfile cnn.antenna.rpt -error 1000
