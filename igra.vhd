----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:28 08/26/2017 
-- Design Name: 
-- Module Name:    igra - Behavioral 
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

entity igra is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           kbdclk_i : in  STD_LOGIC;
           kbddata_i : in  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (3 downto 0);
           G : out  STD_LOGIC_VECTOR (3 downto 0);
           B : out  STD_LOGIC_VECTOR (3 downto 0);
			  hsync_o : out  STD_LOGIC;
           vsync_o : out  STD_LOGIC
           );
end igra;

architecture Behavioral of igra is
--KOMPONENTE---------------------------------------------------------------------

--VGA
component hsync is
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
end component;

component vsync is
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
end component;

--PS2
component keyboard is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           kbdclk_i : in  STD_LOGIC;
           kbddata_i : in  STD_LOGIC;
           dataK_o : out  STD_LOGIC_VECTOR (7 downto 0); ---
           readyK_o : out  STD_LOGIC);
end component;

--ship
component ship is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           on_i : in  STD_LOGIC;
			  readyK_i : in  STD_LOGIC;
           dataK_i : in  STD_LOGIC_VECTOR (7 downto 0);
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  shipX_o : out  STD_LOGIC_VECTOR (9 downto 0);
           shipY_o : out  STD_LOGIC_VECTOR (9 downto 0);
           shipPixel_o : out  STD_LOGIC);
end component;

--shot
component shot is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           on_i : in  STD_LOGIC;
           dataK_i : in  STD_LOGIC_VECTOR (7 downto 0);
           readyK_i : in  STD_LOGIC;
           shipX_i : in  STD_LOGIC_VECTOR (9 downto 0);
           shipY_i : in  STD_LOGIC_VECTOR (9 downto 0);
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  hitShot_i : in  STD_LOGIC;
           shotPixel_o : out  STD_LOGIC);
end component;

--shield
component shield is
	 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  shieldX_i : in  STD_LOGIC_VECTOR (9 downto 0);
           shieldY_i : in  STD_LOGIC_VECTOR (9 downto 0);
           hit_i : in  STD_LOGIC;
           shieldPixel_o : out  STD_LOGIC);
end component;

--alien
component alien is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
			  on_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
           alienX_i : in  STD_LOGIC_VECTOR (9 downto 0);
           alienY_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  start_i : in  STD_LOGIC;
           hit_i : in  STD_LOGIC;
			  speedEnable_i : in  STD_LOGIC;
           rEdge_i : in  STD_LOGIC;
           lEdge_i : in  STD_LOGIC;
           alienPixel_o : out  STD_LOGIC);
end component;
--alienSpeedPrescaler
component alienSpeedPrescaler is
	Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
			  speedUp_i : in STD_LOGIC;
           speedEnable_o : out  STD_LOGIC);
end component;

--winScreen
component winScreen is
	 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  enableShow_i : in  STD_LOGIC;
           winPixel_o : out  STD_LOGIC);
end component;

--loseScreen
component loseScreen is
	 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  enableShow_i : in  STD_LOGIC;
           losePixel_o : out  STD_LOGIC);
end component;


--SIGNALI-----------------------------------------------------------------------

--VGA
signal rowClk: STD_LOGIC;
signal hvidOn: STD_LOGIC;
signal vvidOn: STD_LOGIC;
signal col: STD_LOGIC_VECTOR(9 downto 0);
signal row: STD_LOGIC_VECTOR(9 downto 0);
--PS2
signal readyK: STD_LOGIC;
signal dataK: STD_LOGIC_VECTOR(7 downto 0);
--ship
signal onOff: STD_LOGIC := '1';
signal shipX : STD_LOGIC_VECTOR (9 downto 0);
signal shipY : STD_LOGIC_VECTOR (9 downto 0);
signal shipPixel: STD_LOGIC;
--shot
signal shotPixel: STD_LOGIC;
signal hitShot: STD_LOGIC := '0';
--shield
signal shieldPixel1: STD_LOGIC;
signal shieldPixel2: STD_LOGIC;
signal shieldPixel3: STD_LOGIC;
signal shieldPixel4: STD_LOGIC;
signal hitShield1: STD_LOGIC := '0';
signal hitShield2: STD_LOGIC := '0';
signal hitShield3: STD_LOGIC := '0';
signal hitShield4: STD_LOGIC := '0';
--alien
signal rEdge: STD_LOGIC := '0';
signal lEdge: STD_LOGIC := '0';
signal start: STD_LOGIC := '0';
signal speedUp: STD_LOGIC := '0';
signal alienPixel1: STD_LOGIC;
signal hitAlien1: STD_LOGIC := '0';
signal alienPixel2: STD_LOGIC;
signal hitAlien2: STD_LOGIC := '0';
signal alienPixel3: STD_LOGIC;
signal hitAlien3: STD_LOGIC := '0';
signal alienPixel4: STD_LOGIC;
signal hitAlien4: STD_LOGIC := '0';
signal alienPixel5: STD_LOGIC;
signal hitAlien5: STD_LOGIC := '0';
signal alienPixel6: STD_LOGIC;
signal hitAlien6: STD_LOGIC := '0';
signal alienPixel7: STD_LOGIC;
signal hitAlien7: STD_LOGIC := '0';
signal alienPixel8: STD_LOGIC;
signal hitAlien8: STD_LOGIC := '0';
signal alienPixel9: STD_LOGIC;
signal hitAlien9: STD_LOGIC := '0';
signal alienPixel10: STD_LOGIC;
signal hitAlien10: STD_LOGIC := '0';
signal alienPixel11: STD_LOGIC;
signal hitAlien11: STD_LOGIC := '0';
signal alienPixel12: STD_LOGIC;
signal hitAlien12: STD_LOGIC := '0';
signal alienPixel13: STD_LOGIC;
signal hitAlien13: STD_LOGIC := '0';
signal alienPixel14: STD_LOGIC;
signal hitAlien14: STD_LOGIC := '0';
signal alienPixel15: STD_LOGIC;
signal hitAlien15: STD_LOGIC := '0';
signal alienPixel16: STD_LOGIC;
signal hitAlien16: STD_LOGIC := '0';
signal alienPixel17: STD_LOGIC;
signal hitAlien17: STD_LOGIC := '0';
signal alienPixel18: STD_LOGIC;
signal hitAlien18: STD_LOGIC := '0';
signal alienPixel19: STD_LOGIC;
signal hitAlien19: STD_LOGIC := '0';
signal alienPixel20: STD_LOGIC;
signal hitAlien20: STD_LOGIC := '0';
signal alienPixel21: STD_LOGIC;
signal hitAlien21: STD_LOGIC := '0';
signal alienPixel22: STD_LOGIC;
signal hitAlien22: STD_LOGIC := '0';
signal alienPixel23: STD_LOGIC;
signal hitAlien23: STD_LOGIC := '0';
signal alienPixel24: STD_LOGIC;
signal hitAlien24: STD_LOGIC := '0';
signal alienPixel25: STD_LOGIC;
signal hitAlien25: STD_LOGIC := '0';
signal alienPixel26: STD_LOGIC;
signal hitAlien26: STD_LOGIC := '0';
signal alienPixel27: STD_LOGIC;
signal hitAlien27: STD_LOGIC := '0';
signal alienPixel28: STD_LOGIC;
signal hitAlien28: STD_LOGIC := '0';
signal alienPixel29: STD_LOGIC;
signal hitAlien29: STD_LOGIC := '0';
signal alienPixel30: STD_LOGIC;
signal hitAlien30: STD_LOGIC := '0';
signal alienPixel31: STD_LOGIC;
signal hitAlien31: STD_LOGIC := '0';
signal alienPixel32: STD_LOGIC;
signal hitAlien32: STD_LOGIC := '0';
signal alienPixel33: STD_LOGIC;
signal hitAlien33: STD_LOGIC := '0';
signal alienPixel34: STD_LOGIC;
signal hitAlien34: STD_LOGIC := '0';
signal alienPixel35: STD_LOGIC;
signal hitAlien35: STD_LOGIC := '0';
signal alienPixel36: STD_LOGIC;
signal hitAlien36: STD_LOGIC := '0';
signal alienPixel37: STD_LOGIC;
signal hitAlien37: STD_LOGIC := '0';
signal alienPixel38: STD_LOGIC;
signal hitAlien38: STD_LOGIC := '0';
signal alienPixel39: STD_LOGIC;
signal hitAlien39: STD_LOGIC := '0';
signal alienPixel40: STD_LOGIC;
signal hitAlien40: STD_LOGIC := '0';
signal alienPixel41: STD_LOGIC;
signal hitAlien41: STD_LOGIC := '0';
signal alienPixel42: STD_LOGIC;
signal hitAlien42: STD_LOGIC := '0';
signal alienPixel43: STD_LOGIC;
signal hitAlien43: STD_LOGIC := '0';
signal alienPixel44: STD_LOGIC;
signal hitAlien44: STD_LOGIC := '0';
signal alienPixel45: STD_LOGIC;
signal hitAlien45: STD_LOGIC := '0';
signal alienPixel46: STD_LOGIC;
signal hitAlien46: STD_LOGIC := '0';
signal alienPixel47: STD_LOGIC;
signal hitAlien47: STD_LOGIC := '0';
signal alienPixel48: STD_LOGIC;
signal hitAlien48: STD_LOGIC := '0';
signal alienPixel49: STD_LOGIC;
signal hitAlien49: STD_LOGIC := '0';
signal alienPixel50: STD_LOGIC;
signal hitAlien50: STD_LOGIC := '0';
signal speedEnableAlien: STD_LOGIC;
--winScreen
signal enableShowWin: STD_LOGIC;
signal winPixel: STD_LOGIC;
signal alienNum : STD_LOGIC_VECTOR (8 downto 0);
--loseScreen
signal enableShowLose: STD_LOGIC;
signal shipLost: STD_LOGIC;
signal losePixel: STD_LOGIC;

begin

--PORTI--------------------------------------------------------------------------

--VGA
	hs : hsync
	generic map (
		data_widthC => 10,
		data_valueC => 799,
		data_widthP =>3,
		data_valueP =>3
	)
	port map (
		clk_i => clk_i,
		rst_i => rst_i,
		ROWCLK_o => rowClk,
		HVIDON_o => hvidOn,
		COLUMN_o => col,
		HSYNC_o => hsync_o
	);
	
	vs : vsync
	generic map (
		data_width => 10,
		data_value =>520
	)
	port map (
		clk_i => clk_i,
		rst_i => rst_i,
		ROWCLK_i => rowClk,
		VVIDON_o => vvidOn,
		ROW_o => row,
		VSYNC_o => vsync_o
	);
	
	--PS2
	ps2: keyboard
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		kbdclk_i => kbdclk_i,
		kbddata_i => kbddata_i,
		dataK_o => dataK,
		readyK_o => readyK
	);
	
	--ship
	ladja : ship
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		readyK_i => readyK,
		dataK_i => dataK,
		x_i => col,
		y_i => row,
		shipX_o => shipX,
		shipY_o => shipY,
		shipPixel_o => shipPixel
	);
	
	--shot
	izstrelek : shot
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		readyK_i => readyK,
		dataK_i => dataK,
		x_i => col,
		y_i => row,
		shipX_i => shipX,
		shipY_i => shipY,
		hitShot_i => hitShot,
		shotPixel_o => shotPixel
	);
	
	--shields
	branik1: shield
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		x_i => col,
		y_i => row,
		shieldX_i => conv_std_logic_vector(95, 10),
		shieldY_i => conv_std_logic_vector(335, 10),
		hit_i => hitShield1,
		shieldPixel_o => shieldPixel1
	);

	branik2: shield
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		x_i => col,
		y_i => row,
		shieldX_i => conv_std_logic_vector(220, 10),
		shieldY_i => conv_std_logic_vector(335, 10),
		hit_i => hitShield2,
		shieldPixel_o => shieldPixel2
	);

	branik3: shield
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		x_i => col,
		y_i => row,
		shieldX_i => conv_std_logic_vector(345, 10),
		shieldY_i => conv_std_logic_vector(335, 10),
		hit_i => hitShield3,
		shieldPixel_o => shieldPixel3
	);

	branik4: shield
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		x_i => col,
		y_i => row,
		shieldX_i => conv_std_logic_vector(470, 10),
		shieldY_i => conv_std_logic_vector(335, 10),
		hit_i => hitShield4,
		shieldPixel_o => shieldPixel4
	);
	
	--alienSpeedPrescaler
	alienHitrostPrescaler : alienSpeedPrescaler
	port map (
		clk_i => clk_i,
		rst_i => rst_i,
		speedUp_i => speedUp,
		speedEnable_o => speedEnableAlien
	);
	
	--aliens
	alien1: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(105, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien1,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel1
	);
	
	alien2: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(148, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien2,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel2
	);
	
	alien3: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(191, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien3,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel3
	);
	
	alien4: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(234, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien4,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel4
	);
	
	alien5: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(277, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien5,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel5
	);

	alien6: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(320, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien6,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel6
	);
	
	alien7: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(363, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien7,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel7
	);
	
	alien8: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(406, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien8,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel8
	);
	
	alien9: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(449, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien9,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel9
	);
	
	alien10: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(492, 10),
		alienY_i => conv_std_logic_vector(48, 10),
		hit_i => hitAlien10,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel10
	);
	
	alien11: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(105, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien11,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel11
	);
	
	alien12: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(148, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien12,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel12
	);
	
	alien13: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(191, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien13,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel13
	);
	
	alien14: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(234, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien14,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel14
	);
	
	alien15: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(277, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien15,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel15
	);
	
	alien16: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(320, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien16,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel16
	);
	
	alien17: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(363, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien17,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel17
	);
	
	alien18: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(406, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien18,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel18
	);
	
	alien19: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(449, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien19,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel19
	);
	
	alien20: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(492, 10),
		alienY_i => conv_std_logic_vector(69, 10),
		hit_i => hitAlien20,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel20
	);
	
	alien21: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(105, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien21,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel21
	);
	
	alien22: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(148, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien22,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel22
	);

	alien23: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(191, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien23,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel23
	);

	alien24: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(234, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien24,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel24
	);
	
	alien25: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(277, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien25,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel25
	);
	
	alien26: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(320, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien26,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel26
	);
	
	alien27: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(363, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien27,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel27
	);
	
	alien28: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(406, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien28,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel28
	);
	
	alien29: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(449, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien29,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel29
	);
	
	alien30: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(492, 10),
		alienY_i => conv_std_logic_vector(90, 10),
		hit_i => hitAlien30,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel30
	);
	
	alien31: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(105, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien31,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel31
	);
	
	alien32: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(148, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien32,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel32
	);
	
	alien33: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(191, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien33,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel33
	);
	
	alien34: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(234, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien34,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel34
	);
	
	alien35: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(277, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien35,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel35
	);
	
	alien36: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(320, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien36,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel36
	);
	
	alien37: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(363, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien37,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel37
	);
	
	alien38: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(406, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien38,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel38
	);
	
	alien39: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(449, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien39,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel39
	);
	
	alien40: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(492, 10),
		alienY_i => conv_std_logic_vector(111, 10),
		hit_i => hitAlien40,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel40
	);
	
	alien41: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(105, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien41,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel41
	);
	
	alien42: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(148, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien42,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel42
	);
	
	alien43: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(191, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien43,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel43
	);
	
	alien44: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(234, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien44,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel44
	);
	
	alien45: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(277, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien45,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel45
	);
	
	alien46: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(320, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien46,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel46
	);
	
	alien47: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(363, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien47,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel47
	);
	
	alien48: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(406, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien48,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel48
	);
	
	alien49: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(449, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien49,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel49
	);
	
	alien50: alien
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		on_i => onOff,
		x_i => col,
		y_i => row,
		alienX_i => conv_std_logic_vector(492, 10),
		alienY_i => conv_std_logic_vector(132, 10),
		hit_i => hitAlien50,
		speedEnable_i => speedEnableAlien,
		start_i => start,
		rEdge_i => rEdge,
		lEdge_i => lEdge,
		alienPixel_o => alienPixel50
	);

--winScreen
	zmaga: winScreen
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		x_i => col,
		y_i => row,
		enableShow_i => enableShowWin,
		winPixel_o => winPixel
	);
	
--loseScreen
	poraz: loseScreen
	port map (
		clk_i => clk_i,
		rst_i  => rst_i,
		x_i => col,
		y_i => row,
		enableShow_i => enableShowLose,
		losePixel_o => losePixel
	);
	
--KODA---------------------------------------------------
--zaznavanje zadetkov
	process(clk_i)
		begin
		   if(clk_i'event and clk_i = '1') then
				hitShield1 <= '0'; hitShield2 <= '0'; hitShield3 <= '0'; hitShield4 <= '0'; hitShot <= '0'; speedUp <= '0';
				if(rst_i = '0') then
					hitShield1 <= '0'; hitShield2 <= '0'; hitShield3 <= '0'; hitShield4 <= '0'; hitShot <= '0'; speedUp <= '0'; shipLost <= '0';
					hitAlien1 <= '0'; hitAlien2 <= '0'; hitAlien3 <= '0'; hitAlien4 <= '0'; hitAlien5 <= '0'; 
					hitAlien6 <= '0'; hitAlien7 <= '0'; hitAlien8 <= '0'; hitAlien9 <= '0'; hitAlien10 <= '0';
					hitAlien11 <= '0'; hitAlien12 <= '0'; hitAlien13 <= '0'; hitAlien14 <= '0'; hitAlien15 <= '0'; 
					hitAlien16 <= '0'; hitAlien17 <= '0'; hitAlien18 <= '0'; hitAlien19 <= '0'; hitAlien20 <= '0';
					hitAlien21 <= '0'; hitAlien22 <= '0'; hitAlien23 <= '0'; hitAlien24 <= '0'; hitAlien25 <= '0'; 
					hitAlien26 <= '0'; hitAlien27 <= '0'; hitAlien28 <= '0'; hitAlien29 <= '0'; hitAlien30 <= '0';
					hitAlien31 <= '0'; hitAlien32 <= '0'; hitAlien33 <= '0'; hitAlien34 <= '0'; hitAlien35 <= '0'; 
					hitAlien36 <= '0'; hitAlien37 <= '0'; hitAlien38 <= '0'; hitAlien39 <= '0'; hitAlien40 <= '0';
					hitAlien41 <= '0'; hitAlien42 <= '0'; hitAlien43 <= '0'; hitAlien44 <= '0'; hitAlien45 <= '0'; 
					hitAlien46 <= '0'; hitAlien47 <= '0'; hitAlien48 <= '0'; hitAlien49 <= '0'; hitAlien50 <= '0';
				else
						--zadetek branika
						if(shotPixel = '1' and shieldPixel1 = '1') then
							hitShield1 <= '1';
							hitShot <= '1';
						elsif(shotPixel = '1' and shieldPixel2 = '1') then
							hitShield2 <= '1';
							hitShot <= '1';
						elsif(shotPixel = '1' and shieldPixel3 = '1') then
							hitShield3 <= '1';
							hitShot <= '1';
						elsif(shotPixel = '1' and shieldPixel4 = '1') then
							hitShield4 <= '1';
							hitShot <= '1';
						end if;
						
						--zadetek aliena
						if(shotPixel = '1' and alienPixel1 = '1') then
							hitAlien1 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel2 = '1') then
							hitAlien2 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel3 = '1') then
							hitAlien3 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel4 = '1') then
							hitAlien4 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel5 = '1') then
							hitAlien5 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel6 = '1') then
							hitAlien6 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel7 = '1') then
							hitAlien7 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel8 = '1') then
							hitAlien8 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel9 = '1') then
							hitAlien9 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel10 = '1') then
							hitAlien10 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel11 = '1') then
							hitAlien11 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel12 = '1') then
							hitAlien12 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel13 = '1') then
							hitAlien13 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel14 = '1') then
							hitAlien14 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel15 = '1') then
							hitAlien15 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel16 = '1') then
							hitAlien16 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel17 = '1') then
							hitAlien17 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel18 = '1') then
							hitAlien18 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel19 = '1') then
							hitAlien19 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel20 = '1') then
							hitAlien20 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel21 = '1') then
							hitAlien21 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel22 = '1') then
							hitAlien22 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel23 = '1') then
							hitAlien23 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel24 = '1') then
							hitAlien24 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel25 = '1') then
							hitAlien25 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel26 = '1') then
							hitAlien26 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel27 = '1') then
							hitAlien27 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel28 = '1') then
							hitAlien28 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel29 = '1') then
							hitAlien29 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel30 = '1') then
							hitAlien30 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel31 = '1') then
							hitAlien31 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel32 = '1') then
							hitAlien32 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel33 = '1') then
							hitAlien33 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel34 = '1') then
							hitAlien34 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel35 = '1') then
							hitAlien35 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel36 = '1') then
							hitAlien36 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel37 = '1') then
							hitAlien37 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel38 = '1') then
							hitAlien38 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel39 = '1') then
							hitAlien39 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel40 = '1') then
							hitAlien40 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel41 = '1') then
							hitAlien41 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel42 = '1') then
							hitAlien42 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel43 = '1') then
							hitAlien43 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel44 = '1') then
							hitAlien44 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel45 = '1') then
							hitAlien45 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel46 = '1') then
							hitAlien46 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel47 = '1') then
							hitAlien47 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel48 = '1') then
							hitAlien48 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel49 = '1') then
							hitAlien49 <= '1'; hitShot <= '1'; speedUp <= '1';
						elsif(shotPixel = '1' and alienPixel50 = '1') then
							hitAlien50 <= '1'; hitShot <= '1'; speedUp <= '1';
						end if;
						
						--zadetek ladje
						if(shipPixel = '1'  and (alienPixel1 = '1' or alienPixel2 = '1' or alienPixel3 = '1' or alienPixel4 = '1' or alienPixel5 = '1'
						 or alienPixel6 = '1' or alienPixel7 = '1' or alienPixel8 = '1' or alienPixel9 = '1' or alienPixel10 = '1'
						 or alienPixel11 = '1' or alienPixel12 = '1' or alienPixel13 = '1' or alienPixel14 = '1' or alienPixel15 = '1'
						 or alienPixel16 = '1' or alienPixel17 = '1' or alienPixel18 = '1' or alienPixel19 = '1' or alienPixel20 = '1'
						 or alienPixel21 = '1' or alienPixel22 = '1' or alienPixel23 = '1' or alienPixel24 = '1' or alienPixel25 = '1'
						 or alienPixel26 = '1' or alienPixel27 = '1' or alienPixel28 = '1' or alienPixel29 = '1' or alienPixel30 = '1'
						 or alienPixel31 = '1' or alienPixel32 = '1' or alienPixel33 = '1' or alienPixel34 = '1' or alienPixel35 = '1'
						 or alienPixel36 = '1' or alienPixel37 = '1' or alienPixel38 = '1' or alienPixel39 = '1' or alienPixel40 = '1'
						 or alienPixel41 = '1' or alienPixel42 = '1' or alienPixel43 = '1' or alienPixel44 = '1' or alienPixel45 = '1'
						 or alienPixel46 = '1' or alienPixel47 = '1' or alienPixel48 = '1' or alienPixel49 = '1' or alienPixel50 = '1')) then
							 shipLost <= '1';
						end if;
					
				end if;
			end if;
	end process;
	
--zaznavanje robov
	process(clk_i, row, col)
		begin
		   if(clk_i'event and clk_i = '1') then
				rEdge <= '0'; lEdge <= '0'; --speedUp <= '0';
				
				if(rst_i = '0') then
					rEdge <= '0'; lEdge <= '0'; start <= '0'; enableShowLose <= '0'; enableShowWin <= '0'; --speedUp <= '0';
				else
					if(col > 607 and (alienPixel1 = '1' or alienPixel2 = '1' or alienPixel3 = '1' or alienPixel4 = '1' or alienPixel5 = '1'
						 or alienPixel6 = '1' or alienPixel7 = '1' or alienPixel8 = '1' or alienPixel9 = '1' or alienPixel10 = '1'
						 or alienPixel11 = '1' or alienPixel12 = '1' or alienPixel13 = '1' or alienPixel14 = '1' or alienPixel15 = '1'
						 or alienPixel16 = '1' or alienPixel17 = '1' or alienPixel18 = '1' or alienPixel19 = '1' or alienPixel20 = '1'
						 or alienPixel21 = '1' or alienPixel22 = '1' or alienPixel23 = '1' or alienPixel24 = '1' or alienPixel25 = '1'
						 or alienPixel26 = '1' or alienPixel27 = '1' or alienPixel28 = '1' or alienPixel29 = '1' or alienPixel30 = '1'
						 or alienPixel31 = '1' or alienPixel32 = '1' or alienPixel33 = '1' or alienPixel34 = '1' or alienPixel35 = '1'
						 or alienPixel36 = '1' or alienPixel37 = '1' or alienPixel38 = '1' or alienPixel39 = '1' or alienPixel40 = '1'
						 or alienPixel41 = '1' or alienPixel42 = '1' or alienPixel43 = '1' or alienPixel44 = '1' or alienPixel45 = '1'
						 or alienPixel46 = '1' or alienPixel47 = '1' or alienPixel48 = '1' or alienPixel49 = '1' or alienPixel50 = '1')) then
						--speedUp <= '1';
						rEdge <= '1';
						start <= '1';
					elsif(col < 31 and (alienPixel1 = '1' or alienPixel2 = '1' or alienPixel3 = '1' or alienPixel4 = '1' or alienPixel5 = '1'
						 or alienPixel6 = '1' or alienPixel7 = '1' or alienPixel8 = '1' or alienPixel9 = '1' or alienPixel10 = '1'
						 or alienPixel11 = '1' or alienPixel12 = '1' or alienPixel13 = '1' or alienPixel14 = '1' or alienPixel15 = '1'
						 or alienPixel16 = '1' or alienPixel17 = '1' or alienPixel18 = '1' or alienPixel19 = '1' or alienPixel20 = '1'
						 or alienPixel21 = '1' or alienPixel22 = '1' or alienPixel23 = '1' or alienPixel24 = '1' or alienPixel25 = '1'
						 or alienPixel26 = '1' or alienPixel27 = '1' or alienPixel28 = '1' or alienPixel29 = '1' or alienPixel30 = '1'
						 or alienPixel31 = '1' or alienPixel32 = '1' or alienPixel33 = '1' or alienPixel34 = '1' or alienPixel35 = '1'
						 or alienPixel36 = '1' or alienPixel37 = '1' or alienPixel38 = '1' or alienPixel39 = '1' or alienPixel40 = '1'
						 or alienPixel41 = '1' or alienPixel42 = '1' or alienPixel43 = '1' or alienPixel44 = '1' or alienPixel45 = '1'
						 or alienPixel46 = '1' or alienPixel47 = '1' or alienPixel48 = '1' or alienPixel49 = '1' or alienPixel50 = '1')) then
						--speedUp <= '1';
						lEdge <= '1';
						start <= '1';
					end if;
					
					--lose
					if(row >= 460 and (alienPixel1 = '1' or alienPixel2 = '1' or alienPixel3 = '1' or alienPixel4 = '1' or alienPixel5 = '1'
						 or alienPixel6 = '1' or alienPixel7 = '1' or alienPixel8 = '1' or alienPixel9 = '1' or alienPixel10 = '1'
						 or alienPixel11 = '1' or alienPixel12 = '1' or alienPixel13 = '1' or alienPixel14 = '1' or alienPixel15 = '1'
						 or alienPixel16 = '1' or alienPixel17 = '1' or alienPixel18 = '1' or alienPixel19 = '1' or alienPixel20 = '1'
						 or alienPixel21 = '1' or alienPixel22 = '1' or alienPixel23 = '1' or alienPixel24 = '1' or alienPixel25 = '1'
						 or alienPixel26 = '1' or alienPixel27 = '1' or alienPixel28 = '1' or alienPixel29 = '1' or alienPixel30 = '1'
						 or alienPixel31 = '1' or alienPixel32 = '1' or alienPixel33 = '1' or alienPixel34 = '1' or alienPixel35 = '1'
						 or alienPixel36 = '1' or alienPixel37 = '1' or alienPixel38 = '1' or alienPixel39 = '1' or alienPixel40 = '1'
						 or alienPixel41 = '1' or alienPixel42 = '1' or alienPixel43 = '1' or alienPixel44 = '1' or alienPixel45 = '1'
						 or alienPixel46 = '1' or alienPixel47 = '1' or alienPixel48 = '1' or alienPixel49 = '1' or alienPixel50 = '1')) then
						 enableShowLose <= '1';
					end if;
					
					--win
					if(hitAlien1 = '1' and hitAlien2 = '1' and hitAlien3 = '1' and hitAlien4 = '1' and hitAlien5 = '1' 
						and hitAlien6 = '1' and hitAlien7 = '1' and hitAlien8 = '1' and hitAlien9 = '1' and hitAlien10 = '1'
						and hitAlien11 = '1' and hitAlien12 = '1' and hitAlien13 = '1' and hitAlien14 = '1' and hitAlien15 = '1' 
						and hitAlien16 = '1' and hitAlien17 = '1' and hitAlien18 = '1' and hitAlien19 = '1' and hitAlien20 = '1'
						and hitAlien21 = '1' and hitAlien22 = '1' and hitAlien23 = '1' and hitAlien24 = '1' and hitAlien25 = '1' 
						and hitAlien26 = '1' and hitAlien27 = '1' and hitAlien28 = '1' and hitAlien29 = '1' and hitAlien30 = '1'
						and hitAlien31 = '1' and hitAlien32 = '1' and hitAlien33 = '1' and hitAlien34 = '1' and hitAlien35 = '1' 
						and hitAlien36 = '1' and hitAlien37 = '1' and hitAlien38 = '1' and hitAlien39 = '1' and hitAlien40 = '1'
						and hitAlien41 = '1' and hitAlien42 = '1' and hitAlien43 = '1' and hitAlien44 = '1' and hitAlien45 = '1' 
						and hitAlien46 = '1' and hitAlien47 = '1' and hitAlien48 = '1' and hitAlien49 = '1' and hitAlien50 = '1') then
						 enableShowWin <= '1';
					end if;
					
				end if;
			end if;
	end process;
	
--risanje
	process(clk_i, vvidOn, hvidOn, row, col, shipPixel, shotPixel, shieldPixel1, shieldPixel2, shieldPixel3, shieldPixel4)
		begin
			if(clk_i'event and clk_i = '1') then	
				if(vvidOn = '1' AND hvidOn = '1') then
					if(enableShowLose = '1' or shipLost = '1') then
						if(losePixel = '1') then
							R <= "1111";
							G <= "1111";
							B <= "1111";
						else
							R <= "0000";
							G <= "0000";
							B <= "0000";
						end if;
					else
						if(shipPixel = '1') then
							R <= "0000";
							G <= "1111";
							B <= "0000";
						elsif(shotPixel = '1') then
							R <= "0000";
							G <= "1111";
							B <= "0000";
						elsif(shieldPixel1 = '1' or shieldPixel2 = '1' or shieldPixel3 = '1' or shieldPixel4 = '1') then
							R <= "0000";
							G <= "1111";
							B <= "0000";
						elsif(alienPixel1 = '1' or alienPixel2 = '1' or alienPixel3 = '1' or alienPixel4 = '1' or alienPixel5 = '1'
						 or alienPixel6 = '1' or alienPixel7 = '1' or alienPixel8 = '1' or alienPixel9 = '1' or alienPixel10 = '1'
						 or alienPixel11 = '1' or alienPixel12 = '1' or alienPixel13 = '1' or alienPixel14 = '1' or alienPixel15 = '1'
						 or alienPixel16 = '1' or alienPixel17 = '1' or alienPixel18 = '1' or alienPixel19 = '1' or alienPixel20 = '1'
						 or alienPixel21 = '1' or alienPixel22 = '1' or alienPixel23 = '1' or alienPixel24 = '1' or alienPixel25 = '1'
						 or alienPixel26 = '1' or alienPixel27 = '1' or alienPixel28 = '1' or alienPixel29 = '1' or alienPixel30 = '1'
						 or alienPixel31 = '1' or alienPixel32 = '1' or alienPixel33 = '1' or alienPixel34 = '1' or alienPixel35 = '1'
						 or alienPixel36 = '1' or alienPixel37 = '1' or alienPixel38 = '1' or alienPixel39 = '1' or alienPixel40 = '1'
						 or alienPixel41 = '1' or alienPixel42 = '1' or alienPixel43 = '1' or alienPixel44 = '1' or alienPixel45 = '1'
						 or alienPixel46 = '1' or alienPixel47 = '1' or alienPixel48 = '1' or alienPixel49 = '1' or alienPixel50 = '1') then
							R <= "1111";
							G <= "1111";
							B <= "1111";
						elsif(winPixel = '1') then
							R <= "1111";
							G <= "1111";
							B <= "1111";
						elsif(row = 460 and col >= 31 and col <=607) then
							R <= "0000";
							G <= "1111";
							B <= "0000";
						elsif(row = 0 OR row =479 or col = 639 OR col = 0) then
							R <= "1111";
							G <= "1111";
							B <= "1111";
						else
							R <= "0000";
							G <= "0000";
							B <= "0000";
						end if;
					end if;
				else
					R <= "0000";
					G <= "0000";
					B <= "0000";
				end if;
			end if;
		end process;

end Behavioral;

