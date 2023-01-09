----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.12.2022 12:05:53
-- Design Name: 
-- Module Name: FSM_ascensor - Behavioral
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

entity FSM_ascensor is
port(
    		--entradas
			clk :   in  std_logic; --reloj
   			reset_n : in std_logic;  --vuelve al piso 0 siempre
   			pAct:   in std_logic_vector(3 downto 0); --piso por donde vamos pasando(filtrado)(switches)
        	pCall:  in std_logic_vector(3 downto 0); --piso al que queremos ir (botones) 
   			rearme: in std_logic;
     		--salidas
  			motor : out std_logic_vector(1 downto 0); --un bit para el encendido, otro para saber si sube (1) o baja (0)
  		 	puerta: out std_logic --1 si esta abierta, 0 si esta cerrada
       );
end FSM_ascensor;

architecture Behavioral of FSM_ascensor is
type estados is(s0, s1, s2, s3, s4); --s0 reposo, s1 subir, s2 bajar, s3 emergencia (ir al 0), s4 averia
    signal current_state: estados;       --estado actual
    signal next_state: estados;          --estado siguiente
    --------------------------------------------------------------------------------
begin
      
      state_register: process (reset_n, CLK) --actualiza el estado con los flancos de reloj
          begin
                if reset_n = '0' then
                	current_state <= s3; --si pulso el reset voy al estado de emergencia 
                	--if pAct = "0001" then --si hemos llegado al piso 0
                	   --current_state <= s0;--pasamos al reposo
                	
                elsif rising_edge(clk) then
                	current_state <= next_state;
                end if;
          end process;
      
          
      nxt_state: process(reset_n, pCall, pAct,current_state,rearme)
          begin
          	next_state <= current_state;
            case current_state is
                when s0 => --si pCall es 0000 no pasará nada     
                   if pCall>pAct then
                        next_state <= s1; --si piso actual mayor que desde el que llamo, subira
                   elsif pCall=pAct then
                        next_state <= s0; --si llamo desde el piso actual no me muevo
                   else --si el piso al que hay que ir está por deajo del que estoy
                        if pCall /= "0000" then
                           next_state <= s2;--me iré al estado de bajada
                        end if;
                   end if;
                       
                when s1 =>
                    if(pCall>pAct) then
                        next_state <= s1; --sigo subiendo porque el piso dnd quiero ir está más arriba
                    elsif(pCall=pAct) then--cuando llego al piso dnd quería ir
                        next_state <= s0; --dejo de subir y entro en reposo
                    else
                        next_state <= s4; --entro en averia, no puedo bajar mientras estoy subiendo
                    end if;
                    
                when s2 =>
                   if pCall>pAct then
                        next_state <= s4; --averia, no puedo subir mientras bajo
                    elsif pCall=pAct then--cuando llego al piso dnd quería ir
                        next_state <= s0; --paro de bajar y entro en reposo
                    else
                        next_state <= s2; --sigo bajando, el piso al que quiero ir está más abajo
                   end if;     
                   
                when s3 => --estando en el estado de reset o saiendo de emergencia (ir al piso 0)     
                   if pCall = "0001" then --cuando hemos llegado al piso 0
                        next_state <= S0; --pasamos al estado de reposo
                   end if;
                when s4 =>
                    if rearme='1' then
                         next_state <= S3; --si rearmo paso al piso 0 en estado de emergencica
                    else -------------------------------------------------------------------------------------
                         next_state <= s4; --si no rearmo seguire en averia-----------------------------------
                    end if;  ---------------------------------------------------------------------------------   
                 end case;
            end process;
                     
      salida: process(current_state) --si hay cambio en estado actual se actualiza la salida
      		begin 
            	case current_state is
                		when s0 =>
                        	motor <= "00"; --motor apagado, ni sube ni baja
                            puerta <= '1'; --puerta abierta
      					when s1 =>
                        	motor <= "11"; --motor encendido y subiendo
                            puerta <= '0'; --subiendo, puerta cerrada
                        when s2 =>
                        	motor <= "10"; --motor encendido y bajando
                            puerta <= '0'; --puerta cerrada
                        when s3 =>--bajando al piso 0
                        	motor <= "10"; --motor encendido, bajo al 0
                            puerta <= '0'; --puerta cerrada
                        when s4 =>
                        	motor <= "00"; --motor apagado, no sube ni baja
                            puerta <= '0'; --puerta cerrada por seguridad
      			end case;
      end process;

end Behavioral;
