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

    type state_t is (s0, s1, s2);    
    signal dato1, dato1_n,dato2, dato2_n,sample_out_reg, sample_out_n : STD_LOGIC_VECTOR (sample_size -1 downto 0) := (others => '0');
    signal sample_out_ready_reg,sample_out_ready_n, primer_ciclo, primer_ciclo_n : STD_LOGIC := '0';
    signal state, state_n : state_t := s0;
    signal en4c_reg, en4c_next, md_reg, md_next : std_logic := '0';
    signal  src0_data1, src0_data2, src1_data1, src1_data2 : STD_LOGIC_VECTOR (sample_size -1 downto 0) := (others => '0');
    signal  cuenta : STD_LOGIC_VECTOR(log2c(ciclos)-1 downto 0) := (others =>  '1');
    signal cuenta_n, src0_cuenta, src1_cuenta  : STD_LOGIC_VECTOR(log2c(ciclos)-1 downto 0) := (others =>  '0');
    
begin
    process(clk_12megas, reset)
        begin
            --Asynchronus reset
            if(reset = '1') then
                dato1   <= (others=>'0');
                dato2   <= (others=>'0');
                sample_out_reg  <= (others=>'0');
                sample_out_ready_reg    <= '0';
                cuenta  <= (others =>  '0');
                primer_ciclo    <= '0';
                state   <= s0;
                sample_out_reg <= ( others => '0');
                sample_out_ready_reg <= '0';
                md_reg <= '0';
            
            elsif(rising_edge(clk_12megas)) then
                en4c_reg <= en4c_next;
                if( en4c_reg = '1') then
                    sample_out_ready_reg <= sample_out_ready_n;
                    
                    md_reg <= md_next;
                    dato1   <= dato1_n;
                    dato2   <= dato2_n;
                    state   <= state_n;
                    cuenta  <= cuenta_n;
                    sample_out_reg <= sample_out_n;
                    primer_ciclo <= primer_ciclo_n;                
                end if;
            end if;

    end process;   
    
    --Next state logic
    process(cuenta, state, dato1 ,dato2,state_n,cuenta_n)    
--    process(cuenta, state, dato1 ,dato2, enable_4_cycles, micro_data)
        begin 
        case state is
            when s0 =>
                if ( cuenta = val_105) then
                    state_n <= s1;
                elsif ( cuenta = val_255) then
                    state_n <= s2;
                else
                    state_n <= s0;    
                    
                end if;
            when s1 =>
                if ( cuenta < val_150) then
                    state_n <= s1;
                else
                    state_n <= s0;
                end if;
            when s2 =>
                if ( cuenta = val_299) then
                    state_n <= s0;
                else
                    state_n <= s2;
                end if;
            
        end case;
    end process; 
    
        
    process(state, cuenta, dato1 ,dato2, micro_data,sample_out_ready_n,en4c_next, md_next,enable_4_cycles,sample_out_n) 
        begin
        --Default values
         src0_data1  <=  dato1;
         src1_data1  <=  (others => '0');
         src0_data2  <=  dato2;
         src1_data2  <=  (others => '0');
         src0_cuenta <= cuenta;
         src1_cuenta  <= (others => '0');
         sample_out_n <= sample_out_reg;
         sample_out_ready_n <= sample_out_ready_reg;
         en4c_next <= en4c_reg;
--         en4c_next <= enable_4_cycles;
         md_next <= md_reg;
--         md_next <= micro_data;
         primer_ciclo_n <= primer_ciclo;
        
         case state_n is
             when s0 =>
                en4c_next <= enable_4_cycles;
                md_next <= micro_data;
                if( cuenta = val_299) then
                src0_cuenta <= ( others => '0');
                src1_cuenta <= ( others => '0');
                primer_ciclo_n <= '1';
                else
                    src0_cuenta <= cuenta;
                    src1_cuenta <= '0'&val_1;               
                end if;

                
                if(md_reg = '1') then
                    src0_data1  <=  dato1;
                    src1_data1  <=  val_1;
                    src0_data2  <=  dato2;
                    src1_data2  <=  val_1;
                end if;
                                    
             when s1 =>
                en4c_next <= enable_4_cycles;
                md_next <= micro_data;
                src0_cuenta <= cuenta;
                src1_cuenta <= '0'&val_1;
                
                if(md_reg = '1') then
                     src0_data1  <=  dato1;
                     src1_data1  <=  val_1;
                end if;
                    
                if(cuenta = val_105) then
                    src0_data2  <=  (others => '0');
                    src1_data2  <=  (others => '0');
                    if(primer_ciclo = '1') then
                        sample_out_n <= dato2;
                        sample_out_ready_n <= en4c_reg;
                        primer_ciclo_n <= '0';
                    else
                        sample_out_ready_n <= '0';
                    end if;
                else
                    sample_out_ready_n <= '0';
                end if;
                    
                                  
            when s2 =>
                en4c_next <= enable_4_cycles;
                md_next <= micro_data;
                if(md_reg = '1') then
                    src0_data2  <=  dato2;
                    src1_data2  <=  val_1;
                end if;
                    
                if(cuenta = val_255) then
                    sample_out_n <= dato1;
                    src0_data1  <=  (others =>  '0');
                    src1_data1  <=  (others =>  '0');   
                    sample_out_ready_n <= en4c_reg;
                else
                    sample_out_ready_n <= '0';
                end if;
                    
                    src0_cuenta <= cuenta;
                    src1_cuenta  <= '0'&val_1;            
        end case;
            
        dato1_n  <=  STD_LOGIC_VECTOR(unsigned(src0_data1) + unsigned(src1_data1));
        dato2_n  <=  STD_LOGIC_VECTOR(unsigned(src0_data2) + unsigned(src1_data2));
        cuenta_n <=  STD_LOGIC_VECTOR(unsigned(src0_cuenta) + unsigned(src1_cuenta));
    end process;
    sample_out <= sample_out_reg;
    sample_out_ready <= sample_out_ready_reg;
    
    
end Behavioral;

