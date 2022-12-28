----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 20:58:35
-- Design Name: 
-- Module Name: Decod_sel_tb - Behavioral
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

entity Decod_sel_tb is
--  Port ( );
end Decod_sel_tb;

architecture tb of Decod_sel_tb is
 component Decod_sel
        port (in_sel  : in std_logic_vector (1 downto 0);
              out_sel : out std_logic_vector (7 downto 0));
    end component;

    signal in_sel  : std_logic_vector (1 downto 0);
    signal out_sel : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Decod_sel
    port map (in_sel  => in_sel,
              out_sel => out_sel);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        in_sel <= (others => '1');
        wait for 0.10*TbPeriod;
        in_sel <= "00";
        wait for 0.10*TbPeriod;
        in_sel <= "01";
        wait for 0.10*TbPeriod;
        in_sel <= "10";
        wait for TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
