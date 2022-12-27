----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 20:20:14
-- Design Name: 
-- Module Name: clk_divisor_tb - Behavioral
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

entity clk_divisor_tb is
--  Port ( );
end clk_divisor_tb;

architecture Behavioral of clk_divisor_tb is
component clk_divider is
    Generic (frec: integer:=50000000);  -- default value is for 2hz
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
  end component;

  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal clk_out, clk_out2: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut1: clk_divider generic map ( frec    =>  3)
                      port map ( clk     => clk,
                                 reset   => reset,
                                 clk_out => clk_out );
  uut2: clk_divider generic map ( frec    =>  2)
                      port map ( clk     => clk,
                                 reset   => reset,
                                 clk_out => clk_out2 );                               
                                 
                            
  stimulus: process
  begin
  
   
	reset <= '1';
    wait for 10ns;
    reset <= '0';
    wait for 200ns;

    

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;



end Behavioral;
