
library IEEE;
use IEEE.std_logic_1164.all;

package Constants is

	  type T_MemoryArray is array(0 to (2**10)-1) of std_logic_vector (31 downto 0);


	  -- Operation codes

	  constant OP_R_TYPE : std_logic_vector(5 downto 0) := "000000";
	  constant OP_LW     : std_logic_vector(5 downto 0) := "100011";
	  constant OP_SW     : std_logic_vector(5 downto 0) := "101011";
	  constant OP_BEQ    : std_logic_vector(5 downto 0) := "000100";
	  constant OP_J      : std_logic_vector(5 downto 0) := "000010";
	  constant OP_ADDI   : std_logic_vector(5 downto 0) := "001000";
	  constant OP_LUI    : std_logic_vector(5 downto 0) := "001111";
			
	  

	  
	  -- ALU control codes
	 
	  constant ALU_AND : std_logic_vector(3 downto 0) := "0000";
	  constant ALU_OR  : std_logic_vector(3 downto 0) := "0001";
	  constant ALU_ADD : std_logic_vector(3 downto 0) := "0010";
	  constant ALU_SUB : std_logic_vector(3 downto 0) := "0110";
	  constant ALU_SLT : std_logic_vector(3 downto 0) := "0111";
	  constant ALU_LUI : std_logic_vector(3 downto 0) := "1000";
	  
	  -- Function codes
	 
	  constant FUNCT_ADD  : std_logic_vector(5 downto 0) := "100000";
	  constant FUNCT_SUB  : std_logic_vector(5 downto 0) := "100010";
	  constant FUNCT_AND  : std_logic_vector(5 downto 0) := "100100";
	  constant FUNCT_OR   : std_logic_vector(5 downto 0) := "100101";
	  constant FUNCT_SLT  : std_logic_vector(5 downto 0) := "101010";
  
 

end Constants;


