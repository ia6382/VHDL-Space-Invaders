----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:34:07 08/14/2017 
-- Design Name: 
-- Module Name:    nedge - Behavioral 
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

entity neg is
    Port ( clk_i : in  STD_LOGIC;
           rst_i  : in  STD_LOGIC;
           input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end neg;

architecture Behavioral of neg is

type state_type is ( s0 , s1 , s2); -- možna stanja
signal state , next_state : state_type;

begin

	SYNC_PROC: process(clk_i) -- delovanje registra stanj
	begin
		if (clk_i'event and clk_i = '1') then
			if ( rst_i = '0' ) then
				state <= s0;
			else
				state <= next_state;
			end if;
		end if;
	end process;
	
	NEXT_STATE_DECODE: process(state,input)
	begin
		next_state <= state;
		case (state) is
			when s0 =>
				if input = '0' then 
					next_state <= s0;
				else
					next_state <= s1;
				end if;
			when s1 =>
				if input = '0' then 
					next_state <= s2;
				else
					next_state <= s1;
				end if;
			when s2 =>
				if input = '0' then 
					next_state <= s0;
				else
					next_state <= s1;
				end if;
			when others => next_state <= s0;
		end case;
	end process;
	
	OUTPUT_DECODE: process(state) -- logika za izhod
	begin
		output <= '0';	--default
		case (state) is
			when s0 => output <= '0';
			when s1 => output <= '0';
			when s2 => output <= '1';
			when others => output <= '0';
		end case;
	end process;

end Behavioral;

