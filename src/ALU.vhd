library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Constants.all;

entity ALU is
  port (
    in_Operation : in  std_logic_vector(3 downto 0);
    in_A         : in  std_logic_vector(31 downto 0);
    in_B         : in  std_logic_vector(31 downto 0);
    out_Result   : out std_logic_vector(31 downto 0);
    out_Zero     : out std_logic
    );
end ALU;

architecture behavioral of ALU is

  signal Result : std_logic_vector(31 downto 0);
  
begin

  out_Result <= Result;
  out_Zero   <= '1' when (Result = x"00000000") else '0';

UpdateOutputs : process (in_Operation, in_A, in_B)
begin
	case in_Operation is
		when ALU_ADD => Result <= std_logic_vector(signed(in_A) + signed(in_B));
		when ALU_SUB => Result <= std_logic_vector(signed(in_A) - signed(in_B));
		when ALU_AND => Result <= in_A and in_B;
		when ALU_OR  => Result <= in_A or in_B;
		when ALU_LUI => Result <= in_B(15 downto 0) & "0000000000000000" ;
		when ALU_SLT =>
			if in_A < in_B then
				Result <= x"00000001";
			else
				Result <= x"00000000";
			end if;
		when others => Result <= (others => '0');
	end case;	
	
	end process UpdateOutputs;

end behavioral;
