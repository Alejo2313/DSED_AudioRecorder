----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2018 05:46:10 PM
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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


entity audio_interface is
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
end audio_interface;

architecture Behavioral of audio_interface is

    component en_4_cycles is
        Port ( clk_12megas  : in STD_LOGIC;
               reset        : in STD_LOGIC;
               clk_3megas   : out STD_LOGIC;
               en_2_cycles  : out STD_LOGIC;
               en_4_cycles  : out STD_LOGIC);
    end component;
    
    component FSMD_microphone is
        Port ( clk_12megas  : in STD_LOGIC;
               reset        : in STD_LOGIC;
               enable_4_cycles  : in STD_LOGIC;
               micro_data   : in STD_LOGIC;
               sample_out   : out STD_LOGIC_VECTOR (sample_size -1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    component PWM is
        Port ( clk_12megas  : in STD_LOGIC;
               reset        : in STD_LOGIC;
               en_2_cycles  : in STD_LOGIC;
               sample_in    : in STD_LOGIC_VECTOR (sample_size -1 downto 0);
               pwm_pulse    : out STD_LOGIC;
               sample_request : out STD_LOGIC);
    end component;
    
    
    
 --Signals
 
    signal clk_3megas   : STD_LOGIC;
    signal en_2cycles   : STD_LOGIC;
    signal en_4cycles   : STD_LOGIC;
    signal sample       : STD_LOGIC_VECTOR (sample_size -1 downto 0);
    signal sample_out_r : STD_LOGIC;
        
begin

     utt1: en_4_cycles
        port map (  clk_12megas => clk_12megas,
                    reset       => reset,
                    clk_3megas  => clk_3megas,
                    en_2_cycles => en_2_cycles,
                    en_4_cycles => en_4cycles);
                    
                    
     uut2: FSMD_microphone
        port map (  clk_12megas => clk_12megas,
                    reset       => reset,
                    enable_4_cycles  => en_4cycles,
                    micro_data  => micro_data,
                    sample_out   => sample_out,
                    sample_out_ready => sample_out_ready);
                    
     uut3: PWM 
        port map (  clk_12megas => clk_12megas,
                    reset       => reset,
                    en_2_cycles => en_2cycles,
                    sample_in   => sample_in,
                    pwm_pulse   => jack_pwm,
                    sample_request  => sample_request);   
              
    micro_LR    <= '1';
    jack_sd     <= '1';   
    micro_clk   <= clk_3megas; 
    en_2_cycles <= en_2cycles;
    
    
end Behavioral;
