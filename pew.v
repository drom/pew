module pew #(
  parameter WIDTH = 36,
  parameter HEIGHT = 128
) (
  clk,
  // led,
  trigger,
  pew,
  status
);

  input clk;
  input trigger;
  output pew;
  output [3:0] status;

  wire int_trigger;
  reg [31:0] run;
  reg [23:0] mem [WIDTH * HEIGHT - 1 : 0];

  wire ping;
  reg go;
  reg tick;
  wire [23:0] data;
  wire dat;

  reg [4:0] ptr0; // bit pointer
  reg [15:0] ptr1; // word in line pointer
  reg [11:0] ptr2; // total word pointer
  reg [11:0] raddr;

  SB_IO #(
    .PIN_TYPE    (6'b000001),
    .PULLUP      (1'b1)
  ) u_trigger (
    .PACKAGE_PIN (trigger),
    .D_IN_0      (int_trigger)
  );

  always @(posedge clk)
    if (int_trigger)
      run <= 0;
    else
      run <= run + 1;

  initial $readmemh("pew.txt", mem);

  assign ping = run[20];

  always @(posedge clk)
    if (~ping)
      ptr0 <= 23;
    else
      if (tick) begin
        if (ptr0 == 0) ptr0 <= 5'd23;
        else           ptr0 <= ptr0 - 5'b1;
      end

  always @(posedge clk)
    if (~ping) begin
      ptr1 <= 0;
      go <= 1'b1;
    end else if (tick) begin
      if (ptr0 == 0) begin
        if (ptr1 > 34) begin
          go <= 1'b0;
        end else begin
          ptr1 <= ptr1 + 16'b1;
        end
      end
    end

  assign ptr2 = (run[28:27] == 0) ? (run[26:20] * 6'd36) : 0;

  always @(posedge clk)
    raddr <= ptr1 + ptr2;

  assign data = mem[raddr];
  assign dat = data[ptr0];

  // fast FSM
  reg state, nxt_state;
  reg [15:0] timer0, nxt_timer0;

  always @(posedge clk) timer0 <= nxt_timer0;
  always @(posedge clk) state  <= nxt_state;

  wire timer0_zero;
  assign timer0_zero = ~|timer0;

  always @(*) begin
    nxt_state = state;
    tick = 1'b0;
    nxt_timer0 = (timer0 - 16'b1);
    if (ping & go)
        if (~state) begin
            if (timer0_zero) begin
                nxt_state = ~state;
                if (dat) nxt_timer0 = 69; // 34
                else     nxt_timer0 = 35; // 17
            end
        end else begin
            if (timer0_zero) begin
                tick = 1'b1;
                nxt_state = ~state;
                if (dat) nxt_timer0 = 59; // 29
                else     nxt_timer0 = 79; // 39
            end
        end
    else begin
        nxt_state = 1'b0;
        nxt_timer0 = 4999; // 2499 = 100us reset
    end
  end

  // assign pew = run[24];
  assign pew = state & ping;
  assign status = run[27:24];

endmodule
