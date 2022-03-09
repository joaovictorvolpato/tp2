library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitabit_or is
GENERIC(N: natural:= 8);


port(A, B: in unsigned(N-1 downto 0);
    S: out unsigned(N-1 downto 0));
end bitabit_or;

architecture circ1 of bitabit_or is


begin
 

		  
	GEN_OR: for i in 0 to N-1 generate 
		OR_i: S(i) <= A(i) or B(i);
	end generate;



end circ1;
