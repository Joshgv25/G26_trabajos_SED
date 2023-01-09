----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2022 13:19:53
-- Design Name: 
-- Module Name: FSM_animacion - Behavioral
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

entity FSM_animacion is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           in_motor : in STD_LOGIC_VECTOR (1 downto 0);
           out_bcd : out STD_LOGIC_VECTOR (6 downto 0));
end FSM_animacion;

architecture Behavioral of FSM_animacion is
type STATE is (s0,s1,s2,s3,s4,s5,s6);
signal current_state: STATE := s0;
signal next_state: STATE;
begin
    state_register: process(reset_n,clk)
    begin
        if reset_n = '0' then
            current_state <= s0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
--La transicion de estados s1->s2->s3->s1 se produce con la misma entrada, que es 11  y representa el motor subiendo. La diferencia entre estos estados son sus salidas
--La transicion de estados s4->s5->s6->s4 se produce con la misma entrada, que es 10  y representa el motor bajando. La diferencia entre estos estados son sus salidas
--La transicion se produce a cada ciclo de reloj. Queremos que los cambios en los displays ocurran cada 0,5 segundos, por lo que el componente FSM_animacion utiliza otra señal de reloj que viene del divisor de frecuencia.
    nextstate_decod: process (in_motor, current_state)
    begin
        next_state <= current_state;
        case current_state is 
            when s0 => --El estado s0 corresponde al motor parado
                if in_motor = "11" then --Si el motor empieza a subir, se pasa al estado s1
                    next_state <= s1;
                elsif in_motor = "10" then --Si el motor empieza a bajar, se pasa al estado s4
                    next_state <= s4;
                else
                    next_state <= s0; --Si el motor se queda como esta u ocurre otra cosa, se queda donde esta
                end if;
            when s1 => --s1 representa subiendo y con una secuencia BCD a la salida determinada
                if in_motor = "11" then
                    next_state <= s2;
                elsif in_motor = "10" then
                    next_state <= s4;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s2 => --s2 representa subiendo y con una secuencia BCD a la salida determinada
                if in_motor = "11" then --Si el motor sigue subiendo, se pasa a s3
                    next_state <= s3;
                elsif in_motor = "10" then --Si el motor se pone a bajar, se pasa a s4
                    next_state <= s4;
                elsif in_motor = "00" then --Si el motor se para, se pasa a s0
                    next_state <= s0;
                end if;
             when s3 => --s3 representa subiendo y con una secuencia BCD a la salida determinada
                if in_motor = "11" then
                    next_state <= s1;
                elsif in_motor = "10" then
                    next_state <= s4;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s4 => --s4 representa bajando y con una secuencia BCD a la salida determinada
                if in_motor = "10" then
                    next_state <= s5;
                elsif in_motor = "11" then
                    next_state <= s1;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s5 => --s5 representa bajando y con una secuencia BCD a la salida determinada
                if in_motor = "10" then
                    next_state <= s6;
                elsif in_motor = "11" then
                    next_state <= s1;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s6 => --s6 representa bajando y con una secuencia BCD a la salida determinada
                if in_motor = "10" then
                    next_state <= s4;
                elsif in_motor = "11" then
                    next_state <= s1;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
            when others => 
                next_state <= s0;
        end case;    
    end process;
    
    salida_decod: process (current_state) --Tanto en los estados s1, s2 y s3, el motor esta subiendo, pero se representan codigos BCD distintos. La combinacion de estos diferentes codigos en el tiempo originan una animacion
    begin --Tanto en los estados s4, s5 y s6 el motor esta bajando, pero cada estado tiene una salida BCD diferente, cuya combinacion en el tiempo origina una animacion
        out_bcd <= (others => '1');
        case current_state is 
            when s0 =>
                out_bcd <= "1111110";
            when s1 =>
                out_bcd <= "1101010";
            when s2 =>
                out_bcd <= "0001001";
            when s3 =>
                out_bcd <= "1110111";
            when s4 =>
                out_bcd <= "1011100";
            when s5 =>
                out_bcd <= "1000001";
            when s6 =>
                out_bcd <= "0111111";
        end case;
    end process;
end Behavioral;
