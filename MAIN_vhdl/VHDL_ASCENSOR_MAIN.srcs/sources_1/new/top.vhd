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
        CLK: in std_logic;
        reset_n: in std_logic;
        rearme:in std_logic;
        
        puerta: out std_logic;
        disp_sel: out std_logic_vector(7 downto 0);
        disp_bcd: out std_logic_vector(6 downto 0)
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
    
    component mix_vector
        Port ( 
            bit0: in std_logic;
            bit1: in std_logic;
            bit2: in std_logic;
            bit3: in std_logic;
            pSig: in std_logic_vector(3 downto 0);
            clk: in std_logic;
            CE: in std_logic;
            vec_salida: out std_logic_vector(3 downto 0)
      );
    end component;
    
    component filtro
        port(
            motor: in std_logic_vector(1 downto 0); 
            switch_bit: in std_logic_vector(3 downto 0);
            clk: in std_logic;
            sig_siguiente: out std_logic_vector(3 downto 0);
            sig_salida: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component Counter 
         Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           salida : out std_logic_vector(1 downto 0));
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
    
    signal sync_switch, vector_filtrado, mixed_vector, piso_siguiente: std_logic_vector(3 downto 0);
    signal sync_button: std_logic_vector (3 downto 0);
    signal edges, edgeb: std_logic_vector(3 downto 0);
    signal sal_motor: std_logic_vector(1 downto 0); -------------------------------salida del motor de la fsm
    signal reloj_div:std_logic;
    signal out_counter:std_logic_vector(1 downto 0);
    signal pisoact_bcd, pisoobj_bcd, anim_bcd: std_logic_vector(6 downto 0);
    --variable count: natural;
begin
    gen: for i in 3 downto 0 generate --el for genera 4 instancias para tratar los 4 switches
        sins: Sincronizador port map(CLK => CLK, ASYNC_IN =>switch(i), SYNC_OUT => sync_switch(i));
        sinb: Sincronizador port map(CLK => CLK, ASYNC_IN =>button(i), SYNC_OUT => sync_button(i));
        edgecrtls: edge_ctrl port map(CLK => CLK, SYNC_IN => sync_switch(i), EDGE =>edges(i));
        edgecrtlb: edge_ctrl port map(CLK => CLK, SYNC_IN => sync_button(i), EDGE =>edgeb(i));
    end generate;
    Inst_filtro: filtro port map(motor => sal_motor, switch_bit => edges, clk => CLK ,sig_siguiente => piso_siguiente, sig_salida => vector_filtrado);
    Inst_MixVector: mix_vector port map(bit0 => edgeb(0), bit1 => edgeb(1), bit2 => edgeb(2), bit3 => edgeb(3),pSig => piso_siguiente,clk => CLK,CE => sal_motor(1), vec_salida => mixed_vector);
    Inst_FSM_ascensor: FSM_ascensor port map(clk=>CLK,reset_n=>reset_n, pAct=>vector_filtrado,pCall=>mixed_vector,rearme=>rearme,motor=>sal_motor,puerta=>puerta);
    Inst_decod_pisoact: Decod_BCD_Piso port map(n_bin=>vector_filtrado,n_bcd=>pisoact_bcd);
    Inst_decod_pisoobj: Decod_BCD_Piso port map(n_bin=>mixed_vector,n_bcd=>pisoobj_bcd);
    Inst_animacion: FSM_animacion port map(clk=>CLK,reset_n=>reset_n,in_motor=>sal_motor,out_bcd=>anim_bcd);
    Inst_counter: Counter port map(clk=>reloj_div, reset_n=>reset_n,salida=>out_counter);
    Inst_decodsel: decod_sel port map(in_sel=>out_counter,out_sel=>disp_sel);
    Inst_mux: Mux_4a1 port map(sel=>out_counter,in1=>pisoact_bcd,in2=>pisoobj_bcd,in3=>anim_bcd,salida=>disp_bcd);
    Inst_clkdiv: clk_divisor generic map(frec=>50000000) port map(clk=>CLK,reset=>reset_n,clk_out=>reloj_div);
     
end Structural;
