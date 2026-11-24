library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tirage_03 is
    Port(ce, horloge, raz, add_color : in STD_LOGIC;
        sortie: out STD_LOGIC_VECTOR (1 downto 0)) ;
end tirage_03;

architecture Behavioral of tirage_03 is
    signal sigS: unsigned (1 downto 0);

begin

compt_process : process (horloge, raz)
begin
    if (raz='1') then
        sigS<="0";
    elsif (rising_edge(horloge))then
        if (ce='1') then
            if (sigS=to_unsigned(3,2)) then
                sigS<=to_unsigned(0,2);
            else
                sigS<=sigS + to_unsigned (1,2);
            end if;
        end if;
    end if;
    ---
    if (add_color ='1') then
    sortie <= STD_LOGIC_VECTOR(sigS);
end if;
end process;
----
end Behavioral;
