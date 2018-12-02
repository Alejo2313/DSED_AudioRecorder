library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.package_dsed.all;

entity fir_filter_tb is
end;

architecture bench of fir_filter_tb is

  component fir_filter
      Port (  clk : in STD_LOGIC;
              Reset   : in STD_LOGIC;
              Sample_In           : in signed(sample_size -1 downto 0 );
              Sample_In_enable    : in STD_LOGIC;
              filter_select       : in STD_LOGIC;
              Sample_Out          : out signed(sample_size -1 downto 0);
              Sample_Out_ready    : out STD_LOGIC );
  end component;

  signal clk: STD_LOGIC;
  signal Reset: STD_LOGIC;
  signal Sample_In: signed(sample_size -1 downto 0 );
  signal Sample_In_enable: STD_LOGIC;
  signal filter_select: STD_LOGIC;
  signal Sample_Out: signed(sample_size -1 downto 0);
  signal Sample_Out_ready: STD_LOGIC ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: fir_filter port map ( clk              => clk,
                             Reset            => Reset,
                             Sample_In        => Sample_In,
                             Sample_In_enable => Sample_In_enable,
                             filter_select    => filter_select,
                             Sample_Out       => Sample_Out,
                             Sample_Out_ready => Sample_Out_ready );

  stimulus: process
  begin
    filter_select   <= '0';
    reset           <= '1';
    
    wait for 20 ns;
    reset <= '0';
    wait for 10 ns;
    Sample_In <= "00000000";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns;
    Sample_In <= "00000001";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
    Sample_In <= "00000010";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns;       
    Sample_In <= "00000011";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
    Sample_In <= "00000100";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
    Sample_In <= "00000101";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
    Sample_In <= "00000110";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
    Sample_In <= "00000111";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
        Sample_In <= "00001000";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
        Sample_In <= "00001001";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
        Sample_In <= "00001010";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
        Sample_In <= "00001011";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
        Sample_In <= "00001100";
    Sample_In_enable <= '1';
    wait for 10 ns;
    Sample_In_enable <= '0';
    wait for 150ns; 
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