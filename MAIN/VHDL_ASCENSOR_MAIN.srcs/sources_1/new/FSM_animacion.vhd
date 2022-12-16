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

    nextstate_decod: process (in_motor, current_state)
    begin
        next_state <= current_state;
        case current_state is 
            when s0 => 
                if in_motor = "11" then
                    next_state <= s1;
                elsif in_motor = "10" then 
                    next_state <= s3;
                else
                    next_state <= s0;
                end if;
            when s1 => 
                if in_motor = "11" then
                    next_state <= s2;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s2 => 
                if in_motor = "11" then
                    next_state <= s3;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s3 => 
                if in_motor = "11" then
                    next_state <= s1;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s4 => 
                if in_motor = "10" then
                    next_state <= s5;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s5 => 
                if in_motor = "10" then
                    next_state <= s6;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
             when s6 => 
                if in_motor = "10" then
                    next_state <= s4;
                elsif in_motor = "00" then
                    next_state <= s0;
                end if;
            when others => 
                next_state <= s0;
        end case;    
    end process;
    
    salida_decod: process (current_state)
    begin
        out_bcd <= (others => '1');
        case current_state is 
            when s0 =>
                out_bcd <= "1111110";
            when s1 =>
                out_bcd <= "0010101";
            when s2 =>
                out_bcd <= "1110110";
            when s3 =>
                out_bcd <= "0001000";
            when s4 =>
                out_bcd <= "0100011";
            when s5 =>
                out_bcd <= "0111110";
            when s6 =>
                out_bcd <= "1000000";
        end case;
    end process;
end Behavioral;
