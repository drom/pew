module chip (
  clk,
  // trigger,
  LED
);

input clk;
// input trigger;
output [7:0] LED;

// SB_IO #(
//   .PIN_TYPE    (6'b000001),
//   .PULLUP      (1'b1)
// ) u_trigger (
//   .PACKAGE_PIN (trigger),
//   .D_IN_0      (int_trigger)
// );

pew u0 (
    .clk      (clk),
    .status   (LED)
    // .trigger  (1'b0)
    // .pew      ()
);

endmodule
