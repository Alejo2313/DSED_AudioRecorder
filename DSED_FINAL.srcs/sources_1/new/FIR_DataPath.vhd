----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2018 07:07:12 PM
-- Design Name: 
-- Module Name: FIR_DATAPATH - Behavioral
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


entity FIR_DATAPATH is
    Port (  clk         : in STD_LOGIC;
            Cx          : in MUX_IN_8_8;
            Xx          : in MUX_IN_8_8;
            MuxControl  : in STD_LOGIC_VECTOR (2 downto 0);
            clr         : in STD_LOGIC;
            y           : out signed (19 downto 0));
end FIR_DATAPATH;

architecture Behavioral of FIR_DATAPATH is

    component MUX_8
        Port (      control     : in std_logic_vector(2 downto 0);
                    ports_in    : in MUX_IN_8_8;
                    port_out    : out signed(7 downto 0));
    end component;

    component REG
        generic(    PORT_SIZE   : NATURAL);
        Port (      clk         : in STD_LOGIC;
                    clr         : in STD_LOGIC;
                    Port_In     : in signed(PORT_SIZE - 1 downto 0);
                    Port_Out    : out signed(PORT_SIZE - 1 downto 0));
    end component;
    
    
    signal mux1_out, mux2_out           : signed(7 downto 0);
    signal reg1_in, reg2_in, reg2_out   : signed(15 downto 0);
    signal reg3_in, reg3_out            : signed(19 downto 0);
    

    constant reg12_size                 : NATURAL   := 16;
    constant reg3_size                  : NATURAL   := 20;   
    
begin
    
                       
    mux1: MUX_8 port map (  control   => MuxControl,
                            ports_in  => Cx,
                            port_out  => mux1_out ); 
                            
                         
    mux2: MUX_8 port map (  control   => MuxControl,
                            ports_in  => Xx,
                            port_out  => mux2_out );  

    reg1: REG   generic map ( PORT_SIZE => reg12_size )
                port map (  clk       => clk,
                            clr       => clr,
                            Port_In   => reg1_in,
                            Port_Out  => reg2_in );
                     
    reg2: REG   generic map (   PORT_SIZE =>  reg12_size)
                port map (  clk       => clk,
                            clr       => clr,
                            Port_In   => reg2_in,
                            Port_Out  => reg2_out );

    reg3: REG   generic map ( PORT_SIZE =>  reg3_size)
                port map (  clk       => clk,
                            clr       => clr,
                            Port_In   => reg3_in,
                            Port_Out  => reg3_out );
                            
                            
    reg1_in <= mux2_out*mux1_out;
    reg3_in <= reg2_out + reg3_out;
    y <= reg3_out;
    
end Behavioral;
