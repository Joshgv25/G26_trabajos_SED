----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2022 15:36:35
-- Design Name: 
-- Module Name: MixVector_tb - Behavioral
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

entity MixVector_tb is
--  Port ( );
end MixVector_tb;

architecture Behavioral of MixVector_tb is
component mix_vector
        port (bit0       : in std_logic;
              bit1       : in std_logic;
              bit2       : in std_logic;
              bit3       : in std_logic;
              pSig: in std_logic_vector(3 downto 0);
              clk        : in std_logic;
              CE         : in std_logic;
              vec_salida : out std_logic_vector (3 downto 0));
    end component;

    signal bit0       : std_logic;
    signal bit1       : std_logic;
    signal bit2       : std_logic;
    signal bit3       : std_logic;
    signal pSig       : std_logic_vector(3 downto 0);
    signal clk        : std_logic;
    signal CE         : std_logic;
    signal vec_salida : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : mix_vector
    port map (bit0       => bit0,
              bit1       => bit1,
              bit2       => bit2,
              bit3       => bit3,
              pSig       => pSig,
              clk        => clk,
              CE         => CE,
              vec_salida => vec_salida);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        bit0 <= '0';
        bit1 <= '0';
        bit2 <= '0';
        bit3 <= '0';
        CE <= '0';

        -- Reset generation
        

        -- EDIT Add stimuli here
        wait for 15 ns;
        bit2 <= '1', '0' after TbPeriod;--lo que dura un estimulo(boton) gracias al edge_ctr
        wait for 30 ns;
        CE <= '1';--el ascensor se pone a funcionar
        wait for 2 * TbPeriod;--espera dos periodos
        bit1 <= '1', '0' after TbPeriod;--lo que dura un estimulo(boton) gracias al edge_ctr
        --como el motor se está moviendo, debería ignorarlo
        wait for TbPeriod;--espera un periodo
        pSig <= "0010";--el piso siguiente debería ser el 1(aun estamos subiendo del 0 al 1)
        bit3 <= '1', '0' after TbPeriod;--lo que dura un estimulo(boton) gracias al edge_ctr
        --como el ascensor se está moviendo, deberia ignorarlo
        wait for TbPeriod;--espera un periodo
        --¿que pasa cuando pulsamos otra vez el botón inicial(este caso el bit2)?
        --Seria como despulsar un boton del ascensor
        --Segun el codigo, debería assignar a la salida, la entrada pSig
        --pSig representa la entrada a dnd nos estábamos dirigiendo(las más cercana)(la siguiente)
        bit2 <= '1', '0' after TbPeriod;--lo que dura un estimulo(boton) gracias al edge_ctr
        
        
      
        wait for 1000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;



end Behavioral;
