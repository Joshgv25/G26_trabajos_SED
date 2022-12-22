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
   			pAct:   in std_logic_vector(3 downto 0); --piso actual
        	pCall:  in std_logic_vector(3 downto 0); --piso del que llaman (salida del filtro)
   			filtro: in std_logic; --si llega un 1, tiene en cuenta a pAct
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
    signal vector_switch: std_logic_vector(3 downto 0); 
begin 
      process(filtro)
      begin 
      		 if filtro = '1' then 
        	 	 vector_switch <= pCall;
        	 end if; 
      end process;
 
      state_register: process (reset_n, CLK) --actualiza el estado con los flancos de reloj
          begin
                if reset_n = '0' then
                	current_state <= s3; --si pulso el reset voy al estado de emergencia 
                elsif rising_edge(clk) then
                	next_state <= current_state;
                end if;
          end process;
          
      nxt_state: process(reset_n, pAct, vector_switch)
          begin
          	current_state <= next_state;
               if reset_n = '0' then        --Vuelve a planta 0 siempre, en estado de emergencia
  	        		   next_state <= s3;
    	 	   else
                   case current_state is
                    	when s0 =>
                           
                           if pAct>vector_switch then
                           		next_state <= s1; --si piso actual mayor que desde el que llamo, subira
                           elsif pAct=vector_switch then
                           		next_state <= s0; --si llamo desde el piso actual no me muevo
                           else
                           		next_state <= s2; --
                           end if;
                               
                        when s1 =>
                        	
                            if(pAct>vector_switch) then
                           		next_state <= s1; --sigo subiendo porque el piso en que estoy esta mas arriba
                            elsif(pAct=vector_switch) then
                           		next_state <= s0; --dejo de subir y entro en reposo
                            else
                           		next_state <= s4; --entro en averia, no puedo bajar mientras estoy subiendo
                            end if;
                            
                        when s2 =>
                        
                           	if pAct>vector_switch then
                           		next_state <= s4; --averia, no puedo subir mientras bajo
                            elsif pAct=vector_switch then
                           		next_state <= s0; --paro de bajar y entro en reposo
                            else
                           		next_state <= s2; --sigo bajando, el piso al que quiero ir está más abajo
                           end if;     
                           
               			when s3 =>
                        
                            if pAct>vector_switch then --ESTE ESTADO ES IMPOSIBLE
                           		next_state <= s4; --no puedo bajar, ya estoy en el cero. paso a la averia
                            elsif pAct=vector_switch then
                           		next_state <= s0; --me mantengo en reposo en el 0
                            else
                           		next_state <= s1; --subo si se pulsa un boton que no sea el cero
                           end if;
                           
                        when s4 =>
                        
                        	if rearme='1' then
                           		 next_state <= S3; --si rearmo paso al piso 0 en estado de emergencica
                            else 
                            	 next_state <= s4; --si no rearmo seguire en averia
                            end if;  
                            
                        end case;
                  end if;
            end process;
                     
      salida: process(current_state) --si hay cambio en estado actual se actualiza la salida
      		begin 
            	case current_state is
                		when s0 =>
                        	motor <= "0x"; --motor apagado, ni sube ni baja
                            puerta <= '1'; --puerta abierta
      					when s1 =>
                        	motor <= "11"; --motor encendido y subiendo
                            puerta <= '0'; --subiendo, puerta cerrada
                        when s2 =>
                        	motor <= "10"; --motor encendido y bajando
                            puerta <= '0'; --puerta cerrada
                        when s3 =>
                        	motor <= "10"; --motor encendido, bajo al 0
                            puerta <= '1'; --puerta abierta
                        when s4 =>
                        	motor <= "0x"; --motor apagado, no sube ni baja
                            puerta <= '0'; --puerta cerrada por seguridad
      			end case;
      end process;


end Behavioral;
