library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod8 is
    Port ( 
        c_e    : in  STD_LOGIC;
        horloge: in  STD_LOGIC;
        raz    : in  STD_LOGIC;
        sortie : out STD_LOGIC_VECTOR (2 downto 0); -- position (0..7)
        AN     : out STD_LOGIC_VECTOR (7 downto 0)  -- sélection des afficheurs
    );
end mod8;

architecture Behavioral of mod8 is
    signal count : unsigned(2 downto 0) := (others => '0');
begin

    -- Process compteur modulo 8
    process(horloge, raz)
    begin
        if raz = '1' then
            count <= (others => '0');
        elsif rising_edge(horloge) then
            if c_e = '1' then
                if count = "111" then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
process(count)
begin
    -- Sortie binaire du compteur
    sortie <= std_logic_vector(count);

    -- Sélection d'une seule anode active (active bas)
    case count is
        when "000" => AN <= "11111110"; -- digit 0
        when "001" => AN <= "11111101"; -- digit 1
        when "010" => AN <= "11111011"; -- digit 2
        when "011" => AN <= "11110111"; -- digit 3
        when "100" => AN <= "11101111"; -- digit 4
        when "101" => AN <= "11011111"; -- digit 5
        when "110" => AN <= "10111111"; -- digit 6
        when "111" => AN <= "01111111"; -- digit 7
        when others => AN <= "11111111"; -- sécurité : rien activé
    end case;
end process;
    

end Behavioral;


