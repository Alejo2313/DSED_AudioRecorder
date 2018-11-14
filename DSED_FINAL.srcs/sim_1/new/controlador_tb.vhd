----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2018 09:52:23 AM
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity controlador_tb is
end;

architecture bench of controlador_tb is

  component controlador
      Port ( clk_100Mhz : in STD_LOGIC;
             reset : in STD_LOGIC;
             micro_clk : out STD_LOGIC;
             micro_data : in STD_LOGIC;
             micro_LR : out STD_LOGIC;
             jack_sd : out STD_LOGIC;
             jack_pwm : out STD_LOGIC);
  end component;

  signal clk_100Mhz: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal micro_clk: STD_LOGIC;
  signal micro_data: STD_LOGIC;
  signal micro_LR: STD_LOGIC;
  signal jack_sd: STD_LOGIC;
  signal jack_pwm: STD_LOGIC;

    constant clock_period: time := 10ns;
begin

  uut: controlador port map ( clk_100Mhz => clk_100Mhz,
                              reset      => reset,
                              micro_clk  => micro_clk,
                              micro_data => micro_data,
                              micro_LR   => micro_LR,
                              jack_sd    => jack_sd,
                              jack_pwm   => jack_pwm );

  stimulus: process
  begin
  
    -- Put initialisation code here
        reset <= '1';
        micro_data <= '1';
        wait for 160ns;
        reset <= '0';
    -- Put test bench stimulus code here

    wait;
  end process;

    clock: process
        begin
            clk_100Mhz <= '0', '1' after clock_period / 2;
            wait for clock_period;
    end process;

end;
