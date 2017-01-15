/******************************************************************************
*                                                                             *
* Copyright 2016 myStorm Copyright and related                                *
* rights are licensed under the Solderpad Hardware License, Version 0.51      *
* (the “License”); you may not use this file except in compliance with        *
* the License. You may obtain a copy of the License at                        *
* http://solderpad.org/licenses/SHL-0.51. Unless required by applicable       *
* law or agreed to in writing, software, hardware and materials               *
* distributed under this License is distributed on an “AS IS” BASIS,          *
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or             *
* implied. See the License for the specific language governing                *
* permissions and limitations under the License.                              *
*                                                                             *
******************************************************************************/

module chip (
    // 100MHz clock input
    input  clk,
    // SRAM Memory lines
    output [18:0] ADR,
    output [15:0] DAT,
    output RAMOE,
    output RAMWE,
    output RAMCS,
    // QSPI
    input QCK,
    input QCS,
    input [3:0] QD,
    // All PMOD outputs
    output [55:0] PMOD
  );

  wire	rst = 1'b0;		// Reset is active high
  wire [3:0] led_stub;

  // SRAM signals are not use in this design, lets set them to default values
  assign ADR[18:0] = {19{1'b0}};
  assign DAT[15:0] = {16{1'b0}};
  assign RAMOE = 1'b1;
  assign RAMWE = 1'b1;
  assign RAMCS = 1'b1;

  // Set unused pmod pins to default
  assign PMOD[31:0 ] = {32{1'bz}};
  assign PMOD[51:34] = {18{1'bz}};

  pew u0 (
    .clk  (clk),
    .status   ({PMOD[55:52], led_stub}),
    .trigger  (PMOD[33]), // PMOD9/10 = pin9  = 13A
    .pew      (PMOD[32])  // PMOD9/10 = pin11 = 13B
  );

endmodule
