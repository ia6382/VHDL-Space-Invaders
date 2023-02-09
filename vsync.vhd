----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:11:12 11/10/2015 
-- Design Name: 
-- Module Name:    VSYNC - Behavioral 
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

entity vsync is
Generic(	data_width:integer := 10;
			data_value:integer := 520
		 );
Port 	(	clk_i: in  STD_LOGIC;
			rst_i: in  STD_LOGIC;
			ROWCLK_i: in STD_LOGIC;
			VVIDON_o: out STD_LOGIC;
			ROW_o: out STD_LOGIC_VECTOR(data_width-1 downto 0);
			VSYNC_o: out STD_LOGIC
		);
end vsync;

architecture Behavioral of vsync is

signal counter: std_logic_vector(data_width-1 downto 0);
begin

ROW_o <= counter;

--counter
	process(clk_i)
		begin
			if clk_i'event and clk_i = '1' then
				if(rst_i = '0') then
					counter <= (others => '0');
				else
					if(ROWCLK_i = '1') then
						if(counter = data_value)then
							counter <= (others => '0');
						else
							counter <= counter + 1;
						end if;
					else
						counter <= counter;
					end if;
				end if;
			end if ;
		end process ;

--VVIDON
	process(counter)
		begin
			if(counter < 480) then
				VVIDON_o <= '1';
			else
				VVIDON_o <= '0';
			end if;
		end process;
		
--VSYNC
	process(counter)
		begin
			if(counter > 489 AND counter < 492) then
				VSYNC_o <= '1';
			else
				VSYNC_o <= '0';
			end if;
		end process;

end Behavioral;

