library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;

entity adder16 is
port (A,B: in SIGNED(15 downto 0);
    S: out SIGNED(15 downto 0);
    overflow: out std_logic);
end adder16;

architecture adder16arch of adder16 is

    signal C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14: std_logic;
    
    component half_adder is
        port (A: in std_logic;
        B: in std_logic;
        Sum: out std_logic;
        Cout: out std_logic);
        end component;
    component full_adder is
        port (A: in std_logic;
        B: in std_logic;
        C: in std_logic;
        Sum: out std_logic;
        Cout: out std_logic);
        end component;
begin

    HA: half_adder port map (A => A(0),
                            B => B(0),
                            Sum => S(0),
                            Cout => C0);
    FA1: full_adder port map (A => A(1),
                            B => B(1),
                            C => C0,
                            Sum => S(1),
                            Cout => C1);
    FA2: full_adder port map (A => A(2),
                            B => B(2),
                            C => C1,
                            Sum => S(2),
                            Cout => C2);
    FA3: full_adder port map (A => A(3),
                            B => B(3),
                            C => C2,
                            Sum => S(3),
                            Cout => C3);
    FA4: full_adder port map (A => A(4),
                            B => B(4),
                            C => C3,
                            Sum => S(4),
                            Cout => C4);
    FA5: full_adder port map (A => A(5),
                            B => B(5),
                            C => C4,
                            Sum => S(5),
                            Cout => C5);
    FA6: full_adder port map (A => A(6),
                            B => B(6),
                            C => C5,
                            Sum => S(6),
                            Cout => C6);
    FA7: full_adder port map (A => A(7),
                            B => B(7),
                            C => C6,
                            Sum => S(7),
                            Cout => C7);
    FA8: full_adder port map (A => A(8),
                            B => B(8),
                            C => C7,
                            Sum => S(8),
                            Cout => C8);
    FA9: full_adder port map (A => A(9),
                            B => B(9),
                            C => C8,
                            Sum => S(9),
                            Cout => C9);
    FA10: full_adder port map (A => A(10),
                            B => B(10),
                            C => C9,
                            Sum => S(10),
                            Cout => C10);
    FA11: full_adder port map (A => A(11),
                            B => B(11),
                            C => C10,
                            Sum => S(11),
                            Cout => C11);
    FA12: full_adder port map (A => A(12),
                            B => B(12),
                            C => C11,
                            Sum => S(12),
                            Cout => C12);
    FA13: full_adder port map (A => A(13),
                            B => B(13),
                            C => C12,
                            Sum => S(13),
                            Cout => C13);
    FA14: full_adder port map (A => A(14),
                            B => B(14),
                            C => C13,
                            Sum => S(14),
                            Cout => C14);
    FA15: full_adder port map (A => A(15),
                            B => B(15),
                            C => C14,
                            Sum => S(15),
                            Cout => overflow);

end adder16arch;