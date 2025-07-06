library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logica_comb_fsm is
    port (
        estado_atual   : in  std_logic_vector(3 downto 0);
        inicia_jogo    : in  std_logic;
        jogada_certa   : in  std_logic;
        delay          : in  std_logic;
        botao          : in  std_logic;
        atingiu_nivel  : in  std_logic;
        fim_da_mostra  : in  std_logic;
        nivel          : in  unsigned(1 downto 0);
        proximo_estado : out std_logic_vector(3 downto 0);
        op_nivel       : out std_logic_vector(1 downto 0);
        op_indice      : out std_logic_vector(1 downto 0);
        hab_led        : out std_logic;
        start_timer    : out std_logic
    );
end entity logica_comb_fsm;

architecture main of logica_comb_fsm is
    alias s: std_logic_vector(3 downto 0) is estado_atual;
    signal cond_nivel_vitoria : std_logic;

begin

    cond_nivel_vitoria <= nivel(1) and nivel(0);

    -- SAÍDAS DE CONTROLE
    op_nivel(1) <= (not s(3) and not s(2) and not s(1) and not s(0));
    op_nivel(0) <= (not s(3) and not s(2) and not s(1) and s(0) and not cond_nivel_vitoria);

    op_indice(1) <= (not s(3) and not s(2) and s(1) and not s(0)) or
                    (not s(3) and s(2) and not s(1) and not s(0) and fim_da_mostra);

    op_indice(0) <= (not s(3) and s(2) and not s(1) and not s(0) and not fim_da_mostra) or
                    (not s(3) and s(2) and not s(1) and s(0) and botao and jogada_certa);

    hab_led     <= (not s(3) and not s(2) and s(1) and s(0));
    start_timer <= (not s(3) and not s(2) and s(1) and s(0));

    -- LÓGICA DO PRÓXIMO ESTADO
    proximo_estado(3) <= (not s(3) and not s(2) and not s(1) and s(0) and cond_nivel_vitoria) or
                         (s(3) and not s(2) and not s(1) and not s(0));

    proximo_estado(2) <= (not s(3) and not s(2) and s(1) and s(0) and delay) or
                         (not s(3) and s(2) and not s(1) and not s(0) and fim_da_mostra) or
                         (not s(3) and s(2) and not s(1) and s(0) and not botao) or
                         (not s(3) and s(2) and not s(1) and s(0) and botao and jogada_certa) or
                         (not s(3) and s(2) and s(1) and not s(0) and botao) or
                         (not s(3) and s(2) and s(1) and not s(0) and not botao and not atingiu_nivel) or -- MEXI AQ
                         (not s(3) and s(2) and not s(1) and s(0) and botao and not jogada_certa) or
                         (not s(3) and s(2) and s(1) and s(0));

    proximo_estado(1) <= (not s(3) and not s(2) and not s(1) and s(0) and not cond_nivel_vitoria) or
                         (not s(3) and not s(2) and s(1) and not s(0)) or
                         (not s(3) and not s(2) and s(1) and s(0) and not delay) or
                         (not s(3) and s(2) and not s(1) and not s(0) and not fim_da_mostra) or
                         (not s(3) and s(2) and not s(1) and s(0) and botao and jogada_certa) or
                         (not s(3) and s(2) and s(1) and not s(0) and botao) or
                         (not s(3) and s(2) and not s(1) and s(0) and botao and not jogada_certa) or
                         (not s(3) and s(2) and s(1) and s(0));

    proximo_estado(0) <= (not s(3) and not s(2) and not s(1) and not s(0) and inicia_jogo) or
                         (not s(3) and s(2) and s(1) and not s(0) and not botao and atingiu_nivel) or
                         (not s(3) and not s(2) and s(1) and not s(0)) or
                         (not s(3) and not s(2) and s(1) and s(0) and not delay) or
                         (not s(3) and s(2) and not s(1) and not s(0) and not fim_da_mostra) or
                         (not s(3) and s(2) and not s(1) and not s(0) and fim_da_mostra) or
                         (not s(3) and s(2) and not s(1) and s(0) and not botao) or
                         (not s(3) and s(2) and s(1) and not s(0) and not botao and not atingiu_nivel) or
                         (not s(3) and s(2) and not s(1) and s(0) and botao and not jogada_certa) or
                         (not s(3) and s(2) and s(1) and s(0));

end architecture main;
