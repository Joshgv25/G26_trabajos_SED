----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2023 12:10:12
-- Design Name: 
-- Module Name: top_tb - Structural
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

entity tb_top is
end tb_top;

architecture tb of tb_top is

    component top
        port (button   : in std_logic_vector (3 downto 0);
              switch   : in std_logic_vector (3 downto 0);
              CLK      : in std_logic;
              reset_n  : in std_logic;
              rearme   : in std_logic;
              puerta   : out std_logic;
              disp_sel : out std_logic_vector (7 downto 0);
              disp_bcd : out std_logic_vector (6 downto 0));
    end component;

    signal button   : std_logic_vector (3 downto 0);
    signal switch   : std_logic_vector (3 downto 0);
    signal CLK      : std_logic;
    signal reset_n  : std_logic;
    signal rearme   : std_logic;
    signal puerta   : std_logic;
    signal disp_sel : std_logic_vector (7 downto 0);
    signal disp_bcd : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns; --100 MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top
    port map (button   => button,
              switch   => switch,
              CLK      => CLK,
              reset_n  => reset_n,
              rearme   => rearme,
              puerta   => puerta,
              disp_sel => disp_sel,
              disp_bcd => disp_bcd);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        button <= (others => '0');
        switch <= (others => '0');
        rearme <= '0';

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 50 ns; --5 periodos
        reset_n <= '1';
        wait for 50 ns;--5 periodos

        -- EDIT Add stimuli here
        --estamos en el piso 0, con motor apagado y puerta abierta
        wait for 5 * TbPeriod;--eperamos otros 5 periodos
        button <= "1000";--llamamos al piso 3
        --a partir de aqui subiendo, motor encendido y puerta cerrada
        wait for 5 * TbPeriod;
        button <= (others => '0');
        wait for 2 * TbPeriod;
        switch <= "1000"; --se debería ignorar(filtro)
        wait for 3 * TbPeriod;
        switch <= "0010";--este valor es correcto y no deberia ser ignorado
        wait for TbPeriod;
        button <= "0100";--si se pulsa el boton mientras el ascensor se mueve, se debería ignorar(exceptuando func. despulsar)
        switch <= (others => '0'); 
        wait for 2 * TbPeriod;
        switch <= "0100";--este valor es correcto y no deberia ser ignorado
        wait for 4 * TbPeriod;
        switch <= "1000";--llegamos al piso objetivo
        --A partir de aqui, se deberia pasar al estado de reposo(motor apagado, puerta abierta)
        wait for 10 * TbPeriod;       
     
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
