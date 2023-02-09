----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:56:21 08/26/2017 
-- Design Name: 
-- Module Name:    ramShip - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alienRam is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (5 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 38));
end alienRam;

architecture Behavioral of alienRam is

	type ram_type is array (33 downto 0) of std_logic_vector (0 to 38);
   signal RAM : ram_type;
	signal dataOUT : STD_LOGIC_VECTOR (0 to 38);

begin
	
	data_o <= dataOUT;
	
	--process (clk_i)
	--begin
		--if (clk_i'event and clk_i = '1') then
			RAM(0) <= "000000000000000000000000000000000000000";
			RAM(1) <= "000011000000000000000000000000000110000";
			RAM(2) <= "000011000000000000000000000000000110000";
			RAM(3) <= "000000110000000000000000000000011000000";
			RAM(4) <= "000000110000000000000000000000011000000";
			RAM(5) <= "000011111111111111111111111111111110000";
			RAM(6) <= "000011111111111111111111111111111110000";
			RAM(7) <= "001111001111111111111111111111100111100";
			RAM(8) <= "001111001111111111111111111111100111100";
			RAM(9) <= "111111111111111111111111111111111111111";
			RAM(10) <= "111111111111111111111111111111111111111";
			RAM(11) <= "110011111111111111111111111111111110011";
			RAM(12) <= "110011111111111111111111111111111110011";
			RAM(13) <= "110011000000000000000000000000000110011";
			RAM(14) <= "110011000000000000000000000000000110011";
			RAM(15) <= "000000111111111100000001111111111000000";
			RAM(16) <= "000000111111111100000001111111111000000";
			
			RAM(17) <= "000000000000000000000000000000000000000";
			RAM(18) <= "000011000000000000000000000000000110000";
			RAM(19) <= "000011000000000000000000000000000110000";
			RAM(20) <= "110000110000000000000000000000011000011";
			RAM(21) <= "110000110000000000000000000000011000011";
			RAM(22) <= "110011111111111111111111111111111110011";
			RAM(23) <= "110011111111111111111111111111111110011";
			RAM(24) <= "111111001111111111111111111111100111111";
			RAM(25) <= "111111001111111111111111111111100111111";
			RAM(26) <= "111111111111111111111111111111111111111";
			RAM(27) <= "111111111111111111111111111111111111111";
			RAM(28) <= "000011111111111111111111111111111110000";
			RAM(29) <= "000011111111111111111111111111111110000";
			RAM(30) <= "000011000000000000000000000000000110000";
			RAM(31) <= "000011000000000000000000000000000110000";
			RAM(32) <= "001100000000000000000000000000000001100";
			RAM(33) <= "001100000000000000000000000000000001100";
		--end if;
	--end process;

	-- beres instantno, vrstico ki naslovis z addrOUT_i
	dataOUT <= RAM(conv_integer(addrOUT_i));


end Behavioral;

