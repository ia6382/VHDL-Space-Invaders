----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:13:02 08/26/2017 
-- Design Name: 
-- Module Name:    speedPrescaler - Behavioral 
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

entity speedPrescaler is
	Generic( data_width:integer := 19;
			data_value:integer := 500000
		 );
	Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           onOff_i : in  STD_LOGIC;
           speedEnable_o : out  STD_LOGIC);
end speedPrescaler;

architecture Behavioral of speedPrescaler is

signal count: std_logic_vector(data_width - 1 downto 0);
signal enable: std_logic;

begin

	speedEnable_o <= enable;

	process(clk_i)
		begin
			if clk_i'event and clk_i = '1' then
				if(onOff_i = '1') then
					if(rst_i = '0') then
						count <= (others => '0');
						enable <= '0';
					else
						if(count = data_value-1) then
							count <= (others => '0');
							enable <= '1';
						else
							count <= count + 1;
							enable <= '0';
						end if;
					end if;
				end if;
			end if ;
		end process ;

end Behavioral;

