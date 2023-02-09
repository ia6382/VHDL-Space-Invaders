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

entity shotRam is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (3 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 2));
end shotRam;

architecture Behavioral of shotRam is

	type ram_type is array (9 downto 0) of std_logic_vector (0 to 2);
   signal RAM : ram_type;
	signal dataOUT : STD_LOGIC_VECTOR (0 to 2);

begin
	
	data_o <= dataOUT;
	
	--process (clk_i)
	--begin
		--if (clk_i'event and clk_i = '1') then
			RAM(0) <= "000";
			RAM(1) <= "101";
			RAM(2) <= "111";
			RAM(3) <= "111";
			RAM(4) <= "111";
			RAM(5) <= "111";
			RAM(6) <= "111";
			RAM(7) <= "111";
			RAM(8) <= "111";
			RAM(9) <= "111";
		--end if;
	--end process;

	-- beres instantno, vrstico ki naslovis z addrOUT_i
	dataOUT <= RAM(conv_integer(addrOUT_i));


end Behavioral;

