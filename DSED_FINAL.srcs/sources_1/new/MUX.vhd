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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- IMPORTANT! -> UNCONSTRAINED ARRAYS CAN'T BE SIMULATED  :/ (using another architecture...)
entity MUX_8 is
    Port ( control  : in std_logic_vector(2 downto 0);
           ports_in : in MUX_IN_8_8;
           port_out : out signed(7 downto 0)
    );
end MUX_8;

architecture Behavioral of MUX_8 is

begin
    
    port_out <= ports_in(to_integer(unsigned(control))) when ( control <= "100") else
                (others => '0');
end Behavioral;
