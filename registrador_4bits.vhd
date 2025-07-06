library ieee;
use ieee.std_logic_1164.all;

entity registrador_4bits is
    port (
        clk               : in  std_logic;
        reset             : in  std_logic;
        proximo_estado_in : in  std_logic_vector(3 downto 0);
        estado_atual_out  : out std_logic_vector(3 downto 0)
    );
end entity registrador_4bits;

architecture main of registrador_4bits is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            estado_atual_out <= "0000"; -- Estado inicial INICIO
        elsif rising_edge(clk) then
            estado_atual_out <= proximo_estado_in;
        end if;
    end process;
end architecture main;
