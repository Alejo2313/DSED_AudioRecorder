----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2018 02:33:59 PM
-- Design Name: 
-- Module Name: MUX - Behavioral
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






-- IMPORTANT! -> UNCONSTRAINED ARRAYS CAN'T BE SIMULATED  :/ (using another architecture...)
entity MUX_2 is
    Port ( control  : in std_logic_vector(7 downto 0);
           ports_in : in MUX_IN_2_20;                   -- 2 elements array of 20 bits vector 
           port_out : out std_logic_vector(20 downto 0)
    );
end MUX_2;

architecture Behavioral of MUX_2 is

begin
    port_out <= ports_in(to_integer(unsigned(control)));
end Behavioral;
