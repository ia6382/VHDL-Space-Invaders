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

entity ramShip is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (4 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 54));
end ramShip;

architecture Behavioral of ramShip is

	type ram_type is array (21 downto 0) of std_logic_vector (0 to 54);
   signal RAM : ram_type;
	signal dataOUT : STD_LOGIC_VECTOR (0 to 54);

begin
	
	data_o <= dataOUT;
	
	--process (clk_i)
	--begin
		--if (clk_i'event and clk_i = '1') then
			RAM(0) <= "0000000000000000000000000000000000000000000000000000000";
			RAM(1) <= "0000000000000000000000000011100000000000000000000000000";
			RAM(2) <= "0000000000000000000000000011100000000000000000000000000";
			RAM(3) <= "0000000000000000000000000011100000000000000000000000000";
			RAM(4) <= "0000000000000000000000000011100000000000000000000000000";
			RAM(5) <= "0000000000000000000000000011100000000000000000000000000";
			RAM(6) <= "0000000000000000000000111111111110000000000000000000000";
			RAM(7) <= "0000000000000000000000111111111110000000000000000000000";
			RAM(8) <= "0000000000000000000000111111111110000000000000000000000";
			RAM(9) <= "0000000000000000000000111111111110000000000000000000000";
			RAM(10) <= "0000011111111111111111111111111111111111111111111100000";
			RAM(11) <= "0000011111111111111111111111111111111111111111111100000";
			RAM(12) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(13) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(14) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(15) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(16) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(17) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(18) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(19) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(20) <= "1111111111111111111111111111111111111111111111111111111";
			RAM(21) <= "1111111111111111111111111111111111111111111111111111111";
		--end if;
	--end process;

	-- beres instantno, vrstico ki naslovis z addrOUT_i
	dataOUT <= RAM(conv_integer(addrOUT_i));


end Behavioral;

