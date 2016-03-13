
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MEMWBreg is
    Port ( clk          		: in STD_LOGIC;
			  mem_regWrite 		: in  STD_LOGIC;
           wb_regWrite 			: out  STD_LOGIC;
           mem_memToReg 		: in  STD_LOGIC;
           wb_memToReg       	: out  STD_LOGIC;
           mem_readedDataMem 	: in  STD_LOGIC_VECTOR (31 downto 0);
           wb_readedDataMem 	: out  STD_LOGIC_VECTOR (31 downto 0);
           mem_ALUResult 		: in  STD_LOGIC_VECTOR (31 downto 0);
           wb_ALUResult 		: out  STD_LOGIC_VECTOR (31 downto 0);
           mem_writeBackReg 	: in  STD_LOGIC_VECTOR (4 downto 0);
           wb_writeBackReg 	: out  STD_LOGIC_VECTOR (4 downto 0);
			  mem_RD 		      : in  STD_LOGIC_VECTOR (4 downto 0);
			  wb_RD 		     	   : out  STD_LOGIC_VECTOR (4 downto 0));
end MEMWBreg;

architecture Behavioral of MEMWBreg is

begin
RisingEdge : process(clk)
	begin
		if rising_edge(clk) then
           wb_regWrite      <= mem_regWrite;			
           wb_memToReg      <= mem_memToReg;      	
           wb_readedDataMem <= mem_readedDataMem;	
           wb_ALUResult     <= mem_ALUResult;		
           wb_writeBackReg  <= mem_writeBackReg;
			  wb_RD            <= mem_RD;
		end if;
	end process RisingEdge;

end Behavioral;

