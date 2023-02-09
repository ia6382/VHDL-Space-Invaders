----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:00:06 10/27/2015 
-- Design Name: 
-- Module Name:    prescaler - Behavioral 
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
use IEEE. STD_LOGIC_ARITH. ALL;
use IEEE. STD_LOGIC_UNSIGNED. ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prescaler is
Generic(data_width:integer := 27;
		  data_value:integer := 99999999
		);
Port ( clk: in  STD_LOGIC;
			  reset: in STD_LOGIC;
           enable : out  STD_LOGIC);
end prescaler;

architecture Behavioral of prescaler is
signal count1: std_logic_vector(data_width-1 downto 0);
	
begin
		
	process(clk)
		begin
			if clk'event and clk = '1' then
				if(reset= '0') then
					count1 <= (others => '0');
				else
					if(count1 < data_value) then
						count1 <= count1 +'1';
						enable <= '0';
					else
						count1 <= (others => '0');
						enable <= '1';
					end if;
				end if;
			end if ;
		end process ;

end Behavioral;

