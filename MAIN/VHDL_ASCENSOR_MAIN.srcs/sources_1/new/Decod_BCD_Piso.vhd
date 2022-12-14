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
    WITH code SELECT
        n_bcd <= "0000001" WHEN "0000",
                 "1001111" WHEN "0001",
                 "0010010" WHEN "0010",
                 "0000110" WHEN "0011",
                 "1001100" WHEN "0100",
                 "0100100" WHEN "0101",
                 "0100000" WHEN "0110",
                 "0001111" WHEN "0111",
                 "0000000" WHEN "1000",
                 "0000100" WHEN "1001",
                 "1111110" WHEN others;

end Dataflow;
