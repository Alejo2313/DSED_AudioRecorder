-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.package_dsed.all;


entity FIR_DataPath_tb is
end;

architecture bench of FIR_DataPath_tb is

    component FIR_DATAPATH is
    Port (  clk         : in STD_LOGIC;
            Cx          : in MUX_IN_8_8;
            Xx          : in MUX_IN_8_8;
            MuxControl  : in STD_LOGIC_VECTOR (2 downto 0);
            clr         : in STD_LOGIC;
            y           : out STD_LOGIC_VECTOR (19 downto 0));
    end component;
    
    signal clk      : STD_LOGIC;
    signal clr      : STD_LOGIC;
    signal y        : STD_LOGIC_VECTOR (19 downto 0);
    signal control  : std_logic_vector(2 downto 0) := "000";
    signal Cx       : MUX_IN_8_8 := ( "00000000",
                                      "00000001",
                                      "00000010",
                                      "00000011",
                                      "00000100");
                                      
    signal Xx       : MUX_IN_8_8 := ( "00000000",
                                       "00000001",
                                       "00000010",
                                       "00000011",
                                       "00000100");
                                       
    constant clock_period: time := 10 ns;
    signal stop_the_clock: boolean;

begin
    uut0: FIR_DATAPATH 
        port map (  clk => clk,
                    Cx         => Cx,
                    Xx         => Xx,
                    MuxControl => control,
                    clr        => clr,
                    y          => y);
        
  stimulus: process
  begin
  clr <= '1';
  control <= "000";
  wait for 10 ns;
  clr <= '0';
  control <= "001";
  wait for 10 ns;
  control <= "010";
  wait for 10 ns;
  control <= "011";
  wait for 10 ns;    
  control <= "100";
  wait for 10 ns;
  control <= "101";
  wait for 10 ns;
  control <= "110";
  wait for 10 ns;
  control <= "111";
  wait for 10 ns; 
  clr <= '1';

    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '1', '0' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;