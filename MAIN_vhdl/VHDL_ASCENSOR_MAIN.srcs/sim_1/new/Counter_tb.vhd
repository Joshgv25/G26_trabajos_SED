----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 21:27:53
-- Design Name: 
-- Module Name: Counter_tb - Behavioral
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
--Para este testbench solamente debemos comprobar que a cada flanco de subida del reloj, el valor del contador aumenta en 1
entity Counter_tb is
--  Port ( );
end Counter_tb;

architecture Behavioral of Counter_tb is
  component Counter
        port (clk     : in std_logic;
              reset_n : in std_logic;
              salida  : out unsigned (1 downto 0));
    end component;

    signal clk     : std_logic;
    signal reset_n : std_logic;
    signal salida  : unsigned (1 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Counter
    port map (clk     => clk,
              reset_n => reset_n,
              salida  => salida);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/10 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;




end Behavioral;
