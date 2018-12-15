----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2018 08:00:11 PM
-- Design Name: 
-- Module Name: en_4_clycles - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is
    signal en_4_cycles_out, en_2_cycles_out, clk_3megas_out : STD_LOGIC;
    -- Clock edge counter
     signal counter :  STD_LOGIC:= '0';   
     
begin

    --main process
    process(clk_12megas, reset) 
        begin
            --asynchronus reset
            if(reset = '1') then
                clk_3megas_out <= '0';
                en_4_cycles_out <= '0';
                en_2_cycles_out <= '0';
                counter <= '0'; 
            end if;
            
            if(rising_edge(clk_12megas)) then
                counter <= not counter;
                if(counter = '1') then
                    if(clk_3megas_out = '0') then
                        en_4_cycles_out <= '1';    
                    end if;
                    
                    clk_3megas_out <= NOT clk_3megas_out;
                else
                    en_4_cycles_out <= '0'; 
                end if;
            end if;
    end process;
    
    clk_3megas <= clk_3megas_out;
    en_2_cycles <= counter ;
    en_4_cycles <= en_4_cycles_out;

end Behavioral;