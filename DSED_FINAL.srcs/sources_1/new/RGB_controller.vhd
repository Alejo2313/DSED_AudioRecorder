----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2018 11:19:30 PM
-- Design Name: 
-- Module Name: RGB_controller - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RGB_controller is
    Port (  clk   : in STD_LOGIC;
            reset : in  STD_LOGIC;
            addrA : in STD_LOGIC_VECTOR (18 downto 0);
            en_2_cycles  : in STD_LOGIC;
            R : out STD_LOGIC;
            G : out STD_LOGIC;
            B : out STD_LOGIC);
end RGB_controller;

architecture Behavioral of RGB_controller is

    component PWM is
        Port ( clk_12megas  : in STD_LOGIC;
               reset        : in STD_LOGIC;
               en_2_cycles  : in STD_LOGIC;
               sample_in    : in STD_LOGIC_VECTOR (sample_size -1 downto 0);
               pwm_pulse    : out STD_LOGIC;
               sample_request : out STD_LOGIC);
    end component;
    
    signal  R_reg, G_reg, B_reg             : STD_LOGIC_VECTOR(7 downto 0);
    signal  R_reg_n, G_reg_n, B_reg_n       : STD_LOGIC_VECTOR(7 downto 0);
    signal  sr_R, sr_G, sr_B                : STD_LOGIC;
    
begin


    process(clk, reset) 
    
    begin
        if(reset = '1') then
            R_reg <= (others => '0');
            G_reg <= (others => '0');
            B_reg <= (others => '0');
            
        elsif( rising_edge(clk) ) then
            R_reg <= R_reg_n;
            G_reg <= G_reg_n;
            B_reg <= B_reg_n;
        
        end if;
    end process;
    
    
    process(addrA, R_reg_n, G_reg_n, B_reg_n) 
    
    begin
        R_reg_n <= R_reg;
        G_reg_n <= G_reg;                  
        B_reg_n <= (others => '0');
        
        if(addrA(18) = '0') then
            G_reg_n <= (others => '1');
            R_reg_n <= addrA(17 downto 10);
        else
            R_reg_n <= (others => '1');
            G_reg_n <= NOT addrA(17 downto 10);
        end if;
    
    end process;
          
    uut1: PWM 
        port map (  clk_12megas => clk,
                    reset       => reset,
                    en_2_cycles => en_2_cycles,
                    sample_in   => R_reg,
                    pwm_pulse   => R,
                    sample_request  => sr_R); 

                            
    uut2: PWM 
        port map (  clk_12megas => clk,
                    reset       => reset,
                    en_2_cycles => en_2_cycles,
                    sample_in   => G_reg,
                    pwm_pulse   => G,
                    sample_request  => sr_G); 

     uut3: PWM 
        port map (  clk_12megas => clk,
                    reset       => reset,
                    en_2_cycles => en_2_cycles,
                    sample_in   => B_reg,
                    pwm_pulse   => B,
                    sample_request  => sr_B);  
                   
end Behavioral;
