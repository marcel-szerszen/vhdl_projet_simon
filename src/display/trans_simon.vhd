library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trans is
    port (
        nb_binaire    : in  STD_LOGIC_VECTOR(5 downto 0);
        --seq_color     : in std_logic_vector(1 downto 0); --for test on 7 segments, venant de la ram
        sequence      : in std_logic_vector(127 downto 0);
        iteration     : in integer range 0 to 63;
        
        S_diz      : out STD_LOGIC_VECTOR(6 downto 0);
        S_uni      : out STD_LOGIC_VECTOR(6 downto 0);
        color_symbol : out STD_LOGIC_VECTOR(6 downto 0) --for test on 7 segments, symbole à afficher sur 7 seg
    );
end trans;

architecture Behavioral of trans is
    function decode7seg(digit : integer) return STD_LOGIC_VECTOR is
    begin
        case digit is
            when 0 => return "0000001";
            when 1 => return "1001111";
            when 2 => return "0010010";
            when 3 => return "0000110";
            when 4 => return "1001100";
            when 5 => return "0100100";
            when 6 => return "0100000";
            when 7 => return "0001111";
            when 8 => return "0000000";
            when 9 => return "0000100";
            when others => return "0010000";
        end case;
    end function;

begin
    process(nb_binaire)
        variable val    : integer;
        variable diz    : integer;
        variable uni    : integer;
    begin
        val  := to_integer(unsigned(nb_binaire));
        diz  := (val mod 100) / 10;
        uni  := val mod 10;

        S_diz     <= decode7seg(diz);
        S_uni     <= decode7seg(uni);
    end process;
    
    process(sequence)  --for test on 7 segments
    begin
        case(sequence(2*iteration+1 downto 2*iteration)) is
            when "00" =>
                color_symbol <= "1001111";
                
            when "01" =>
                color_symbol <= "0111111";
                
            when "10" =>
                color_symbol <= "1111001";
            
            when "11" =>
                color_symbol <= "1101111";
        end case;
    end process;
                

end Behavioral;
