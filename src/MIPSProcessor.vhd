
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPSProcessor is
	generic (
		ADDR_WIDTH : integer := 32;
		DATA_WIDTH : integer := 32
	);
	port (
		clk, reset 				: in std_logic;
		processor_enable		: in std_logic;
		imem_data_in			: in std_logic_vector(31 downto 0);
		imem_address			: out std_logic_vector(7 downto 0);
		dmem_data_in			: in std_logic_vector(31 downto 0);
		dmem_address			: out std_logic_vector(7 downto 0);
		dmem_data_out			: out std_logic_vector(31 downto 0);
		dmem_write_enable		: out std_logic
	);
end MIPSProcessor;

architecture Behavioral of MIPSProcessor is
	
	
	
	
	-- IF
	signal counterReg       : std_logic_vector(31 downto 0);
	signal NextAddr     		: std_logic_vector(31 downto 0);
	signal if_Instruction   : std_logic_vector(31 downto 0);
	signal PCStall 			: std_logic;
	signal IFIDregStall 		: std_logic;
	signal CtrlHazardIFID   : std_logic;
	signal CtrlHazardReg     : std_logic;
	
	-- ID
	signal id_counterReg       : std_logic_vector(31 downto 0);
	signal id_Instruction      : std_logic_vector(31 downto 0);
	signal extendedAddr        : std_logic_vector(31 downto 0);
	signal jumpAddr            : std_logic_vector(25 downto 0);
	signal opcode              : std_logic_vector(5 downto 0);
	signal Iaddr              : std_logic_vector(15 downto 0);
	signal RS                  : std_logic_vector(4 downto 0);
	signal RT                  : std_logic_vector(4 downto 0);
	signal RD                  : std_logic_vector(4 downto 0);
	signal writeBackData       : std_logic_vector(31 downto 0);
	signal id_outData1         : std_logic_vector(31 downto 0);
	signal id_outData2         : std_logic_vector(31 downto 0);
	signal regWrite				: std_logic;
	signal branch				   : std_logic;
	signal regDst			   	: std_logic;
	signal ALUOp			   	: std_logic_vector(1 downto 0);
	signal ALUSrc			     	: std_logic;
	signal memRead				   : std_logic;
	signal memToReg		   	: std_logic;
   signal memWrite			   : std_logic;
	signal jump  			   	: std_logic;
	signal ControlStall 			: std_logic;
	
	-- EX
	
	signal ex_regWrite       : std_logic;
	signal ex_memToReg       : std_logic;
	signal ex_branch         : std_logic;
	signal ex_memRead        : std_logic;
	signal ex_memWrite       : std_logic;
	signal ex_regDst         : std_logic;
	signal ex_ALUOp          : std_logic_vector(1 downto 0);
	signal ex_ALUSrc         : std_logic;
	signal ex_jump           : std_logic;
	signal ex_jumpAddr		 : std_logic_vector(25 downto 0);
	signal ex_counterReg		 : std_logic_vector(31 downto 0);
	signal ex_regData1		 : std_logic_vector(31 downto 0);
	signal ex_regData2		 : std_logic_vector(31 downto 0);
	signal ex_extendedAddr	 : std_logic_vector(31 downto 0);
	signal ex_RS	          : std_logic_vector(4 downto 0);
	signal ex_RT	          : std_logic_vector(4 downto 0);
	signal ex_RD	          : std_logic_vector(4 downto 0);
	signal ex_RDmux          : std_logic_vector(4 downto 0);
	signal concatAddr			 : std_logic_vector(31 downto 0);
	signal addResult			 : std_logic_vector(31 downto 0);
	signal ALUSrc1        	 : std_logic_vector(31 downto 0);
	signal ALUSrc2        	 : std_logic_vector(31 downto 0);
	signal ALUSrc2fwd      	 : std_logic_vector(31 downto 0);
	signal ALUresult       	 : std_logic_vector(31 downto 0);
	signal ALUCode        	 : std_logic_vector(3 downto 0);
	signal writeBackReg    	 : std_logic_vector(4 downto 0);
	signal zeroFlag          : std_logic;
	signal forwardA			 : std_logic_vector(1 downto 0);
	signal forwardB			 : std_logic_vector(1 downto 0);
	
	-- MEM
	signal mem_regWrite      : std_logic;
	signal mem_memToReg      : std_logic;
	signal mem_branch        : std_logic;
	signal mem_ZeroFlag      : std_logic;
	signal mem_Jump          : std_logic;
   signal mem_BranchAddr    : std_logic_vector(31 downto 0);
	signal mem_JumpAddr      : std_logic_vector(31 downto 0);
	signal mem_ALUResult     : std_logic_vector(31 downto 0);
	signal mem_regData2      : std_logic_vector(31 downto 0);
	signal mem_writeBackReg  : std_logic_vector(4 downto 0);
	signal mem_Rd            : std_logic_vector(4 downto 0);
	signal CtrlHazard        : std_logic;
	
	-- WB
	signal wb_memToReg       : std_logic;
	signal wb_readedData 	 : std_logic_vector(31 downto 0);
	signal wb_writeBackReg   : std_logic_vector(4 downto 0);
	signal wb_regwrite 		 : std_logic;
	signal wb_ALUResult      : std_logic_vector(31 downto 0);
	signal wb_RD             : std_logic_vector(4 downto 0);

begin
	
	
	--MEM
	MEMWBreg : entity work.MEMWBreg
		port map (
			  clk => clk,
           mem_regWrite => mem_regWrite,            
           mem_memToReg => mem_memToReg,                
           mem_readedDataMem => dmem_data_in,         
           mem_ALUResult => mem_ALUResult,
			  mem_RD => mem_RD,
           mem_writeBackReg => mem_writeBackReg,
			  wb_regWrite => wb_regWrite,
			  wb_memToReg => wb_memToReg,
			  wb_readedDataMem => wb_readedData,
			  wb_ALUResult => wb_ALUResult,
           wb_writeBackReg => wb_writeBackReg,
			  wb_RD => wb_RD
			  
 
		);
	
	dmem_address <= ALUResult(7 downto 0);
	dmem_data_out <= ALUsrc2fwd;
	dmem_write_enable <= ex_memWrite;
	
	-- EX
	with forwardA select 
	ALUSrc1 <= ex_regData1   when "00",
				  mem_ALUresult when "10",
				  writeBackData when "01",
				  ex_regData1   when "11";
	
	with forwardB select
	ALUsrc2fwd <= ex_regData2   when "00",
				     mem_ALUresult when "10",
				     writeBackData when "01",
				     ex_regData1   when "11";
	
	ALUSrc2 <= ALUsrc2fwd when ex_ALUSrc = '0' else ex_extendedAddr; 
	
	ALU : entity work.ALU
		port map (
          in_Operation =>ALUCode,
			 in_A => ALUSrc1,         
			 in_B => ALUSrc2,        
			 out_Result => ALUresult,  
			 out_Zero => zeroFlag   
		);
	
	
	
	ALUCtrl : entity work.ALUCtrl
		port map (
			in_Funct => ex_extendedAddr(5 downto 0),  
			in_ALUOp => ex_ALUOp,
			out_ALUOp => ALUCode
		);
	
		addResult <= std_logic_vector(unsigned(ex_counterReg) + unsigned(ex_extendedAddr));
		writeBackReg <= ex_RT when ex_regDst = '0' else ex_RD;
		concatAddr <= ex_counterReg(31 downto 26) & ex_jumpAddr;
		ex_RDmux <= ex_RT when ex_memread = '1' or ex_ALUOp = "11"	else ex_RD;
	
	EXMEMreg : entity work.EXMEMreg
		port map (
		   clk => clk,
			ex_regWrite => ex_regWrite,
			ex_memToReg => ex_memToReg,
			ex_branch => ex_branch,
			ex_zeroFlag => zeroFlag,
			ex_concatAddr => concatAddr,
			ex_branchAddr => addResult,
			ex_ALUresult => ALUresult,
			ex_regData2 => ex_regData2,
			ex_writeBackReg => writeBackReg,
			ex_jump => ex_jump,
			mem_regWrite => mem_regWrite,
			mem_memToReg => mem_memToReg,
			mem_branch => mem_branch,
			mem_zeroFlag => mem_zeroFlag,
			mem_concatAddr => mem_jumpAddr,
			mem_branchAddr => mem_branchAddr,
			mem_ALUresult => mem_ALUresult,
			mem_regData2 => mem_regData2,
			mem_writeBackReg => mem_writeBackReg,
			mem_jump => mem_jump,
			ex_RD => ex_RDmux,
			mem_RD => mem_RD
		);
	
	ForwardingUnit : entity work.Forwarding_unit
		port map (
			mem_regWrite => mem_regWrite,
         wb_regWrite => wb_regWrite,
         ex_RT => ex_RT,
         ex_RS => ex_RS,
         mem_RD => mem_RD,
         wb_RD => wb_RD,
         forwardA => forwardA,
         forwardB => forwardB
		);
	
	
	-- ID
	decoder : entity work.InstructionDecoder
		port map (
			in_instruction => id_instruction,
			out_Opcode => Opcode,
			out_RS => RS,
			out_RT => RT,
			out_RD => RD,
			out_Iaddress => Iaddr,
			out_JAddress => jumpAddr
		);
	
	
	writeBackData <= wb_ALUResult when wb_memToReg = '1' else wb_readedData;
	
	RegisterFile : entity work.RegisterFIle
		port map (
		   clk => clk,
			in_Reset     => reset,
			in_ReadReg1  => RS,
			in_ReadReg2  => RT,
			in_WriteReg  => wb_writeBackReg,
			in_Data      => writeBackData,
			in_WriteEn   => wb_regWrite,
			out_data1    => id_outData1,
			out_data2    => id_outData2
		);
	
	SignExtender : entity work.SignExtender
		port map (
			in_data  => Iaddr,
			out_data => ExtendedAddr
		);
	
	IDEXreg : entity work.IDEXreg
		port map (
			clk => clk,
			id_regWrite => regWrite,
			id_branch => branch,
			id_regDst => regDst,
			id_ALUOp => AlUOp,
			id_ALUSrc => AlUSrc,
			id_counterReg => id_counterReg,
			id_regData1 => id_outData1,
			id_regData2 => id_outData2,
			id_extendedAddr => ExtendedAddr,
			id_RS => RS,
			id_RD => RD,
			id_RT => RT,
			id_jumpAddr => jumpAddr,
			id_memRead => memRead,
			id_memToReg => memToReg,
			id_memWrite => memWrite,
			id_jump => jump,			
			ex_regWrite => ex_regWrite,      		
		   ex_branch   => ex_branch,      		
		   ex_regDst  => ex_regDst,      		
			ex_ALUOp  => ex_ALUOp,			
		   ex_ALUSrc	 => ex_ALUSrc,	    		
			ex_counterReg  => ex_counterReg,	
		   ex_regData1	   => ex_regData1,  		
			ex_regData2 	 => ex_regData2,	     
			ex_extendedAddr  => ex_extendedAddr,
			ex_RS				=> ex_RS,
			ex_RT 			 => ex_RT,	 				
			ex_RD 			 => ex_RD,
         ex_jumpAddr     => ex_jumpAddr,
			ex_memRead => ex_memRead,
		   ex_memToReg  => ex_memToReg,
			ex_memWrite => ex_memWrite, 
			ex_jump  =>	ex_jump,
			flush => CtrlHazard
		);
	
	Controller : entity work.Controller
		port map (
			 
			 in_reset         => reset,
			 processor_enable => processor_enable,
			 in_Opcode        => opcode,
			 out_RegDst       => RegDst,
			 out_Branch       => branch,
			 out_MemRead      => memRead,
			 out_MemtoReg     => memToReg,
			 out_ALUOp        =>	ALUOp,
			 out_MemWrite     => memWrite,
			 out_ALUSrc       => ALUSrc,
			 out_RegWrite     => regWrite,
			 out_Jump         => jump,
			 ControlStall     => ControlStall,
			 CtrlHazard       => CtrlHazard
		);
		
	Hazard_detection_unit : entity work.Hazard_detection_unit
		port map (			 
			RT => RT,
         RS => RS,
         ex_RT => ex_RT,
			ex_memRead => ex_memRead,
         PCStall => PCStall,
         IFIDregStall => IFIDregStall,
         ControlStall => ControlStall
		);	
	
	-- IF
	
	IFIDreg : entity work.IFIDreg
		port map (
			clk => clk,
			if_instruction => if_instruction,
			if_counterReg => counterReg,
			id_Instruction => id_Instruction,
			id_counterReg => id_counterReg,
			IFIDregStall => IFIDregStall,
			flush => CtrlHazard 
		);
	
	NextAddr   <= std_logic_vector(unsigned(counterReg) + 1);
	
	imem_address <= std_logic_vector(counterReg(7 downto 0)) when (PCStall = '0') else std_logic_vector(id_counterReg(7 downto 0)); 
	
	
	
	if_instruction <= imem_data_in when CtrlHazardIFID = '0' else (others => '0');
	
	CtrlHazard <= (mem_Branch and mem_ZeroFlag) or mem_jump;
	
	CtrlHazardIFID <= CtrlHazard or CtrlHazardReg;
	
	
	CtrlHazardRegProcess : process(clk) -- Register needed to flush in case of taken branch or a jump
	begin
		if rising_edge(clk) then
			CtrlHazardReg <= CtrlHazard;
		end if;
	end process CtrlHazardRegProcess; 
	
		
	UpdatePC : process(clk, reset)	
	begin
		if reset = '1' then
			counterReg <= (others => '1');
		elsif PCStall = '0' then
			if rising_edge(clk) and processor_enable = '1' then
				if mem_Branch = '1' and mem_ZeroFlag = '1' then  
					counterReg <= mem_BranchAddr;
				elsif mem_Jump ='1' then 
					counterReg <= mem_JumpAddr;
				else
					counterReg <= NextAddr;
				end if;	
			end if;
		end if;


	end process UpdatePC; 
end Behavioral;

