----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2018 05:59:03 PM
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size -1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is
    signal cuenta, cuenta_n : INTEGER range 0 to 300;
    signal dato1, dato1_n, dato2, dato2_n, sample_out_n : STD_LOGIC_VECTOR (sample_size -1 downto 0);
    signal sample_out_ready_n, primer_ciclo : STD_LOGIC ;
    
begin
    process(clk_12megas, reset)
        begin
            if(reset = '1') then
                dato1_n <= (others=>'0');
                dato2_n <= (others=>'0');
                sample_out_n <= (others=>'0');
                sample_out_ready_n <= '0';
                cuenta_n <= 0;
                primer_ciclo <= '0';
            end if;
            
            if(rising_edge(clk_12megas)) then
                dato1 <= dato1_n;
                dato2 <= dato2_n;
                cuenta <= cuenta_n;
                sample_out <= sample_out_n;
                sample_out_ready <= sample_out_ready_n;
            end if;
    end process;   
    
    
    process(cuenta)
        begin 
            if(cuenta > 105) then
                if(cuenta > 150) then
                    if(cuenta > 255) then
                        if(micro_data = '1') then
                            dato2_n <= STD_LOGIC_VECTOR(unsigned(dato2) + 1);
                        end if;
                        
                        if(cuenta = 256) then
                            sample_out_n <= dato1;
                            dato1_n <= (others => '0');
                            sample_out_ready_n <= enable_4cycles;
                        else
                            sample_out_ready <= '0';
                        end if;
                        
                        if(cuenta = 299) then
                            cuenta_n <= 0;
                            primer_ciclo <= '1';
                        else
                            cuenta_n <= cuenta + 1;
                        end if;
                        
                        
                    else
                        cuenta_n <= cuenta + 1;
                        if(micro_data = '1') then
                            dato1_n <= STD_LOGIC_VECTOR(unsigned(dato1) + 1);
                            dato2_n <= STD_LOGIC_VECTOR(unsigned(dato2) + 1);
                         end if;
                    end if;
                else
                    cuenta <= cuenta + 1;
                    if(micro_data = '1') then
                        dato1_n <= STD_LOGIC_VECTOR(unsigned(dato1) + 1);
                    end if;
                    
                    if(primer_ciclo = '1') then
                        if(cuenta = 106) then
                            sample_out_n <= dato2;
                            dato2_n <= (others=>'0');
                            sample_out_ready_n <= enable_4cycles;
                        else
                            sample_out_ready_n <= '0';
                        end if;
                    else
                        sample_out_ready_n <= '0';
                    end if;
                end if;
                
            else
                cuenta_n <= cuenta + 1;
                if(micro_data = '1') then
                    dato1_n <= STD_LOGIC_VECTOR(unsigned(dato1) + 1);
                    dato2_n <= STD_LOGIC_VECTOR(unsigned(dato2) + 1);
                end if;
            end if;
    end process; 
        
    
end Behavioral;
