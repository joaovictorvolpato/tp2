library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity raizquadrada is
    generic(N : integer := 8);
    port (
        Clk : in std_logic;    
        rst, ini : in std_logic;     
        input : in unsigned(N-1 downto 0);  
        done : out std_logic;  
        sq_root : out unsigned(N/2-1 downto 0) 
    );
end raizquadrada;

architecture arch of raizquadrada is

begin

    SQROOT_PROC : process(Clk,rst, ini)
        variable a : unsigned(N-1 downto 0); 
        variable left,right,r : unsigned(N/2+1 downto 0):=(others => '0'); 
        variable q : unsigned(N/2-1 downto 0) := (others => '0');  
        variable i : integer := 0;   
    begin
        if(rst = '1') then  
            done <= '0';
            sq_root <= (others => '0');
            i := 0;
            a := (others => '0');
            left := (others => '0');
            right := (others => '0');
            r := (others => '0');
            q := (others => '0');
        
		  elsif (clk'EVENT AND clk = '1' AND ini = '1') THEN
            
            if(i = 0) then  
                a := input;
                done <= '0';    
                i := i+1;   
            elsif(i < N/2) then 
                i := i+1;  
            end if;
        
            right := q & r(N/2+1) & '1';
            left := r(N/2-1 downto 0) & a(N-1 downto N-2);
            a := a(N-3 downto 0) & "00"; 
            if ( r(N/2+1) = '1') then  
                r := left + right;
            else
                r := left - right;
            end if;
            q := q(N/2-2 downto 0) & (not r(N/2+1));
            if(i = N/2) then    
                done <= '1';    
                i := 0; 
                sq_root <= q;  
                left := (others => '0');
                right := (others => '0');
                r := (others => '0');
                q := (others => '0');
            end if;
        end if;    
    end process;


end arch;