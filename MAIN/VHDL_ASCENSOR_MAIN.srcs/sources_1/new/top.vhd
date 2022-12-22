----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2022 01:31:40
-- Design Name: 
-- Module Name: top - Structural
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
use iEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (
        button: in std_logic_vector(3 downto 0);
        switch: in std_logic_vector(3 downto 0);
        CLK: in std_logic 
    
     );
end top;

architecture Structural of top is
    component Sincronizador
        port(
            CLK : in std_logic;
            ASYNC_IN : in std_logic;
            SYNC_OUT : out std_logic
        );
    end component;
    
    component filtro
        port(
            motor: in std_logic_vector(1 downto 0); 
            switch_bit: in std_logic_vector(3 downto 0);
            validez : out std_logic;
            sig_salida: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component Counter 
         Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           salida : out unsigned (1 downto 0));
    end component;
    
    component Decod_BCD_Piso
         Port ( n_bin : in STD_LOGIC_VECTOR (3 downto 0);
           n_bcd : out STD_LOGIC_VECTOR (6 downto 0));
           
    end component;

    component Decod_sel
         Port ( in_sel : in STD_LOGIC_VECTOR (1 downto 0);
           out_sel : out STD_LOGIC_VECTOR (7 downto 0)); --( bits, como la cantidad de displays que hay
    end component;
    
    component FSM_animacion
        Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           in_motor : in STD_LOGIC_VECTOR (1 downto 0);
           out_bcd : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    component FSM_ascensor
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
    end component;
    
    component Mux_4a1 
         Port ( sel : in STD_LOGIC_VECTOR (1 downto 0); --La entrada de selección vendrá de la salida de un contador
           in1 : in STD_LOGIC_VECTOR (6 downto 0);
           in2 : in STD_LOGIC_VECTOR (6 downto 0);
           in3 : in STD_LOGIC_VECTOR (6 downto 0);
           salida : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    component clk_divisor
         Generic (frec: integer:=50000000);  -- default value is for 2hz
         Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
    end component;
    
    component edge_ctrl
          port (
        CLK : in std_logic;
        SYNC_IN : in std_logic;
        EDGE : out std_logic
    );
    end component;
    
    signal vector_sincronized, vector_filtrado: std_logic_vector(3 downto 0);
    signal sal_motor: std_logic_vector(1 downto 0); -------------------------------salida del motor de la fsm
    signal correcto: std_logic;
    --variable count: natural;
begin
    gen: for i in 3 downto 0 generate --el for genera 4 instancias para tratar los 4 switches
        sin: Sincronizador port map(CLK => CLK, ASYNC_IN =>switch(i), SYNC_OUT => vector_sincronized(i));
    end generate;
    Inst_filtro: filtro port map(motor => sal_motor, switch_bit => vector_sincronized, validez => correcto, sig_salida => vector_filtrado);

end Structural;
