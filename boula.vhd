library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;

-- 0000 No operation
-- 0001 A + B
-- 0010 A - B
-- 0011 A++
-- 0100 A--
-- 0101 not(A)
-- 0110 (A and B) bit a bit
-- 0111 (A or B) bit a bit
-- 1000 (A xor B) bit a bit
-- 1001 A * B
-- 1010 A raiz B
-- 1111 Halt

entity boula is

generic (X: natural := 8);

port (A, B: in UNSIGNED(X-1 downto 0); -- entrada de valores
        clk, rst, iniciar_calculos: in STD_LOGIC;
        Op: in UNSIGNED(3 downto 0); -- operação escolhida 
        S1, S2: out UNSIGNED(X-1 downto 0); -- resultados das operações
        N, Z, O, prontoSqrt: out STD_LOGIC); -- valor negativo, zero e overflow
end boula;


architecture arch of boula is
	 signal result1, result2 : UNSIGNED (X-1 downto 0);
    signal resultMult: UNSIGNED(X+X-1 downto 0);
    signal resultRaiz: UNSIGNED(X/2-1 downto 0);
	 signal result_And, result_Or, result_Xor: UNSIGNED(X-1 downto 0);
    signal resultIncr, resultDecr : UNSIGNED(X-1 downto 0);
    signal resultAnd, resultOr, resultXor: UNSIGNED(X-1 downto 0);
    signal overflowSomaSub, overflowIncr, overflowDecr: STD_LOGIC;
    signal prontoRaiz: STD_LOGIC;
	 signal sigZeros, sigOne, sigOnes: UNSIGNED(X-1 downto 0);
	
	 signal signedA, signedB, resultSomaSub: SIGNED(X-1 downto 0);
    signal unsignedSomaSub: UNSIGNED(X-1 downto 0);
	 
	COMPONENT bitabit_or is
	port(A, B: in unsigned(X-1 downto 0);
		 S: out unsigned(X-1 downto 0));
	end COMPONENT;


	COMPONENT bitabit_xor is
	port(A, B: in unsigned(X-1 downto 0);
		 S: out unsigned(X-1 downto 0));
	end COMPONENT;
	 
	COMPONENT bitabit_and IS
	port(A, B: in unsigned(X-1 downto 0);
		 S: out unsigned(X-1 downto 0));
	end COMPONENT;
	 
    component wallace8 is
        Port (A, B: in  UNSIGNED(X-1 downto 0);
                prod: out  UNSIGNED(X+X-1 downto 0));
    end component;
    
	-- 1 soma 0 sub
    component somasub8bits is
        Port (Op: in STD_LOGIC;
            A, B: in  SIGNED(X-1 downto 0);
            S: out  SIGNED(X-1 downto 0);
            OVF: out STD_LOGIC);
    end component;

    component raizquadrada is
        Port (
            clk, rst, ini : in STD_LOGIC;
            input : in UNSIGNED(X-1 downto 0);
            done : out STD_LOGIC; 
            sq_root : out UNSIGNED(X/2-1 downto 0));
    end component;
	 
begin
	-- Type Cast
	signedA <= signed(A);
	signedB <= signed(B);
	unsignedSomaSub <= unsigned(resultSomaSub);
	
    -- Sinais 
    sigZeros <= (others => '0');
    sigOnes <= (others => '1');
    sigOne <= sigZeros + "00000001";
	 prontoSqrt <= prontoRaiz;
	 
    -- Operações ULA
    SOMASUB: somasub8bits port map(Op(0), signedA, signedB, resultSomaSub, overflowSomaSub);
    MULT: wallace8 port map(A, B, resultMult);
    RAIZ : raizquadrada port map(clk, rst, iniciar_calculos, A, prontoRaiz, resultRaiz);
    BIT_AND : bitabit_and port map(A, B, result_And);
	 BIT_OR : bitabit_or port map(A, B, result_Or);
	 BIT_XOR : bitabit_xor port map(A, B, result_Xor);
	 resultIncr <= A + sigOne;
    resultDecr <= A - sigOne;
     
     -- Manda o resultado selecionado para a saída
    result1 <= unsignedSomaSub when (Op = "0001" or Op = "0010") else
                resultIncr when Op = "0011" else
                resultDecr when Op = "0100" else
                resultMult(X-1 downto 0) when Op = "1001" else 
					 "0000" & resultRaiz when Op = "1010" else
					 not(A) when Op = "0101" else
					 result_And when Op = "0110" else
					 result_Xor when Op = "1000" else
					 result_Or when Op = "0111" else
					 sigZeros;                   	
	 result2 <= resultMult(X+X-1 downto X) when Op = "1001" else sigZeros;            
    S1 <= result1; 
    S2 <= result2; 
	  
	  
	 -- Overflow Incremento e Decremento
    overflowIncr <= '1' when (A = "01111111" and Op = "0011") else '0'; 
    overflowDecr <= '1' when (A = "10000000" and Op = "0100") else '0'; 

	 -- Flags
    N <= '1' when result1(X-1) = '1' else '0';
    Z <= '1' when (result1 = sigZeros and result2 = sigZeros) else '0';    
    O <= overflowSomaSub when (Op = "0001" or Op = "0010")
        else overflowIncr when Op = "0011"
        else overflowDecr when Op = "0100"
        else '0';
end arch;