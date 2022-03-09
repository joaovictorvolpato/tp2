LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mainula IS
GENERIC(X: INTEGER:= 8;
        SIZE_OP: INTEGER:= 4);
PORT (reset, clk, iniciarCalculo: IN STD_LOGIC;
    pronto, prontoSqrtSaida, erro: OUT STD_LOGIC;
    A, B : IN UNSIGNED(X-1 DOWNTO 0);
    Op: IN UNSIGNED(SIZE_OP-1 downto 0);
    Saida1, Saida2 : OUT UNSIGNED(X-1 DOWNTO 0);
    O, Z, N: OUT STD_LOGIC);
END mainula;

ARCHITECTURE estrutura OF mainula IS
	
    COMPONENT boula IS
    port (A, B: in UNSIGNED(X-1 downto 0); -- entrada de valores
        clk, rst, iniciar_calculos : in STD_LOGIC;
        Op: in UNSIGNED(SIZE_OP-1 downto 0); -- operação escolhida 
        S1, S2: out UNSIGNED(X-1 downto 0); -- resultados das operações
        N, Z, O, prontoSqrt: out STD_LOGIC); -- valor negativo, zero e overflow
    end COMPONENT;

    COMPONENT fsmula IS
    PORT (clk, iniciarCalculo, reset, prontoSqrt: IN STD_LOGIC;
          opcode: IN UNSIGNED(SIZE_OP-1 downto 0);
          prontoUla, erroUla, iniciar_calculos, reset_calculos: OUT STD_LOGIC);
    END COMPONENT;
	
    -- Signals Saída ULA
	SIGNAL flagZ, flagO, flagN: STD_LOGIC;
	SIGNAL S1, S2: UNSIGNED(X-1 DOWNTO 0);
	SIGNAL prontoULA, erroULA: STD_LOGIC;
	-- Signals Controle Ula
    SIGNAL prontoSqrt, iniciar_calculos, reset_calculos: STD_LOGIC;
	
	BEGIN
	Saida1 <= S1;
	Saida2 <= S2;
   pronto <= prontoULA;
   erro <= erroULA;
	Z <= flagZ;
	N <= flagN;
	O <= flagO;
	prontoSqrtSaida <= prontoSqrt;
	
	CONTROLE: fsmula PORT MAP(clk, iniciarCalculo, reset, prontoSqrt, Op, prontoULA, erroULA, iniciar_calculos, reset_calculos);
	OPERATIVO: boula PORT MAP(A, B, clk, reset_calculos, iniciar_calculos, Op, S1, S2, flagZ, flagO, flagN, prontoSqrt);

END estrutura;