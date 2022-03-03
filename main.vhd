LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY main IS

GENERIC (X: INTEGER := 16);
PORT (reset, clk, inicio: IN STD_LOGIC;
		pronto, erro: OUT STD_LOGIC;
      A, B : IN SIGNED(X-1 DOWNTO 0);
		Op : IN SIGNED(1 DOWNTO 0);
      Saida1, Saida2 : OUT SIGNED(X-1 DOWNTO 0));
END main;

ARCHITECTURE estrutura OF main IS
	TYPE state_type IS (S0, S1, S2, S3, S4);
	SIGNAL state: state_type;
	
	COMPONENT bc IS
	PORT (reset, clk, inicio, flagO: IN STD_LOGIC;
		pronto : OUT STD_LOGIC;
      ini, loadIn, loadOut, erro: OUT STD_LOGIC);
	END COMPONENT;
	
	
	COMPONENT bo IS
	PORT (clk, loadIn, loadOut : IN STD_LOGIC;
      entA, entB : IN SIGNED(X-1 DOWNTO 0);
		Op: IN SIGNED(1 downto 0);
		flagZ, flagO, flagN: OUT STD_LOGIC;
      result1, result2: OUT SIGNED(X-1 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL ini, loadIn, loadOut, flagZ, flagO, flagN, erroBc: STD_LOGIC;
	SIGNAL result1, result2: SIGNED(X-1 DOWNTO 0);

	BEGIN
	erro <= erroBc;
	Saida1 <= result1;
	Saida2 <= result2;
	
	CONTROLE: bc PORT MAP(reset, clk, inicio, flagO, pronto, ini, loadIn, loadOut, erroBc);
	OPERATIVO: bo PORT MAP(clk, loadIn, loadOut, A, B, Op, flagZ, flagO, flagN, result1, result2);

END estrutura;