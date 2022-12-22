----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2022 16:11:50
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use iEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           salida : out std_logic_vector(1 downto 0));
end Counter;

architecture Behavioral of Counter is
signal s_salida : unsigned (salida'range);
begin
    count : process (clk, reset_n)
    begin 
       if reset_n = '0' then
            s_salida <= "00";
       elsif rising_edge (clk) then
            s_salida <= (s_salida + 1) mod 3;
       end if;     
    end process;

end Behavioral;
