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

entity alienSpeedPrescaler is
	Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
			  speedUp_i : in STD_LOGIC;
           speedEnable_o : out  STD_LOGIC);
end alienSpeedPrescaler;

architecture Behavioral of alienSpeedPrescaler is

signal count: std_logic_vector(24 downto 0);
signal enable: STD_LOGIC;
constant data_value: std_logic_vector(24 downto 0) := conv_std_logic_vector(30000000, 25);
signal minus: std_logic_vector(24 downto 0):= conv_std_logic_vector(0, 25);

begin

	speedEnable_o <= enable;

	--prescaler za aliene
		process(clk_i)
		begin
			if clk_i'event and clk_i = '1' then	
				if(rst_i = '0') then
					minus <= (others => '0');
					count <= (others => '0');
					enable <= '0';
				else
					if(speedUp_i = '1') then
						if(minus < 29000000) then
							minus <= minus + 400000;
						end if;
					end if;
					
					if(count >= (data_value - minus)) then
						count <= (others => '0');
						enable <= '1';
					else
						count <= count + 1;
						enable <= '0';
					end if;
				end if;
			end if ;
		end process ;

end Behavioral;

