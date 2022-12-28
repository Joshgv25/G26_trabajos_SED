----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 16:27:32
-- Design Name: 
-- Module Name: Decod_BCD_Piso - Behavioral
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
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decod_BCD_Piso is
    Port ( n_bin : in STD_LOGIC_VECTOR (3 downto 0);
           n_bcd : out STD_LOGIC_VECTOR (6 downto 0));
           
end Decod_BCD_Piso;

architecture Dataflow of Decod_BCD_Piso is
begin
    WITH n_bin SELECT
        n_bcd <= "0000001" WHEN "0001", --Muestra el 0 cuando estamos en el piso 0
                 "1001111" WHEN "0010", --Muestra el 1 cuando estamos en el piso 1
                 "0010010" WHEN "0100", --Muestra el 2 cuando estamos en el piso 2
                 "0000110" WHEN "1000", --Muestra el 3 cuando estamos en el piso 3
                 "1111110" WHEN others; --Si por algún casusl hubiese un error, se muestra una linea

end Dataflow;
