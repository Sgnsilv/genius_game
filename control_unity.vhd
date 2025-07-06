library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk              : in  std_logic;
        reset            : in  std_logic;
        inicia_jogo      : in  std_logic;
        jogada_certa     : in  std_logic;
        delay            : in  std_logic;
        botao            : in  std_logic;
        atingiu_nivel    : in  std_logic;
        fim_da_mostra    : in  std_logic; -- << ADICIONADO
        nivel            : in  unsigned(1 downto 0);
        op_nivel         : out std_logic_vector(1 downto 0);
        op_indice        : out std_logic_vector(1 downto 0);
        hab_led          : out std_logic;
        start_timer      : out std_logic;
        estado_atual_out : out std_logic_vector(3 downto 0)
    );
end entity control_unit;

architecture estrutural of control_unit is

    component registrador_4bits is
        port (
            clk               : in  std_logic;
            reset             : in  std_logic;
            proximo_estado_in : in  std_logic_vector(3 downto 0);
            estado_atual_out  : out std_logic_vector(3 downto 0)
        );
    end component;

    component logica_comb_fsm is
        port (
            estado_atual   : in  std_logic_vector(3 downto 0);
            inicia_jogo    : in  std_logic;
            jogada_certa   : in  std_logic;
            delay          : in  std_logic;
            botao          : in  std_logic;
            atingiu_nivel  : in  std_logic;
            fim_da_mostra  : in  std_logic; -- << ADICIONADO
            nivel          : in  unsigned(1 downto 0);
            proximo_estado : out std_logic_vector(3 downto 0);
            op_nivel       : out std_logic_vector(1 downto 0);
            op_indice      : out std_logic_vector(1 downto 0);
            hab_led        : out std_logic;
            start_timer    : out std_logic
        );
    end component;

    signal s_estado_atual, s_proximo_estado : std_logic_vector(3 downto 0);

begin

    U_REG: registrador_4bits
        port map (
            clk               => clk,
            reset             => reset,
            proximo_estado_in => s_proximo_estado,
            estado_atual_out  => s_estado_atual
        );

    U_COMB: logica_comb_fsm
        port map (
            estado_atual   => s_estado_atual,
            inicia_jogo    => inicia_jogo,
            jogada_certa   => jogada_certa,
            delay          => delay,
            botao          => botao,
            atingiu_nivel  => atingiu_nivel,
            fim_da_mostra  => fim_da_mostra, -- << ADICIONADO
            nivel          => nivel,
            proximo_estado => s_proximo_estado,
            op_nivel       => op_nivel,
            op_indice      => op_indice,
            hab_led        => hab_led,
            start_timer    => start_timer
        );

    estado_atual_out <= s_estado_atual;

end architecture estrutural;
