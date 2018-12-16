----------------------------------------------------------------------------------
-- Company: UPM
-- Engineer: Alejandro Gómez Molina & Luis Felipe Velez
-- 
-- Create Date: 10/30/2018 05:59:03 PM
-- Design Name:  FSMD Microphone
-- Module Name: FSMD_microphone - Behavioral
-- Project Name: DSED -> Sistema de grabación, tratamiento y reproducción de audio.
-- Target Devices:  Nexys 4 DDR
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


entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size -1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

    --Types
    type state_t is (s0, s1, s2);
    
    --Signals
    signal state, state_n                                   : state_t                               := s0;
    signal src0_data1, src0_data2, src1_data1, src1_data2   : unsigned (sample_size -1 downto 0)    := (others => '0');
    signal dato1, dato1_n, dato2, dato2_n                   : unsigned (sample_size -1 downto 0)     := (others => '0');
    signal cuenta, cuenta_n, src0_cuenta, src1_cuenta       : unsigned (sample_size downto 0)       := (others =>  '0');
    signal sample_out_n, sample_out_reg                     : STD_LOGIC_VECTOR (sample_size -1 downto 0) := (others => '0');
    signal primer_ciclo, primer_ciclo_n                     : STD_LOGIC                             := '0';
    signal sample_out_ready_n, sample_out_ready_reg         : STD_LOGIC                             := '0';
    
    
    
begin
    process(clk_12megas, reset)
        begin
            --Asynchronus reset
            if(reset = '1') then
                --Load default values 
                sample_out_ready_reg    <= '0';
                sample_out_reg  <= (others=>'0');
                primer_ciclo    <= '0';
                dato1   <= (others=>'0');
                dato2   <= (others=>'0');
                cuenta  <= (others =>  '0');
                state   <= s0;
            
            elsif(rising_edge(clk_12megas)) then
                sample_out_ready_reg <= '0';        --Must to be active only one cycle!!
                
                if( enable_4_cycles = '1') then
                    --Next state update 
                    sample_out_ready_reg <= sample_out_ready_n; 
                    sample_out_reg  <= sample_out_n;
                    primer_ciclo    <= primer_ciclo_n;                
                    dato1   <= dato1_n;
                    dato2   <= dato2_n;
                    state   <= state_n;
                    cuenta  <= cuenta_n;
                end if;
            end if;

    end process;   
    
    
    
    --Next state logic
    process(cuenta, state, cuenta, dato1 ,dato2, enable_4_cycles, micro_data)
        begin 
            if(cuenta >= 105) then
                if(cuenta >= 150) then
                    if(cuenta >= 255) then   
                        state_n <= s2;
                    else
                        state_n <= s0;
                    end if;
                else
                    state_n <= s1;
                end if;
            else
                state_n <= s0;
            end if;
    end process; 
    
 
    
     
        
    process(state, cuenta, dato1 ,dato2, enable_4_cycles, micro_data) 
        begin
        --Default values
         sample_out_ready_n <= sample_out_ready_reg;
         primer_ciclo_n <= primer_ciclo;
         sample_out_n   <= sample_out_reg;
         src0_data1  <= dato1;
         src1_data1  <= (others => '0');
         src0_data2  <= dato2;
         src1_data2  <= (others => '0');
         src0_cuenta <= cuenta;
         src1_cuenta <= (others => '0');
        
         case state_n is
----------------------------------------------    
             when s0 =>
                src0_cuenta <= cuenta;
                src1_cuenta <= to_unsigned( 1 ,src1_cuenta'length);
                
                if(micro_data = '1') then
                    src0_data1  <=  dato1;
                    src1_data1  <=  to_unsigned( 1 ,src1_data1'length);
                    src0_data2  <=  dato2;
                    src1_data2  <=  to_unsigned( 1 ,src1_data2'length);
                end if;
             
------------------------------------------------                                   
             when s1 =>
                src0_cuenta <= cuenta;
                src1_cuenta <= to_unsigned( 1 ,src1_cuenta'length);
                
                if(micro_data = '1') then
                     src0_data1  <=  dato1;
                     src1_data1  <=  to_unsigned( 1 ,src1_data1'length);
                end if;
                    
                if(cuenta = 105) then
                    src0_data2  <=  (others => '0');
                    src1_data2  <=  (others => '0');
                    if(primer_ciclo = '1') then
                        sample_out_ready_n <= '1';
                        sample_out_n <= STD_LOGIC_VECTOR(dato2);
                    else
                        sample_out_ready_n <= '0';
                    end if;
                else
                    sample_out_ready_n <= '0';
                end if;
                                  
  ------------------------------------------------                                   
                                 
            when s2 =>
                if(micro_data = '1') then
                    src0_data2  <=  dato2;
                    src1_data2  <=  to_unsigned( 1 ,src1_data2'length) ;
                end if;
                    
                if(cuenta = 255) then
                    sample_out_n <= STD_LOGIC_VECTOR(dato1);
                    src0_data1  <=  (others =>  '0');
                    src1_data1  <=  (others =>  '0');   
                    sample_out_ready_n <= '1';
                else
                    sample_out_ready_n <= '0';
                end if;
                    
                if(cuenta = 299) then
                    src0_cuenta <= (others => '0');
                    src1_cuenta <= (others => '0');
                    primer_ciclo_n <= '1';
                else
                    src0_cuenta <= cuenta;
                    src1_cuenta  <= to_unsigned( 1 ,src1_cuenta'length);
                end if;             
        end case;
        
------------------------------------------------                                   

            
        dato1_n  <=  src0_data1  + src1_data1;
        dato2_n  <=  src0_data2  + src1_data2;
        cuenta_n <=  src0_cuenta + src1_cuenta;
        
    end process;
    
    
    --Output logic
    sample_out_ready <= sample_out_ready_reg; 
    sample_out <= sample_out_reg;
    
end Behavioral;