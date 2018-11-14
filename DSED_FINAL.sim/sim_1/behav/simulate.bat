@echo off
set xv_path=D:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim FSMD_microphone_tb_behav -key {Behavioral:sim_1:Functional:FSMD_microphone_tb} -tclbatch FSMD_microphone_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
