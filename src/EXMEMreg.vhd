
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity EXMEMreg is
    Port ( clk              : in STD_LOGIC;
			  ex_regWrite      : in  STD_LOGIC;
           mem_regWrite     : out  STD_LOGIC;
			  ex_memToReg      : in STD_LOGIC;
			  mem_memToReg     : out STD_LOGIC;
           ex_branch        : in  STD_LOGIC;
           mem_branch       : out  STD_LOGIC;
           ex_zeroFlag      : in  STD_LOGIC;
           mem_zeroFlag     : out  STD_LOGIC;
			  ex_jump          : in  STD_LOGIC;
			  mem_jump    		 : out  STD_LOGIC;
           ex_concatAddr    : in  STD_LOGIC_VECTOR (31 downto 0);
           mem_concatAddr   : out  STD_LOGIC_VECTOR (31 downto 0);
           ex_branchAddr    : in  STD_LOGIC_VECTOR (31 downto 0);
           mem_branchAddr   : out  STD_LOGIC_VECTOR (31 downto 0);
           ex_ALUresult     : in  STD_LOGIC_VECTOR (31 downto 0);
           mem_ALUresult    : out  STD_LOGIC_VECTOR (31 downto 0);
           ex_regData2      : in  STD_LOGIC_VECTOR (31 downto 0);
           mem_regData2     : out  STD_LOGIC_VECTOR (31 downto 0);
           ex_writeBackReg  : in  STD_LOGIC_VECTOR (4 downto 0);
           mem_writeBackReg : out  STD_LOGIC_VECTOR (4 downto 0);
			  ex_RD 				 : in  STD_LOGIC_VECTOR (4 downto 0);
			  mem_RD 			 : out  STD_LOGIC_VECTOR (4 downto 0));
end EXMEMreg;

architecture Behavioral of EXMEMreg is

begin
	RisingEdge : process(clk)
	begin
					
		if rising_edge(clk) then

			  mem_regWrite 		<= ex_regWrite;
			  mem_memToReg       <= ex_memToReg;
			  mem_branch 			<= ex_branch;
			  mem_zeroFlag 		<= ex_zeroFlag;
			  mem_concatAddr 		<= ex_concatAddr;
			  mem_branchAddr 		<= ex_branchAddr;
			  mem_ALUresult 		<= ex_ALUresult;
			  mem_regData2 		<= ex_regData2;
			  mem_writeBackReg   <= ex_writeBackReg;
			  mem_jump 				<= ex_jump;
			  mem_RD             <= ex_RD;
							
		end if;
	end process RisingEdge;

end Behavioral;

