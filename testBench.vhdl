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


--TEST BENCH KODU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity TestBench is
end TestBench;
architecture Behavioral of TestBench is
 component ControlUnit
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
11
 ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
 ALUSrcB : out STD_LOGIC_VECTOR(1 downto 0);
 ALUSrcA : out STD_LOGIC;
 RegWrite : out STD_LOGIC;
 RegDst : out STD_LOGIC
 );
 end component;
 
 signal Opcode : STD_LOGIC_VECTOR(5 downto 0);
 signal State : STD_LOGIC_VECTOR(3 downto 0);
 signal PCWrite : STD_LOGIC;
 signal PCWriteCond: STD_LOGIC;
 signal IorD : STD_LOGIC;
 signal MemRead : STD_LOGIC;
 signal MemWrite : STD_LOGIC;
 signal IRWrite : STD_LOGIC;
 signal MemtoReg : STD_LOGIC;
 signal PCSource : STD_LOGIC_VECTOR(1 downto 0);
 signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
 signal ALUSrcB : STD_LOGIC_VECTOR(1 downto 0);
 signal ALUSrcA : STD_LOGIC;
 signal RegWrite : STD_LOGIC;
 signal RegDst : STD_LOGIC;
 
begin
 uut: ControlUnit
 Port map (
 Opcode => Opcode,
 State => State,
12
 PCWrite => PCWrite,
 PCWriteCond=> PCWriteCond,
 IorD => IorD,
 MemRead => MemRead,
 MemWrite => MemWrite,
 IRWrite => IRWrite,
 MemtoReg => MemtoReg,
 PCSource => PCSource,
 ALUOp => ALUOp,
 ALUSrcB => ALUSrcB,
 ALUSrcA => ALUSrcA,
 RegWrite => RegWrite,
 RegDst => RegDst
 );
 
 -- Test işlemleri
 process
 begin
 -- Test Fetch
 Opcode <= "000000";
 State <= "0000";
 wait for 10 ns;
 
 -- Diğer durumları test et
 State <= “0001”;
 wait for 10 ns;
 
 State <= “0010”;
 wait for 10 ns; 
13
 State <= “0011”;
 wait for 10 ns;
 
 State <= “0100”;
 wait for 10 ns;
 
 State <= “0101”;
 wait for 10 ns;
 
 State <= “0110”;
 wait for 10 ns;
 
 State <= “0111”;
 wait for 10 ns;
 
 State <= “1000”;
 wait for 10 ns;
 
 -- Test bitişi
 wait;
 end process;
end Behavioral;
