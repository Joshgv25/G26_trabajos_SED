----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.12.2022 12:13:36
-- Design Name: 
-- Module Name: edge_ctrl - Behavioral
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
--Este componente se usa para conseguir una señal limpia al pulsar un boton o utilizar los switches de la placa de desarrollo.

entity edge_ctrl is
    port (
        CLK : in std_logic;
        SYNC_IN : in std_logic;
        EDGE : out std_logic
    );
end edge_ctrl;

architecture Behavioral of edge_ctrl is
signal sreg : std_logic_vector(2 downto 0); --Señal utilizada para identificar cuando ha ocurrido el ultimo flanco de bajada
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
        sreg <= sreg(1 downto 0) & SYNC_IN; --Vamos pasando los valores del boton/switch y se guardan en sreg
        end if;
    end process;
    
    with sreg select
        EDGE <= '1' when "100", --Cuando en un instante dado ocurra que hace dos ciclos de reloj el periferico estaba activo y durante los dos ultimos ciclos ha estado desactivado, significa que ha ocurrido una pulsacion
        '0' when others;


end Behavioral;
