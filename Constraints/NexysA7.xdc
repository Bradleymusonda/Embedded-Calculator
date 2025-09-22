
## Nexys A7 Constraints Template (enable actual pins using Digilent Master XDC)
## Port names are chosen to match Digilent defaults used in their XDC:
##  - CLK100MHZ, btnC, btnU, btnL, btnR, btnD, sw[15:0], an[7:0], seg[6:0], dp
## Open the official 'Nexys-A7-Master.xdc' and uncomment the lines to bind pins.

## Clock
#set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {CLK100MHZ}];
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];

## Buttons
## set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports {btnC}];
## set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports {btnU}];
## set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports {btnL}];
## set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports {btnR}];
## set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports {btnD}];

## Switches
## Example for sw[0]..sw[15] (verify pins in Digilent XDC)
## set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {sw[0]}];
## ...
## set_property -dict { PACKAGE_PIN V4  IOSTANDARD LVCMOS33 } [get_ports {sw[15]}];

## Seven Segment Anodes (active-low)
## set_property -dict { PACKAGE_PIN U2  IOSTANDARD LVCMOS33 } [get_ports {an[0]}];
## ...
## set_property -dict { PACKAGE_PIN V5  IOSTANDARD LVCMOS33 } [get_ports {an[7]}];

## Seven Segment Segments (active-high here; invert externally if needed)
## set_property -dict { PACKAGE_PIN W7  IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]; # a
## set_property -dict { PACKAGE_PIN W6  IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]; # b
## set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]; # c
## set_property -dict { PACKAGE_PIN V8  IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]; # d
## set_property -dict { PACKAGE_PIN U5  IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]; # e
## set_property -dict { PACKAGE_PIN V5  IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]; # f
## set_property -dict { PACKAGE_PIN U7  IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]; # g
## set_property -dict { PACKAGE_PIN V7  IOSTANDARD LVCMOS33 } [get_ports {dp}];     # dp

## LEDs (optional)
## set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {led[0]}];
## ...
## set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {led[15]}];
