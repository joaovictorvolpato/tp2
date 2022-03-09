library ieee;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;


entity tbmain is
GENERIC(X: INTEGER:= 8);
end tbmain;

architecture arch of tbmain is

    signal reset, clk, inicio, pronto, erro, calculando, Overflow, Zero, Negativo: STD_LOGIC;
    signal Saida1, Saida2: UNSIGNED(X-1 downto 0);
    
begin
    UUT : entity work.main port map (reset, clk, inicio, pronto, erro, calculando, Saida1, Saida2, Overflow, Zero, Negativo);
    inicio <= '1';
	 reset <= '0';
	 
    tb1 : process
    constant periodo: time := 20 ns; 
    begin
        wait for periodo/2;
        clk <= '1';
        wait for periodo/2; 
        clk <= '0';
    end process;

end arch;
