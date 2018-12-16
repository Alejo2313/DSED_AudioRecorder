----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2018 08:57:10 PM
-- Design Name: 
-- Module Name: FIR_Controller - Behavioral
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
use IEEE.Numeric_Std.all;

use work.package_dsed.all;


entity FIR_Controller is
    Port ( clk              : in STD_LOGIC;
           Reset            : in STD_LOGIC;
           Sample_In_enable : in STD_LOGIC;
           control          : out STD_LOGIC_VECTOR(2 downto 0);
           Sample_out_ready : out STD_LOGIC;
           clr              : out STD_LOGIC);
              
end FIR_Controller;

architecture Behavioral of FIR_Controller is
    type state_t is (start, waits ,t0, t1, t2, t3, t4, t5, t6, t7);
            
    signal state, state_next        : state_t                       := start;
    signal clr_next                 : STD_LOGIC                     := '0';
    signal control_next             : STD_LOGIC_VECTOR(2 downto 0)  := (others => '0');  
    signal Sample_out_ready_next    : STD_LOGIC                     := '0';
    
    
    
begin

    process(clk, Reset)
    begin
        if(Reset = '1') then
            state   <= start;
        elsif(rising_edge(clk)) then
            Sample_out_ready <= Sample_out_ready_next;
            state   <= state_next;
            clr     <= clr_next;
            control <= control_next;
        end if;
    end process;
    
    
    process(state, Sample_In_enable)       
        begin
            --Default values 
            Sample_out_ready_next <= '0';
            control_next    <= (others => '0');
            state_next      <= state;            
            clr_next        <= '0';
            
            case state is
------------------------------------------------            
                when start  =>      --solo vuelve tras un reset
                    Sample_out_ready_next <= '0';                
                    state_next  <= waits;
------------------------------------------------            
                    
                when waits  =>
                    clr_next<= '1';
                    Sample_out_ready_next <= '0';
                    if(Sample_In_enable = '1') then
                        clr_next     <= '0';
                        state_next   <= t0;
                        control_next <= "000";
                    end if;                   
------------------------------------------------            
                    
               when t0 =>
                    clr_next     <= '0';
                    control_next    <= "001";
                    state_next      <= t1;
------------------------------------------------            
                    
               when t1 =>
                    control_next    <= "010";
                    state_next      <= t2;
------------------------------------------------            
                    
               when t2 =>
                    control_next    <= "011";
                    state_next      <= t3;
------------------------------------------------            
                    
               when t3 =>
                    control_next    <= "100";
                    state_next      <= t4;
------------------------------------------------            
                    
               when t4 =>
                    control_next    <= "101";
                    state_next      <= t5;
------------------------------------------------            
                    
               when t5 =>
                    control_next    <= "110";
                    state_next      <= t6;
------------------------------------------------            
                    
               when t6 =>
                    control_next    <= "111";
                    state_next      <= t7;
------------------------------------------------            
                    
               when t7 =>
                    control_next    <= "111";
                    Sample_out_ready_next <= '1';
                    state_next      <= waits;
            end case;
    end process;
    
end Behavioral;
