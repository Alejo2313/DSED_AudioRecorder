----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2018 13:01:04
-- Design Name: 
-- Module Name: package_dsed - Behavioral
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

package package_dsed is
    constant sample_size : integer := 8;
    constant ciclos : integer := 300; 
    constant val_1 : std_logic_vector( sample_size-1 downto 0) := (0 => '1', others => '0');
--    constant val_105 : std_logic_vector := std_logic_vector(to_unsigned(105,val_1'length));
    constant val_105 : std_logic_vector ( sample_size downto 0) := "001101001";
    
    constant val_150 : std_logic_vector ( sample_size downto 0) := "010010110";
    
    constant val_255 : std_logic_vector ( sample_size downto 0) := (8 => '0', others => '1');
    
    constant val_299 : std_logic_vector ( sample_size downto 0) := "100101011";
    function maxab (a: integer ;b : integer) return integer; 
    function log2c (n: integer) return integer;
    constant val_300 : std_logic_vector (log2c(ciclos) -1 downto 0) :="100101100";   
    constant val_301 : std_logic_vector :=std_logic_vector( to_unsigned(301,log2c(ciclos)-1));
    
    type MUX_IN_8_8 is array (0 to 4) of signed(7 downto 0);


end package_dsed;

-- package body
package body package_dsed is 
    function log2c(n: integer) return integer is 
        variable m,p : integer;
    begin
        m := 0;
        p := 1;
        while p < n loop
        m := m + 1;
        p := p * 2;
        end loop;
        return m;
    end log2c;
    function maxab (a: integer ;b : integer) return integer is
        begin
            if( a >= log2c(b)) then
                return a;
            else
                return log2c(b);
            end if;    
    end maxab;
end package_dsed;
