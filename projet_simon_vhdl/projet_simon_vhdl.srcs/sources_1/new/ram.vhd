LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ram IS
PORT (
      CLOCK          : IN  STD_LOGIC;
      ADDR_R         : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
      ADDR_W         : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
      data_in        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      r_w            : IN  STD_LOGIC;
      DATA_OUT       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
      
      );
END ram;

ARCHITECTURE Behavioral OF ram IS

  TYPE ram_type IS ARRAY (0 TO ((2**6)-1)) OF SIGNED (1 DOWNTO 0);
  SIGNAL memory : ram_type := (others => (others => '0'));

  -- QUELQUES PETITES MODIFICATIONS FAITES POUR AIDER VIVADO A FAIRE LES BONS
  -- CHOIX D'IMPLEMENTATION...


BEGIN

  PROCESS (CLOCK)
  BEGIN
    IF (rising_edge(clock)) THEN
        if (r_w = '1') then
            memory(to_integer(UNSIGNED(ADDR_W))) <= signed (data_in);
        else
            DATA_OUT <= STD_LOGIC_VECTOR( memory(to_integer(UNSIGNED(ADDR_R))) );
        end if;
   
    END IF;
  END PROCESS;
  
END Behavioral;