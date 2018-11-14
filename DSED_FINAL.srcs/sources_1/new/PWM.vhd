----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2018 03:03:11 PM
-- Design Name: 
-- Module Name: PWM - Behavioral
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

entity PWM is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size -1 downto 0);
           pwm_pulse : out STD_LOGIC;
           sample_request : out STD_LOGIC);
end PWM;

architecture Behavioral of PWM is
    signal r_reg : STD_LOGIC_VECTOR(sample_size downto 0);
    signal r_next : STD_LOGIC_VECTOR(sample_size downto 0);
    signal buff_reg , buff_next: STD_LOGIC;
    
    
begin

process(en_2cycles, reset)
    begin
        if( reset = '1') then
            r_reg <=  (others=>'0');
            buff_reg <= '0';
        end if;
        if(rising_edge(en_2cycles)) then
            r_reg <= r_next;
            buff_reg <= buff_next;
        end if;
end process;

r_next <= STD_LOGIC_VECTOR(unsigned(r_reg) +  1) when  unsigned(r_reg) /= "100101100" else
          (others => '0');
sample_request <= '1' when  unsigned(r_reg) = "100101100" else
                  '0';
buff_next <= '1' when ( unsigned(r_reg) < (unsigned(sample_in)) or ( sample_in = "00000000")) else
             '0';    
             
pwm_pulse <= buff_reg;        
end Behavioral;
