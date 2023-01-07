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
           salida : out unsigned(1 downto 0));
end Counter;

architecture Behavioral of Counter is
signal s_salida : unsigned (salida'range);
begin
    count : process (clk, reset_n)
    begin 
       if reset_n = '0' then
            s_salida <= "00";
       elsif rising_edge (clk) then --A cada pulso de reloj se ira aumentando en 1 el valor de la salida, pero solo tomando valores de entre 0 y 2 decimal
            s_salida <= (s_salida + 1) mod 3; --Solo toma 3 valores distintos porque es el numero de informacion diferente que queremos mostrar en el display
       end if;     
    end process;
salida <= s_salida;
end Behavioral;
