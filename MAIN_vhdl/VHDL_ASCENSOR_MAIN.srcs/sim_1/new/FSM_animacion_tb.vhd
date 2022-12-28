----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2022 16:41:11
-- Design Name: 
-- Module Name: FSM_animacion_tb - Behavioral
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

entity FSM_animacion_tb is
--  Port ( );
end FSM_animacion_tb;

architecture Behavioral of FSM_animacion_tb is
component FSM_animacion
        port (clk      : in std_logic;
              reset_n  : in std_logic;
              in_motor : in std_logic_vector (1 downto 0);
              out_bcd  : out std_logic_vector (6 downto 0));
    end component;

    signal clk      : std_logic;
    signal reset_n  : std_logic;
    signal in_motor : std_logic_vector (1 downto 0);
    signal out_bcd  : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    

begin

    dut : FSM_animacion
    port map (clk      => clk,
              reset_n  => reset_n,
              in_motor => in_motor,
              out_bcd  => out_bcd);

    -- Clock generation
     clk_process :process
  begin
    clk <= '0';
    wait for 0.05 * TbPeriod;
    clk <= '1';
    wait for 0.05 * TbPeriod;
  end process;

    -- EDIT: Check that clk is really your main clock signal
    

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        in_motor <= "11";

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 5 ns;
        reset_n <= '1';
        wait for 5 ns;

        -- EDIT Add stimuli here
        wait for 0.3*TbPeriod;
        in_motor <= "00";
        wait for 0.3*TbPeriod;
        in_motor <= "10";
        wait for 0.3*TbPeriod;
        assert false;
            report "[SUCCESS]: simulation finished."
            severity failure;
        -- Stop the clock and hence terminate the simulation
        
    end process;


end Behavioral;
