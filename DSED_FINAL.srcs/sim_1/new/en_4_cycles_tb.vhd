library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity en_4_clycles_tb is
end;

architecture bench of en_4_clycles_tb is

  component en_4_clycles
      Port ( clk_12megas : in STD_LOGIC;
             reset : in STD_LOGIC;
             clk_3megas : out STD_LOGIC;
             en_2_cycles : out STD_LOGIC;
             en_4_cycles : out STD_LOGIC);
  end component;

  signal clk_12megas: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal clk_3megas: STD_LOGIC;
  signal en_2_cycles: STD_LOGIC;
  signal en_4_cycles: STD_LOGIC;

  constant clock_period: time := 83 ns;
  signal stop_the_clock: boolean;

begin

  uut: en_4_clycles port map ( clk_12megas => clk_12megas,
                               reset       => reset,
                               clk_3megas  => clk_3megas,
                               en_2_cycles => en_2_cycles,
                               en_4_cycles => en_4_cycles );

  stimulus: process
  begin
    
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 500 ns;
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk_12megas <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;