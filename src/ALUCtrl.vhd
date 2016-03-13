library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.Constants.all;

entity ALUCtrl is
  port(
   in_Funct  : in  std_logic_vector(5 downto 0);
	in_ALUOp : in  std_logic_vector(1 downto 0);
	out_ALUOp : out std_logic_vector(3 downto 0)
	);
end ALUCtrl;

architecture Behaviour of ALUCtrl is
begin
	UpdateOutputsALUControl: process(in_Funct,in_ALUOp)
	begin
	   
		if in_ALUOp = "10" then
			case in_Funct is
				when FUNCT_ADD  => out_ALUOp <= ALU_ADD;			  
				when FUNCT_AND  => out_ALUOp <= ALU_AND;			  
				when FUNCT_OR   => out_ALUOp <= ALU_OR;
				when FUNCT_SLT  => out_ALUOp <= ALU_SLT;			  
				when FUNCT_SUB  => out_ALUOp <= ALU_SUB;			
				when others     => out_ALUOp <= "0000";
			end case;
		elsif in_ALUOp = "01" then
			out_ALUOp <= ALU_SUB;
		elsif in_ALUOp = "00" then
			out_ALUOp <= ALU_ADD;
		elsif in_ALUOp = "11" then
			out_ALUOp <= ALU_LUI;
		else out_ALUOp <= ALU_ADD;
			
		end if;
			 
	end process UpdateOutputsALUControl;

end Behaviour;



