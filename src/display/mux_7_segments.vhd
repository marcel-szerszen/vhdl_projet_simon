library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux8 is
    Port (
        E0, E1, E2, E3, E4, E5, E6, E7 : in  STD_LOGIC_VECTOR(6 downto 0);
        commande : in  STD_LOGIC_VECTOR(2 downto 0);
        sortie : out STD_LOGIC_VECTOR(6 downto 0);
        DP : out STD_LOGIC
    );
end mux8;

architecture Behavioral of mux8 is
begin
    process(E0, E1, E2, E3, E4, E5, E6, E7, commande)
    begin
        case commande is
            when "000" => sortie <= E0;
            when "001" => sortie <= E1;
            when "010" => sortie <= E2;
            when "011" => sortie <= E3;
            when "100" => sortie <= E4;
            when "101" => sortie <= E5;
            when "110" => sortie <= E6;
            when "111" => sortie <= E7;
            when others => sortie <= (others => '0');
        end case;

        -- Gestion du point décimal
        if commande = "000" then
            DP <= '0';
        else
            DP <= '1';
        end if;
    end process;
end Behavioral;