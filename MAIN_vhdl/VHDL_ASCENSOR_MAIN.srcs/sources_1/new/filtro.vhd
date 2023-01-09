----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2022 18:07:10
-- Design Name: 
-- Module Name: filtro - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filtro is
    port(
        motor: in std_logic_vector(1 downto 0); 
        switch_bit: in std_logic_vector(3 downto 0);
        clk: in std_logic;
        sig_siguiente: out std_logic_vector(3 downto 0);-------------------------------------------------------------
        sig_salida: out std_logic_vector(3 downto 0)
    );
end filtro;

architecture Behavioral of filtro is
    signal switch_ant :std_logic_vector(3 downto 0) := "0001"; --el ascensor comienza en el piso 0
    --switch_ant va almacenando los vectores correctos que representan los pisos por donde vayamos pasando
    signal aux_sube: std_logic_vector(3 downto 0);
    signal aux_baja: std_logic_vector(3 downto 0);
    signal aux: std_logic_vector(3 downto 0);--representa el piso siguiente al que le corresponderia ir el ascensor
begin
    edge: process(switch_bit, clk, motor)
    begin
        --comparacion de la señal switch anterior y la posicion
        if rising_edge(clk) then
            if switch_bit /= "0000" then --se ignora siempre que switch bit sea 0000
                if motor(1) = '1' then --si el motor está activo
                    if motor(0) = '1' then --si está subiendo
                        --comparar posicion(entrada) y switch_ant(signal de la arquitectura)
                        if switch_bit = aux_sube then --si la posicion es la que debiera ser                
                            switch_ant <= switch_bit;
                        end if;
                        ----------------------------------------------------------------------------------
                    else --sin motor es 0 (está bajando)
                        if switch_bit = aux_baja then--si la posicion es la que debiera ser
                            switch_ant <= switch_bit;
                        end if;
                        -----------------------------------------------------------------------------------
                    end if;
                end if; 
            end if; 
        end if;    
    end process;
    
    switch_teorico:process(switch_ant)
    begin
        aux_sube <= switch_ant(2) & switch_ant(1) & switch_ant(0) & '0';
        aux_baja <= '0' & switch_ant(3) & switch_ant(2) & switch_ant(1);
    end process;
    
    asig_siguiente: process (aux_sube,aux_baja)
    begin
        if motor = "11" then
            sig_siguiente <= aux_sube;
        elsif motor = "10" then     
            sig_siguiente <= aux_baja;
        end if;
    end process;
    
    sig_salida <= switch_ant;
    

end Behavioral;
