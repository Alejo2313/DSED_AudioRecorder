----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2018 13:59:52
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR( sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is


signal r_reg : STD_LOGIC_VECTOR(log2c(ciclos)-1 downto 0);
signal r_next : STD_LOGIC_VECTOR(log2c(ciclos)-1 downto 0);
signal buff_reg , buff_next, sample_reg, sample_reg_n : STD_LOGIC;


begin

-- register & buffer
process(clk_12megas, reset)
begin
    if( reset = '1') then
        r_reg <=  (others=>'0');
        buff_reg <= '0';
    end if;
    if(rising_edge(clk_12megas)) then
        if(sample_reg = '1') then       --We need only one 12Mhz cycle!!!
            sample_reg <= '0';
        else
            sample_reg <= sample_reg_n;
        end if;
        
        if(en_2_cycles = '1') then
            r_reg <= r_next;
            buff_reg <= buff_next;
        end if;
        
        
    end if;
end process;


-- Next state logic
r_next <= STD_LOGIC_VECTOR(unsigned(r_reg) +  1) when  unsigned(r_reg) /= "100101100" else
      (others => '0');
      
sample_reg_n <= '1' when  unsigned(r_reg) = "100101100" else
              '0';
buff_next <= '1' when ( unsigned(r_reg) < (unsigned(sample_in)) ) else
         '0'; 
            
-- Output logic         
pwm_pulse <= buff_reg;     
sample_request <= sample_reg;

end Behavioral;
