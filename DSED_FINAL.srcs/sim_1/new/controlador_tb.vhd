-- Testbench created online at:

--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.package_dsed.all;

entity controlador_tb is
end;

architecture bench of controlador_tb is

  component controlador
      Port ( clk_100Mhz   : in STD_LOGIC;
             reset        : in STD_LOGIC;
             BTNL         : in STD_LOGIC;
             BTNC         : in STD_LOGIC;
             BTNR         : in STD_LOGIC;
             SW0          : in STD_LOGIC;
             SW1          : in STD_LOGIC;
             micro_clk    : out STD_LOGIC;
             micro_data   : in STD_LOGIC;
             micro_LR     : out STD_LOGIC;
             jack_sd      : out STD_LOGIC;
             jack_pwm     : out STD_LOGIC;
             led_out      : out STD_LOGIC_VECTOR(sample_size - 1 downto 0));
  end component;

  signal clk_100Mhz: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal BTNL: STD_LOGIC;
  signal BTNC: STD_LOGIC;
  signal BTNR: STD_LOGIC;
  signal SW0: STD_LOGIC;
  signal SW1: STD_LOGIC;
  signal micro_clk: STD_LOGIC;
  signal micro_data: STD_LOGIC;
  signal micro_LR: STD_LOGIC;
  signal jack_sd: STD_LOGIC;
  signal jack_pwm: STD_LOGIC;
  signal led_out: STD_LOGIC_VECTOR(sample_size - 1 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: controlador port map ( clk_100Mhz => clk_100Mhz,
                              reset      => reset,
                              BTNL       => BTNL,
                              BTNC       => BTNC,
                              BTNR       => BTNR,
                              SW0        => SW0,
                              SW1        => SW1,
                              micro_clk  => micro_clk,
                              micro_data => micro_data,
                              micro_LR   => micro_LR,
                              jack_sd    => jack_sd,
                              jack_pwm   => jack_pwm,
                              led_out    => led_out );

  stimulus: process
  begin
  
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    
    SW0 <= '0';
    SW1 <= '1';
    BTNR <= '0';
    BTNC <= '0';
    micro_data <= '1';
    BTNL <= '1';
    wait for 500us;
    
    BTNL <= '0';
    BTNR <= '1';
    wait for 500ns;
    BTNR <= '0';
    wait for 500us;
    
    
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk_100Mhz <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;