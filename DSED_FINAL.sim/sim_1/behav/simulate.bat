@echo off
set xv_path=D:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim controlador_tb_behav -key {Behavioral:sim_1:Functional:controlador_tb} -tclbatch controlador_tb.tcl -view D:/OneDrive/Documentos/Universidad/DSED/DSED_PROJ/controlador_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
