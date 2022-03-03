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

port (A, B: in SIGNED(X-1 downto 0); -- entrada de valores
        clk, rst : in STD_LOGIC;
        Op: in SIGNED(3 downto 0); -- operação escolhida 
        S1, S2: out SIGNED(X-1 downto 0); -- resultados das operações
        N, Z, O: out STD_LOGIC); -- valor negativo, zero e overflow
end ula;


architecture arch of ula is
	 signal result1, result2 : SIGNED (X-1 downto 0);
    signal resultMult: SIGNED(X+X-1 downto 0);
    signal resultRaiz: UNSIGNED(X/2-1 downto 0);
    signal resultSomaSub: SIGNED(X-1 downto 0);
    signal resultIncr, resultDecr : SIGNED(X-1 downto 0);
    signal resultAnd, resultOr, resultXor: SIGNED(X-1 downto 0);
    signal overflowSomaSub, overflowIncr, overflowDecr: STD_LOGIC;
	 signal reset, pronto: STD_LOGIC;
	 signal zeros: STD_LOGIC(X-1 downto 0);


    
    component wallace8 is
        Port (A, B: in  SIGNED(X-1 downto 0);
                prod: out  SIGNED(X+X-1 downto 0));
    end component;
    
	-- 1 soma 0 sub
    component somasub8bits is
        Port (A, B: in  SIGNED(X-1 downto 0);
					Op: in STD_LOGIC;
               result: out  SIGNED(X-1 downto 0);
					overflow: out STD_LOGIC);
    end component;

    component sqrt is
        Port (
            Clk, rst : in STD_LOGIC;
            entrada : in unsigned(X-1 downto 0);
            pronto : out STD_LOGIC; 
            resultado : out unsigned(X/2-1 downto 0));
    end component;

begin
	  zeros <= (other => '0');
		
     SOMASUB: somasub8bits port map(A, B, Op(0), resultSomaSub, overflowSomaSub);
     MULT: wallace8 port map(A, B, resultMult);
     RAIZ : sqrt port map(clk, reset, unsigned(std_logic_vector(A)), pronto, resultRaiz);
     resultIncr <= A + "00000001";
     resultDecr <= A - "00000001";

     S1 <= result1;
     S2 <= result2;
     
     -- Manda o resultado selecionado para a saída
     result1 <= resultSomaSub when (Op = "0001" or Op = "0010") else
                resultIncr when Op = "0011" else
                resultDecr when Op = "0100" else
                resultMult(X-1 downto 0) when Op = "1001" else zeros;
                    
     result2 <= resultMult(X+X-1 downto X) when Op = "1001" else zeros;            
     
     overflowIncr <= '1' when (A = "01111111" and Op = "0011") else '0'; 
     overflowDecr <= '1' when (A = "11111111" and Op = "0100") else '0'; 
          
     N <= '1' when (result1 < zeros and result2 < "00000001") else '0';
     Z <= '1' when (result1 = zeros and result2 = zeros) else '0';    
     O <= overflowSomaSub when (Op = "0001" or Op = "0010")
        else overflowIncr when Op = "0011"
        else overflowDecr when Op = "0100"
        else '0';
     
end arch;