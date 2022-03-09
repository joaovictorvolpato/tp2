
--ROM.vhd


-- Functionality:
  -- stores OPCODE, A and B values

-- ports:
    -- addr       : input for addres
    -- data       : data of addr
    -- addr_width : total number of data to store
    -- addr_bits  : bits to store elements 
    -- data_width : number of bits in each elements
    
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
    generic(
        addr_width : integer := 16; -- store 16 elements
        addr_bits  : integer := 4; -- required bits to store 16 elements
        data_width : integer := 8 -- each element has 7-bits
        );
port(
    addr : in UNSIGNED(addr_bits-1 downto 0);
    data : out UNSIGNED(data_width-1 downto 0)
);
end ROM;

architecture ROMarch of ROM is

    type rom_type is array (0 to addr_width-1) of UNSIGNED(data_width-1 downto 0);
	
	-- 0000 Nada
	-- 0001 A + B
	-- 0010 A - B
	-- 0011 A++
	-- 0100 A--
	-- 0101 not(A)
	-- 0110 (A and B) bit a bit
	-- 0111 (A or B) bit a bit
	-- 1000 (A xor B) bit a bit
	-- 1001 A * B
	-- 1010 A raiz B
	-- 1110 No operation
	-- 1111 Halt

    
    signal ROM1 : rom_type := (
									 "00000110", -- OPCODE: 0110 - And
                            "00000000", -- VALOR DE A
                            "00000000", -- VALOR DE B
                            "00000011", -- OPCODE: 0011 - A ++
                            "01111111", -- VALOR DE A
                            "00000111", -- OPCODE: 0111 - Or
                            "00101011", -- VALOR DE A
                            "00001110", -- VALOR DE B
                            "00000101", -- OPCODE: 0101 - not(A)
                            "11000100", -- VALOR DE A
                            "00001000", -- OPCODE: 0010 - Xor
                            "00110010", -- VALOR DE A
                            "00001100", -- VALOR DE B
                            "00000100", -- OPCODE: 0100 - A--
                            "10000000", -- VALOR DE A
									 "00001111" -- OPCODE: 1111 - HALT+
        );
		  
begin
    data <= ROM1(to_integer(unsigned(addr)));
end ROMarch;
