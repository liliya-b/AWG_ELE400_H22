--------------------------------------------------------------------------------
-- Title       : <Title Block>
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : Generator_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Sun Apr 10 21:57:33 2022
-- Last update : Sun Apr 10 22:13:06 2022
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2022 User Company Name
-------------------------------------------------------------------------------
-- Description: 
--------------------------------------------------------------------------------
-- Revisions:  Revisions and documentation are controlled by
-- the revision control system (RCS).  The RCS should be consulted
-- on revision history.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------------------------------------

entity Generator_tb is

end entity Generator_tb;

-----------------------------------------------------------

architecture testbench of Generator_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk       : STD_LOGIC;
	signal reset     : STD_LOGIC;
	signal wave_type : STD_LOGIC;
	signal dataout   : STD_LOGIC_VECTOR (7 downto 0);

	-- Other constants
	constant C_CLK_PERIOD : real := 10.0e-9; -- NS

begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clk <= '1';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
		clk <= '0';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
	end process CLK_GEN;

	RESET_GEN : process
	begin
		reset <= '1',
		         '0' after 20.0*C_CLK_PERIOD * (1 SEC);
		wait;
	end process RESET_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
		WAVE_TYPE_GEN : process
	begin
		wave_type <= '1';
		wait for 100.0*C_CLK_PERIOD * (1 SEC);
		wave_type <= '0';
		wait for 100.0*C_CLK_PERIOD * (1 SEC);
	end process WAVE_TYPE_GEN;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.Generator
		port map (
			clk       => clk,
			reset     => reset,
			wave_type => wave_type,
			dataout   => dataout
		);

end architecture testbench;