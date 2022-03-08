LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY registrador_4bit IS
PORT (clk, carga : IN STD_LOGIC;
	  d : IN UNSIGNED(3 DOWNTO 0);
	  q : OUT UNSIGNED(3 DOWNTO 0));
END registrador_4bit;

ARCHITECTURE estrutura OF registrador_4bit IS
BEGIN
	PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1' AND carga = '1') THEN
			q <= d;
		END IF;
	END PROCESS;
END estrutura;