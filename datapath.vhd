library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
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
        fim_da_mostra_out   : out std_logic;
        nivel_out           : out std_logic_vector(1 downto 0);
        leds_cores_out      : out std_logic_vector(2 downto 0);
        led_pronto_out      : out std_logic;
        led_vencedor_out    : out std_logic;
        led_fim_de_jogo_out : out std_logic
    );
end entity datapath;

architecture rtl of datapath is

    type T_ROM is array (0 to 3) of std_logic_vector(2 downto 0);
    constant ROM_SEQUENCIA : T_ROM := ("001", "010", "100", "000");

    constant C_DELAY_VALOR : unsigned(24 downto 0) := to_unsigned(1, 25);

    signal s_valor_nivel      : unsigned(1 downto 0);
    signal s_valor_indice     : unsigned(1 downto 0);
    signal s_contador_delay   : unsigned(24 downto 0);
    signal s_cor_da_sequencia : std_logic_vector(2 downto 0);

begin
    nivel_out <= std_logic_vector(s_valor_nivel);
    s_cor_da_sequencia <= ROM_SEQUENCIA(to_integer(s_valor_indice));


    -- Comparador de 3 bits para 'jogada_certa_out'
    jogada_certa_out <= (botoes_jogador_in(0) xnor s_cor_da_sequencia(0)) and
                        (botoes_jogador_in(1) xnor s_cor_da_sequencia(1)) and
                        (botoes_jogador_in(2) xnor s_cor_da_sequencia(2));

    -- Porta OR de 3 entradas para o sinal 'botao_out'
    botao_out <= botoes_jogador_in(0) or botoes_jogador_in(1) or botoes_jogador_in(2);

    -- Multiplexador 2-para-1 para os 'leds_cores_out'
    leds_cores_out(0) <= (s_cor_da_sequencia(0) and hab_led_in) or ('0' and (not hab_led_in));
    leds_cores_out(1) <= (s_cor_da_sequencia(1) and hab_led_in) or ('0' and (not hab_led_in));
    leds_cores_out(2) <= (s_cor_da_sequencia(2) and hab_led_in) or ('0' and (not hab_led_in));
    
    atingiu_nivel_out   <= '1' when (s_valor_indice = s_valor_nivel) and (s_valor_nivel > 0) else '0';
    fim_da_mostra_out   <= '1' when s_valor_indice = (s_valor_nivel - 1) and s_valor_nivel > 0 else '0';
    
    -- Decodificador de LEDs de Status
    led_pronto_out      <= (not estado_fsm_in(3)) and (not estado_fsm_in(2)) and (not estado_fsm_in(1)) and (not estado_fsm_in(0)); -- Estado 0000
    led_fim_de_jogo_out <= (not estado_fsm_in(3)) and estado_fsm_in(2) and estado_fsm_in(1) and estado_fsm_in(0);             -- Estado 0111
    led_vencedor_out    <= estado_fsm_in(3) and (not estado_fsm_in(2)) and (not estado_fsm_in(1)) and (not estado_fsm_in(0)); -- Estado 1000

    
    -- Processo do contador de Nível
    process (clk, reset)
    begin
        if reset = '1' then
            s_valor_nivel <= (others => '0');
        elsif rising_edge(clk) then
            if op_nivel_in = "10" then
                s_valor_nivel <= (others => '0');
            elsif op_nivel_in = "01" then
                s_valor_nivel <= s_valor_nivel + 1;
            end if;
        end if;
    end process;

    -- Processo do contador de Índice
    process (clk, reset)
    begin
        if reset = '1' then
            s_valor_indice <= (others => '0');
        elsif rising_edge(clk) then
            if op_indice_in = "10" then
                s_valor_indice <= (others => '0');
            elsif op_indice_in = "01" then
                s_valor_indice <= s_valor_indice + 1;
            end if;
        end if;
    end process;

    -- Processo do contador de Delay
    process (clk, reset)
    begin
        if reset = '1' then
            s_contador_delay <= (others => '0');
            delay_out <= '1';
        elsif rising_edge(clk) then
            if start_timer_in = '1' then
                if s_contador_delay >= C_DELAY_VALOR - 1 then
                    s_contador_delay <= (others=>'0');
                    delay_out <= '1';
                else
                    s_contador_delay <= s_contador_delay + 1;
                    delay_out <= '0';
                end if;
            else
                s_contador_delay <= (others => '0');
                delay_out <= '0';
            end if;
        end if;
    end process;

end architecture rtl;
