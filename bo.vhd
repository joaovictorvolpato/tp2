LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY bo IS
GENERIC (X: INTEGER:= 8);
GENERIC (SIZE_MEM:= 3);
GENERIC (SIZE_WORD:= 8);
GENERIC (SIZE_OP:= 3);
PORT (clk, enPC, enA, enB, enOp, enOut : IN STD_LOGIC;
	 flagZ, flagO, flagN: OUT STD_LOGIC;
      S, PQ: OUT SIGNED(X-1 DOWNTO 0));
END bo;

ARCHITECTURE estrutura OF bo IS
	
	COMPONENT registrador IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN SIGNED(X-1 DOWNTO 0);
		  q : OUT SIGNED(X-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT registrador_4bit IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN SIGNED(3 DOWNTO 0);
		  q : OUT SIGNED(3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT registrador_1bit IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN STD_LOGIC;
		  q : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT ula is
		PORT (A, B: in SIGNED(X-1 downto 0); 
				clk, rst : in STD_LOGIC;
				Op: in SIGNED(SIZE_OP downto 0); 
				S1, S2: out SIGNED(X-1 downto 0); 
				N, Z, O: out STD_LOGIC); 
		END COMPONENT;
	
	COMPONENT pc is
		PORT (enable, reset, clk: in STD_LOGIC;
			PC_COUNT: out STD_LOGIC_VECTOR(SIZE_MEM downto 0));
	END COMPONENT;
	
	COMPONENT ram is 
		PORT (clk: in STD_LOGIC;
			address: in STD_LOGIC_VECTOR(SIZE_MEM downto 0);
			data: out STD_LOGIC_VECTOR(SIZE_WORD downto 0));
	END COMPONENT;

	-- Saídas do BO
	SIGNAL sairegZ, sairegO, sairegN: SIGNED;
	SIGNAL sairegPQ, sairegS: SIGNED(X-1 downto 0);

	-- Saídas Ula
	SIGNAL saiulaPQ, saiulaS: SIGNED(X-1 downto 0);
	SIGNAL saiulaO, saiulaZ, saiulaN: SIGNED;
	
	-- Entradas da ULA
	SIGNAL sairegA, sairegB: SIGNED (X-1 DOWNTO 0);
	SIGNAL sairegOp: SIGNED(SIZE_OP DOWNTO 0);
	SIGNAL DadoLido: SIGNED(SIZE_WORD downto 0);
	SIGNAL PcCount: SIGNED(SIZE_MEM downto 0);
	
BEGIN
	PC: pc PORT MAP(enPC, reset, clk, PcCount);
	RAM: ram PORT MAP(clk, PcCount, DadoLido);
	ULA: ula PORT MAP(sairegA, sairegB, clk, reset, sairegOp, saiulaPQ, saiulaS, saiulaN, saiulaZ, saiulaO);

	-- Regs entrada ULA
	regOP: registrador_4bit PORT MAP (clk, enOP, DadoLido, sairegOp); 
	regA: registrador PORT MAP (clk, enA, DadoLido, sairegA);
	regB: registrador PORT MAP (clk, enB, DadoLido, sairegB);

	-- Regs Saída Ula
	regPQ: registrador PORT MAP (clk, enOut, saiulaPQ, sairegPQ);
	regS: registrador PORT MAP (clk, enOut, saiulaS, sairegS);
	regN: registrador_1bit PORT MAP(clk, enOut, saiulaN, sairegN);
	regZ: registrador_1bit PORT MAP(clk, enOut, saiulaZ, sairegZ);
	regO: registrador_1bit PORT MAP(clk, enOut, saiulaO, sairegO);
	
	
	PQ <= sairegPQ;
	S <= sairegS;
	flagZ <= sairegZ;
	flagN <= sairegN;
	flagO <= sairegO;
	
END estrutura;