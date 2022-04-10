----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2022 10:25:27 PM
-- Design Name: 
-- Module Name: Wrapper - Behavioral
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

entity Wrapper is
PORT(sclk : in STD_LOGIC; -- Signal de clock venant du Arduino
     mosi : in STD_LOGIC; -- Master Out Slave In
     ss_n : in STD_LOGIC; -- Slave select (quand low, le master parle au slave (arduino parle au fpga))
     miso : out STD_LOGIC; -- Master In Slave Out
     dataout : out STD_LOGIC_VECTOR (15 downto 0));--Waveform en sortie
end Wrapper;

architecture Behavioral of Wrapper is
            --Signaux de communication entre les modules
           SIGNAL busy_sig,rx_req_sig,reset_n_sig,tx_load_en_sig : STD_LOGIC; --SIGNAUX entre les 2 modules 
           SIGNAL sclk_sig,mosi_sig,ss_n_sig,miso_sig : STD_LOGIC; -- Signaux entre les pin de sortie et le module SPI
           SIGNAL rx_data_sig, tx_load_data_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
           SIGNAL dataout : STD_LOGIC_VECTOR(15 downto 0);
           
begin
    SPI :        entity work.spi_slave(comm)
                 PORT MAP(sclk=>sclk_sig,mosi=>mosi_sig ); -- Branchements entre le module SPI et le generateur
    
    Generateur : entity work.Generator(Wave_generator)
                 PORT MAP(busy=busy_sig);

end Behavioral;
