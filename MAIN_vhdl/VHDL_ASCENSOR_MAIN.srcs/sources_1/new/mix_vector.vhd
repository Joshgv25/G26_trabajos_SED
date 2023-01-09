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
        pSig: in std_logic_vector(3 downto 0);--------------------------------------------
        clk: in std_logic;
        reset_n : in std_logic;
        CE: in std_logic;
        vec_salida: out std_logic_vector(3 downto 0)
      );
end mix_vector;

architecture Behavioral of mix_vector is
    signal aux_vector: std_logic_vector(3 downto 0) := "0001";
begin
    process(clk,bit0,bit1,bit2,bit3,CE)
    begin
    if reset_n = '0' then
        aux_vector <= "0001";
    elsif rising_edge(clk) then
        if CE = '0' then --estando el motor apagado
            if bit0 = '1' then --si el bit 0 cambia de 0 a 1
                aux_vector <= "0001"; --eliminamos lo que tenia almacenado previamente el vector y
            elsif bit1 = '1' then --si el bit 1 cambia de 0 a 1
                aux_vector <= "0010"; 
            elsif bit2 = '1' then --si el bit 2 cambia de 0 a 1
                aux_vector <= "0100"; 
            elsif bit3 = '1' then --si el bit 3 cambia de 0 a 1
                aux_vector <= "1000"; 
            end if;
        else --si CE es '1'; es decir, si el motor está encendido, lo unico que puede hacer es asignar al vector de salida 
        --el piso siguiente del que estamos, que viene del componente del filtro
            if bit0 = '1' then --si el bit 0 cambia de 0 a 1
                if aux_vector = "0001" then --si el vector de salida ya era 0001 
                    aux_vector <= pSig;
                end if;
            elsif bit1 = '1' then --si el bit 1 cambia de 0 a 1
                if aux_vector = "0010" then--si el vector de salida ya era 0010 
                    aux_vector <= pSig; 
                end if;
            elsif bit2 = '1' then --si el bit 2 cambia de 0 a 1
                if aux_vector = "0100" then--si el vector de salida ya era 0100 
                    aux_vector <= pSig; 
                end if;
            elsif bit3 = '1' then --si el bit 3 cambia de 0 a 1
                if aux_vector = "1000" then--si el vector de salida ya era 1000
                    aux_vector <= pSig; 
                end if;
            end if;
        end if;
    end if;
    end process;

  vec_salida <= aux_vector;--asignamos al vector de salida el vector auxiliar

end Behavioral;
