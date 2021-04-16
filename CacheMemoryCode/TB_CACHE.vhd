library IEEE;
use IEEE.std_logic_1164.all;  

entity TB_CACHE is
end TB_CACHE;


architecture TB_CACHE_arch of TB_CACHE is  

component CacheController is
	port(	
		 ADDR_CPU : in STD_LOGIC_VECTOR(15 downto 0);
		 CLK : in STD_LOGIC;
		 RST : in STD_LOGIC;
		 RD_CPU : in STD_LOGIC;
		 WR_CPU : in STD_LOGIC;
		 DATA_CPU : INOUT STD_LOGIC_VECTOR(7 downto 0); -------------  
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
end component;

component SRAM is
	port(						
		 SRAM_CACHE_LINE : out STD_LOGIC_VECTOR(31 downto 0);
		 RD_SRAM : in STD_LOGIC;
		 WR_SRAM : in STD_LOGIC;
		 WR_DATA_SRAM : in STD_LOGIC_VECTOR(31 downto 0);
		 ADDR_INDEX : in STD_LOGIC_VECTOR(2 downto 0)
	     );
end component;

component TAG_SRAM is
	 port(
	 	 TagSRAM_ValidBit : out STD_LOGIC;
	 	 TagSRAM_TAG : out STD_LOGIC_VECTOR(10 downto 0);
		 WR_TAG : in STD_LOGIC;
		 RD_TAG : in STD_LOGIC;
		 WR_DATA_TAG_SRAM : in STD_LOGIC_VECTOR(10 downto 0);
		  ADDR_INDEX : in STD_LOGIC_VECTOR(2 downto 0)
	     );
end component;

component Main_Memory is
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
end component;

signal ADDR_CPU : STD_LOGIC_VECTOR(15 downto 0);
signal CLK : STD_LOGIC;
signal RST : STD_LOGIC;
signal RD_CPU : STD_LOGIC;
signal WR_CPU : STD_LOGIC;
signal DATA_CPU : STD_LOGIC_VECTOR(7 downto 0);	
SIGNAL DATA_CPU_WR : STD_LOGIC_VECTOR(7 downto 0);
signal cacheL1_HIT : STD_LOGIC := '0';
signal cacheL1_MISS : STD_LOGIC := '0';
		 
signal ADDR_INDEX : STD_LOGIC_VECTOR(2 DOWNTO 0);	 
		 
signal SRAM_CACHE_LINE : STD_LOGIC_VECTOR(31 downto 0);
signal RD_DRAM : STD_LOGIC;
signal WR_DRAM : STD_LOGIC;								
signal WR_DATA_SRAM : STD_LOGIC_VECTOR(31 downto 0);

signal TagSRAM_ValidBit : STD_LOGIC;
signal TagSRAM_TAG : STD_LOGIC_VECTOR(10 downto 0);
signal WR_TAG : STD_LOGIC;
signal RD_TAG : STD_LOGIC;
signal WR_DATA_TAG_SRAM : STD_LOGIC_VECTOR(10 downto 0);
		 
signal ADDRESS : STD_LOGIC_VECTOR(15 downto 0);	 ------------------------------------------------------------
signal DATA_DRAM_RD : STD_LOGIC_VECTOR(31 downto 0);																	
signal DATA_DRAM_WR : STD_LOGIC_VECTOR(31 downto 0);
signal RD_SRAM : STD_LOGIC;
signal WR_SRAM : STD_LOGIC;
signal READY_DRAM : STD_LOGIC; 


begin
	
	TEST1: TAG_SRAM PORT MAP(
		TagSRAM_ValidBit => TagSRAM_ValidBit,
		TagSRAM_TAG => TagSram_TAG,
		WR_TAG => WR_TAG,
		RD_TAG => RD_TAG,
		WR_DATA_TAG_SRAM => WR_DATA_TAG_SRAM,	  
		ADDR_INDEX => ADDR_CPU(4 DOWNTO 2)
	);
	
	TEST2: SRAM PORT MAP(  
		SRAM_CACHE_LINE => SRAM_CACHE_LINE,
		RD_SRAM => RD_SRAM,
		WR_SRAM => WR_SRAM,
		WR_DATA_SRAM => WR_DATA_SRAM,
		ADDR_INDEX => ADDR_CPU(4 DOWNTO 2)
	);			 
	
	TEST3: CacheController PORT MAP(
		ADDR_CPU => ADDR_CPU,
		CLK => CLK,
		RST => RST,
		RD_CPU => RD_CPU,
		WR_CPU => WR_CPU,
		DATA_CPU => DATA_CPU,
		DATA_CPU_WR => DATA_CPU_WR,
		cacheL1_HIT => cacheL1_HIT,
		cacheL1_MISS => cacheL1_MISS,
				 
		ADDR_INDEX => ADDR_INDEX,
				 
		SRAM_CACHE_LINE => SRAM_CACHE_LINE,
		RD_DRAM => RD_DRAM,
		WR_DRAM => WR_DRAM,
		WR_DATA_SRAM => WR_DATA_SRAM,
		
		TagSRAM_ValidBit => TagSRAM_ValidBit,
		TagSRAM_TAG => TagSRAM_TAG,
		WR_TAG => WR_TAG,
		RD_TAG => RD_TAG,
		WR_DATA_TAG_SRAM => WR_DATA_TAG_SRAM,
				 
		ADDRESS => ADDRESS,
		DATA_DRAM_RD => DATA_DRAM_RD ,	 
		DATA_DRAM_WR => DATA_DRAM_WR, 
		RD_SRAM => RD_SRAM,
		WR_SRAM => WR_SRAM,
		READY_DRAM => READY_DRAM	
	);			 
	
	TEST4: Main_Memory PORT MAP(
		CLK => CLK,
		 RST => RST,
		 ADDRESS => ADDRESS,
		 DATA_DRAM_RD => DATA_DRAM_RD ,
		 DATA_DRAM_WR => DATA_DRAM_WR,
		 RD_DRAM => RD_DRAM,
		 WR_DRAM => WR_DRAM,
		 READY_DRAM => READY_DRAM
	
	);
	
	CACHE : PROCESS
	BEGIN
		RD_CPU <= '1';
		WR_CPU <= '0';
		ADDR_CPU <= "0000000000100001";	 	
		ADDR_INDEX <= ADDR_CPU(4 DOWNTO 2);
		WAIT FOR 20 NS;				   		
		
		ADDR_CPU <= "0000000000011100";
		ADDR_INDEX <= ADDR_CPU(4 DOWNTO 2);	
		WAIT FOR 20 NS;				   		
		
		ADDR_CPU <= "0000000000010001";
		ADDR_INDEX <= ADDR_CPU(4 DOWNTO 2);		
		WAIT FOR 20 ns;					    
		
		RD_CPU <= '0';
		WR_CPU <= '1';
		DATA_CPU_WR <= X"23";
		
		WAIT FOR 50 NS;
		
		RD_CPU <= '0';
		WR_CPU <= '0';
		
		WAIT ;
		
	END PROCESS;
	
	
end TB_CACHE_arch;
