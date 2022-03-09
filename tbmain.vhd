library ieee;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;


entity tbmain is
GENERIC(X: INTEGER:= 8);
end tbmain;

architecture arch of tbmain is

    signal reset, clk, inicio, pronto, erro, Overflow, Zero, Negativo, prontoUla: STD_LOGIC;
    signal Saida1, Saida2, A, B: STD_LOGIC_VECTOR(X-1 downto 0);
	SIGNAL estado: STD_LOGIC_VECTOR(2 downto 0);
	 signal opcode : STD_LOGIC_VECTOR(3 downto 0);
	 
begin
    UUT : entity work.main port map (reset, clk, inicio, pronto, erro, estado, Saida1, Saida2, A, B, opcode, Negativo, Zero, Overflow);
    inicio <= '1';
	reset <= '0';
	 
	 
    tb1 : process
    constant periodo: time := 30 ns; 
    begin
        wait for periodo/2;
        clk <= '1';
        wait for periodo/2; 
        clk <= '0';
    end process;

end arch;
