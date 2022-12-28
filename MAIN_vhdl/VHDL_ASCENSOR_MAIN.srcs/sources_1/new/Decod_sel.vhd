----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2022 16:58:49
-- Design Name: 
-- Module Name: Decod_sel - Behavioral
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

entity Decod_sel is
    Port ( in_sel : in STD_LOGIC_VECTOR (1 downto 0);
           out_sel : out STD_LOGIC_VECTOR (7 downto 0)); --( bits, como la cantidad de displays que hay
end Decod_sel;

architecture Behavioral of Decod_sel is
signal s_outsel : std_logic_vector (out_sel'range);
begin
    conversion : process (in_sel)
    begin
        if in_sel = "00" then
            s_outsel <= "11111110";
        elsif in_sel = "01" then
            s_outsel <= "11111101";
        elsif in_sel = "10" then
            s_outsel <= "11111011";
        else
            s_outsel <= "11111111";
        end if; 
    end process;
    out_sel <= s_outsel;
end Behavioral;
