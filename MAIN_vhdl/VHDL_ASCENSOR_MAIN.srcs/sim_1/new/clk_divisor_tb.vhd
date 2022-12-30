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
component clk_divisor
        generic (frec: integer:=50000000);
        port (clk     : in std_logic;
              reset   : in std_logic;
              clk_out : out std_logic);
    end component;

    signal clk     : std_logic;
    signal reset   : std_logic;
    signal clk_out : std_logic;
    signal clk_out2 : std_logic;
    signal clk_out3 : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut1 : clk_divisor
    generic map( frec => 1) --El reloj tendra un periodo 2 veces mayor (2*frec veces mayor)
    port map (clk     => clk,
              reset   => reset,
              clk_out => clk_out);
              
    dut2 : clk_divisor
    generic map( frec => 2) -- El reloj tednrá un periodo 4 veces mayor (2*frec veces mayor)
    port map (clk     => clk,
              reset   => reset,
              clk_out => clk_out2);
    
    dut3 : clk_divisor
    generic map( frec => 3) -- El reloj tednrá un periodo 6 veces mayor (2*frec veces mayor)
    port map (clk     => clk,
              reset   => reset,
              clk_out => clk_out3);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/20 when TbSimEnded /= '1' else '0'; --Periodo de 100 ns

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;



end Behavioral;
