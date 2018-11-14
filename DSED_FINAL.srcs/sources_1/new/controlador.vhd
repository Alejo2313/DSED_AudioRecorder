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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador is
    Port ( clk_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           --test
           led_out : out STD_LOGIC_VECTOR(sample_size - 1 downto 0));
end controlador;

architecture Behavioral of controlador is

--Components
    component clk_12_Meg
        port
         (-- Clock in ports
          -- Clock out ports
          clk_out1          : out    std_logic;
          -- Status and control signals
          reset             : in     std_logic;
          clk_in1           : in     std_logic
         );
    end component;

    component en_4_clycles is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_3megas : out STD_LOGIC;
               en_2_cycles : out STD_LOGIC;
               en_4_cycles : out STD_LOGIC);
    end component;
    
    component FSMD_microphone is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable_4cycles : in STD_LOGIC;
               micro_data : in STD_LOGIC;
               sample_out : out STD_LOGIC_VECTOR (sample_size -1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    component PWM is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               en_2cycles : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size -1 downto 0);
               pwm_pulse : out STD_LOGIC;
               sample_request : out STD_LOGIC);
    end component;
    
    
    
 --Signals
 
    signal clk_12megas :  STD_LOGIC;
    signal clk_3megas : STD_LOGIC;
    signal en_2_cycles : STD_LOGIC;
    signal en_4_cycles :  STD_LOGIC;
    signal sample :  STD_LOGIC_VECTOR (sample_size -1 downto 0);
    signal sample_out_ready :  STD_LOGIC;
    signal sample_request : STD_LOGIC;
        
begin

    utt0 : clk_12_Meg
        port map ( 
      -- Clock out ports  
            clk_out1 => clk_12megas,
      -- Status and control signals                
            reset => reset,
       -- Clock in ports
            clk_in1 => clk_100Mhz
     );
     
    
     utt1: en_4_clycles
        port map (  clk_12megas => clk_12megas,
                    reset => reset,
                    clk_3megas => clk_3megas,
                    en_2_cycles => en_2_cycles,
                    en_4_cycles => en_4_cycles);
                    
                    
     uut2: FSMD_microphone
        port map (  clk_12megas => clk_12megas,
                    reset => reset,
                    enable_4cycles => en_4_cycles,
                    micro_data => micro_data,
                    sample_out => sample,
                    sample_out_ready => sample_out_ready);
                    
     uut3: PWM 
        port map (  clk_12megas => clk_12megas,
                    reset => reset,
                    en_2cycles => en_2_cycles,
                    sample_in => sample,
                    pwm_pulse => jack_pwm,
                    sample_request => sample_request);   
              
    micro_LR <= '1';
    jack_sd <= '1';   
    micro_clk <= clk_3megas;                        
    led_out <= sample;
end Behavioral;
