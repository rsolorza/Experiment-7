----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2017 11:57:56 AM
-- Design Name: 
-- Module Name: testbench_exp7 - Behavioral
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

entity testbench_exp7 is
--  Port ( );
end testbench_exp7;

architecture Behavioral of testbench_exp7 is

    component Rat_MCU is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
         SEL : in STD_LOGIC_VECTOR (3 downto 0);
         Cin : in STD_LOGIC;
      RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end component;

signal a, b, result : std_logic_vector (7 downto 0) := "00000000";
signal sel : std_logic_vector(3 downto 0) := "0000";
signal cin, c, z : std_logic := '0';

begin

logic_unit : ALU 
    Port map ( A => a,
               B => b,
               SEL => sel,
               Cin => cin,
               RESULT => result,
               C => c,
               Z => z);
               
number_process : process
    begin
    
    end process; 
    
end Behavioral;