
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity wallace8 is
	Port ( A : in  UNSIGNED (7 downto 0);
           B : in  UNSIGNED (7 downto 0);
           prod : out  UNSIGNED (15 downto 0));
end wallace8;

architecture arch of wallace8 is

component full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

component half_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

signal p0, p1, p2, p3, p4, p5, p6, p7:UNSIGNED (7 downto 0);
signal k01,k02,k03,k04,k05,k06,k07,k08,k09,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,k20,k21,k22,k23,k24,k25,k26,k27,k28,k29,k30,k31,k32,k33,k34,k35,k36,k37,k38,k39,k40,k41,k42,k43,k44,k45,k46,k47,k48,k49,k50,k51,k52,k53,k54,k55,k56,k57,k58,k59,k60,k61,k62,k63,k64,k65,k66,k67,k68:std_logic;
signal c01,c02,c03,c04,c05,c06,c07,c08,c09,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37,c38,c39,c40,c41,c42,c43,c44,c45,c46,c47,c48,c49,c50,c51,c52,c53,c54,c55,c56,c57,c58,c59,c60,c61,c62,c63,c64,c65,c66,c67,c68:std_logic;
begin

process(A,B)
begin
    for i in 0 to 7 loop -- Cria os produtos parciais 
        p0(i) <= A(i) and B(0); 
        p1(i) <= A(i) and B(1); 
        p2(i) <= A(i) and B(2); 
        p3(i) <= A(i) and B(3);
        p4(i) <= A(i) and B(4);
        p5(i) <= A(i) and B(5);
        p6(i) <= A(i) and B(6);
        p7(i) <= A(i) and B(7);

		  
    end loop;       
end process;


--Primeiro Estagio

ha00: half_adder port map(p0(1),p1(0),k01,c01);
fa00: full_adder port map(p2(0),p0(2),p1(1),k02,c02);
fa01: full_adder port map(p3(0),p2(1),p1(2),k03,c03);
fa02: full_adder port map(p4(0),p3(1),p2(2),k04,c04);
ha01: half_adder port map(p1(3),p0(4),k05,c05);
fa03: full_adder port map(p5(0),p4(1),p3(2),k06,c06);
fa04: full_adder port map(p2(3),p1(4),p0(5),k07,c07);
fa05: full_adder port map(p6(0),p5(1),p4(2),k08,c08);
fa06: full_adder port map(p3(3),p2(4),p1(5),k09,c09);
fa07: full_adder port map(p7(0),p6(1),p5(2),k10,c10);
fa08: full_adder port map(p4(3),p3(4),p2(5),k11,c11);
ha02: half_adder port map(p1(6),p0(7),k12,c12);
fa09: full_adder port map(p7(1),p6(2),p5(3),k13,c13);
fa90: full_adder port map(p4(4),p3(5),p2(6),k14,c14);
fa31: full_adder port map(p7(2),p6(3),p5(4),k15,c15);
fa32: full_adder port map(p4(5),p3(6),p2(7),k16,c16);
fa33: full_adder port map(p7(3),p6(4),p5(5),k17,c17);
ha03: half_adder port map(p4(6),p3(7),k18,c18);
fa34: full_adder port map(p7(4),p6(5),p5(6),k19,c19);
fa35: full_adder port map(p7(5),p6(6),p5(7),k20,c20);
ha04: half_adder port map(p7(6),p6(7),k21,c21);

--Segundo Estagio
ha10: half_adder port map(k02,c01,k22,c22);
fa10: full_adder port map(p0(3),c02,k03,k23,c23);
fa11: full_adder port map(k04,k05,c03,k24,c24);
fa12: full_adder port map(k06,k07,c04,k25,c25);
fa13: full_adder port map(k08,k09,p0(6),k26,c26);
ha11: half_adder port map(c06,c07,k27,c27);
fa14: full_adder port map(k10,k11,k12,k28,c28);
ha12: half_adder port map(c08,c09,k29,c29);
fa15: full_adder port map(k13,k14,p1(7),k30,c30);
fa16: full_adder port map(c10,c11,c12,k31,c31);
fa17: full_adder port map(k15,k16,c13,k32,c32);
fa18: full_adder port map(k17,k18,c15,k33,c33);
fa19: full_adder port map(k19,c17,c18,k34,c34);
ha13: half_adder port map(k20,c19,k35,c35);
ha14: half_adder port map(k21,c20,k36,c36);

--Terceiro Estagio
ha40: half_adder port map(k23,c22,k37,c37);
ha41: half_adder port map(c23,k24,k38,c38);
fa40: full_adder port map(c24,k25,c05,k39,c39);
fa41: full_adder port map(c25,k26,k27,k40,c40);
fa42: full_adder port map(c26,c27,k28,k41,c41);
fa43: full_adder port map(c28,c29,k30,k42,c42);
fa44: full_adder port map(c30,c31,k32,k43,c43);
fa45: full_adder port map(c32,c16,k33,k44,c44);
fa46: full_adder port map(c33,p4(7),k34,k45,c45);
ha42: half_adder port map(k35,c34,k46,c46);
ha43: half_adder port map(c35,k36,k47,c47);
fa47: full_adder port map(p7(7),c21,c36,k48,c48);

--Quarto Estagio
ha50: half_adder port map(c37,k38,k49,c49);
fa50: full_adder port map(k39,c38,c49,k50,c50);
fa51: full_adder port map(k40,c39,c50,k51,c51);
fa52: full_adder port map(c40,k41,k29,k52,c52);
fa53: full_adder port map(c41,k31,k42,k53,c53);
fa54: full_adder port map(c14,c42,k43,k54,c54);
fa55: full_adder port map(k44,c43,c54,k55,c55);
fa56: full_adder port map(c44,k45,c55,k56,c56);
fa57: full_adder port map(k46,c45,c56,k57,c57);
fa58: full_adder port map(c46,k47,c57,k58,c58);
fa59: full_adder port map(k48,c47,c58,k59,c59);

--Quinto Estagio
ha70: half_adder port map(c51,k52,k60,c60);
fa70: full_adder port map(c52,k53,c60,k61,c61);
fa71: full_adder port map(c53,k54,c61,k62,c62);
ha71: half_adder port map(k55,c62,k63,c63);
ha72: half_adder port map(k56,c63,k64,c64);
ha73: half_adder port map(k57,c64,k65,c65);
ha74: half_adder port map(k58,c65,k66,c66);
ha75: half_adder port map(k59,c66,k67,c67);
fa81: full_adder port map(c48,c59,c67,k68,c68);


prod(0) <= p0(0);
prod(1) <= k01;
prod(2) <= k22;
prod(3) <= k37;
prod(4) <= k49;
prod(5) <= k50;
prod(6) <= k51;
prod(7) <= k60;
prod(8) <= k61;
prod(9) <= k62;
prod(10) <= k63;
prod(11) <= k64;
prod(12) <= k65;
prod(13) <= k66;
prod(14) <= k67;
prod(15) <= k68 or c68;

end arch;

