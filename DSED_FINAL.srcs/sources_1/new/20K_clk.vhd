----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2018 07:09:32 PM
-- Design Name: 
-- Module Name: 20K_clk - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_20k is
    Port ( clk : in STD_LOGIC;
           clk_20k : out STD_LOGIC;
           reset : in STD_LOGIC);
end clk_20k;

architecture Behavioral of clk_20k is
    signal counter : unsigned(9 downto 0) := (others => '0');
begin
    process(clk) 
    begin
        if(reset = '1') then
            counter <= (others => '0');
            clk_20k <= '0';
            
        elsif(rising_edge(clk)) then
            if(counter = 600) then
                counter <= (others => '0');
                clk_20k <= '1';
            else
                counter <= counter + 1;
                clk_20k <= '0';
            end if;
        end if;
    end process;

end Behavioral;
