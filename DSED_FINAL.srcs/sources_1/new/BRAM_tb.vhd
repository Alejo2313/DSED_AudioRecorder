----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2018 08:43:44 AM
-- Design Name: 
-- Module Name: BRAM_tb - Behavioral
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

entity BRAM_tb is
--  Port ( );
end BRAM_tb;

architecture Behavioral of BRAM_tb is
COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal clka : STD_LOGIC;
signal ena : STD_LOGIC;
signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal addra : STD_LOGIC_VECTOR(18 DOWNTO 0);
signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal douta : STD_LOGIC_VECTOR(7 DOWNTO 0);

constant clock_period : TIME := 10ns;

begin

    your_instance_name : blk_mem_gen_0
          PORT MAP (
            clka => clka,
            ena => ena,
            wea => wea,
            addra => addra,
            dina => dina,
            douta => douta
      );


    process
        variable value : unsigned(7 downto 0) := (others => '0');
        variable addr  : unsigned(18 downto 0) := (others => '0');
    begin
        -- INIT BLOCK
        ena <= '1';
        
        -- WRITE THREE BLOCKS
        
        wea <= "1";
        
        for i in 0 to 10 loop
            addra <= STD_LOGIC_VECTOR( addr );
            dina <= STD_LOGIC_VECTOR( value );
            wait for clock_period;
            addr := addr + 1;
            value := value + 1;       
        end loop;
        
        wea <= "0";
        addr := (others => '0');
        for i in 0 to 10 loop
            addra <= STD_LOGIC_VECTOR( addr );
            wait for clock_period;
            addr := addr + 1;
        end loop;
    
    end process;

    process
    begin
        clka <= '1', '0' after clock_period / 2;
        wait for clock_period;
    end process;
end Behavioral;
