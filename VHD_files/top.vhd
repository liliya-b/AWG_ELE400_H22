----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2022 07:52:32 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
 port (
     clk : in std_logic;
     reset : in std_logic;
     wave_type : in std_logic;
     dataout : out std_logic_vector(7 downto 0)
 );
end top;

architecture awg of top is

    component Generator is 
        port(
            clk         : in STD_LOGIC;
            reset       : in STD_LOGIC;
            wave_type   : in STD_LOGIC;
            dataout     : out STD_LOGIC_VECTOR (7 downto 0)
        );
    
    end component;     
    component ila_0
        port(
            clk         : in std_logic;
            probe0      : in std_logic_vector(0 downto 0);
            probe1      : in std_logic_vector(0 downto 0);
            probe2      : in std_logic_vector(7 downto 0)     
        );
    end component;
    
    signal reset_ff , reset_ff_ff , reset_ff_ff_ff  : std_logic;
    signal wave_type_ff : std_logic;
    signal output_wave : std_logic_vector(7 downto 0);
    signal output_wave_ff : std_logic_vector(7 downto 0);
    
begin


wave_gen : Generator
    port map (
        clk => clk,
        reset => reset_ff_ff_ff,
        wave_type => wave_type_ff,
        dataout => output_wave
    );

analyzer : ila_0
    port map (
        clk => clk,
        probe0(0) => reset_ff_ff_ff,
        probe1(0) => wave_type_ff,
        probe2 => output_wave
    );
 --   
 PROCESS(clk) IS
   BEGIN
    IF RISING_EDGE(clk) THEN    
        --Filtrage du bouton reset    
        reset_ff <= reset;    
        reset_ff_ff <= reset_ff;
        reset_ff_ff_ff <= reset_ff AND reset_ff_ff AND NOT(reset);
        
        wave_type_ff <= wave_type;
        
        output_wave_ff <= output_wave; 
    END IF;    
   END PROCESS;
   
    dataout  <= output_wave_ff;

end awg;
