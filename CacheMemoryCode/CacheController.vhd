library IEEE;
use IEEE.std_logic_1164.all; 
USE ieee.numeric_std.ALL;

entity CacheController is
	port(	
		 ADDR_CPU : in STD_LOGIC_VECTOR(15 downto 0);
		 CLK : in STD_LOGIC;
		 RST : in STD_LOGIC;
		 RD_CPU : in STD_LOGIC;
		 WR_CPU : in STD_LOGIC;
		 DATA_CPU : INOUT STD_LOGIC_VECTOR(7 downto 0); ----------------
		 DATA_CPU_WR : IN STD_LOGIC_VECTOR(7 downto 0); 
		 cacheL1_HIT : OUT STD_LOGIC;
		 cacheL1_MISS : OUT STD_LOGIC;
		 
		 ADDR_INDEX : out STD_LOGIC_VECTOR(2 DOWNTO 0);	 
		 
		 SRAM_CACHE_LINE : in STD_LOGIC_VECTOR(31 downto 0);
		 RD_DRAM : out STD_LOGIC;
		 WR_DRAM : out STD_LOGIC;								
		 WR_DATA_SRAM : out STD_LOGIC_VECTOR(31 downto 0);

		 TagSRAM_ValidBit : in STD_LOGIC;
		 TagSRAM_TAG : in STD_LOGIC_VECTOR(10 downto 0);
		 WR_TAG : out STD_LOGIC;
		 RD_TAG : out STD_LOGIC;
		 WR_DATA_TAG_SRAM : out STD_LOGIC_VECTOR(10 downto 0);
		 
		 ADDRESS : out STD_LOGIC_VECTOR(15 downto 0);
		 DATA_DRAM_RD : in STD_LOGIC_VECTOR(31 downto 0);
		 DATA_DRAM_WR : OUT STD_LOGIC_VECTOR(31 downto 0);
		 RD_SRAM : out STD_LOGIC;
		 WR_SRAM : out STD_LOGIC;
	     READY_DRAM : in STD_LOGIC
		 );												 
end CacheController;

architecture CacheController_arch of CacheController is
type state is (s0, s1, s2);
signal pr_state, next_state: state;

begin
	process(clk)
	begin
		if rising_edge(CLK)	then
			pr_state <= next_state;
		end if;
	end process;
	
PROCESS(ADDR_CPU, RD_CPU, TagSRAM_TAG, TagSRAM_ValidBit, SRAM_CACHE_LINE, DATA_DRAM_RD,pr_state, DATA_CPU_WR,READY_DRAM)	  
VARIABLE I : INTEGER RANGE 0 TO 31;
VARIABLE J : INTEGER RANGE 0 TO 31;
BEGIN	
	CASE pr_state is
		when s0 =>	 --READ DATES ON SRAM
			cacheL1_HIT <=	'0';
			cacheL1_MISS <=	'0';
			IF(RD_CPU='1')THEN  
				RD_TAG <= '1';
				WR_TAG <= '0';
				WR_SRAM <= '0';	   
				
				I := (to_integer(unsigned(ADDR_CPU(1 DOWNTO 0)))*8+7) ;
				J := (to_integer(unsigned(ADDR_CPU(1 DOWNTO 0)))*8);
				
				
				next_state <= s1;
			elsif(WR_CPU = '1') then		  
				RD_TAG <= '0';
				WR_TAG <= '1';	
				RD_SRAM <= '0';
				WR_SRAM <= '1';	
				RD_DRAM <= '0';
				WR_DRAM <= '1';
				DATA_CPU <= "ZZZZZZZZ";	 
				
				--WR_DATA_SRAM <= SRAM_CACHE_LINE;	
				DATA_DRAM_WR <= DATA_DRAM_RD;
				
				next_state <= s2;
			end if;

		when s1 =>   --READ DATES ON MainMemory 
			IF(ADDR_CPU(15 DOWNTO 5) = TagSRAM_TAG AND TagSRAM_ValidBit= '1') THEN    
				cacheL1_MISS <= '0';
				cacheL1_HIT <= '1';
				RD_SRAM <= '1';
				RD_DRAM <= '0';
				DATA_CPU <= SRAM_CACHE_LINE(I DOWNTO J);-- alegem byte-ul din linia de cache prin intermediul offsetului
				
				if(RD_CPU = '0') THEN -- SE STA IN S1 CAT TIMP EXISTA SEMNAL DE READ
					next_state <= s0;
				END IF;
			ELSE				--adresa cautata nu se afla in SRAM;
				ADDRESS <= ADDR_CPU;								
				cacheL1_HIT <= '0';		
				cacheL1_MISS <=	'1';								
				RD_SRAM <= '0';
				RD_DRAM <= '1';
				WR_SRAM <= '1';
				IF(READY_DRAM = '1') THEN
					DATA_CPU <= DATA_DRAM_RD(I DOWNTO J);
					WR_DATA_SRAM <= DATA_DRAM_RD;
				ELSE
					DATA_CPU <= "ZZZZZZZZ";
				END IF;
				
				if(RD_CPU = '0') THEn
					next_state <= s0;
				END IF;
			END IF;			   
		when s2 =>	-- WRITE DATES		
			cacheL1_HIT <=	'0';
			cacheL1_MISS <=	'1';
			WR_DATA_SRAM(I DOWNTO J) <= DATA_CPU_WR; 
			
			DATA_DRAM_WR(I DOWNTO J) <= DATA_CPU_WR;   
			
			if(WR_CPU = '0') THEN  --SE STA IN S2 CAT TIMP EXISTA SEMNAL DE WRITE
				next_state <= s0;
			END IF;
		
		WHEN OTHERS =>
	END CASE;	
END PROCESS;	

end CacheController_arch;
