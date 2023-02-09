----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:28:07 08/17/2017 
-- Design Name: 
-- Module Name:    kontrolnaEnota - Behavioral 
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

entity kontrolnaEnota is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           pulse_i : in  STD_LOGIC;
           data_i : in  STD_LOGIC;
           shren_o : out  STD_LOGIC;
			  ready_o : out  STD_LOGIC);
end kontrolnaEnota;

architecture Behavioral of kontrolnaEnota is

type state_type is (st_IDLE, st_START, st_B0, st_B1, st_B2, st_B3,
							st_B4, st_B5, st_B6, st_B7, st_PAR);
signal state, next_state : state_type;
signal shr_en : STD_LOGIC;
signal ready : STD_LOGIC;

begin
shren_o <= shr_en;
ready_o <= ready;

-- register stanj:
   SYNC_PROC: process (clk_i)
   begin
      if (clk_i'event and clk_i = '1') then
         if (rst_i = '0') then
            state <= st_IDLE;
         else
            state <= next_state;
				-- assign other outputs to internal signals
         end if;
      end if;
   end process;
   
   -- racunanje novega stanja:
   NEXT_STATE_DECODE: process (state, pulse_i, data_i)
	  begin
		  --declare default state for next_state to avoid latches
		  next_state <= state;  --default is to stay in current state
		  case (state) is
			  when st_IDLE =>
				  if (pulse_i = '1' and data_i = '0') then
					  next_state <= st_START;
				  end if;
			  when st_START =>
				  if pulse_i = '1' then
					  next_state <= st_B0;
				  end if;
			  when st_B0 =>
				  if pulse_i = '1' then
					  next_state <= st_B1;
				  end if;
			  when st_B1 =>
				  if pulse_i = '1' then
					  next_state <= st_B2;
				  end if;
			  when st_B2 =>
				  if pulse_i = '1' then
					  next_state <= st_B3;
				  end if;
			  when st_B3 =>
				  if pulse_i = '1' then
					  next_state <= st_B4;
				  end if;    
				when st_B4 =>
					 if pulse_i = '1' then
						 next_state <= st_B5;
					 end if;
				 when st_B5 =>
					 if pulse_i = '1' then
						 next_state <= st_B6;
					 end if;
				 when st_B6 =>
					 if pulse_i = '1' then
						 next_state <= st_B7;
					 end if;
				 when st_B7 =>
					 if pulse_i = '1' then
						 next_state <= st_PAR;
					 end if; 
				 when st_PAR =>
						 if (pulse_i = '1' and data_i = '1') then
							 next_state <= st_IDLE;
						 end if;
			  when others => 
						 next_state <= st_IDLE;
		  end case;
	  end process;
	
   -- racunanje izhodov
  	OUTPUT_DECODE: process(state, pulse_i, data_i) 
	begin
	 --declare default value for all outputs to avoid latches
		shr_en <= '0';  --default 
		ready <= '0';
		
     case (state) is
        when st_IDLE =>
           if (pulse_i = '1' and data_i = '0') then
              shr_en <= '1';
           end if;
			  ready <= '1';
        when st_START =>
           if pulse_i = '1' then
              shr_en <= '1';
           end if;
			  ready <= '0';
        when st_B0 =>
           if pulse_i = '1' then
              shr_en  <= '1';
           end if;
			  ready <= '0';
        when st_B1 =>
           if pulse_i = '1' then
               shr_en <= '1';
           end if;
			  ready <= '0';
        when st_B2 =>
           if pulse_i = '1' then
              shr_en <= '1';
           end if;
			  ready <= '0';
        when st_B3 =>
           if pulse_i = '1' then
              shr_en <= '1';
           end if;
			  ready <= '0';
         when st_B4 =>
             if pulse_i = '1' then
                shr_en <= '1';
             end if;
				 ready <= '0';
          when st_B5 =>
             if pulse_i = '1' then
                shr_en <= '1';
             end if;
				 ready <= '0';
          when st_B6 =>
             if pulse_i = '1' then
                shr_en <= '1';
             end if;
				 ready <= '0';
          when st_B7 =>
             if pulse_i = '1' then
                shr_en <= '1';
             end if; 
				 ready <= '0';
          when st_PAR =>
                if (pulse_i = '1' and data_i = '1') then
                   shr_en <= '0';
                end if;
					 ready <= '0';
        when others =>
           shr_en <= '0';
			  ready <= '0';
     end case;
	end process;
	
end Behavioral;

