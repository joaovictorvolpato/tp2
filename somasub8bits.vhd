library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity somasub8bits is



port(OP: in std_logic;
    A, B: in std_logic_vector(7 downto 0);
    S: out std_logic_vector(7 downto 0);
     OVF: out std_logic);
end somasub8bits;

architecture circ1 of somasub8bits is

signal sig_s, sig_b: std_logic_vector(7 downto 0);

begin


sig_b <= B when OP = '0' else
            -B;
            
sig_s <= A + sig_b;

S <= sig_s;

OVF  <= (A(7) and sig_b(7) and not sig_s(7)) or (not A(7) and not sig_b(7) and sig_s(7));




end circ1;
