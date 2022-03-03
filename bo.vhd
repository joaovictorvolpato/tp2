LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY bo IS
GENERIC (X: INTEGER:= 16);
PORT (clk, loadIn, loadOut : IN STD_LOGIC;
      entA, entB : IN SIGNED(X-1 DOWNTO 0);
		Op: IN SIGNED(1 downto 0);
		flagZ, flagO, flagN: OUT STD_LOGIC;
      result1, result2: OUT SIGNED(X-1 DOWNTO 0));
END bo;

ARCHITECTURE estrutura OF bo IS
	
	COMPONENT registrador IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN SIGNED(X-1 DOWNTO 0);
		  q : OUT SIGNED(X-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT registrador_2bit IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN SIGNED(1 DOWNTO 0);
		  q : OUT SIGNED(1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT registrador_1bit IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN STD_LOGIC;
		  q : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT wallace16 IS
		Port (A: in  SIGNED(X-1 downto 0);
				B: in  SIGNED(X-1 downto 0);
				prod:  out  SIGNED(X+X-1 downto 0));
	END COMPONENT;
	
	COMPONENT ula IS
	PORT (A, B: IN SIGNED(X-1 DOWNTO 0); 
        Op: IN SIGNED(1 DOWNTO 0); 
        S1, S2: OUT SIGNED(X-1 DOWNTO 0);
        N, Z, O: OUT STD_LOGIC);
	END COMPONENT;
	
	
	SIGNAL saiulaZ, saiulaO, saiulaN, sairegN, sairegZ, sairegO: STD_LOGIC;
	SIGNAL sairegOp: SIGNED(1 DOWNTO 0);
	SIGNAL sairegA, sairegB, sairegS1, sairegS2: SIGNED (X-1 DOWNTO 0);
	SIGNAL saidaUla1, saidaUla2: SIGNED(X-1 DOWNTO 0);
	
BEGIN

	regOP: registrador_2bit PORT MAP (clk, loadIn, Op, sairegOp); 
	regA: registrador PORT MAP (clk, loadIn, entA, sairegA);
	regB: registrador PORT MAP (clk, loadIn, entB, sairegB); -- load = cA = cB = cOp

	regS1: registrador PORT MAP (clk, loadOut, saidaUla1, sairegS1);
	regS2: registrador PORT MAP (clk, loadOut, saidaUla2, sairegS2);
	
	regN: registrador_1bit PORT MAP(clk, loadOut, saiulaN, sairegN);
	regZ: registrador_1bit PORT MAP(clk, loadOut, saiulaZ, sairegZ);
	regO: registrador_1bit PORT MAP(clk, loadOut, saiulaO, sairegO);
	
	CALC: ula PORT MAP (sairegA, sairegB, sairegOp, saidaUla1, saidaUla2, saiulaN, saiulaZ, saiulaO);
	
	result1 <= sairegS1;
	result2 <= sairegS2;
	flagZ <= sairegZ;
	flagN <= sairegN;
	flagO <= sairegO;
	
END estrutura;