library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.simon_pkg.all;

--POSSBILEMENT PAS BESOIN D'INCLURE CE BLOC 

entity compare_input is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        player_pressed : in std_logic;
        player_color : in std_logic_vector(1 downto 0);
        --new_color : in std_logic_vector(1 downto 0);
        sequence : in seq_array; -- le tableau dont nous avons déjà parlé
        step_index : in integer range 0 to 63; -- index courant dans la séquence
        good_step : out std_logic;
        error : out std_logic
    );
end compare_input;

architecture Behavioral of compare_input is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            good_step <= '0';
            error <= '0';
        elsif rising_edge(clk) then
            if player_pressed = '1' then
                if player_color = sequence(step_index) then
                    good_step <= '1';
                    error <= '0';
                else
                    good_step <= '0';
                    error <= '1';
                end if;
            else
                good_step <= '0';
                error <= '0';
            end if;
        end if;
    end process;

end Behavioral;

