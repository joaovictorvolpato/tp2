LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY registrador IS
generic(X: INTEGER:= 8);
PORT (clk, carga : IN STD_LOGIC;
	  d : IN UNSIGNED(X-1 DOWNTO 0);
	  q : OUT UNSIGNED(X-1 DOWNTO 0));
END registrador;

ARCHITECTURE estrutura OF registrador IS
BEGIN
	PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1' AND carga = '1') THEN
			q <= d;
		END IF;
	END PROCESS;
END estrutura;