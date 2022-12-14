----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 17:46:29
-- Design Name: 
-- Module Name: Decod_BCD_Animacion - Behavioral
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
-- Esto va a ser la entidad que maneje la animacion de subiendo, bajando, etc. Aun no esta
-- muy claro si lo vamos a hacer con el reloj habiendo ajustado su frecuencia, pero será lo más probable
entity Decod_BCD_Animacion is
    Port ( estado_ascensor : in STD_LOGIC_VECTOR (1 downto 0);
           display : out STD_LOGIC_VECTOR (6 downto 0);
           reset : in STD_LOGIC;
           clk : in std_logic);
end Decod_BCD_Animacion;

architecture Behavioral of Decod_BCD_Animacion is
signal s_display : std_logic_vector(6 downto 0);

begin

    process (estado_ascensor, clk)
    variable flag : natural;
    begin
        if (reset = '1') then
            s_display <= "0000001";
        else 
            if (estado_ascensor = "00") then --En principio 00 representa parado
                s_display <= "1001001";
            elsif (estado_ascensor = "10") then --10 representa activo subiendo
                flag := 1;
                while (flag = 1) loop
                    s_display <= "0010101";
                    wait for 1 s;
                    s_display <= "1110110";
                end loop;
            elsif (estado_ascensor = "11") then --11 representa activo bajando
                flag := 2;
                while (flag = 2) loop 
                    s_display <= "0100011";
                    wait for 1 s;
                    s_display <= "0111110";
                end loop;
            end if;
        end if;
    end process;
display <= s_display;

end Behavioral;
