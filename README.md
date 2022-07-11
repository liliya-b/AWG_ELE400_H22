# AWG_ELE400_H22

Waveform generator VHDL design for Ki3 Photonics. Completed as part of the course ELE400 at École de technologie supérieure.

## Directories

This project contains many files, but only a few are necessary to reproduce the result demonstrated to Ki3 Photonics. These files are in the `VHD_files` folder.

| Directory | Contents |
| ------ | ------ |
| `VHD_files` | Contains all .vhd files that are use to produce the waveforms, including the testbench file. |
| `Others` | Contains some files used for local implementation. |

## Structure

This project, like any other VHDL project, can be be implemented in two separate ways : 

1. On a computer, with the testbench file as the Vivado project's top design source. This is used to monitor the expected values without implementing on a physical FPGA. 

2. On an FPGA, with the top file as the Vivado project's top design source. To monitor the physical signals on the FPGA, this project makes use of the [ILA IP](https://www.xilinx.com/products/intellectual-property/ila.html) from Xilinx. 

## Usage

This project was completed using Vivado ML, under the 2021.2 version. The software can be downloaded from the [Xilinx Download Center](https://www.xilinx.com/support/download.html). 

__To run the testbench__, create a new project in Vivado and add files `Generator.vhd` and `Generator_tb.vhd` to your project. The top file should be `Generator_tb.vhd`. The design then needs to be synthesized, after which you will be able to visualize the signals in your preferred simulation environment by running the implementation. Xilinx offers an integrated behavioral simulation environment in their Vivado ML software. The Modelsim software is preferred for scripted simulation. 

__To run on an FPGA__, create a new project in Vivado and add files `Generator.vhd` and `top.vhd` to your project. The top file should be `top.vhd`. It is important to choose the correct FPGA board in the project creation. The design then needs to be synthesized and the bistream generated. If a proper FPGA is connected to your computer, you should be able to upload the bitstream to the device. 

The default project is created for the [Basys3](https://digilent.com/shop/basys-3-artix-7-fpga-trainer-board-recommended-for-introductory-users/) development board by Digilent. The reset button is programmed to be BTNC (U18), the middle pushbutton. The wavetype selector is programmed to be SW15, the outer slide switch.
