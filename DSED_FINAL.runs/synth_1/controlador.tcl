# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.cache/wt [current_project]
set_property parent.project_path D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_output_repo d:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -vhdl2008 -library xil_defaultlib D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/new/package_dsed.vhd
read_vhdl -library xil_defaultlib {
  D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/new/FSMD_microphone.vhd
  D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/new/PWM.vhd
  D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/new/en_4_clycles.vhd
  D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/new/controlador.vhd
}
read_ip -quiet D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/ip/clk_12_Meg/clk_12_Meg.xci
set_property used_in_implementation false [get_files -all d:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/ip/clk_12_Meg/clk_12_Meg_board.xdc]
set_property used_in_implementation false [get_files -all d:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/ip/clk_12_Meg/clk_12_Meg.xdc]
set_property used_in_implementation false [get_files -all d:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/ip/clk_12_Meg/clk_12_Meg_ooc.xdc]
set_property is_locked true [get_files D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/DSED_FINAL.srcs/sources_1/ip/clk_12_Meg/clk_12_Meg.xci]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Alejo/Downloads/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files C:/Users/Alejo/Downloads/Nexys4DDR_Master.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top controlador -part xc7a100tcsg324-1


write_checkpoint -force -noxdef controlador.dcp

catch { report_utilization -file controlador_utilization_synth.rpt -pb controlador_utilization_synth.pb }
