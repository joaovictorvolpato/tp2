LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY bc IS
PORT (reset, clk, inicio, prontoUla, erroUla: IN STD_LOGIC;
		opcode: IN UNSIGNED(3 downto 0);
      enPC, enA, enB, enOUT, enOP, pronto, erro, iniciarUla: OUT STD_LOGIC);
END bc;


ARCHITECTURE estrutura OF bc IS
	TYPE state_type IS (S0, S1, S2, S3, S4, S5, S6, S7);
	SIGNAL state: state_type;
BEGIN

	-- Parado S0
	-- LerOperacao S1
	-- LerA S2 
	-- LerB S3
	-- Operação S4
	-- LerSaídaULA S5
	-- OperaçãoPronta S6
	-- Erro S7
	
	-- 0000 Nada
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
	-- 1110 No operation
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
					if (opcode = "1110" or opcode = "1111") then
						state <= S0; -- Parado
					else
						state <= S2; -- Ler A
					end if;
						
				-- Após Ler A, vê qual deve ser o próximo estado
				WHEN S2 =>
					if (opcode = "0001" or opcode = "0010" or opcode = "0110" or opcode = "0111" or opcode = "1000" or opcode = "1001") then
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
						state <= S7; -- Erro
					end if;
				
				-- LerSaídaUla
				WHEN S5 => 
					state <= S6; -- Instrução pronta

				
				-- Instrução pronta
				WHEN S6 =>
					state <= S1; -- Ler próxima instrução
				
				WHEN S7 =>
					IF reset = '1' THEN
						state <= S0;
					END IF;
				
			END CASE;
		END IF;
	END PROCESS;

	PROCESS (state)
	BEGIN
		CASE state IS
			-- Estado Parado
			WHEN S0 =>
				enA <= '0';
				enB <= '0';
				enPC <= '0';
				enOp <= '0';
				enOUT <= '0';
				pronto <= '0';
				erro <= '0';
				iniciarUla <= '0';
			
			-- Ler Instrução
			WHEN S1 =>
				enA <= '0';
				enB <= '0';
				enPC <= '1';
				enOp <= '1';
				enOUT <= '0';
				pronto <= '0';
				erro <= '0';
				iniciarUla <= '0';
			
			-- Ler A
			WHEN S2 =>
				enA <= '1';
				enB <= '0';
				enPC <= '1';
				enOp <= '0';
				enOUT <= '0';
				pronto <= '0';
				erro <= '0';
				iniciarUla <= '0';
				
			-- Ler B 
			WHEN S3 =>
				enA <= '0';
				enB <= '1';
				enPC <= '1';
				enOp <= '0';
				enOUT <= '0';
				pronto <= '0';
				erro <= '0';
				iniciarUla <= '0';
				
			-- Operação
			WHEN S4 =>
				enA <= '0';
				enB <= '0';
				enPC <= '0';
				enOp <= '0';
				enOUT <= '0';
				pronto <= '0';
				erro <= '0';
				iniciarUla <= '1';
			
			-- LerSaídaUla
			WHEN S5 =>
				enA <= '0';
				enB <= '0';
				enPC <= '0';
				enOp <= '0';
				enOUT <= '1'; -- Ler a Ula
				pronto <= '0';
				erro <= '0';
				iniciarUla <= '0';
				
			-- InstruçãoPronta
			WHEN S6 =>
				enA <= '0';
				enB <= '0';
				enPC <= '0';
				enOp <= '0';
				enOUT <= '0';
				pronto <= '1'; -- Falar pro usuário que a saída tá pronta
				erro <= '0';
				iniciarUla <= '0';
				
			-- Erro
			WHEN S7 =>
				enA <= '0';
				enB <= '0';
				enPC <= '0';
				enOp <= '0';
				enOUT <= '0';
				pronto <= '0';
				erro <= '1';
				iniciarUla <= '0';
				
		END CASE;
	END PROCESS;
END estrutura;