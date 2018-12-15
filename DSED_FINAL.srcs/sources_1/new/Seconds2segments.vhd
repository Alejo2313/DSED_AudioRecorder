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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Seconds2segments is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           addrA : in unsigned (18 downto 0);
           addrB : in unsigned (18 downto 0);
           seg   : out STD_LOGIC_VECTOR (7 downto 0);
           an    : out STD_LOGIC_VECTOR (7 downto 0));
end Seconds2segments;

architecture Behavioral of Seconds2segments is

    component decod7s 
    Port ( D : in  STD_LOGIC_VECTOR (3 downto 0);					 -- entrada de datos en binario
           S : out  STD_LOGIC_VECTOR (7 downto 0));   	 -- salidas para los segmentos
    end component;


    signal divider, addr, size  : unsigned( 18 downto 0 );
    signal counter              : unsigned( 14 downto 0);
    
    signal an_reg   : STD_LOGIC_VECTOR (7 downto 0);
    
    signal uSeconds, dSeconds : STD_LOGIC_VECTOR (4 downto 0);
    signal S :  STD_LOGIC_VECTOR (7 downto 0);
    signal D :  STD_LOGIC_VECTOR (3 downto 0);

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
        end if;
    end process;

    with counter(14 downto 13)
    select an_reg <=    "11111110" when  "00",
                        "11111101" when  "01",
                        "11111011" when  "10",
                        "11110111" when  "11";
                        
    with counter(14) 
        select addr <=  addrA when  '1',
                        addrB when '0';             
    with counter(14) 
        select size <=  (others => '1') when  '1',
                        (others => '0') when '0';   
                                                                   
    divider  <= ( size - addr) / 20000; 
    uSeconds <= STD_LOGIC_VECTOR(divider(4 downto 0) rem 10 );
    dSeconds <= STD_LOGIC_VECTOR(divider(4 downto 0) / 10 )  ;
    
    with counter(13)
    select D <=  uSeconds(3 downto 0) when '0',
                 dSeconds(3 downto 0) when '1';
                 
    an <= an_reg;
    seg <= S;
                 
                 
                 

end Behavioral;
