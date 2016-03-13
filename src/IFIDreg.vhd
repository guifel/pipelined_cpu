
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity IFIDreg is
    Port ( clk             : in STD_LOGIC;
			  IFIDregStall    : in STD_LOGIC;
			  if_instruction  : in  STD_LOGIC_VECTOR (31 downto 0);
           if_counterReg   : in  STD_LOGIC_VECTOR (31 downto 0);
           id_instruction  : out  STD_LOGIC_VECTOR (31 downto 0);
           id_counterReg   : out  STD_LOGIC_VECTOR (31 downto 0);
			  flush           : in STD_LOGIC
			 );
end IFIDreg;

architecture Behavioral of IFIDreg is
begin
	RisingEdge : process(clk, IFIDregStall,flush)
	begin
		if flush = '1' then
			id_instruction <= (others => '0');
			id_counterReg <=  (others => '0');			
		elsif rising_edge(clk) and IFIDregStall = '0' then		
	   	id_instruction <= if_instruction;
			id_counterReg <= if_counterReg;
		end if;
	end process RisingEdge;

end Behavioral;

