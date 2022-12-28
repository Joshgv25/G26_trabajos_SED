----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 20:28:11
-- Design Name: 
-- Module Name: Decod_BCD_Piso_tb - Behavioral
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

entity Decod_BCD_Piso_tb is
--  Port ( );
end Decod_BCD_Piso_tb;

architecture tb of Decod_BCD_Piso_tb is
    component Decod_BCD_Piso
        port (n_bin : in std_logic_vector (3 downto 0);
              n_bcd : out std_logic_vector (6 downto 0));
    end component;

    signal n_bin : std_logic_vector (3 downto 0);
    signal n_bcd : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Decod_BCD_Piso
    port map (n_bin => n_bin,
              n_bcd => n_bcd);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        n_bin <= (others => '0');
        wait for 0.10*TbPeriod;
        n_bin <= "0001";
        wait for 0.10*TbPeriod;
        n_bin <= "0010";
        wait for 0.10*TbPeriod;
        n_bin <= "0100";
        wait for 0.10*TbPeriod;
        n_bin <= "1000";
        wait for TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
