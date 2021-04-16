library IEEE;
use IEEE.std_logic_1164.all;  
USE ieee.numeric_std.ALL;

entity Main_Memory is
	 port(
		 CLK : in STD_LOGIC;
		 RST : in STD_LOGIC;
		 ADDRESS : in STD_LOGIC_VECTOR(15 downto 0);
		 DATA_DRAM_RD : out STD_LOGIC_VECTOR(31 downto 0);
		 DATA_DRAM_WR : in STD_LOGIC_VECTOR(31 downto 0);
		 RD_DRAM : in STD_LOGIC;
		 WR_DRAM : in STD_LOGIC;
		 READY_DRAM : out STD_LOGIC
	     );
end Main_Memory;

architecture Main_Memory_arch of Main_Memory is
type Main_Memory_ARRAY is array (0 to 63) of std_logic_vector (31 downto 0);
SIGNAL Main_Memory : Main_Memory_ARRAY :=  
(x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777",
x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777",
x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777",
x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777",
x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777",
x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777",
x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777",
x"00000001", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777");
begin	
	PROCESS (CLK, ADDRESS, RD_DRAM)  
	VARIABLE I : INTEGER RANGE 0 TO 11 := 0;
	begin 
			READY_DRAM <= '1';
			DATA_DRAM_RD <= Main_Memory(to_integer(unsigned(ADDRESS)));
			IF(RD_DRAM = '0' AND WR_DRAM = '1') THEN
					if rising_edge(CLK)	then
						I:= I + 1;
						if(I > 9) then
							READY_DRAM <= '1';
							Main_Memory(to_integer(unsigned(ADDRESS))) <= DATA_DRAM_WR;	 
							I := 0;
						end if;	   
					END IF;		   
			end if;			   
	END PROCESS;
end Main_Memory_arch;
