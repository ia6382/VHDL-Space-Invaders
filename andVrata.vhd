----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:03:10 08/17/2017 
-- Design Name: 
-- Module Name:    andVrata - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Dcelica is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           desync_i : in  STD_LOGIC;
           sync_o : out  STD_LOGIC);
end Dcelica;

architecture Behavioral of Dcelica is

begin
	process(clk_i)
		begin
			if (clk_i'event and clk_i = '1') then
				if(rst_i = '0') then
					sync_o <= '1';
				else
					sync_o <= desync_i;
				end if;
			end if;
	end process;

end Behavioral;

