LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY main IS


GENERIC(
        X: INTEGER:= 8;
		  SIZE_OP: INTEGER:= 4);

PORT (reset, clk, inicio: IN STD_LOGIC;
		pronto, erro: OUT STD_LOGIC;
      S1Vector, S2Vector, AVector, BVector: OUT STD_LOGIC_VECTOR(X-1 DOWNTO 0);
		opcodeVector: OUT STD_LOGIC_VECTOR(SIZE_OP-1 downto 0);
		N, Z, O: OUT STD_LOGIC:= '0');
END main;

ARCHITECTURE estrutura OF main IS
	COMPONENT bc IS
	PORT (reset, clk, inicio, prontoUla, erroUla: IN STD_LOGIC;
			opcode: IN UNSIGNED(3 downto 0);
			enPC, enA, enB, enOut, enOp, pronto, erro, iniciarUla: OUT STD_LOGIC);
	END COMPONENT;


	COMPONENT bo IS
	PORT (clk, reset, iniciarUla, enPC, enA, enB, enOp, enOut: IN STD_LOGIC;
	 flagN, flagZ, flagO, prontoUla, erroUla: OUT STD_LOGIC;
	 opcodeOut: OUT UNSIGNED(SIZE_OP-1 downto 0);
      S, PQ: OUT UNSIGNED(X-1 DOWNTO 0);
		A, B: OUT UNSIGNED(X-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL result1, result2: UNSIGNED(X-1 DOWNTO 0);
	SIGNAL prontoUla, erroUla: STD_LOGIC;
	SIGNAL enA, enB, enOut, enOP, enPC: STD_LOGIC;
	SIGNAL opcode: UNSIGNED(SIZE_OP-1 DOWNTO 0);
	SIGNAL A, B: UNSIGNED(X-1 DOWNTO 0);
	SIGNAL iniciarUla: STD_LOGIC;
	
	BEGIN
	--Saida1 <= result1;
	--Saida2 <= result2;
	AVector <= std_logic_vector(A);
	BVector <= std_logic_vector(B);
	opcodeVector <= std_logic_vector(opcode);
	
	S1Vector <= std_logic_vector(result1);
	S2Vector <=  std_logic_vector(result2);

	CONTROLE: bc PORT MAP(reset, clk, inicio, prontoUla, erroUla, opcode, enPC, enA, enB, enOUT, enOP, pronto, erro, iniciarUla);
	OPERATIVO: bo PORT MAP(clk, reset, iniciarUla, enPC, enA, enB, enOp, enOut, N, Z, O, prontoUla, erroUla, opcode, result1, result2, A, B);

END estrutura;