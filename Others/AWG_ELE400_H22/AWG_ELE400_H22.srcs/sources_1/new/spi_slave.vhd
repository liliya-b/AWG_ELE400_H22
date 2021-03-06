----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2022 10:16:27 PM
-- Design Name: 
-- Module Name: spi_slave - comm
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
use IEEE.NUMERIC_STD.ALL;
use ieee.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi_slave is
GENERIC(
    cpol    : STD_LOGIC := '0';  --spi clock polarity mode
    cpha    : STD_LOGIC := '0';  --spi clock phase mode
    d_width : INTEGER := 8);     --data width in bits
  PORT(
    sclk         : IN     STD_LOGIC;  --spi clk from master
    reset_n      : IN     STD_LOGIC;  --active low reset
    ss_n         : IN     STD_LOGIC;  --active low slave select
    mosi         : IN     STD_LOGIC;  --master out, slave in
    rx_req       : IN     STD_LOGIC;  --'1' while busy = '0' moves data to the rx_data output
    st_load_en   : IN     STD_LOGIC;  --asynchronous load enable
    tx_load_en   : IN     STD_LOGIC;  --asynchronous transmit buffer load enable
    tx_load_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --asynchronous tx data to load
    rx_data      : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receive register output to logic
    busy         : OUT    STD_LOGIC := '0';  --busy signal to logic ('1' during transaction)
    miso         : OUT    STD_LOGIC := 'Z'); --master in, slave out
end spi_slave;

architecture comm of spi_slave is

SIGNAL mode    : STD_LOGIC;  --groups modes by clock polarity relation to data
  SIGNAL clk     : STD_LOGIC;  --clock
  SIGNAL bit_cnt : STD_LOGIC_VECTOR(d_width+8 DOWNTO 0);  --'1' for active transaction bit
  SIGNAL wr_add  : STD_LOGIC;  --address of register to write ('0' = receive, '1' = status)
  SIGNAL rd_add  : STD_LOGIC;  --address of register to read ('0' = transmit, '1' = status)
  SIGNAL rx_buf  : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receiver buffer
  SIGNAL tx_buf  : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --transmit buffer
BEGIN
  busy <= NOT ss_n;  --high during transactions
  
  --adjust clock so writes are on rising edge and reads on falling edge
  mode <= cpol XOR cpha;  --'1' for modes that write on rising edge
  WITH mode SELECT
    clk <= sclk WHEN '1',
           NOT sclk WHEN OTHERS;

  --keep track of miso/mosi bit counts for data alignmnet
  PROCESS(ss_n, clk)
  BEGIN
    IF(ss_n = '1' OR reset_n = '0') THEN                         --this slave is not selected or being reset
     bit_cnt <= (conv_integer(NOT cpha) => '1', OTHERS => '0'); --reset miso/mosi bit count
    ELSE                                                         --this slave is selected
      IF(rising_edge(clk)) THEN                                  --new bit on miso/mosi
        bit_cnt <= bit_cnt(d_width+8-1 DOWNTO 0) & '0';          --shift active bit indicator
      END IF;
    END IF;
  END PROCESS;

  PROCESS(ss_n, clk, st_load_en, tx_load_en, rx_req)
  BEGIN
  
    --write address register ('0' for receive, '1' for status)
    IF(bit_cnt(1) = '1' AND falling_edge(clk)) THEN
      wr_add <= mosi;
    END IF;

    --read address register ('0' for transmit, '1' for status)
    IF(bit_cnt(2) = '1' AND falling_edge(clk)) THEN
      rd_add <= mosi;
    END IF;
        
 
    --receive registers
    --write to the receive register from master
    IF(reset_n = '0') THEN
      rx_buf <= (OTHERS => '0');
    ELSE
      FOR i IN 0 TO d_width-1 LOOP          
        IF(wr_add = '0' AND bit_cnt(i+9) = '1' AND falling_edge(clk)) THEN
          rx_buf(d_width-1-i) <= mosi;
        END IF;
      END LOOP;
    END IF;
    --fulfill user logic request for receive data
    IF(reset_n = '0') THEN
      rx_data <= (OTHERS => '0');
    ELSIF(ss_n = '1' AND rx_req = '1') THEN  
      rx_data <= rx_buf;
    END IF;

    --transmit registers
    IF(reset_n = '0') THEN
      tx_buf <= (OTHERS => '0');
    ELSIF(ss_n = '1' AND tx_load_en = '1') THEN  --load transmit register from user logic
      tx_buf <= tx_load_data;
    ELSIF(rd_add = '0' AND bit_cnt(7 DOWNTO 0) = "00000000" AND bit_cnt(d_width+8) = '0' AND rising_edge(clk)) THEN
      tx_buf(d_width-1 DOWNTO 0) <= tx_buf(d_width-2 DOWNTO 0) & tx_buf(d_width-1);  --shift through tx data
    END IF;

    --miso output register
    IF(ss_n = '1' OR reset_n = '0') THEN           --no transaction occuring or reset
      miso <= 'Z';
    ELSIF(rising_edge(clk)) THEN
      IF(rd_add = '1') THEN  --write status register to master
        CASE bit_cnt(10 DOWNTO 8) IS
          WHEN "001" => miso <= trdy;
          WHEN "010" => miso <= rrdy;
          WHEN "100" => miso <= roe;
          WHEN OTHERS => NULL;
        END CASE;
      ELSIF(rd_add = '0' AND bit_cnt(7 DOWNTO 0) = "00000000" AND bit_cnt(d_width+8) = '0') THEN
        miso <= tx_buf(d_width-1);                  --send transmit register data to master
      END IF;
    END IF;
    
  END PROCESS;

end comm;
