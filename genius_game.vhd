library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genius_game is
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        inicia_jogo    : in  std_logic;
        botoes_jogador : in  std_logic_vector(2 downto 0);
        leds_cores     : out std_logic_vector(2 downto 0);
        led_pronto     : out std_logic;
        led_vencedor   : out std_logic;
        led_fim_de_jogo: out std_logic;
        estado_fsm_out : out std_logic_vector(3 downto 0)
    );
end entity genius_game;

architecture estrutura of genius_game is

    component control_unit is
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
    end component;

    component datapath is
        port (
            clk                 : in  std_logic;
            reset               : in  std_logic;
            botoes_jogador_in   : in  std_logic_vector(2 downto 0);
            op_nivel_in         : in  std_logic_vector(1 downto 0);
            op_indice_in        : in  std_logic_vector(1 downto 0);
            hab_led_in          : in  std_logic;
            start_timer_in      : in  std_logic;
            estado_fsm_in       : in  std_logic_vector(3 downto 0);
            jogada_certa_out    : out std_logic;
            delay_out           : out std_logic;
            botao_out           : out std_logic;
            atingiu_nivel_out   : out std_logic;
            fim_da_mostra_out   : out std_logic; -- << ADICIONADO
            nivel_out           : out std_logic_vector(1 downto 0);
            leds_cores_out      : out std_logic_vector(2 downto 0);
            led_pronto_out      : out std_logic;
            led_vencedor_out    : out std_logic;
            led_fim_de_jogo_out : out std_logic
        );
    end component;

    signal s_op_nivel       : std_logic_vector(1 downto 0);
    signal s_op_indice      : std_logic_vector(1 downto 0);
    signal s_hab_led        : std_logic;
    signal s_start_timer    : std_logic;
    signal s_estado_fsm     : std_logic_vector(3 downto 0);
    signal s_jogada_certa   : std_logic;
    signal s_delay_fim      : std_logic;
    signal s_botao          : std_logic;
    signal s_atingiu_nivel  : std_logic;
    signal s_fim_da_mostra  : std_logic; -- << ADICIONADO
    signal s_nivel          : std_logic_vector(1 downto 0);
    signal s_nivel_unsigned : unsigned(1 downto 0);

begin

    s_nivel_unsigned <= unsigned(s_nivel);

    U_Controle: control_unit
        port map (
            clk              => clk,
            reset            => reset,
            inicia_jogo      => inicia_jogo,
            jogada_certa     => s_jogada_certa,
            delay            => s_delay_fim,
            botao            => s_botao,
            atingiu_nivel    => s_atingiu_nivel,
            fim_da_mostra    => s_fim_da_mostra, -- << ADICIONADO
            nivel            => s_nivel_unsigned,
            op_nivel         => s_op_nivel,
            op_indice        => s_op_indice,
            hab_led          => s_hab_led,
            start_timer      => s_start_timer,
            estado_atual_out => s_estado_fsm
        );

    U_Datapath: datapath
        port map (
            clk                 => clk,
            reset               => reset,
            botoes_jogador_in   => botoes_jogador,
            op_nivel_in         => s_op_nivel,
            op_indice_in        => s_op_indice,
            hab_led_in          => s_hab_led,
            start_timer_in      => s_start_timer,
            estado_fsm_in       => s_estado_fsm,
            jogada_certa_out    => s_jogada_certa,
            delay_out           => s_delay_fim,
            botao_out           => s_botao,
            atingiu_nivel_out   => s_atingiu_nivel,
            fim_da_mostra_out   => s_fim_da_mostra, -- << ADICIONADO
            nivel_out           => s_nivel,
            leds_cores_out      => leds_cores,
            led_pronto_out      => led_pronto,
            led_vencedor_out    => led_vencedor,
            led_fim_de_jogo_out => led_fim_de_jogo
        );

    estado_fsm_out <= s_estado_fsm;

end architecture estrutura;
