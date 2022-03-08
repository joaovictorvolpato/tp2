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


entity ula is

generic (X: natural := 8);

port (A, B: in UNSIGNED(X-1 downto 0); -- entrada de valores
        clk, rst : in STD_LOGIC;
        Op: in UNSIGNED(3 downto 0); -- operação escolhida 
        S1, S2: out UNSIGNED(X-1 downto 0); -- resultados das operações
        N, Z, O: out STD_LOGIC); -- valor negativo, zero e overflow
end ula;


architecture arch of ula is
	 signal result1, result2 : UNSIGNED (X-1 downto 0);
    signal resultMult: UNSIGNED(X+X-1 downto 0);
    signal resultRaiz: UNSIGNED(X/2-1 downto 0);
    signal resultSomaSub: UNSIGNED(X-1 downto 0);
    signal resultIncr, resultDecr : UNSIGNED(X-1 downto 0);
    signal resultAnd, resultOr, resultXor: UNSIGNED(X-1 downto 0);
    signal overflowSomaSub, overflowIncr, overflowDecr: STD_LOGIC;
	signal reset, pronto: STD_LOGIC;
	signal sigZeros, sigOne, sigOnes: UNSIGNED(X-1 downto 0);
    
    component wallace8 is
        Port (A, B: in  UNSIGNED(X-1 downto 0);
                prod: out  UNSIGNED(X+X-1 downto 0));
    end component;
    
	-- 1 soma 0 sub
    component somasub8bits is
        Port (Op: in STD_LOGIC;
					A, B: in  UNSIGNED(X-1 downto 0);
               S: out  UNSIGNED(X-1 downto 0);
					OVF: out STD_LOGIC);
    end component;


	 
    component raizquadrada is
        Port (
            clk, rst : in STD_LOGIC;
            input : in UNSIGNED(X-1 downto 0);
            done : out STD_LOGIC; 
            sq_root : out UNSIGNED(X/2-1 downto 0));
    end component;
	 
	 
begin
     sigZeros <= (others => '0');
     sigOnes <= (others => '1');
     sigOne <= sigZeros + "00000001";
     SOMASUB: somasub8bits port map(Op(0), A, B, resultSomaSub, overflowSomaSub);
     MULT: wallace8 port map(A, B, resultMult);
     RAIZ : raizquadrada port map(clk, reset, A, pronto, resultRaiz);
     resultIncr <= A + sigOne;
     resultDecr <= A - sigOne;

     S1 <= result1; 
     S2 <= result2;
     
     -- Manda o resultado selecionado para a saída
     result1 <= resultSomaSub when (Op = "0001" or Op = "0010") else
                resultIncr when Op = "0011" else
                resultDecr when Op = "0100" else
                resultMult(X-1 downto 0) when Op = "1001" else sigZeros;
                    
     result2 <= resultMult(X+X-1 downto X) when Op = "1001" else sigZeros;            
     
     overflowIncr <= '1' when (A = "01111111" and Op = "0011") else '0'; 
     overflowDecr <= '1' when (A = sigOnes and Op = "0100") else '0'; 
          
     N <= '1' when (result1 < sigZeros and result2 < sigOne) else '0';
     Z <= '1' when (result1 = sigZeros and result2 = sigZeros) else '0';    
     O <= overflowSomaSub when (Op = "0001" or Op = "0010")
        else overflowIncr when Op = "0011"
        else overflowDecr when Op = "0100"
        else '0';
     
end arch;