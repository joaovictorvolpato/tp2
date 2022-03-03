library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;
use ieee.signed_std.all;


entity somasub8bits is
port (A,B: in SIGNED(7 downto 0);
    Op: in std_logic;
    result: out SIGNED(7 downto 0);
    overflow: out std_logic);
end somasub8bits;

architecture somasub8bitsarch of somasub8bits is

    signal SO, SU, MUX: std_logic_vector(7 downto 0);
    
    component mux2_1x8 is
        port(sel: in std_logic;
        ent0, ent1: in std_logic_vector;
        saida: out std_logic_vector);
        end component;

begin
    
    SO <= A + B
    SU <= A - B  

    mux0: mux2_1x8 port map (sel <= OP,
                            ent0 <= SO, 
                            ent1 <= SU, 
                            saida <= result);

    overflow <= '1' if (A < 0 and B < 0 and result > 0) or (A > 0 and B > 0 and result < 0)


end somasub8arch;