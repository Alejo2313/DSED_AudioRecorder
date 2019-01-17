LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use work.package_dsed.all;



ENTITY fir_filter_x IS
END fir_filter_x;

ARCHITECTURE behavior OF fir_filter_x IS
    -- Clock signal declaration
    signal clk : std_logic := '1';
    signal clk2: std_logic := '1';
    -- Declaration of the reading signal
    signal Sample_In : signed(7 downto 0) := (others => '0');
    -- Clock period definitions
    constant clk_period : time := 10 ns;
    
    signal Reset: STD_LOGIC;
    signal Sample_In_enable: STD_LOGIC;
    signal filter_select: STD_LOGIC;
    signal Sample_Out: signed(sample_size -1 downto 0);
    signal Sample_Out_ready: STD_LOGIC ;
    signal count, count1          : integer := 0;
    signal fin: std_logic := '0';
    
      component fir_filter
        Port (  clk : in STD_LOGIC;
                Reset   : in STD_LOGIC;
                Sample_In           : in signed(sample_size -1 downto 0 );
                Sample_In_enable    : in STD_LOGIC;
                filter_select       : in STD_LOGIC;
                Sample_Out          : out signed(sample_size -1 downto 0);
                Sample_Out_ready    : out STD_LOGIC );
      end component;
    
    
BEGIN

    -- Clock statement
    clk <= not clk after clk_period/2 when (fin = '0') else '0';
    
    filter_select <= '1';
      
    
    
      uut: fir_filter port map ( clk              => clk,
                               Reset            => Reset,
                               Sample_In        => Sample_In,
                               Sample_In_enable => Sample_In_enable,
                               filter_select    => filter_select,
                               Sample_Out       => Sample_Out,
                               Sample_Out_ready => Sample_Out_ready );
                               
    
    read_process : PROCESS (clk)

    BEGIN
        if (clk'event and clk = '1') then
            if(count = 15) then
                count <= 0;
                
                if(count1 = 4 ) then
                    Sample_In <= "10000000";
                elsif(count1 = 10) then
                    fin <= '1';
                else
                    Sample_In <= (others => '0');
                    
                end if;
                count1 <= count1 + 1;
                Sample_In_enable <= '1';
             else 
                count <= count +1;
                Sample_In_enable <= '0';
            end if;
        end if;
    end process;
        
    process
        begin
            Reset <= '0';
            wait for 20 ns;
            Reset <= '1';
    end process;
END;