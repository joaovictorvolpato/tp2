LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY main IS


GENERIC(
        X: INTEGER:= 8;
		  SIZE_OP: INTEGER:= 4);

PORT (reset, clk, inicio: IN STD_LOGIC;
		pronto, erro, calculando: OUT STD_LOGIC;
      A, B : IN UNSIGNED(X-1 DOWNTO 0);
		Op : IN UNSIGNED(1 DOWNTO 0);
      Saida1, Saida2 : OUT UNSIGNED(X-1 DOWNTO 0);
		O, Z, N: OUT STD_LOGIC);
END main;

ARCHITECTURE estrutura OF main IS
	TYPE state_type IS (S0, S1, S2, S3, S4);
	SIGNAL state: state_type;
	
	COMPONENT bc IS
	PORT (reset, clk, inicio, prontoUla, erroUla: IN STD_LOGIC;
			opcode: IN UNSIGNED(3 downto 0);
			enPC, enA, enB, enOUT, enOP, pronto, erro, calculando: OUT STD_LOGIC);
	END COMPONENT;


	
	COMPONENT bo IS
	PORT (clk, enPC, enA, enB, enOp, enOut, reset : IN STD_LOGIC;
	 flagZ, flagO, flagN: OUT STD_LOGIC;
	 opcode: OUT UNSIGNED(SIZE_OP-1 downto 0);
      S, PQ: OUT UNSIGNED(X-1 DOWNTO 0));
	END COMPONENT;

	
	
	SIGNAL flagZ, flagO, flagN: STD_LOGIC;
	SIGNAL result1, result2: UNSIGNED(X-1 DOWNTO 0);
	SIGNAL prontoUla, erroUla: STD_LOGIC;
	SIGNAL enA, enB, enOUT, enOP, enPC: STD_LOGIC;
	SIGNAL opcode: UNSIGNED(SIZE_OP-1 DOWNTO 0);
	
	BEGIN
	Saida1 <= result1;
	Saida2 <= result2;
	Z <= flagZ;
	N <= flagN;
	O <= flagO;
	
	CONTROLE: bc PORT MAP(reset, clk, inicio, prontoUla, erroUla, opcode, enPC, enA, enB, enOUT, enOP,
								pronto, erro, calculando);
	OPERATIVO: bo PORT MAP(clk, enPC, enA, enB, enOp, enOUT, reset, flagZ, flagO, flagN, opcode, result1, result2);

END estrutura;