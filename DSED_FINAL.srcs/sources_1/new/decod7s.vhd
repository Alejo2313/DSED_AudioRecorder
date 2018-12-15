----------------------------------------------------------------------------------
-- 
-- Create Date:    20:04:01 10/23/2017 
-- Design Name:   Decodificador de 7 segmentos
-- Module Name:   decod7s - Behavioral  
-- Description:  Codifica un numero de 4 bits en BCD a  una señal de 7 segmentos 
--				para el display
--
----------------------------------------------------------------------------------
Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity decod7s is
    Port ( D : in  STD_LOGIC_VECTOR (3 downto 0);				
           S : out  STD_LOGIC_VECTOR (7 downto 0));   	 
end decod7s;

architecture a_decod7s of decod7s is

begin

with D select S <=
"00000011" when "0000",
"10011111" when "0001",
"00100101" when "0010",
"00001101" when "0011",
"10011001" when "0100",
"01001001" when "0101",
"01000001" when "0110",
"00011111" when "0111",
"00000001" when "1000",
"00011001" when "1001",
"00010001" when "1010",
"11000001" when "1011",
"01100011" when "1100",
"10000101" when "1101",
"01100001" when "1110",
"01110001" when "1111",
"00000001" when others;

end a_decod7s;


