----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 20:54:52
-- Design Name: 
-- Module Name: mix_vector - Behavioral
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

--De esta forma, vamos almacenando en el vector auxiliar que switch vamos pulsando, hasta que pulsamos otro
--El proceso de 'filtrado' de los switches pulsados lo realizará el siguiente componente: "filtro"
entity mix_vector is
      Port ( 
        bit0: in std_logic;
        bit1: in std_logic;
        bit2: in std_logic;
        bit3: in std_logic;
        clk: in std_logic;
        CE: in std_logic;
        vec_salida: out std_logic_vector(3 downto 0)
      );
end mix_vector;

architecture Behavioral of mix_vector is
    signal aux_vector: std_logic_vector(3 downto 0):= "0001";
begin
    process(clk,bit0,CE)
    begin
        if rising_edge(bit0) and CE = '1' then --si el bit 0 cambia de 0 a 1
            aux_vector <= "0001"; --eliminamos lo que tenia almacenado previamente el vector y
            --le ponemos un 1 en la posicion 0 del vecto(piso 0)
        end if;
    end process;
    process(clk,bit1,CE)
    begin
        if rising_edge(bit1) and CE = '1' then --si el bit 1 cambia de 0 a 1
            aux_vector <= "0010"; --eliminamos lo que tenia almacenado previamente el vector y
            --le ponemos un 1 en la posicion 1 del vecto(piso 1)
        end if;
    end process;
    process(clk,bit2,CE)
    begin
        if rising_edge(bit2) and CE = '1' then --si el bit 2 cambia de 0 a 1
            aux_vector <= "0100"; --eliminamos lo que tenia almacenado previamente el vector y
            --le ponemos un 1 en la posicion 2 del vecto(piso 2)
        end if;
    end process;
    process(clk,bit3,CE)
    begin
        if rising_edge(bit3) and CE = '1' then --si el bit 3 cambia de 0 a 1
            aux_vector <= "1000"; --eliminamos lo que tenia almacenado previamente el vector y
            --le ponemos un 1 en la posicion 3 del vecto(piso 3)
        end if;
    end process;
    salida: process(aux_vector)
    begin
        vec_salida <= aux_vector;--asignamos al vector de salida el vector auxiliar
    end process;

end Behavioral;
