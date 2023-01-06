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
        port (motor         : in std_logic_vector (1 downto 0);
              switch_bit    : in std_logic_vector (3 downto 0);
              clk           : in std_logic;
              sig_siguiente : out std_logic_vector (3 downto 0);
              sig_salida    : out std_logic_vector (3 downto 0));
    end component;

    signal motor         : std_logic_vector (1 downto 0);
    signal switch_bit    : std_logic_vector (3 downto 0);
    signal clk           : std_logic;
    signal sig_siguiente : std_logic_vector (3 downto 0);
    signal sig_salida    : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- 100MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : filtro
    port map (motor         => motor,
              switch_bit    => switch_bit,
              clk           => clk,
              sig_siguiente => sig_siguiente,
              sig_salida    => sig_salida);

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
        wait for 3 * TbPeriod;--espera 10 periodos
        switch_bit <= "0010";--acabamos de pasar el piso dos(la posición tiene sentido)se pasa a sig_salida
        wait for 3 * TbPeriod;--espera 10 periodos
        switch_bit <= "0001";--esta posición no tiene sentido puesto que seguíamos subiendo, esta entrada debería ser filtrada
        wait for 3 * TbPeriod;--espera 10 periodos
        switch_bit <= "1000";--nos hemos saltado un piso, esta entrada debería ser filtrada
        wait for 3 * TbPeriod;
         switch_bit <= "0100";--acabamos de pasar el piso tres(la posicion tiene sentido)se pasa a sig_salida
        wait for 3 * TbPeriod;
        motor <= "10";--motor activo y bajar
        wait for 3 * TbPeriod;
        switch_bit <= "1000";--mal(no se pasa a sig_salida)
        wait for 2 * TbPeriod;
        switch_bit <= "0001";--mal(no se pasa a sig_salida)
        wait for 2 * TbPeriod;
        switch_bit <= "0100";--no se pasa por los ifs, pero igualmente sig_salida sigue siendo '0100'
        wait for 2 * TbPeriod;
        switch_bit <= "0010";--bien(se pasa a sig_salida)
        wait for 4 * TbPeriod;
        switch_bit <= "0001";--bien(se pasa a sig_salida)
        wait for 7 * TbPeriod;
        switch_bit <= "0000";--deberia ser ignorado
        wait for 2 * TbPeriod;
        motor <= "00";--se para el motor
        wait for 2 * TbPeriod;
        switch_bit <= "0010";--deberia ser ignorado al estar el motor parado
        wait for 2 * TbPeriod;
        switch_bit <= "0100";
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;