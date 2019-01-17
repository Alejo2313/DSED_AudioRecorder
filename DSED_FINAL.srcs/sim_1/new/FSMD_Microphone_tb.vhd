library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.package_dsed.all;


entity FSMD_microphone_tb is
end;

architecture bench of FSMD_microphone_tb is

  component en_4_cycles
      Port ( clk_12megas : in STD_LOGIC;
             reset : in STD_LOGIC;
             clk_3megas : out STD_LOGIC;
             en_2_cycles : out STD_LOGIC;
             en_4_cycles : out STD_LOGIC);
  end component;
  
  
  component  FSMD_microphone is
      Port ( clk_12megas : in STD_LOGIC;
             reset : in STD_LOGIC;
             enable_4_cycles : in STD_LOGIC;
             micro_data : in STD_LOGIC;
             sample_out : out STD_LOGIC_VECTOR (sample_size -1 downto 0);
             sample_out_ready : out STD_LOGIC);
  end component;
  
  

  signal clk_12megas: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal clk_3megas: STD_LOGIC;
  signal en_2cycles: STD_LOGIC;
  signal en_4cycles: STD_LOGIC ;
  signal micro_data: STD_LOGIC;
  signal sample_out : STD_LOGIC_VECTOR (sample_size -1 downto 0);
  signal sample_out_ready : STD_LOGIC;

  constant clock_period: time := 83 ns;
  signal stop_the_clock: boolean;

begin

  uut: en_4_cycles port map ( clk_12megas => clk_12megas,
                               reset       => reset,
                               clk_3megas  => clk_3megas,
                               en_2_cycles => en_2cycles,
                               en_4_cycles => en_4cycles );
                               
                               
  uut1: FSMD_microphone port map ( clk_12megas => clk_12megas,
                                   reset       => reset,
                                   enable_4_cycles => en_4cycles,
                                   micro_data  => micro_data,
                                   sample_out  => sample_out,
                                   sample_out_ready => sample_out_ready);

  stimulus: process
  begin
  
    reset <= '1';
    micro_data <= '1';
    wait for 10 ns;
    reset <= '0';
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