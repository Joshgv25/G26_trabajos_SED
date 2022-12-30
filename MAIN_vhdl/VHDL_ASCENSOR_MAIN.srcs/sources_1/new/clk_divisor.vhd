----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2022 13:17:31
-- Design Name: 
-- Module Name: clk_divisor - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divisor is
 Generic (frec: integer:=50000000);  -- default value is for 2hz
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end clk_divisor;

architecture Behavioral of clk_divisor is
signal clk_sig: std_logic;
begin

  process (clk,reset)
  variable cnt:integer;
  begin
		if (reset='1') then
		  cnt:=0;
		  clk_sig<='0';
		elsif rising_edge(clk) then--------------------------------------------------------------------------
			cnt:=cnt+1;
            if (cnt=frec) then
				cnt:=0;
				clk_sig<=not(clk_sig);
			end if;
		end if;
  end process;
  clk_out<=clk_sig;
end Behavioral;
