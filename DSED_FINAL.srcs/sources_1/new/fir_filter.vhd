----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2018 10:35:53 PM
-- Design Name: 
-- Module Name: fir_filter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.package_dsed.all;
use IEEE.NUMERIC_STD.ALL;


entity fir_filter is
    Port (  clk : in STD_LOGIC;
            Reset   : in STD_LOGIC;
            Sample_In           : in signed(sample_size -1 downto 0 );
            Sample_In_enable    : in STD_LOGIC;
            filter_select       : in STD_LOGIC;
            Sample_Out          : out signed(sample_size -1 downto 0);
            Sample_Out_ready    : out STD_LOGIC );
            
end fir_filter;

architecture Behavioral of fir_filter is
    component FIR_Controller 
        Port ( clk              : in STD_LOGIC;
               Reset            : in STD_LOGIC;
               Sample_In_enable : in STD_LOGIC;
               control          : out STD_LOGIC_VECTOR(2 downto 0);
               Sample_out_ready : out STD_LOGIC;
               clr              : out STD_LOGIC);          
    end component;
    
    component FIR_DATAPATH 
        Port (  clk         : in STD_LOGIC;
                Cx          : in MUX_IN_8_8;
                Xx          : in MUX_IN_8_8;
                MuxControl  : in STD_LOGIC_VECTOR (2 downto 0);
                clr         : in STD_LOGIC;
                y           : out signed (19 downto 0));
    end component;
    
    
    constant low_pass_c             : MUX_IN_8_8 := ("00000101", "00011111","00111001","00000001","00011111");
    constant band_pass_c            : MUX_IN_8_8 := ("10000001", "10011111","01001101","10011111","10000001");
    constant zero_MUX_8             : MUX_IN_8_8 := ("00000000", "00000000","00000000","00000000","00000000");
    
    signal c_in, x_in   : MUX_IN_8_8                    := zero_MUX_8;
    signal clr          : STD_LOGIC;                   
    signal control      : STD_LOGIC_VECTOR(2 downto 0); 
    signal sample_ready : STD_LOGIC;
    signal sample_o     : signed(19 downto 0);
               
begin


    --Controller path
    controller: FIR_Controller 
        port map (  clk                 => clk,
                    Reset               => Reset,
                    Sample_In_enable    => Sample_In_enable,
                    control             => control,
                    Sample_out_ready    => sample_ready,
                    clr                 => clr);
    --Functional unit
    dataPath: FIR_DATAPATH 
        port map (  clk                 => clk,
                    Cx                  => c_in,
                    Xx                  => x_in,
                    MuxControl          => control,
                    clr                 => clr,
                    y                   => sample_o);           --tamaños no encajan
                    
    --Routing and registers
    process(clk, Reset) 
    begin
        if(Reset = '1') then
            x_in <= zero_MUX_8;
        elsif( rising_edge(clk)) then
            if(Sample_In_enable = '1') then
                x_in(0) <= Sample_In;
                x_in(1) <=  x_in(0);
                x_in(2) <=  x_in(1);
                x_in(3) <=  x_in(2);
                x_in(4) <=  x_in(3);
            end if;
            
            if(filter_select = '0') then
                c_in <= low_pass_c;
            else
                c_in <= band_pass_c;
            end if;
            
            if(sample_ready = '1') then
                Sample_Out  <= sample_o(14 downto 7);  -- EXPLICACION: El numero más grande que aparecerá a la salida es
                                                       -- 2*(1-2^(-7))^2 = 1.968...., por tanto, los bits más significativos
                                                       -- estarán desde B13 hasta B0 (la salida tiene formato <6,14>), los demás
                                                       -- son extensión de signo. Como necesitamos truncar al formato <1,7>, cogemos
                                                       -- el B14 como signo 
            end if;
            
            Sample_out_ready    <= sample_ready;
        end if;  
    end process;
   
   
end Behavioral;
