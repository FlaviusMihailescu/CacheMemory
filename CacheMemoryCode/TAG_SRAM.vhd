library IEEE;
use IEEE.std_logic_1164.all;  
USE ieee.numeric_std.ALL;

entity TAG_SRAM is
	 port(
	 	 TagSRAM_ValidBit : out STD_LOGIC;
	 	 TagSRAM_TAG : out STD_LOGIC_VECTOR(10 downto 0);
		 WR_TAG : in STD_LOGIC;
		 RD_TAG : in STD_LOGIC;
		 WR_DATA_TAG_SRAM : in STD_LOGIC_VECTOR(10 downto 0);
		 ADDR_INDEX : in STD_LOGIC_VECTOR(2 downto 0)
	     );
end TAG_SRAM;

architecture TAG_SRAM_arch of TAG_SRAM is
type TAG_SRAM_ARRAY is array (0 to 7) of std_logic_vector (11 downto 0);
constant TAG_SRAM : TAG_SRAM_ARRAY :=  (x"003", x"011", x"002", x"003", 
								x"004", x"005", x"006", x"FFF");
begin	 
	PROCESS(RD_TAG, ADDR_INDEX)	
	BEGIN							
		
		IF (RD_TAG = '1') THEN							
			TagSRAM_TAG <= TAG_SRAM(to_integer(unsigned(ADDR_INDEX)))(11 DOWNTO 1);
			TagSRAM_ValidBit <= TAG_SRAM(to_integer(unsigned(ADDR_INDEX)))(0);			
		END IF;	
	END PROCESS;


end TAG_SRAM_arch;
