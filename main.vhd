LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY main IS


GENERIC(
        X: INTEGER:= 8;
		  SIZE_OP: INTEGER:= 4);

PORT (reset, clk, inicio: IN STD_LOGIC;
		pronto, prontoSqrt, erro, calculando: OUT STD_LOGIC;
		estado: OUT STD_LOGIC_VECTOR(2 downto 0);
      S1Vector, S2Vector, AVector, BVector: OUT STD_LOGIC_VECTOR(X-1 DOWNTO 0);
		opcodeVector: OUT STD_LOGIC_VECTOR(SIZE_OP-1 downto 0);
		O, Z, N, prontoSaida: OUT STD_LOGIC:= '0');
END main;

ARCHITECTURE estrutura OF main IS
	COMPONENT bc IS
	PORT (reset, clk, inicio, prontoUla, erroUla: IN STD_LOGIC;
			opcode: IN UNSIGNED(3 downto 0);
			estado: OUT STD_LOGIC_VECTOR(2 downto 0);
			enPC, enA, enB, enOUT, enOP, pronto, erro, calculando, iniciarCalculo: OUT STD_LOGIC);
	END COMPONENT;


	
	COMPONENT bo IS
	PORT (clk, reset, inicio, enPC, enA, enB, enOp, enOut, iniciarCalculo: IN STD_LOGIC;
	 flagZ, flagO, flagN, prontoUla, prontoSqrt, erroUla: OUT STD_LOGIC;
	 opcodeOut: OUT UNSIGNED(SIZE_OP-1 downto 0);
      S, PQ: OUT UNSIGNED(X-1 DOWNTO 0);
		A, B: OUT UNSIGNED(X-1 DOWNTO 0));
	END COMPONENT;

	
	
	SIGNAL flagZ, flagO, flagN: STD_LOGIC;
	SIGNAL result1, result2: UNSIGNED(X-1 DOWNTO 0);
	SIGNAL prontoUla, erroUla: STD_LOGIC;
	SIGNAL enA, enB, enOUT, enOP, enPC: STD_LOGIC;
	SIGNAL opcode: UNSIGNED(SIZE_OP-1 DOWNTO 0);
	SIGNAL A, B: UNSIGNED(X-1 DOWNTO 0);
	SIGNAL iniciarCalculo: STD_LOGIC;
	
	
	BEGIN
	--Saida1 <= result1;
	--Saida2 <= result2;
	Z <= flagZ;
	N <= flagN;
	O <= flagO;
	AVector <= std_logic_vector(A);
	BVector <= std_logic_vector(B);
	opcodeVector <= std_logic_vector(opcode);
	prontoSaida <= prontoUla;
	
	S1Vector <= std_logic_vector(result1);
	S2Vector <=  std_logic_vector(result2);

	CONTROLE: bc PORT MAP(reset, clk, inicio, prontoUla, erroUla, opcode, estado, enPC, enA, enB, enOUT, enOP,
								pronto, erro, calculando, iniciarCalculo);
	OPERATIVO: bo PORT MAP(clk, reset, inicio, enPC, enA, enB, enOp, enOUT, iniciarCalculo, flagZ, flagO, flagN, prontoUla, prontoSqrt, erroUla, opcode, result1, result2, A, B);

END estrutura;