
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Forwarding_unit is
    Port ( mem_regWrite : in  STD_LOGIC;
           wb_regWrite : in  STD_LOGIC;
           ex_RT : in  STD_LOGIC_VECTOR (4 downto 0);
           ex_RS : in  STD_LOGIC_VECTOR (4 downto 0);
           mem_RD : in  STD_LOGIC_VECTOR (4 downto 0);
           wb_RD : in  STD_LOGIC_VECTOR (4 downto 0);
           forwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           forwardB : out  STD_LOGIC_VECTOR (1 downto 0));
end Forwarding_unit;

architecture Behavioral of Forwarding_unit is

begin

	UpdateOutputs : process (mem_regWrite, wb_regWrite, ex_RT, ex_RS, mem_RD, wb_RD)
	begin
	
		if mem_regWrite = '1' and mem_RD /= "00000" and mem_RD = ex_RS then
			forwardA <= "10";
		elsif wb_regWrite = '1' and wb_RD /= "00000" and not(mem_regWrite ='1' and mem_RD /= "00000" and mem_RD = ex_RS) and wb_RD = ex_RS then
			forwardA <= "01";
		else
			forwardA <= "00";
		end if;
		
		
		
		if mem_regWrite ='1' and mem_RD /= "00000" and mem_RD = ex_RT then
			forwardB <= "10";
		elsif wb_regWrite = '1' and wb_RD /= "00000" and not(mem_regWrite ='1' and mem_RD /= "00000" and mem_RD = ex_RT) and wb_RD = ex_RT then
			forwardB <= "01";
		else
			forwardB <= "00";
		end if; 

	end process UpdateOutputs;	  	
end Behavioral;

