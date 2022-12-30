----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 21:16:08
-- Design Name: 
-- Module Name: Mux_tb - Behavioral
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

entity Mux_tb is
--  Port ( );
end Mux_tb;

architecture tb of Mux_tb is
component Mux_4a1
        port (sel    : in std_logic_vector (1 downto 0);
              in1    : in std_logic_vector (6 downto 0);
              in2    : in std_logic_vector (6 downto 0);
              in3    : in std_logic_vector (6 downto 0);
              salida : out std_logic_vector (6 downto 0));
    end component;

    signal sel    : std_logic_vector (1 downto 0);
    signal in1    : std_logic_vector (6 downto 0);
    signal in2    : std_logic_vector (6 downto 0);
    signal in3    : std_logic_vector (6 downto 0);
    signal salida : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Mux_4a1
    port map (sel    => sel,
              in1    => in1,
              in2    => in2,
              in3    => in3,
              salida => salida);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';


    stimuli : process
    begin
        -- Inicializamos las entradas
        sel <= (others => '0');
        in1 <= "0000001";
        in2 <= "0000011";
        in3 <= "0000111";


        -- EDIT Add stimuli here
        wait for 0.1*TbPeriod;
        sel <= "01"; --La entrada de seleccion multiplexa y muestra en la salida la entrada in1
        wait for 0.1*TbPeriod;
        sel <= "10"; --La entrada de seleccion multiplexa y muestra en la salida la entrada in2
        wait for 0.1*TbPeriod;
        sel <= "11"; --La entrada de seleccion multiplexa y muestra en la salida la entrada in3
        wait for TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;



end tb;
