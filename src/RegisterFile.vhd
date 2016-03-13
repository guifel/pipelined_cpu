
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity RegisterFile is
	port (
	 clk         : in  std_logic;
    in_Reset    : in  std_logic;
    in_ReadReg1 : in  std_logic_vector(4 downto 0);
    in_ReadReg2 : in  std_logic_vector(4 downto 0);
    in_WriteReg : in  std_logic_vector(4 downto 0);
    in_Data     : in  std_logic_vector(31 downto 0);
    in_WriteEn  : in  std_logic;
    out_Data1   : out std_logic_vector(31 downto 0);
    out_Data2   : out std_logic_vector(31 downto 0)
    );
end RegisterFile;

architecture behavioral of RegisterFile is

  type T_Register_Array is array(0 to 31) of std_logic_vector (31 downto 0);
  signal Registers : T_Register_Array;
  
begin
  
  out_Data1 <= Registers(to_integer(unsigned(in_ReadReg1)));
  out_Data2 <= Registers(to_integer(unsigned(in_ReadReg2)));

  WriteRegister : process (in_Reset,in_WriteEn, in_Data, in_Writereg,clk)
  begin


-- The following code can be use to avoid the use of the falling_edge(clk) but it will generate a latch warning   
--    if in_Reset = '1' then
--      Registers <= (others => x"00000000");
--    elsif (in_WriteEn = '1') then
--      Registers(to_integer(unsigned(in_WriteReg))) <= in_Data;
--    end if;
	 
	 if in_Reset = '1' then
      Registers <= (others => x"00000000");
	 elsif falling_edge(clk) then
	    if(in_WriteEn = '1') then    
          Registers(to_integer(unsigned(in_WriteReg))) <= in_Data;
		 end if;
    end if;
	 
  end process WriteRegister;
  
end behavioral;

