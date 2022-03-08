LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY bo IS

generic(
        X: INTEGER:= 8;
        SIZE_MEM: INTEGER:= 4; 
        SIZE_WORD: INTEGER:= 8; 
		  SIZE_OP: INTEGER:= 4
        );

PORT (clk, enPC, enA, enB, enOp, enOut, reset : IN STD_LOGIC;
	 flagZ, flagO, flagN: OUT STD_LOGIC;
	 opcode: OUT UNSIGNED(SIZE_OP-1 downto 0);
      S, PQ: OUT UNSIGNED(X-1 DOWNTO 0));
END bo;

ARCHITECTURE estrutura OF bo IS
	
	COMPONENT registrador IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN UNSIGNED(X-1 DOWNTO 0);
		  q : OUT UNSIGNED(X-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT registrador_4bit IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN UNSIGNED(3 DOWNTO 0);
		  q : OUT UNSIGNED(3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT registrador_1bit IS
	PORT (clk, carga : IN STD_LOGIC;
		  d : IN STD_LOGIC;
		  q : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT ula is
		PORT (A, B: in UNSIGNED(X-1 downto 0); 
				clk, rst : in STD_LOGIC;
				Op: in UNSIGNED(SIZE_OP-1 downto 0); 
				S1, S2: out UNSIGNED(X-1 downto 0); 
				N, Z, O: out STD_LOGIC); 
		END COMPONENT;
	
	COMPONENT pc is
		PORT (enable, reset, clk: in STD_LOGIC;
			PcCount: out UNSIGNED(SIZE_MEM-1 downto 0));
	END COMPONENT;
	
	COMPONENT rom is 
		PORT (addr: in UNSIGNED(SIZE_MEM-1 downto 0);
			data: out UNSIGNED(SIZE_WORD-1 downto 0));
	END COMPONENT;

	-- Saídas do BO
	SIGNAL sairegZ, sairegO, sairegN: STD_LOGIC;
	SIGNAL sairegPQ, sairegS: UNSIGNED(X-1 downto 0);

	-- Saídas Ula
	SIGNAL saiulaPQ, saiulaS: UNSIGNED(X-1 downto 0);
	SIGNAL saiulaO, saiulaZ, saiulaN: STD_LOGIC;
	
	-- Entradas da ULA
	SIGNAL sairegA, sairegB: UNSIGNED (X-1 DOWNTO 0);
	SIGNAL sairegOp: UNSIGNED(SIZE_OP-1 DOWNTO 0);
	SIGNAL DadoLido: UNSIGNED(SIZE_WORD-1 downto 0);
	SIGNAL PcCount: UNSIGNED(SIZE_MEM-1 downto 0);
	
BEGIN
	PC1: pc PORT MAP(enPC, reset, clk, PcCount);
	ROM1: rom PORT MAP(PcCount, DadoLido);
	ULA1: ula PORT MAP(sairegA, sairegB, clk, reset, sairegOp, saiulaPQ, saiulaS, saiulaN, saiulaZ, saiulaO);

	-- Regs entrada ULA
	regOP: registrador_4bit PORT MAP (clk, enOP, DadoLido(SIZE_OP-1 downto 0), sairegOp); 
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
	opcode <= DadoLido(SIZE_OP-1 downto 0);
	
END estrutura;