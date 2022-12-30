----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 17:01:45
-- Design Name: 
-- Module Name: FSM_ascensor_tb - Behavioral
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

entity tb_FSM_ascensor is
end tb_FSM_ascensor;

architecture tb of tb_FSM_ascensor is

    component FSM_ascensor
        port (clk     : in std_logic;
              reset_n : in std_logic;
              pAct    : in std_logic_vector (3 downto 0);
              pCall   : in std_logic_vector (3 downto 0);
              rearme  : in std_logic;
              motor   : out std_logic_vector (1 downto 0);
              puerta  : out std_logic);
    end component;

    signal clk     : std_logic;
    signal reset_n : std_logic;
    signal pAct    : std_logic_vector (3 downto 0);
    signal pCall   : std_logic_vector (3 downto 0);
    signal rearme  : std_logic;
    signal motor   : std_logic_vector (1 downto 0);
    signal puerta  : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : FSM_ascensor
    port map (clk     => clk,
              reset_n => reset_n,
              pAct    => pAct,
              pCall   => pCall,
              rearme  => rearme,
              motor   => motor,
              puerta  => puerta);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        pAct <= "0001";
        pCall <= "0001";
        rearme <= '0';

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';--reseteamos
        wait for 20 ns;
        reset_n <= '1';--quitamos reset
        wait for 40 ns;

        -- EDIT Add stimuli here
        wait for 5 * TbPeriod;
        pCall <= "1000";--llamamos al piso 3(ultimo)
        --a partir de aqui, se debería de haber pasado al estado s1(subiendo)
        --la salida del motor debería de ser "11"
        wait for 10 * TbPeriod;
        pAct <= "0010";--pasamos del segundo piso
        wait for 10 * TbPeriod;
        pAct <= "0100";--pasamos del tercer piso
        wait for 10 * TbPeriod;
        pAct <= "1000";--llegamos al cuarto piso
        --una vez hemos llegado al piso, se debería haber pasado al estado s0(reposo)
        --la salida del motor deberia ser "00"
        wait for 10 * TbPeriod;
        pCall <= "0001";--llamamos al piso 0
        --a partir de aqui, se deberia de haber pasado al estado s2(bajando)
        --la salida del motor debería de ser "10"
        wait for 10 * TbPeriod;
        pAct <= "0100";--pasamos al tercer piso
        wait for 10 * TbPeriod;
        --Se vuelve a pulsar el botón del piso 0(de pulsar cualquier otro botón se ignoraría)
        pCall<= "0010";--pCall le corresponde el siguiente piso al actual, teniendo en cuenta si la cabina 
        --estabasubiendo o bajando
        --el estado debería seguir siendo s2(bajada) y el motor no debería haber cambiado
        wait for 5 * TbPeriod;
        --en este momento pulsamos otro botón. Debido a que el estado sigue siendo el de bajar, el motor esta activo
        --Si el botón pulsado no es "0010", la señal de entrada no se procesará debido al CE(conectado al motor)
        --Si el botón pulsado es el "0010", la señal pulsada será procesada de la misma forma que antes
        --Es decir, a Pcall le corresponderá el siguiente piso al actual, teniendo en cuenta de si sube o baja el ascensor
        --Como pAct sigue siendo "0100", el pCall CONTINUARÁ siendo "0010";
        pAct <= "0010";--llegamos al piso 1
        --en este momento, se deberia haber pasado al estado s0(reposo)
        --Por lo tanto, el motor debería estar en "00"
        
        wait for 20 * TbPeriod;
        reset_n <= '0';--hacemos reset
        --en este momento, se debería pasar al estado s3(vuelta al piso 0)
        --el motor deberia estar en "10"(activo y bajando)
        wait for 15 * TbPeriod;
        pAct <= "0001"; --llegamos al piso 0
        --en este momento se deberia haber pasado al estado s0(reposo)
        --el motor deberia estar en "00"  
        wait for 20 * TbPeriod;      
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
