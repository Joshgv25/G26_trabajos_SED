----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 21:58:57
-- Design Name: 
-- Module Name: filtro_tb - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

entity tb_filtro is
end tb_filtro;

architecture tb of tb_filtro is

    component filtro
        port (motor      : in std_logic_vector (1 downto 0);
              switch_bit : in std_logic_vector (3 downto 0);
              clk        : in std_logic;
              validez    : out std_logic;
              sig_salida : out std_logic_vector (3 downto 0));
    end component;

    signal motor      : std_logic_vector (1 downto 0);
    signal switch_bit : std_logic_vector (3 downto 0);
    signal clk        : std_logic;
    signal validez    : std_logic;
    signal sig_salida : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : filtro
    port map (motor      => motor,
              switch_bit => switch_bit,
              clk        => clk,
              validez    => validez,
              sig_salida => sig_salida);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        motor <= (others => '0');
        switch_bit <= (others => '0');

        -- EDIT Add stimuli here
        wait for 20 * TbPeriod;--que pasen 20 periodos
        switch_bit <= "0001";
        wait for 5 * TbPeriod;
        motor <= "11"; --motor activado y sube
        wait for 10 * TbPeriod;--espera 10 periodos
        switch_bit <= "0010";
        wait for 10 * TbPeriod;--espera 10 periodos
        switch_bit <= "0001";
        wait for 10 * TbPeriod;--espera 10 periodos
        switch_bit <= "1000";
        wait for 20 * TbPeriod;
        motor <= "00";

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;