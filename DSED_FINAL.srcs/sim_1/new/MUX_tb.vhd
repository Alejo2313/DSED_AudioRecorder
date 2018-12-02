library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.package_dsed.all;


entity MUX_tb is
end;


architecture bench of MUX_tb is
  constant PORT_SIZE  : NATURAL := 3; 
  component MUX_8
      Port ( control  : in std_logic_vector(2 downto 0);
             ports_in : in MUX_IN_8_8;
             port_out : out std_logic_vector(7 downto 0)
      );
  end component;

  signal control: std_logic_vector(2 downto 0) := "000";
  signal ports_in: MUX_IN_8_8 := (  "00000000",
                                    "00000101", 
                                    "00000110",
                                    "00000111");
  signal port_out: std_logic_vector(7 downto 0) ;

begin

  -- Insert values for generic parameters !!
  uut: MUX_8    port map ( control   => control,
                         ports_in  => ports_in,
                         port_out  => port_out );

  stimulus: process
  begin
    
    
    control <= "000";
    wait for 50 ns;
    control <= "001";
    wait for 50 ns;
    control <= "010";
    wait for 50 ns;
    control <= "011";
    wait for 50 ns;    
    control <= "100";
    wait for 50 ns;
    control <= "101";
    wait for 50 ns;
    control <= "110";
    wait for 50 ns;
    control <= "111";
    wait for 50 ns; 
    

    wait;
  end process;


end;