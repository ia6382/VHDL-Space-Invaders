----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:10:56 11/10/2015 
-- Design Name: 
-- Module Name:    HSYNC - Behavioral 
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

entity hsync is
Generic(	data_widthC:integer := 10;
			data_valueC:integer := 799;
			data_widthP:integer := 3;
			data_valueP:integer := 3
		 );
Port 	(	clk_i: in  STD_LOGIC;
			rst_i: in  STD_LOGIC;
			ROWCLK_o: out STD_LOGIC;
			HVIDON_o: out STD_LOGIC;
			COLUMN_o: out STD_LOGIC_VECTOR(data_widthC-1 downto 0);
			HSYNC_o: out STD_LOGIC
		);
end hsync;

architecture Behavioral of hsync is
signal count1: std_logic_vector(data_widthP-2 downto 0);
signal counter: std_logic_vector(data_widthC-1 downto 0);
signal enable: std_logic;
		
begin

COLUMN_o <= counter;

--prescaler
	process(clk_i)
		begin
			if clk_i'event and clk_i = '1' then
				if(rst_i = '0') then
					count1 <= (others => '0');
					enable <= '0';
				else
					if(count1 = data_valueP) then
						count1 <= (others => '0');
						enable <= '1';
					else
						count1 <= count1 + 1;
						enable <= '0';
					end if;
				end if;
			end if ;
		end process ;

--counter
	process(clk_i)
		begin
			if clk_i'event and clk_i = '1' then
				if(rst_i = '0') then
					counter <= (others => '0');
				else
					if(enable = '1') then
						if(counter = data_valueC)then
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
		
--rowclk
	process(counter, enable)
		begin
			if(counter = 799 AND enable = '1') then
				ROWCLK_o <= '1';
			else
				ROWCLK_o <= '0';
			end if;
		end process;

--HVIDON
	process(counter)
		begin
			if(counter < 640) then
				HVIDON_o <= '1';
			else
				HVIDON_o <= '0';
			end if;
		end process;
		
--HSYNC (counter > 655 AND counter < 742)
	process(counter)
		begin
			if(counter > 655 AND counter < 742) then
				HSYNC_o <= '1';
			else
				HSYNC_o <= '0';
			end if;
		end process;

end Behavioral;

