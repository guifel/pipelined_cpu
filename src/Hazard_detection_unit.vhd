
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hazard_detection_unit is
    Port ( RT : in  STD_LOGIC_VECTOR (4 downto 0);
           RS : in  STD_LOGIC_VECTOR (4 downto 0);
           ex_RT : in  STD_LOGIC_VECTOR (4 downto 0);
           ex_memRead : in  STD_LOGIC;
           PCStall : out  STD_LOGIC;
           IFIDregStall : out  STD_LOGIC;
           ControlStall : out  STD_LOGIC);
end Hazard_detection_unit;

architecture Behavioral of Hazard_detection_unit is


begin

	UpdateOutputs : process (RT, RS, ex_RT, ex_memRead)
	begin
	
		if ex_memRead = '1' and (ex_RT = RS or ex_RT = RT) then
			PCStall <= '1';
			IFIDregStall <= '1';
			ControlStall <= '1';
		else
			PCStall <= '0';
			IFIDregStall <= '0';
			ControlStall <= '0';
		end if;
		

	end process UpdateOutputs;



end Behavioral;

