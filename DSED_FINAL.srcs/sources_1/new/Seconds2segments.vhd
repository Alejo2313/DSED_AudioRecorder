----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2018 11:30:46 PM
-- Design Name: 
-- Module Name: Seconds2segments - Behavioral
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


entity Seconds2segments is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           addrA : in unsigned (18 downto 0);
           addrB : in unsigned (18 downto 0);
           alarm : out STD_LOGIC;
           seg   : out STD_LOGIC_VECTOR (7 downto 0);
           an    : out STD_LOGIC_VECTOR (7 downto 0));
end Seconds2segments;

architecture Behavioral of Seconds2segments is
    --Components
    component decod7s 
        Port ( D : in  STD_LOGIC_VECTOR (3 downto 0);					
               S : out  STD_LOGIC_VECTOR (7 downto 0));   	
    end component;
    
    --Signals
    signal uSeconds, dSeconds   : STD_LOGIC_VECTOR (6 downto 0);
    signal addr                 : unsigned( 6 downto 0 );
    signal divider, src0, src1        : unsigned(6 downto 0);
    signal counter              : unsigned( 14 downto 0); 
    signal an_reg               : STD_LOGIC_VECTOR (7 downto 0);
    signal S                    : STD_LOGIC_VECTOR (7 downto 0);
    signal D                    : STD_LOGIC_VECTOR (3 downto 0);
    
    signal  R, G, B             : STD_LOGIC_VECTOR(7 downto 0);

begin

    uut1: decod7s 
        port map ( D => D,
                   S => S);
                                
    process(clk) 
    
    
    begin
        if(reset = '1') then
            counter <= (others => '0');
        elsif(rising_edge(clk)) then
            counter <= counter + 1;
            
            if(addrA(18 downto 12) = 127) then
                alarm <= '1';
            elsif(addrA(18 downto 12) = 112 ) then
                alarm <= '1';
            else
                alarm <= '0';
            end if;
            
            
            if(addrA(18) = '0') then
                B <= (others => '1');
                R <= STD_LOGIC_VECTOR(addrA(17 downto 10));
                G <= STD_LOGIC_VECTOR(addrA(17 downto 10));
                
            else
                R <= (others => '1');
                G <= STD_LOGIC_VECTOR(NOT addrA(17 downto 10));
                B <= STD_LOGIC_VECTOR(NOT addrA(17 downto 10));
                
            end if;
            
        end if;
    end process;


    -- Anodes out!
    with counter(14 downto 13)
    select an_reg <=    "11111110" when  "00",   --Using only 4 displays. Fr ~ 12M/(2^15) = 366Hz
                        "11111101" when  "01",
                        "11111011" when  "10",
                        "11110111" when  "11",
                        "11111111" when others;
                        

    --Comparation source selection! -->                                
    with counter(14) 
        select src0 <=  (others => '1')     when  '1',
                        addrB(18 downto 12) when  others;
    with counter(14) 
        select src1 <=  addrA(18 downto 12) when  '1',
                        (others => '0')     when  others;                    
                        
     -- Logic!
     
    divider <= (src0 - src1) / 5;   -->srcX son multiplos de 2^12 = 4096. Por tanto 4096*5 = 20480.
                                    -- Comentemos un error en cada segundo, pero reduccimos en más de la
                                    -- mitad el area y el número de nets utilizadas.                
                                                                               
    uSeconds <= STD_LOGIC_VECTOR(divider rem 10 );
    dSeconds <= STD_LOGIC_VECTOR(divider / 10 )  ;
    
    --Segments output selection!! 
    with counter(13)
    select D <=  uSeconds(3 downto 0) when '0',
                 dSeconds(3 downto 0) when '1',
                 (others => '0') when  others;
    
    --Output Logic             
    an <= an_reg;
    seg <= S;
                 
              
end Behavioral;
