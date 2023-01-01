----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2023 15:27:22
-- Design Name: 
-- Module Name: Sincronizador_tb - Behavioral
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

entity Sincronizador_tb is
--  Port ( );
end Sincronizador_tb;

architecture Behavioral of Sincronizador_tb is
component Sincronizador
        port (CLK      : in std_logic;
              ASYNC_IN : in std_logic;
              SYNC_OUT : out std_logic);
    end component;

    signal CLK      : std_logic;
    signal ASYNC_IN : std_logic;
    signal SYNC_OUT : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Sincronizador
    port map (CLK      => CLK,
              ASYNC_IN => ASYNC_IN,
              SYNC_OUT => SYNC_OUT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/50 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        ASYNC_IN <= '0';

        -- EDIT Add stimuli here
        wait for 19 ns;
        ASYNC_IN <= '1';
        wait for 2 ns;
        ASYNC_IN <= '0';
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;



end Behavioral;
