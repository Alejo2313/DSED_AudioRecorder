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
                sample_out_ready_reg <= sample_out_ready_n; 
                if( en4c_next = '1') then
                    en4c_reg <= en4c_next;
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
    process(cuenta, state, cuenta, dato1 ,dato2, enable_4_cycles, micro_data)
        begin 
            if(cuenta >= val_105) then
                if(cuenta >= val_150) then
                    if(cuenta >= val_255) then   
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
    
        
    process(state, cuenta, dato1 ,dato2, enable_4_cycles, micro_data,sample_out_ready_n,en4c_next) 
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
         en4c_next <= enable_4_cycles;
         md_next <= micro_data;
         primer_ciclo_n <= primer_ciclo;
        
         case state_n is
             when s0 =>
                src0_cuenta <= cuenta;
                src1_cuenta <= '0'&val_1;
                
                if(md_reg = '1') then
                    src0_data1  <=  dato1;
                    src1_data1  <=  val_1;
                    src0_data2  <=  dato2;
                    src1_data2  <=  val_1;
                end if;
                                    
             when s1 =>
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
                        sample_out_ready_n <= en4c_next;
                        primer_ciclo_n <= '0';
                    else
                        sample_out_ready_n <= '0';
                    end if;
                else
                    sample_out_ready_n <= '0';
                end if;
                    
                                  
            when s2 =>
                if(md_reg = '1') then
                    src0_data2  <=  dato2;
                    src1_data2  <=  val_1;
                end if;
                    
                if(cuenta = val_255) then
                    sample_out_n <= dato1;
                    src0_data1  <=  (others =>  '0');
                    src1_data1  <=  (others =>  '0');   
                    sample_out_ready_n <= en4c_next;
                else
                    sample_out_ready_n <= '0';
                end if;
                    
                if(cuenta = val_299) then
                    src0_cuenta <= (others => '0');
                    src1_cuenta <= (others => '0');
                    primer_ciclo_n <= '1';
                else
                    src0_cuenta <= cuenta;
                    src1_cuenta  <= '0'&val_1;
                end if;             
        end case;
            
        dato1_n  <=  STD_LOGIC_VECTOR(unsigned(src0_data1) + unsigned(src1_data1));
        dato2_n  <=  STD_LOGIC_VECTOR(unsigned(src0_data2) + unsigned(src1_data2));
        cuenta_n <=  STD_LOGIC_VECTOR(unsigned(src0_cuenta) + unsigned(src1_cuenta));
    end process;
    sample_out <= sample_out_reg;
    sample_out_ready <= sample_out_ready_reg;
    
    
end Behavioral;

