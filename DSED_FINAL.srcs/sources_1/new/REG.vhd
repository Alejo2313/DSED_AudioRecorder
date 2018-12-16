----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2018 03:17:20 PM
-- Design Name: 
-- Module Name: REG - Behavioral
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
use IEEE.Numeric_Std.all;


entity REG is
    generic(
        PORT_SIZE   : NATURAL
    );
    Port (  clk         : in STD_LOGIC;
            clr         : in STD_LOGIC;
            Port_In     : in signed(PORT_SIZE - 1 downto 0);
            Port_Out    : out signed(PORT_SIZE - 1 downto 0)
    );
end REG;

architecture Behavioral of REG is
    --Signals 
    signal next_out : signed(PORT_SIZE - 1 downto 0):=(others => '0');
    
begin

    process(clk, clr)
        begin
            --Synchronus clear
            if(rising_edge(clk)) then
                if(clr = '1') then
                    next_out <= (others => '0');
                else
                    next_out <= Port_In;
                end if;
            end if;
    end process;
    
    --Output logic
    Port_Out <= next_out;
    
end Behavioral;
