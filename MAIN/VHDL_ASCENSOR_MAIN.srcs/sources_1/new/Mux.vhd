----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2022 16:01:38
-- Design Name: 
-- Module Name: Mux_4a1 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--Entidad creada con el fin de multiplexar lo que se muestra en los displays
--ya que tendremos 3 fuentes de información por representar.
--En teoría el multiplexor es de 4 a 1, pero solo vamos a multiplexar 3 entradas
entity Mux_4a1 is
    Port ( sel : in STD_LOGIC_VECTOR (1 downto 0); --La entrada de selección vendrá de la salida de un contador
           in1 : in STD_LOGIC_VECTOR (6 downto 0);
           in2 : in STD_LOGIC_VECTOR (6 downto 0);
           in3 : in STD_LOGIC_VECTOR (6 downto 0);
           salida : out STD_LOGIC_VECTOR (6 downto 0));
end Mux_4a1;

architecture Behavioral of Mux_4a1 is
signal s_salida : std_logic_vector (salida'range);
begin
    mux : process (sel)
    begin
        if (sel = "00") then
            s_salida <= in1;
        elsif (sel = "01") then
            s_salida <= in2;
        elsif (sel = "10") then
            s_salida <= in3;
        else
            s_salida <= "1111110";
        end if;
    end process;
salida <= s_salida;
end Behavioral;
