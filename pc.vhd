library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;


entity pc is
generic(SIZE_MEM: INTEGER := 4);
port (enable, reset, clk: in STD_LOGIC;
	PcCount: out UNSIGNED(SIZE_MEM-1 downto 0));
end pc;

architecture arch of pc is
    signal current_pc: UNSIGNED(SIZE_MEM-1 downto 0) := (others => '0');
begin

    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            current_pc <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
				IF (enable = '1') then 
					current_pc <= UNSIGNED(unsigned(current_pc) + 1);
				END IF;
        END IF;
    end PROCESS;
    
    PcCount <= current_pc;

end arch;