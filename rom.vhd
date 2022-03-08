
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
    addr : in std_logic_vector(addr_bits-1 downto 0);
    data : out std_logic_vector(data_width-1 downto 0)
);
end ROM;

architecture ROMarch of ROM is

    type rom_type is array (0 to addr_width-1) of std_logic_vector(data_width-1 downto 0);
    
    signal ROM1 : rom_type := (
                            "00000001", -- OPCODE: 0001 - A + B 
                            "00110010", -- VALOR DE A
                            "00001100", -- VALOR DE B
                            "00000011", -- OPCODE: 0011 - A ++
                            "00011110", -- VALOR DE A
                            "00001001", -- OPCODE: 1001 - A * B
                            "00110010", -- VALOR DE A
                            "00001100", -- VALOR DE B
                            "00001010", -- OPCODE: 1010 - SQRT(A)
                            "11000100", -- VALOR DE A
                            "00000010", -- OPCODE: 0010 - A - B
                            "00110010", -- VALOR DE A
                            "00001100", -- VALOR DE B
                            "00000100", -- OPCODE: 0100 - A--
                            "00110010", -- VALOR DE A
                            "00001111"  -- OPCODE: 1111 - HALT+
									 
        );
begin
    data <= ROM1(to_integer(unsigned(addr)));
end ROMarch;
