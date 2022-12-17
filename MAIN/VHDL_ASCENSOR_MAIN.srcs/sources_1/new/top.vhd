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
