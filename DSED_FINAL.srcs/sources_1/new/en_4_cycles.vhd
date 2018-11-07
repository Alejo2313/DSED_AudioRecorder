----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2018 19:30:02
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is
    signal c_state3M , n_state3M : std_logic_vector(1 downto 0);
    signal c_state_en2 , n_state_en2 : std_logic;
    signal c_state_en4 , n_state_en4 : std_logic_vector(1 downto 0);
begin
    -- next_state logic
    n_state3M <= std_logic_vector(unsigned(c_state3M) + 1);
    n_state_en2 <= '1' when c_state_en2 = '0' else
                   '0'  ;
    n_state_en4 <= (others => '0') when c_state_en4 = "11" else
                   std_logic_vector(unsigned(c_state_en4) + 1);
   
   
   -- Register
   process(clk_12megas, reset)
   begin
    if( reset = '1') then
        c_state3M <= (others => '0');
        c_state_en2 <= '0';
        c_state_en4 <= ( others => '0');
    elsif( rising_edge(clk_12megas)) then
        c_state3M <= n_state3M;
        c_state_en2 <= n_state_en2;
        c_state_en4 <= n_state_en4;    
    end if;
   end process;    
   
   -- Output logic
   clk_3megas <= '1' when (to_integer(unsigned(c_state3M)) >1) else
                 '0';
   en_2_cycles <= '1' when c_state_en2 = '1' else
                  '0';
   en_4_cycles <= '1' when (to_integer(unsigned(c_state_en4)) = 2) else
                  '0';                              
                              


end Behavioral;
