----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2022 22:05:23
-- Design Name: 
-- Module Name: Sincronizador - Behavioral
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
--Este componente se usa para identificar correctamente la pulsacion de un boton o de un switch aunque el evento se produzca en un instante en el que pueda 
--introducir problemas de sincronizacion con el reloj del sistema.

entity Sincronizador is
    port ( 
        CLK : in std_logic;
        ASYNC_IN : in std_logic;
        SYNC_OUT : out std_logic
    );
end Sincronizador;
architecture Behavioral of Sincronizador is
    signal sreg : std_logic_vector(1 downto 0); --Señal que guarda los dos ultimos valores de la entrada, ya sea proveniente de un boton o de un switch
begin
     process (CLK)
         begin
         if rising_edge(CLK) then 
            sync_out <= sreg(1); --Si la activacion de la entrada no se ha detectado en el ciclo de reloj actual, se "detectará" en el siguiente gracias a que se ha guardado en sreg.
            sreg <= sreg(0) & async_in; 
         end if; 
     end process; 
end Behavioral;
