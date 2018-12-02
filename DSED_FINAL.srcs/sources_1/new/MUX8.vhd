----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2018 02:32:42 PM
-- Design Name: 
-- Module Name: MUX8 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX8 is
    Port ( Control : in STD_LOGIC_VECTOR (2 downto 0);
           M8_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           M8_IN1 : in STD_LOGIC;
           M8_IN2 : in STD_LOGIC);
end MUX8;

architecture Behavioral of MUX8 is

begin


end Behavioral;
