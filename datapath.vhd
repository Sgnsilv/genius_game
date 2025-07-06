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
		  fim_da_mostra_out   : out std_logic;
        delay_out           : out std_logic;
        botao_out           : out std_logic;
        atingiu_nivel_out   : out std_logic;
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
	 
	 --simulacao
    constant C_DELAY_VALOR : unsigned(24 downto 0) := to_unsigned(1, 25);
	 --fpga
	 --constant C_DELAY_VALOR : unsigned(24 downto 0) := to_unsigned(25000000, 25); -- Para clock de 50MHz

    signal s_valor_nivel      : unsigned(1 downto 0);
    signal s_valor_indice     : unsigned(1 downto 0);
    signal s_contador_delay   : unsigned(24 downto 0);
    signal s_cor_da_sequencia : std_logic_vector(2 downto 0);

begin
    nivel_out <= std_logic_vector(s_valor_nivel);

    s_cor_da_sequencia <= ROM_SEQUENCIA(to_integer(s_valor_indice));
    jogada_certa_out   <= '1' when botoes_jogador_in = s_cor_da_sequencia else '0';
    botao_out          <= '1' when botoes_jogador_in /= "000" else '0';

    atingiu_nivel_out <= '1' when (s_valor_indice = s_valor_nivel) and (s_valor_nivel > 0) else '0';
    fim_da_mostra_out <= '1' when s_valor_indice = (s_valor_nivel - 1) and s_valor_nivel > 0 else '0';

    leds_cores_out      <= s_cor_da_sequencia when hab_led_in = '1' else "000";
    led_pronto_out      <= '1' when estado_fsm_in = "0000" else '0';
    led_fim_de_jogo_out <= '1' when estado_fsm_in = "0111" else '0';
    led_vencedor_out    <= '1' when estado_fsm_in = "1000" else '0';

    -- Processo do contador de Nível
    process (clk, reset)
    begin
        if reset = '1' then
            s_valor_nivel <= (others => '0');
        elsif rising_edge(clk) then
            if op_nivel_in = "10" then       -- Zerar
                s_valor_nivel <= (others => '0');
            elsif op_nivel_in = "01" then    -- Incrementar
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
            if op_indice_in = "10" then      -- Zerar
                s_valor_indice <= (others => '0');
            elsif op_indice_in = "01" then   -- Incrementar
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
                    s_contador_delay <= (others=>'0'); -- Zera para o próximo uso
                    delay_out <= '1';
                else
                    s_contador_delay <= s_contador_delay + 1;
                    delay_out <= '0';
                end if;
            else
                s_contador_delay <= (others => '0');
                delay_out <= '0'; -- O delay só termina (vai para '1') após a contagem
            end if;
        end if;
    end process;

end architecture rtl;
