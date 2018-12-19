@echo off
set xv_path=D:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim fir_data_tb_behav -key {Behavioral:sim_1:Functional:fir_data_tb} -tclbatch fir_data_tb.tcl -view D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/controlador_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
