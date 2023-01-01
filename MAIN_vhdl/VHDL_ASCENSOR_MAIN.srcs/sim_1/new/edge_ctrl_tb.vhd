----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2023 15:36:48
-- Design Name: 
-- Module Name: edge_ctrl_tb - Behavioral
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

entity edge_ctrl_tb is
--  Port ( );
end edge_ctrl_tb;

architecture Behavioral of edge_ctrl_tb is
component edge_ctrl
        port (CLK     : in std_logic;
              SYNC_IN : in std_logic;
              EDGE    : out std_logic);
    end component;

    signal CLK     : std_logic;
    signal SYNC_IN : std_logic;
    signal EDGE    : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : edge_ctrl
    port map (CLK     => CLK,
              SYNC_IN => SYNC_IN,
              EDGE    => EDGE);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/50 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        SYNC_IN <= '0';

        -- EDIT Add stimuli here
        wait for 25 ns;
        SYNC_IN <= '1';
        wait for 40 ns;
        SYNC_IN <= '0';
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;


end Behavioral;
