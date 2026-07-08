# ? Single-Port RAM (Random Access Memory)

[![Language: SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-00599C?style=for-the-badge&logo=c&logoColor=white)](#)
[![Design: RTL](https://img.shields.io/badge/Design-RTL_Logic-FF4136?style=for-the-badge)](#)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](#)
[![Status: Verified](https://img.shields.io/badge/Status-Verified-2ECC40?style=for-the-badge)](#)

> **A robust, synthesizable Single-Port RAM module designed and verified using SystemVerilog.** 
> Features parameterized data and address widths, synchronous read/write operations, and comprehensive testbench coverage.

---

## ? Architecture Schematic

Below is the ASCII block diagram illustrating the structural flow of the Single-Port RAM. Since it uses a single port, the read and write operations share the same data and address buses, controlled by the Write Enable (`we`) signal.

```text
 
                   +-----------------------------------------------+
                   |                                               |
                   |               SINGLE PORT RAM                 |
  [ADDR_WIDTH-1:0] |                                               |  [DATA_WIDTH-1:0]
      addr =======>|---[ Address Decoder ]                         |=======> data_out
                   |           |                                   |
                   |           v                                   |
  [DATA_WIDTH-1:0] |    +-------------------+                      |
      data_in ====>|===>|                   |                      |
                   |    |   Memory Array    |---[ Read Latch ]     |
                   |    |  (2^ADDR x DATA)  |                      |
                   |    |                   |                      |
                   |    +-------------------+                      |
            we --->|----------[ Control Logic ]                    |
                   |                                               |
           clk --->|-----------------------------------------------+
                   |                                               |
                   +-----------------------------------------------+

                      Legend: ===> Data/Bus Lines   ---> Control Signals
