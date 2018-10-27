@echo off
set xv_path=D:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 2d143609b749460bb8217bffd1e12db9 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot en_4_clycles_tb_behav xil_defaultlib.en_4_clycles_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
