library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.package_dsed.all;


entity pwm_tb is
end;

architecture bench of pwm_tb is

  component en_4_clycles
      Port ( clk_12megas : in STD_LOGIC;
             reset : in STD_LOGIC;
             clk_3megas : out STD_LOGIC;
             en_2_cycles : out STD_LOGIC;
             en_4_cycles : out STD_LOGIC);
  end component;
  
  
component PWM is
      Port ( clk_12megas : in STD_LOGIC;
             reset : in STD_LOGIC;
             en_2cycles : in STD_LOGIC;
             sample_in : in STD_LOGIC_VECTOR (sample_size -1 downto 0);
             pwm_pulse : out STD_LOGIC;
             sample_request : out STD_LOGIC);
  end component;
  

  signal clk_12megas: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal clk_3megas: STD_LOGIC;
  signal en_2_cycles: STD_LOGIC;
  signal en_4_cycles: STD_LOGIC ;
  signal sample_in :  STD_LOGIC_VECTOR (sample_size -1 downto 0);
  signal sample_request :  STD_LOGIC;
  signal pwm_pulse :  STD_LOGIC;

  constant clock_period: time := 83 ns;
  signal stop_the_clock: boolean;

begin

  uut: en_4_clycles port map ( clk_12megas => clk_12megas,
                               reset       => reset,
                               clk_3megas  => clk_3megas,
                               en_2_cycles => en_2_cycles,
                               en_4_cycles => en_4_cycles );
                               
   utt1: PWM port map (  clk_12megas => clk_12megas,
                         reset       => reset,                       
                         en_2cycles => en_2_cycles,
                         sample_in => sample_in,
                         sample_request => sample_request,
                         pwm_pulse => pwm_pulse);
                         
  stimulus: process
  begin
  
    reset <= '1';
    sample_in <= (others => '0');
    wait for 160 ns;
    reset <= '0';
    sample_in <= "00000001";
    wait until sample_request = '1';
    sample_in <= "00000010";
    wait until sample_request = '1';
    sample_in <= "00000100";
    wait until sample_request = '1';
    sample_in <= "00001000";
    wait until sample_request = '1';
    sample_in <= "00010000";
    wait until sample_request = '1';
    sample_in <= "00100000";
    wait until sample_request = '1';
        sample_in <= "01000000";
    wait until sample_request = '1';
        sample_in <= "10000000";
    wait until sample_request = '1';
        sample_in <= "10100100";
    wait until sample_request = '1';
        sample_in <= "11100100";
    wait until sample_request = '1';
    sample_in <= (others=>'1');
    wait until sample_request = '1';
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