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
           led_out      : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
           state_out    : out STD_LOGIC_VECTOR(2 downto 0);
           
           seg          : out STD_LOGIC_VECTOR (7 downto 0);
           an           : out STD_LOGIC_VECTOR (7 downto 0);
           RGB          : out STD_LOGIC_VECTOR (2 downto 0));
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
    
    
    component audio_interface 
        Port (  clk_12megas : in STD_LOGIC;
                reset : in STD_LOGIC;
                --Recording ports
                --To/From the controller
                record_enable:  in STD_LOGIC;
                sample_out:     out STD_LOGIC_VECTOR (sample_size-1 downto 0);
                sample_out_ready: out STD_LOGIC;
                --To/From the microphone
                micro_clk : out STD_LOGIC;
                micro_data : in STD_LOGIC;
                micro_LR : out STD_LOGIC;
                --Playing ports
                --To/From the controller
                play_enable: in STD_LOGIC;
                sample_in: in std_logic_vector(sample_size-1 downto 0);
                sample_request: out std_logic;
                --To/From the mini-jack
                jack_sd : out STD_LOGIC;
                jack_pwm : out STD_LOGIC;
                en_2_cycles  : out STD_LOGIC);
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

    component Seconds2segments 
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               addrA : in unsigned (18 downto 0);
               addrB : in unsigned (18 downto 0);
               alarm : out STD_LOGIC;
               seg : out STD_LOGIC_VECTOR (7 downto 0);
               an : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    
    component RGB_controller 
        Port (  clk   : in STD_LOGIC;
                reset : in  STD_LOGIC;
                addrA : in unsigned (18 downto 0);
                en_2_cycles  : in STD_LOGIC;
                R : out STD_LOGIC;
                G : out STD_LOGIC;
                B : out STD_LOGIC);
    end component;
    
    

    
 --Signals
 
    signal state, state_n   : state_t;
    signal clk_12megas      : STD_LOGIC;
    signal en_2cycles  : STD_LOGIC;

    signal sample, memory_out, PWM_in ,PWM_in_n         : STD_LOGIC_VECTOR (sample_size -1 downto 0);
    signal filter_out       : signed (sample_size -1 downto 0);
    signal sample_out_ready : STD_LOGIC;
    signal sample_request   : STD_LOGIC;
    
    signal cur_b, last_b        : unsigned(18 downto 0) := (others => '0') ;    -- Memory Pointers 
    signal cur_b_n, last_b_n    : unsigned(18 downto 0) := (others => '0'); 
    
    signal addra, addra_n       : unsigned(18 downto 0) := (others => '0');     --current address
    signal ena, ena_n           : STD_LOGIC;                                    -- RAM control signals
    signal wea, wea_n           : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal alarm                : STD_LOGIC;
    
    signal Sample_In_enable, Sample_In_enable_n : STD_LOGIC;
    signal Sample_Out_ready_filter    : STD_LOGIC;
    
    signal Sample_in_filtet     : signed( sample_size -1 downto 0);
    signal led_out_reg, led_out_n : STD_LOGIC_VECTOR(7 downto 0);
        
    constant full_memory    : unsigned(18 downto 0) := (others => '1');
    
    
    
        
begin

    utt0 : clk_12_Meg
        port map (  clk_out1    => clk_12megas,
                    reset       => reset,
                    clk_in1     => clk_100Mhz);
     
    uut1: audio_interface 
        Port map (  clk_12megas => clk_12megas,
                    reset       => reset,
                    sample_out  => sample,
                    micro_clk   => micro_clk,
                    micro_data  => micro_data,
                    micro_LR    => micro_LR,
                    play_enable => ena_n,
                    sample_in   => PWM_in,
                    jack_sd     => jack_sd,
                    jack_pwm    => jack_pwm,
                    record_enable   => ena_n,                    
                    sample_request  => sample_request,
                    sample_out_ready => sample_out_ready,
                    en_2_cycles => en_2cycles);
                    
    uut5: fir_filter 
        port map (  clk                 => clk_12megas,
                    reset               => reset,
                    Sample_in           => Sample_in_filtet,
                    Sample_In_enable    => Sample_In_enable,
                    filter_select       => SW0,
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
     
    uut7 : Seconds2segments
        port map (  clk     => clk_12megas,
                    reset   => reset,
                    addrA   => last_b,
                    addrB   => cur_b,
                    alarm   => alarm,
                    seg     => seg,
                    an      => an
                    );
    uut8: RGB_controller
        port map (  clk => clk_12megas,
                    reset => reset,
                    addrA => last_b,
                    en_2_cycles => en_2cycles,
                    R   => RGB(0),
                    G   => RGB(1),
                    B   => RGB(2));       
     
    Sample_in_filtet <= signed ( (NOT memory_out(7))&memory_out(6 downto 0));                                      
    led_out     <=  led_out_reg;

    Process(clk_12megas, reset)
        
    begin
        if(reset = '1') then
            state <= START;
            ena   <= '0';
            wea   <= "0";
            addra <= (others => '0');
            cur_b <= (others => '0');
            last_b <= (others => '0');
            sample_in_enable <= '0';
            PWM_in <= (others => '0');
            led_out_reg <= (others => '0');
            
        elsif( rising_edge(clk_12megas)) then
            state   <= state_n;
            cur_b   <= cur_b_n;
            last_b  <= last_b_n;
            ena     <= ena_n;
            wea     <= wea_n;
            addra   <= addra_n;
            Sample_In_enable <= Sample_In_enable_n;
            PWM_in <= PWM_in_n;
            led_out_reg <= led_out_n;
            
        end if;
    end process;
    
 -- Next State logic   
    Process(state, BTNL, BTNC, BTNR, cur_b, last_b) 
    begin
        state_n <= state;
        
        state_out <= "000";
        case state is
            when START  =>
               state_out <= "001";
               state_n <= IDLE;
                
            when IDLE   =>
                state_out <= "010";
                if( BTNL = '1') then
                    state_n <= REC;
                elsif( BTNC = '1') then
                    state_n <= DELETE;
                elsif( BTNR = '1') then
                    state_n <= PLAY;
                end if;
                
            when REC    =>
                state_out <= "011";
                if(BTNL = '1') then
                    state_n <= REC;
                else
                    state_n <= IDLE;
                end if;
                
                
            when PLAY   =>
                state_out <= "100";
                
                if( ((NOT SW1)AND SW0) = '1') then
                    if(cur_b = 0) then
                        state_n <= IDLE;
                    end if;
                else
                    if(cur_b = last_b) then
                        state_n <= IDLE;
                    end if;
                end if;


            when DELETE => 
                state_out <= "101";
                state_n     <= IDLE;
           
        end case;
    end process;
    
    
    Process(state, Sample_Out_ready_filter, sample_out_ready, sample_request ) 
    begin
        wea_n   <= "0";
        ena_n   <= '0';
        PWM_in_n  <= PWM_in;
        cur_b_n   <= cur_b;
        last_b_n  <= last_b;
        addra_n   <= addra;
        led_out_n <= (others => '0');
        
        sample_in_enable_n <= '0';
        
        case state is 
            when START =>
                -- Init registers
                cur_b_n <= (others => '0');
                last_b_n <= (others => '0');
                Sample_In_enable_n <= '0';
                ena_n <= '0';
                wea_n <= "0";
                addra_n <= (others => '0');
                            
                -- IDLE state -> waiting for action
            when IDLE =>
                PWM_in_n<= (others => '0');
                ena_n <= '0';
                wea_n <= "0";
                 
                if( SW1 = '1') then
                    cur_b_n <= (others => '0');                            
                else 
                    if( SW0 = '1') then
                        cur_b_n <= last_b;
                    else
                        cur_b_n <= (others => '0');
                    end if;      
                    
                end if;
                    
                -- Recording...
                
            when REC  =>
                ena_n <= '1';
               -- PWM_in_n <= (others =>'0');
                led_out_n <= memory_out;
                
                if( alarm = '1') then
                        PWM_in_n <= STD_LOGIC_VECTOR( unsigned(PWM_in) +1);
                end if;
                
                if( last_b /= full_memory) then           
                    if( sample_out_ready = '1') then
                        addra_n <=  last_b;
                        wea_n <= "1";
                        last_b_n <= last_b + 1; 
                     else
                        wea_n <= "0";
                     end if;                    
                end if;
  
                
            when PLAY =>
                ena_n <= '1';  
                led_out_n <= PWM_in; 
                
                if(sample_request = '1') then
                    addra_n <= cur_b;                    
                    if( SW1 = '1') then
                        Sample_In_enable_n <= '1';
                        PWM_in_n <= STD_LOGIC_VECTOR((NOT filter_out(7))&filter_out(6 downto 0) );--filter out
                        cur_b_n <= cur_b + 1;

                    else
                         PWM_in_n <=  memory_out;
                         if( SW0 = '1' ) then
                            cur_b_n <= cur_b - 1;
                         else 
                            cur_b_n <= cur_b + 1;
                         end if;
                    end if;
                    
                else
                    Sample_In_enable_n <= '0';     
                end if;
                
            when DELETE =>
                last_b_n <= (others => '0');
                
        end case;
    end process;
 

 
end Behavioral;
