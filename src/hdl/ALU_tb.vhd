----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2024 12:14:00 AM
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is
    component ALU is
    Port (
        i_A         : in std_logic_vector (7 downto 0);
        i_B         : in std_logic_vector (7 downto 0);
        i_opcode    : in std_logic_vector (2 downto 0);
        o_result    : out std_logic_vector (7 downto 0);
        o_flags     : out std_logic_vector (2 downto 0)
    );
    end component ALU;
    
    signal w_A  : std_logic_vector(7 downto 0);
    signal w_B  : std_logic_vector(7 downto 0);
    signal w_opcode : std_logic_vector(2 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
    signal w_flags  : std_logic_vector(2 downto 0);

begin
    uut: entity work.ALU
        port map (
            i_A => w_A,
            i_B => w_B,
            i_opcode => w_opcode,
            o_result => w_result,
            o_flags => w_flags
        );
        
    process
    begin
        w_A <= "00000011";
        w_B <= "00000110";
        w_opcode <= "000";
        wait for 10 ns;
        assert w_result = "00001001" report "Bad add of 3 and 6" severity failure;
        
        w_opcode <= "001";
        wait for 10 ns;
        assert w_result = "11111101" report "Bad sub of 3 and 6" severity failure;
        
        w_opcode <= "010";
        wait for 10 ns;
        assert w_result = "00000111" report "Bad or of 3 and 6" severity failure;
        
        w_opcode <= "100";
        wait for 10 ns;
        assert w_result = "00000010" report "Bad and of 3 and 6" severity failure;
        
        w_opcode <= "110";
        wait for 10 ns;
        assert w_result = "11000000" report "Bad left shift of 3 and 6" severity failure;
        assert w_flags(2) = '1' report "Bad negative flag" severity failure;
        
        w_opcode <= "111";
        wait for 10 ns;
        assert w_result = "00000000" report "Bad right shift of 3 and 6" severity failure; 
        assert w_flags(1) = '1' report "Bad zero flag" severity failure;
        
        --check that 0 -(-128) results in a carry out and -128
        w_A <= "00000000";
        w_B <= "10000000";
        w_opcode <= "001";
        wait for 10 ns;
        assert w_result = "10000000" report "Bad sub 0 and -128" severity failure;
        assert w_flags(0) = '1' report "Bad carry out" severity failure;
        assert w_flags(2) = '1' report "Bad negative" severity failure;
        
        wait;
        end process;
        
        

end Behavioral;
