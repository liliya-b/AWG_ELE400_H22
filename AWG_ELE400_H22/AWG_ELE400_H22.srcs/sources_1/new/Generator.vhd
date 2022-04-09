----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 10:51:45 AM
-- Design Name: 
-- Module Name: Generator - Behavioral
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

entity Generator is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           cmd  : in STD_LOGIC_VECTOR(9 DOWNTO 0); -- À ADAPTER
           dataout : out STD_LOGIC_VECTOR (15 downto 0));
end Generator;

architecture Wave_generator of Generator is

    CONSTANT TAILLE_ROM : positive := 30;
    TYPE romtype IS ARRAY (0 TO TAILLE_ROM) OF std_logic_vector(7 downto 0);
    
    signal i : integer := 0;
    
    -- À ADAPTER section passage de commande
    signal wave_type : integer := 0; --PORTION DE LA COMMANDE
    signal repetition_rate : integer := 0; --PORTION DE LA COMMANDE

---- SINC WAVE WITH 30 SAMPLES----  
CONSTANT SincRom : romtype :=(
    0 =>    "00000000",  --0 : 0
    1 =>    "11101000",  --1 : -24
    2 =>    "11101100",  --2 : -20
    3 =>    "00011110",  --3 : 30
    4 =>    "01100000",  --4 : 96
    5 =>    "11111111",  --5 : 127
    6 =>    "01100000",  --6 : 96
    7 =>    "00011110",  --7 : 30
    8 =>    "11101100",  --8 : -20
    9 =>    "11101000",  --9 : -24
    10 =>   "00000000",  --10: 0
    11 =>   "00000000",  --11: 0
    12 =>   "00000000",  --12: 0
    13 =>   "00000000",  --13: 0
    14 =>   "00000000",  --14: 0
    15 =>   "00000000",  --15: 0
    16 =>   "00000000",  --16: 0
    17 =>   "00000000",  --17: 0
    18 =>   "00000000",  --18: 0
    19 =>   "00000000",  --19: 0
    20 =>   "00000000",  --20: 0
    21 =>   "00000000",  --21: 0
    22 =>   "00000000",  --22: 0
    23 =>   "00000000",  --23: 0
    24 =>   "00000000",  --24: 0
    25 =>   "00000000",  --25: 0
    26 =>   "00000000",  --26: 0
    27 =>   "00000000",  --27: 0
    28 =>   "00000000",  --28: 0
    29 =>   "00000000",  --29: 0
    30 =>   "00000000");  --30: 0

---- GAUSSIAN WAVE WITH 30 SAMPLES----  
CONSTANT GaussRom : romtype :=(
    0 =>    "01000000",  --0 : 64
    1 =>    "01010010",  --1 : 82
    2 =>    "01011100",  --2 : 99
    3 =>    "01100110",  --3 : 102
    4 =>    "01111100",  --4 : 124
    5 =>    "11111111",  --5 : 127
    6 =>    "01111100",  --6 : 124
    7 =>    "01100110",  --7 : 102
    8 =>    "01011100",  --8 : 99
    9 =>    "01010010",  --9 : 82
    10 =>   "01000000",  --10: 64
    11 =>   "00000000",  --11: 0
    12 =>   "00000000",  --12: 0
    13 =>   "00000000",  --13: 0
    14 =>   "00000000",  --14: 0
    15 =>   "00000000",  --15: 0
    16 =>   "00000000",  --16: 0
    17 =>   "00000000",  --17: 0
    18 =>   "00000000",  --18: 0
    19 =>   "00000000",  --19: 0
    20 =>   "00000000",  --20: 0
    21 =>   "00000000",  --21: 0
    22 =>   "00000000",  --22: 0
    23 =>   "00000000",  --23: 0
    24 =>   "00000000",  --24: 0
    25 =>   "00000000",  --25: 0
    26 =>   "00000000",  --26: 0
    27 =>   "00000000",  --27: 0
    28 =>   "00000000",  --28: 0
    29 =>   "00000000",  --29: 0
    30 =>   "00000000");  --30: 0

begin

PROCESS(clk)
    BEGIN
    
    IF(RISING_EDGE(clk)) THEN
    
        IF reset = '1' THEN
        
        i <= 0;
        
        ELSE
            
            IF wave_type = 1 then
            
             dataout <= GaussRom(i);
             
            ELSE 
            
             dataout <= SincRom(i);
        
            END IF;
            
            i<= i+1;
    
            IF(i = 30) THEN
            i<=0;
        
            END IF;
        END IF;
    END IF;
END PROCESS;

end Wave_generator;
