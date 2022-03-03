LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY registrador_2bit IS
PORT (clk, carga : IN STD_LOGIC;
	  d : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	  q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END registrador_2bit;

ARCHITECTURE estrutura OF registrador_2bit IS
BEGIN
	PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1' AND carga = '1') THEN
			q <= d;
		END IF;
	END PROCESS;
END estrutura;