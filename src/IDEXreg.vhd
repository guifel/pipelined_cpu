
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IDEXreg is
		 Port ( clk             : in STD_LOGIC;
				  id_regWrite 		: in  STD_LOGIC;
				  ex_regWrite 		: out  STD_LOGIC;
				  id_branch 		: in  STD_LOGIC;
				  ex_branch 		: out  STD_LOGIC;
				  id_regDst 		: in  STD_LOGIC;
				  ex_regDst 		: out  STD_LOGIC;
				  id_ALUOp 			: in  STD_LOGIC_VECTOR (1 downto 0);
				  ex_ALUOp 			: out  STD_LOGIC_VECTOR (1 downto 0);
				  id_ALUSrc		   : in  STD_LOGIC;
				  ex_ALUSrc 		: out  STD_LOGIC;
				  id_counterReg 	: in  STD_LOGIC_VECTOR (31 downto 0);
				  ex_counterReg 	: out  STD_LOGIC_VECTOR (31 downto 0);
				  id_regData1	   : in  STD_LOGIC_VECTOR (31 downto 0);
				  ex_regData1 		: out  STD_LOGIC_VECTOR (31 downto 0);
				  id_regData2 		: in  STD_LOGIC_VECTOR (31 downto 0);
				  ex_regData2     : out  STD_LOGIC_VECTOR (31 downto 0);
				  id_extendedAddr : in  STD_LOGIC_VECTOR (31 downto 0);
				  ex_extendedAddr : out  STD_LOGIC_VECTOR (31 downto 0);
				  id_RS				: in  STD_LOGIC_VECTOR (4 downto 0);
				  ex_RS				: out  STD_LOGIC_VECTOR (4 downto 0);
				  id_RT 				: in  STD_LOGIC_VECTOR (4 downto 0);
				  ex_RT 				: out  STD_LOGIC_VECTOR (4 downto 0);
				  id_RD 				: in  STD_LOGIC_VECTOR (4 downto 0);
				  ex_RD 				: out  STD_LOGIC_VECTOR (4 downto 0);
				  id_jumpAddr   	: in  STD_LOGIC_VECTOR (25 downto 0);
				  ex_jumpAddr  	: out  STD_LOGIC_VECTOR (25 downto 0);
				  id_memRead	   : in  STD_LOGIC;
				  ex_memRead 		: out  STD_LOGIC;
				  id_memToReg		: in  STD_LOGIC;
				  ex_memToReg 		: out  STD_LOGIC;
				  id_memWrite		: in  STD_LOGIC;
				  ex_memWrite 		: out  STD_LOGIC;
				  id_jump		   : in  STD_LOGIC;
				  ex_jump 		   : out  STD_LOGIC;
				  flush           : in  STD_LOGIC
				  );
end IDEXreg;

architecture Behavioral of IDEXreg is
begin
	RisingEdge : process(clk,flush)
	begin
			if flush = '1' then
			
				
				  ex_regWrite     <= '0'; 		
				  ex_branch       <= '0'; 		
				  ex_regDst       <= '0'; 		
				  ex_ALUOp 			<= (others => '0'); 			
				  ex_ALUSrc		   <= '0'; 		
				  ex_counterReg 	<= (others => '0'); 	
				  ex_regData1	   <= (others => '0'); 		
				  ex_regData2 		<= (others => '0');     
				  ex_extendedAddr <= (others => '0'); 
				  ex_RT 				<= (others => '0'); 				
				  ex_RD 				<= (others => '0');
				  ex_RS				<= (others => '0');
				  ex_jumpAddr     <= (others => '0');				  	   
				  ex_memRead 		<= '0';
				  ex_memToReg 		<= '0';
				  ex_memWrite 		<= '0';
				  ex_jump 		   <= '0';
				  
			elsif rising_edge(clk) then
				  ex_regWrite     <= id_regWrite; 		
				  ex_branch       <= id_branch; 		
				  ex_regDst       <= id_regDst; 		
				  ex_ALUOp 			<= id_ALUOp; 			
				  ex_ALUSrc		   <= id_ALUSrc; 		
				  ex_counterReg 	<= id_counterReg; 	
				  ex_regData1	   <= id_regData1; 		
				  ex_regData2 		<= id_regData2;     
				  ex_extendedAddr <= id_extendedAddr; 
				  ex_RT 				<= id_RT; 				
				  ex_RD 				<= id_RD;
				  ex_RS				<= id_RS;
				  ex_jumpAddr     <= id_jumpAddr;				  	   
				  ex_memRead 		<= id_memRead;
				  ex_memToReg 		<= id_memToReg;
				  ex_memWrite 		<= id_memWrite;
				  ex_jump 		   <= id_jump;
			end if;
	end process RisingEdge;

end Behavioral;

