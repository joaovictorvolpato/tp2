library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;
use ieee.signed_std.all;


entity pc is
generic(X :INTEGER := 3);
port (enable, reset, clk: in STD_LOGIC;
	PC_COUNT: out STD_LOGIC_VECTOR(X-1 downto 0));
end pc;

architecture arch of pc is
    signal current_pc: std_logic_vector(X-1 downto 0) := (others => '0');
begin

    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            current_pc <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
				IF (enable = '1') then 
					current_pc <= std_logic_vector(unsigned(current_pc) + 1);
				END IF;
        END IF;
    end PROCESS;
    
    PC_COUNT <= current_pc;

end arch;