LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use work.package_dsed.all;



ENTITY fir_data_tb IS
END fir_data_tb;

ARCHITECTURE behavior OF fir_data_tb IS
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
    signal count           : integer := 0;
    signal fin : STD_LOGIC := '0';
    
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
        FILE in_file : text OPEN read_mode IS "D:\OneDrive\Documentos\Universidad\DSED\DSED_PROJ\sample_in.dat";
        VARIABLE in_line : line;
        VARIABLE in_int : integer;
        VARIABLE in_read_ok : BOOLEAN;
    BEGIN
        if (clk'event and clk = '1') then
            if(count = 15) then
                count <= 0;
                if NOT endfile(in_file) then
                    ReadLine(in_file,in_line);
                    Read(in_line, in_int, in_read_ok);
                    sample_in <= to_signed(in_int, 8); -- 8 = the bit width
                    Sample_In_enable <= '1';
                else
                    fin <= '1';
                    assert false report "Simulation Finished" severity failure;
                end if;
                
             else 
                count <= count +1;
                Sample_In_enable <= '0';
            end if;
        end if;
    end process;
    
    
    write_process : PROCESS (clk)
        FILE out_file : text OPEN write_mode IS "D:\OneDrive\Documentos\Universidad\DSED\DSED_PROJ\sample_out.dat";
        VARIABLE out_line : line;

    BEGIN
        if (clk'event and clk = '1') then
            if(Sample_In_enable = '1') then
                if (fin = '0') then
                    write(out_line, to_integer(Sample_Out));
                    WriteLine(out_file,out_line);
                else
                    assert false report "Simulation Finished" severity failure;
                end if;              
              
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