library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--POSSIBLEMENT PAS BESOIN D'INCLURE CE BLOC

entity input_reader is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        btnU, btnR, btnD, btnL : in std_logic;
        player_pressed : out std_logic;
        player_color : out std_logic_vector(1 downto 0)
    );
end input_reader;

architecture Behavioral of input_reader is
    signal btn_vector : std_logic_vector(3 downto 0);
begin
    btn_vector <= btnU & btnR & btnD & btnL;

    process(clk, reset)
    begin
        if reset = '1' then
            player_pressed <= '0';
            player_color <= "00";
        elsif rising_edge(clk) then
            case btn_vector is
                when "1000" => player_color <= "00"; player_pressed <= '1';
                when "0100" => player_color <= "01"; player_pressed <= '1';
                when "0010" => player_color <= "10"; player_pressed <= '1';
                when "0001" => player_color <= "11"; player_pressed <= '1';
                when others => player_pressed <= '0'; -- aucun bouton
            end case;
        end if;
    end process;

end Behavioral;
