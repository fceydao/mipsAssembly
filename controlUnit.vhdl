--VHDL KODU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ControlUnit is
 Port (
 Opcode : in STD_LOGIC_VECTOR(5 downto 0);
 State : in STD_LOGIC_VECTOR(3 downto 0);
 PCWrite : out STD_LOGIC;
 PCWriteCond: out STD_LOGIC;
 IorD : out STD_LOGIC;
 MemRead : out STD_LOGIC;
 MemWrite : out STD_LOGIC;
 IRWrite : out STD_LOGIC;
 MemtoReg : out STD_LOGIC;
 PCSource : out STD_LOGIC_VECTOR(1 downto 0);
 ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
 ALUSrcB : out STD_LOGIC_VECTOR(1 downto 0);
 ALUSrcA : out STD_LOGIC;
 RegWrite : out STD_LOGIC;
 RegDst : out STD_LOGIC
 );
8
end ControlUnit;
architecture Behavioral of ControlUnit is
begin
 process(Opcode, State)
 begin
 -- Varsayılan değerler
 PCWrite <= '0';
 PCWriteCond<= '0';
 IorD <= '0';
 MemRead <= '0';
 MemWrite <= '0';
 IRWrite <= '0';
 MemtoReg <= '0';
 PCSource <= "00";
 ALUOp <= "00";
 ALUSrcB <= "00";
 ALUSrcA <= '0';
 RegWrite <= '0';
 RegDst <= '0';
 
 case State is
 when "0000" => -- Fetch
 MemRead <= '1';
 IRWrite <= '1';
 ALUSrcB <= "01";
 PCWrite <= '1';
 
 when "0001" => -- Decode
9
 ALUSrcB <= "11";
 
 when "0010" => -- Memory Address Computation
 ALUSrcA <= '1';
 ALUSrcB <= "10";
 
 when "0011" => -- Memory Access (Read)
 MemRead <= '1';
 IorD <= '1';
 
 when "0100" => -- Memory Access (Write-back)
 RegWrite <= '1';
 MemtoReg <= '1';
 
 when "0101" => -- Memory Access (Write)
 MemWrite <= '1';
 IorD <= '1';
 
 when "0110" => -- Execute
 ALUSrcA <= '1';
 ALUOp <= "10";
 
 when "0111" => -- ALU Result Write-back
 RegWrite <= '1';
 RegDst <= '1';
 
 when "1000" => -- Branch
 ALUSrcA <= '1';
 ALUOp <= "01";
10
 PCWriteCond <= '1';
 PCSource <= "01";
 
 when others =>
 null;
 end case;
 end process;
end Behavioral;