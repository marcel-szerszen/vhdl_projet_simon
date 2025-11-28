library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gestion_freq is
    Port ( horloge : in STD_LOGIC;
           raz : in STD_LOGIC;
           ce_affichage : out STD_LOGIC;
           ce_perception : out STD_LOGIC);
end gestion_freq;

architecture Behavioral of gestion_freq is

    signal s_affichage: unsigned (23 downto 0);
    signal s_perception: unsigned (15 downto 0);

begin

    gestion_horloge: process (horloge, raz)
    begin
        if (raz = '1') then
            s_affichage <= (others => '0');
            s_perception <= (others => '0');
        end if;
        
        if(rising_edge(horloge)) then
            if (s_perception=to_unsigned(33334,16)) then
                    s_perception <= to_unsigned(0,16);
                else
                    s_perception <= s_perception + 1;
            end if;
         
                if (s_affichage=to_unsigned(10000000 ,24)) then

                    s_affichage <= to_unsigned(0,24);
                    else
                    s_affichage <= s_affichage + 1;
                end if;              
        end if;
    end process;        
        
       process(s_affichage, s_perception)
       begin
            if (raz = '1') then
                ce_perception <= '0';
                ce_affichage <= '0';
            else
                if s_affichage = to_unsigned(9999999,24) then
                    ce_affichage <= '1';
                else 
                    ce_affichage <= '0';
                end if;
                
                if s_perception = to_unsigned(33333, 16) then
                    ce_perception <= '1';
                else 
                    ce_perception <= '0';
                end if;
            end if;
    end process;
end Behavioral;
