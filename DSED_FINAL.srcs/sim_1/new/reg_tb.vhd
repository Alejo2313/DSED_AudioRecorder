-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.package_dsed.all;


entity REG_tb is
end;

architecture bench of REG_tb is
  constant PORT_SIZE  : NATURAL := 8; 
  
    component MUX_8
        Port ( control  : in std_logic_vector(2 downto 0);
            ports_in : in MUX_IN_8_8;
            port_out : out std_logic_vector(7 downto 0)
        );
    end component;

  component REG
      generic(
          PORT_SIZE   : NATURAL
      );
      Port (  clk         : in STD_LOGIC;
              clr         : in STD_LOGIC;
              Port_In     : in std_logic_vector(PORT_SIZE - 1 downto 0);
              Port_Out    : out std_logic_vector(PORT_SIZE - 1 downto 0)
      );
  end component;

  signal clk: STD_LOGIC;
  signal clr: STD_LOGIC;
  signal Port_In: std_logic_vector(PORT_SIZE - 1 downto 0);
  signal Port_Out: std_logic_vector(PORT_SIZE - 1 downto 0) ;
  signal control: std_logic_vector(2 downto 0) := "000";
  signal ports_in: MUX_IN_8_8 := (  "00000000",
                                      "00000001",
                                      "00000010",
                                      "00000011",
                                      "00000111");
  signal port_out_mux: std_logic_vector(7 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut1: REG generic map ( PORT_SIZE =>  PORT_SIZE)
              port map ( clk       => clk,
                         clr       => clr,
                         Port_In   => port_out_mux,
                         Port_Out  => Port_Out );
                         
   uut2: MUX_8    port map ( control   => control,
                            ports_in  => ports_in,
                            port_out  => port_out_mux );                        

  stimulus: process
  begin
  clr <= '1';
  control <= "001";
  wait for 10 ns;
  clr <= '0';
  control <= "000";
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

    stop_the_clock <= true;
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