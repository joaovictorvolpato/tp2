LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY bc IS
PORT (reset, clk, inicio, prontoUla, erroUla: IN STD_LOGIC;
		opcode: IN STD_LOGIC_VECTOR(3 downto 0);
      enPC, enA, enB, enOUT, pronto: OUT STD_LOGIC);
END bc;


ARCHITECTURE estrutura OF bc IS
	TYPE state_type IS (S0, S1, S2, S3, S4, S5, S6);
	SIGNAL state: state_type;
BEGIN
	-- Parado S0
	-- LerOperacao S1
	-- LerA S2 
	-- LerB S3
	-- Operação S4
	-- LerSaídaULA S5
	-- Erro S6
	
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
	
	-- Logica de proximo estado (e registrador de estado)
	PROCESS (clk, reset)
	BEGIN
		if(reset = '1') THEN
			state <= S0;
		ELSIF (clk'EVENT AND clk = '1') THEN
			CASE state IS
				WHEN S0 =>
					-- Se inicio, passa para ler as operações
					if inicio = '1' then
						state <= S1;
					end if;
					
				-- Se preparando os dados, passa para cálculo
				WHEN S1 =>
					if (opcode = "0000" or opcode = "1111") then
						state <= S0; -- Parado
					else
						state <= S2; -- Ler A
					end if;
						
				-- Após Ler A, vê qual deve ser o próximo estado
				WHEN S2 =>
					if (opcode = "0001" or opcode = "0010" or opcode = "0110" or opcode = "0111" or opcode = "1000") then
						state <= S3; -- Ler B
					else
						state <= S4; -- Operação
					end if;

				
				-- Após Ler B, vai direto para a Operação
				WHEN S3 =>
					state <= S4;
				
				-- Na operação, espera a entrada pronto da ULA
				WHEN S4 =>
					if prontoUla = '1' then
						state <= S5; -- LerSaídaUla
					end if;
					if erroUla = '1' then
						state <= S6; -- Erro
				WHEN S5 => 
					state <= S1; -- Ler próxima instrução
					
			END CASE;
		END IF;
	END PROCESS;
	
	-- Logica de saida
	PROCESS (state)
	BEGIN
		CASE state IS
			-- Estado para fazer nada
			WHEN S0 =>
				ini <= '0';
				loadOut <= '0';
				loadIn <= '0'; -- cB = 0, cOp = 0
				pronto <= '0';
				erro <= '0';
			
			-- Carregar registradores do BO
			WHEN S1 =>
				ini <= '1';
				loadIn <= '1'; -- cB = 1, cOp = 1
			
			-- Estado durante calculo
			WHEN S2 =>
				ini <= '0'; -- Já prepara para fazer a soma no S3
				loadIn <= '0'; -- Para de carregador os registradores de entrada
				loadOut <= '1'; -- Começa a carregar os registradores de saída
				
			-- Estado de erro 
			WHEN S3 =>
				erro <= '1';
				
			-- Estado de cálculo finalizado
			WHEN S4 =>
				pronto <= '1';
				
		END CASE;
	END PROCESS;
END estrutura;