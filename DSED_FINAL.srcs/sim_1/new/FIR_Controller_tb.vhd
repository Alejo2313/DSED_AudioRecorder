
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity FIR_Controller_tb is
end;

architecture bench of FIR_Controller_tb is

  component FIR_Controller
      Port ( clk              : in STD_LOGIC;
             Reset            : in STD_LOGIC;
             Sample_In        : in STD_LOGIC_VECTOR (7 downto 0);
             Sample_In_enable : in STD_LOGIC;
             filter_select    : in STD_LOGIC;
             control          : out STD_LOGIC_VECTOR(2 downto 0);
             Sample_out_ready : out STD_LOGIC;
             clr              : out STD_LOGIC);
  end component;

  signal clk: STD_LOGIC;
  signal Reset: STD_LOGIC;
  signal Sample_In: STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');
  signal Sample_In_enable: STD_LOGIC              := '0';
  signal filter_select: STD_LOGIC                 := '0';
  signal control: STD_LOGIC_VECTOR(2 downto 0);
  signal Sample_out_ready: STD_LOGIC;
  signal clr: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: FIR_Controller port map ( clk              => clk,
                                 Reset            => Reset,
                                 Sample_In        => Sample_In,
                                 Sample_In_enable => Sample_In_enable,
                                 filter_select    => filter_select,
                                 control          => control,
                                 Sample_out_ready => Sample_out_ready,
                                 clr              => clr );

  stimulus: process
  begin
  
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    wait for 15 ns;
    Sample_In <= "00000001";
    Sample_In_enable <= '1';
    wait for 15 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
        Sample_In <= "00000001";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
        Sample_In <= "00000000";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
        Sample_In <= "00000001";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
        Sample_In <= "00000010";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
        Sample_In <= "00000011";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
        Sample_In <= "00000100";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
        Sample_In <= "00000101";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150 ns;
    
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;