LIBRARY ieee;
USE ieee.std_logic_1164.all;
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

ENTITY fsmula IS
PORT (clk, inicio, reset, prontoSqrt: IN STD_LOGIC;
      opcode: IN STD_LOGIC_VECTOR(3 downto 0);
      prontoUla, erroUla: OUT STD_LOGIC);
END fsmula;


ARCHITECTURE estrutura OF fsmula IS
	TYPE state_type IS (S0, S1, S2, S3);
	SIGNAL state: state_type;
BEGIN
    -- S0 Parado
    -- S1 Calculando
    -- S2 Pronto
    -- S3 Erro

	-- Logica de proximo estado
	PROCESS (clk, reset)
	BEGIN
		if(reset = '1') THEN
			state <= S0;
		ELSIF (clk'EVENT AND clk = '1') THEN
			CASE state IS
				WHEN S0 =>
					-- Se inicio, passa para o calculo
					if inicio = '1' then
						state <= S1;
					end if;
					
				-- No calculo verifica qual a operação, caso seja sqrt vai esperar, se não já está pronto
				WHEN S1 =>
					if opcode = "1010" then
						if prontoSqrt = '1' then
                            state <= S2; -- Pronto
                        end if;
					else
                       state <= S2; -- Ler A            
                    end if; 
                    						
				-- Em pronto vai retornar para parado
				WHEN S2 =>
                    if reset = '1' then
                        state <= S0;
                    end if;

				
				-- Em erro espera reset para voltar ao primeiro
				WHEN S3 =>
					state <= S0;
			END CASE;
		END IF;
	END PROCESS;

	PROCESS (state)
	BEGIN
		CASE state IS
			-- Estado Parado
			WHEN S0 =>
				prontoUla <= '0';
				erroUla <= '0';

			-- Calculo
			WHEN S1 =>
                prontoUla <= '0';
                erroUla <= '0';
			
			-- Pronto
			WHEN S2 =>
                prontoUla <= '1';
                erroUla <= '0';
				
			-- Erro
			WHEN S3 =>
                prontoUla <= '0';
                erroUla <= '1';
				
		END CASE;
	END PROCESS;
END estrutura;