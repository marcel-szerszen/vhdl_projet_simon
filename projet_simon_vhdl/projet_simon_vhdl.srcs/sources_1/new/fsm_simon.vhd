library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm_simon is
    Port (
        clk            : in  std_logic;
        reset          : in  std_logic;

        -- Signaux venant d'autres modules
        
        B_DOWN         : in std_logic;
        B_UP           : in std_logic;
        B_RIGHT        : in std_logic; 
        B_LEFT         : in std_logic; 
        B_CENTER       : in std_logic; 
        sequence_color : in  std_logic_vector(1 downto 0); -- couleur attendue
        show_done      : in  std_logic; -- indique que l'affichage de la séquence est terminé
        curr_length    : inout std_logic_vector(5 downto 0); 
        

        -- Signaux sortants pour contrôle
        --player_color   : out std_logic_vector(1 downto 0);
        sequence       : out std_logic_vector(127 downto 0);
        iteration      : out integer range 0 to 63; 
        seq_add_color  : out std_logic; -- ajouter une couleur à la séquence
        show_start     : out std_logic; -- commencer affichage
        reset_show     : out std_logic; -- reset index d'affichage
        reset_input    : out std_logic; -- reset index de l'entrée joueur
        input_next     : out std_logic; -- avancer à la prochaine couleur attendue
        lose_flag      : out std_logic -- joue séquence "défaite"
        --win_flag       : out std_logic  -- indique qu'on passe au round suivant
        --last_click     : out std_logic
    );
end fsm_simon;

architecture Behavioral of fsm_simon is

    --------------------------------------------------------------------
    -- Machine d'états
    --------------------------------------------------------------------
    type state_type is (
        IDLE,
        GEN_SEQ,
        SHOW_SEQ,
        WAIT_INPUT,
        CHECK_INPUT,
        WIN_ROUND,
        LOSE
    );

    signal current_state, next_state : state_type := IDLE;
    signal curr_seq_index : integer range 0 to 63;  
    --signal us_current_length : unsigned(curr_length);
    signal s_player_color   :  std_logic_vector(1 downto 0);
    signal s_sequence : std_logic_vector(127 downto 0);
    signal s_iteration : integer range 0 to 63;
begin

    --------------------------------------------------------------------
    -- PROCESS SEQUENTIEL : registre d'état
    --------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    --------------------------------------------------------------------
    -- PROCESS COMBINATOIRE : transitions + sorties
    --------------------------------------------------------------------
    process(current_state, sequence_color, show_done, B_CENTER, B_RIGHT, B_LEFT, B_DOWN, B_UP)
    begin

        -- valeurs par défaut (indispensable)
        seq_add_color <= '0';
        show_start    <= '0';
        reset_show    <= '0';
        reset_input   <= '0';
        input_next    <= '0';
        lose_flag     <= '0';
        --win_flag      <= '0';
        s_player_color <= "00";

        next_state <= current_state; -- défaut

        case current_state is

            ----------------------------------------------------------------
            when IDLE =>
                -- Réinitialiser les compteurs externes
                s_iteration <= 0;
                lose_flag <= '0';
                reset_show  <= '1';
                reset_input <= '1';
                -- On démarre un nouveau jeu
                if (B_CENTER = '1') then
                    next_state <= GEN_SEQ;
                end if;
            ----------------------------------------------------------------
            when GEN_SEQ =>
                -- Demande l'ajout d'une nouvelle couleur
                seq_add_color <= '1';
                -- Puis on lance l'affichage
                reset_show <= '1';
                show_start <= '1';
                s_sequence(2*s_iteration+1 downto 2*s_iteration) <= sequence_color;
                
                next_state <= SHOW_SEQ;
                
                
            ----------------------------------------------------------------
            when SHOW_SEQ =>
                -- On attend que l'affichage finisse la séquence
                s_iteration <= s_iteration + 1;
                if show_done = '1' then
                    reset_input <= '1';
                    next_state <= WAIT_INPUT;
                    
                end if;

            ----------------------------------------------------------------
            when WAIT_INPUT =>
                -- Attente d'un bouton du joueur
                if (B_RIGHT = '1') then
                    s_player_color <= "00";
                    next_state <= CHECK_INPUT;
                elsif (B_UP = '1') then
                    s_player_color <= "01";
                    next_state <= CHECK_INPUT;
                elsif (B_LEFT = '1') then
                    s_player_color <= "10";
                    next_state <= CHECK_INPUT;
                elsif (B_DOWN = '1') then
                    s_player_color <= "11";
                    next_state <= CHECK_INPUT;
                end if;

            ----------------------------------------------------------------
            when CHECK_INPUT =>
                if (s_player_color = s_sequence(2*curr_seq_index+1 downto 2*curr_seq_index)) then
                    if (curr_seq_index = s_iteration) then
                        curr_seq_index <= 0;
                        next_state <= GEN_SEQ;
                    else
                        curr_seq_index <= curr_seq_index + 1;
                        input_next <= '1'; --???
                        next_state <= WAIT_INPUT;
                    end if; 
                else
                    next_state <= LOSE;   
                end if;

            ----------------------------------------------------------------
            when WIN_ROUND =>
                --win_flag <= '1';
                next_state <= GEN_SEQ;

            ----------------------------------------------------------------
            when LOSE =>
                lose_flag <= '1';
                next_state <= IDLE;

        end case;
    end process;
    
    --player_color <= s_player_color;
    iteration <= s_iteration;   
    sequence <= s_sequence;

end Behavioral;
