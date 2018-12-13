----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2018 08:49:59 AM
-- Design Name: 
-- Module Name: controlador - Behavioral
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



entity controlador is
    Port ( clk_100Mhz   : in STD_LOGIC;
           reset        : in STD_LOGIC;
           
           BTNL         : in STD_LOGIC;
           BTNC         : in STD_LOGIC;
           BTNR         : in STD_LOGIC;
           SW0          : in STD_LOGIC;
           SW1          : in STD_LOGIC;
           
           micro_clk    : out STD_LOGIC;
           micro_data   : in STD_LOGIC;
           micro_LR     : out STD_LOGIC;
           jack_sd      : out STD_LOGIC;
           jack_pwm     : out STD_LOGIC;
           led_out      : out STD_LOGIC_VECTOR(sample_size - 1 downto 0));
end controlador;

architecture Behavioral of controlador is
--types 
    type state_t is ( START, IDLE, PLAY, REC, DELETE);
--Components
    component clk_12_Meg
        port
         (  clk_out1    : out std_logic;
            reset       : in std_logic;
            clk_in1     : in std_logic);
    end component;
    
    component clk_20k 
        Port ( clk : in STD_LOGIC;
               clk_20k : out STD_LOGIC;
               reset : in STD_LOGIC);
    end component;

    component en_4_clycles is
        Port ( clk_12megas  : in STD_LOGIC;
               reset        : in STD_LOGIC;
               clk_3megas   : out STD_LOGIC;
               en_2_cycles  : out STD_LOGIC;
               en_4_cycles  : out STD_LOGIC);
    end component;
    
    component FSMD_microphone is
        Port ( clk_12megas      : in STD_LOGIC;
               reset            : in STD_LOGIC;
               enable_4_cycles  : in STD_LOGIC;
               micro_data       : in STD_LOGIC;
               sample_out       : out STD_LOGIC_VECTOR (sample_size -1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    component blk_mem_gen_0
      PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
    end component;
    
    component fir_filter 
        Port (  clk : in STD_LOGIC;
                Reset   : in STD_LOGIC;
                Sample_In           : in signed(sample_size -1 downto 0 );
                Sample_In_enable    : in STD_LOGIC;
                filter_select       : in STD_LOGIC;
                Sample_Out          : out signed(sample_size -1 downto 0);
                Sample_Out_ready    : out STD_LOGIC );
                
    end component;
    
    component PWM is
        Port ( clk_12megas      : in STD_LOGIC;
               reset            : in STD_LOGIC;
               en_2_cycles      : in STD_LOGIC;
               sample_in        : in STD_LOGIC_VECTOR (sample_size -1 downto 0);
               pwm_pulse        : out STD_LOGIC;
               sample_request   : out STD_LOGIC);
    end component;
    
    
    
 --Signals
 
    signal state, state_n   : state_t := START;
    signal clk_12megas      : STD_LOGIC;
    signal clk_3megas       : STD_LOGIC;
    signal en_2_cycles      : STD_LOGIC;
    signal en_4_cycles      : STD_LOGIC;
    signal sample, memory_out, PWM_in          : STD_LOGIC_VECTOR (sample_size -1 downto 0);
    signal filter_out       : signed (sample_size -1 downto 0);
    signal sample_out_ready : STD_LOGIC;
    signal sample_request   : STD_LOGIC;
    
    signal cur_b, last_b        : unsigned(18 downto 0) := (others => '0') ;    -- Memory Pointers 
    signal cur_b_n, last_b_n    : unsigned(18 downto 0) := (others => '0'); 
    
    signal addra, addra_n       : unsigned(18 downto 0) := (others => '0');     --current address
    signal ena, ena_n           : STD_LOGIC;                                    -- RAM control signals
    signal wea, wea_n           : STD_LOGIC_VECTOR(0 DOWNTO 0);
    
    signal clk_20_k  : STD_LOGIC;
    
    
    signal Sample_In_enable, Sample_In_enable_n : STD_LOGIC;
    signal Sample_Out_ready_filter    : STD_LOGIC;
        
begin

    utt0 : clk_12_Meg
        port map (  clk_out1    => clk_12megas,
                    reset       => reset,
                    clk_in1     => clk_100Mhz);
     
     
    
     utt1: en_4_clycles
        port map (  clk_12megas     => clk_12megas,
                    reset           => reset,
                    clk_3megas      => clk_3megas,
                    en_2_cycles     => en_2_cycles,
                    en_4_cycles     => en_4_cycles);
                    
                    
     uut2: FSMD_microphone
        port map (  clk_12megas         => clk_12megas,
                    reset               => reset,
                    enable_4_cycles     => en_4_cycles,
                    micro_data          => micro_data,
                    sample_out          => sample,
                    sample_out_ready    => sample_out_ready);
  
  
                    
     uut3: PWM 
        port map (  clk_12megas     => clk_12megas,
                    reset           => reset,
                    en_2_cycles     => en_2_cycles,
                    sample_in       => PWM_in,
                    pwm_pulse       => jack_pwm,
                    sample_request  => sample_request);   
     
    uut4:  clk_20k
        port map (  clk     => clk_12megas,
                    reset   => reset,
                    clk_20k => clk_20_k);
                    
    uut5: fir_filter 
        port map (  clk                 => clk_12megas,
                    reset               => reset,
                    Sample_in           => signed (memory_out),
                    Sample_In_enable    => Sample_In_enable,
                    filter_select       => SW1,
                    Sample_Out          => filter_out,
                    Sample_Out_ready    => Sample_Out_ready_filter);
                    
     uut6 : blk_mem_gen_0
                      PORT MAP (
                        clka => clk_12megas,
                        ena => ena,
                        wea => wea,
                        addra => STD_LOGIC_VECTOR(addra),
                        dina => sample,
                        douta => memory_out
                      );                              
     
                  
    micro_LR    <= '1';
    jack_sd     <= '1';   
    micro_clk   <= clk_3megas;                        
    led_out     <= sample;
    
    
    
    
    
    
    Process(clk_12megas)
    begin
        if(reset = '1') then
            state <= START;
        elsif( rising_edge(clk_12megas)) then
            state   <= state_n;
            cur_b   <= cur_b_n;
            last_b  <= last_b_n;
            ena     <= ena_n;
            wea     <= wea_n;
            addra   <= addra_n;
        end if;
    end process;
    
 -- Next State logic   
    Process(state, BTNL, BTNC, BTNR, cur_b, last_b) 
    begin
        case state is
            when START  =>
                state_n <= IDLE;
                
            when IDLE   =>
                if( BTNL = '1') then
                    state_n <= REC;
                elsif( BTNC = '1') then
                    state_n <= DELETE;
                elsif( BTNR = '1') then
                    state_n <= PLAY;
                end if;
                
            when REC    =>
                if(BTNL = '1') then
                    state_n <= REC;
                else
                    state_n <= IDLE;
                end if;
                
            when PLAY   =>
                if(cur_b = last_b) then
                    state_n <= IDLE;
                end if;
                
            when DELETE => 
                state_n     <= IDLE;
        end case;
    end process;
    
    
    
    
    Process(state, Sample_Out_ready_filter, sample_out_ready, clk_20_k ) 
    begin
        case state is 
            when START =>
                -- Init registers
                cur_b_n <= (others => '0');
                last_b_n <= (others => '0');
                Sample_In_enable_n <= '0';
                -- IDLE state -> waiting for action
            when IDLE =>
                cur_b_n <= (others => '0');
                ena_n <= '0';
                wea_n <= "0";
                -- Recording...
            when REC  =>
                ena_n <= '1';
                addra_n <=  last_b;
          
                if( sample_out_ready = '1') then
                    wea_n <= "1";
                    last_b_n <= last_b + 1; 
                else
                    wea_n <= "0";
                end if;
                
            when PLAY =>
                ena_n <= '1';   
                addra_n <= cur_b;
                
                --Output rate is 20Khz
                if( clk_20_k = '1') then    
                    cur_b_n <= cur_b + 1;
                    Sample_In_enable_n <= '1';
                else 
                    Sample_In_enable_n <= '0';
                end if;         
                
                if( Sample_Out_ready_filter = '1') then   
                    if(SW0 = '1') then
                        PWM_in <= STD_LOGIC_VECTOR( ( NOT filter_out(7))&filter_out(6 downto 0) );--filter out
                    else
                        PWM_in <=  memory_out;                                                      --memory out
                    end if;
                end if;
          
            when DELETE =>
                last_b_n <= (others => '0');
                
        end case;
    end process;
 
end Behavioral;
