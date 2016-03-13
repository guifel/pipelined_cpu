library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.Constants.all;

entity Controller is
  port (
	 in_reset         : in std_logic;
	 processor_enable : in std_logic;
    in_Opcode        : in  std_logic_vector(5 downto 0);
	 ControlStall     : in std_logic;
	 CtrlHazard      : in std_logic;
    out_RegDst       : out std_logic;
    out_Branch       : out std_logic;
    out_MemRead      : out std_logic;
    out_MemtoReg     : out std_logic;
    out_ALUOp        : out std_logic_vector(1 downto 0);	 
    out_MemWrite     : out std_logic;
    out_ALUSrc       : out std_logic;
    out_RegWrite     : out std_logic;
    out_Jump         : out std_logic
    );
end Controller;

architecture behavioral of Controller is
begin		
	UpdateOutputs : process (in_Opcode,processor_enable, in_reset, ControlStall, CtrlHazard)
	begin		 		
		if processor_enable = '0' or in_reset = '1' or ControlStall = '1' or CtrlHazard = '1' then
			out_RegDST   <= '0';
			out_ALUSrc   <= '0';
			out_MemtoReg <= '0';
			out_RegWrite <= '0';
			out_MemRead  <= '0';
			out_MemWrite <= '0';
			out_Branch   <= '0';
			out_ALUOp    <= "00";
			out_Jump     <= '0';
		
		else			
			case in_Opcode is				
			when OP_R_TYPE =>
				out_RegDST   <= '1';
				out_ALUSrc   <= '0';
				out_MemtoReg <= '1';
				out_RegWrite <= '1';
				out_MemRead  <= '0';
				out_MemWrite <= '0';
				out_Branch   <= '0';
				out_ALUOp    <= "10";
				out_Jump     <= '0';				
			when OP_ADDI =>	  
				out_RegDST   <= '0';
				out_ALUSrc   <= '1';
				out_MemtoReg <= '0';
				out_RegWrite <= '1';
				out_MemRead  <= '0';
				out_MemWrite <= '0';
				out_Branch   <= '0';
				out_ALUOp    <= "00";
				out_Jump     <= '0';				
			when OP_LUI =>	  
				out_RegDST   <= '0';
				out_ALUSrc   <= '1';
				out_MemtoReg <= '1';
				out_RegWrite <= '1';
				out_MemRead  <= '0';
				out_MemWrite <= '0';
				out_Branch   <= '0';
				out_ALUOp    <= "11";
				out_Jump     <= '0';				
			when OP_BEQ =>
				out_RegDST   <= '0';
				out_ALUSrc   <= '0';
				out_MemtoReg <= '0';
				out_RegWrite <= '0';
				out_MemRead  <= '0';
				out_MemWrite <= '0';
				out_Branch   <= '1';
				out_ALUOp    <= "01";
				out_Jump     <= '0';			 
			when OP_LW =>
				out_RegDST   <= '0';
				out_ALUSrc   <= '1';
				out_MemtoReg <= '0';
				out_RegWrite <= '1';
				out_MemRead  <= '1';
				out_MemWrite <= '0';
				out_Branch   <= '0';
				out_ALUOp    <= "00";
				out_Jump     <= '0';			  
			when OP_SW =>
				out_RegDST   <= '0';
				out_ALUSrc   <= '1';
				out_MemtoReg <= '0';
				out_RegWrite <= '0';
				out_MemRead  <= '0';
				out_MemWrite <= '1';
				out_Branch   <= '0';
				out_ALUOp    <= "00";
				out_Jump     <= '0';			 
			when OP_J =>
			  out_RegDST   <= '0';
			  out_Branch   <= '0';
			  out_MemRead  <= '0';
			  out_MemWrite <= '0';
			  out_ALUOp    <= "00";
			  out_MemtoReg <= '0';
			  out_ALUSrc   <= '0';
			  out_RegWrite <= '0';
			  out_Jump     <= '1';		  
			when others =>
				out_RegDST   <= '0';
				out_ALUSrc   <= '0';
				out_MemtoReg <= '0';
				out_RegWrite <= '0';
				out_MemRead  <= '0';
				out_MemWrite <= '0';
				out_Branch   <= '0';
				out_ALUOp    <= "00";
				out_Jump     <= '0';			  
			end case;
		end if;		
	end process UpdateOutputs;	  
end behavioral;

