module mode4 (input PULSE,               
              input RESET,
              input MODE4_ON,
              input [2:0]state_selector,
              output [17:0]LEDr4,
              output [2:0]state); 
              
// MODE4: use switch to choose state
      
wire [5:0]STBegin, STOver; //begin and over state indicator
wire [2:0]STATE;
wire [17:0]State1LEDr4;
wire [17:0]State2LEDr4;
wire [17:0]State3LEDr4;
wire [17:0]State4LEDr4;
wire [17:0]State5LEDr4;
wire [17:0]State6LEDr4;

reg [2:0]STATE_reg, STATE_next;

initial STATE_reg = 0;

localparam  // 6 states are required
    state1 = 3'b000, //STBegin[0] = 1
    state2 = 3'b001, //STBegin[1] = 1
    state3 = 3'b010, //STBegin[2] = 1
    state4 = 3'b011, //STBegin[3] = 1
    state5 = 3'b100, //STBegin[4] = 1
    state6 = 3'b101; //STBegin[5] = 1 
    
always @ (posedge PULSE, posedge RESET) //using the divided clock to operate
   begin
      if (RESET == 1) STATE_reg <= state1; //go to state 1 if reset
      else 
         STATE_reg <= state_selector;   //else choose the states as selected
   end
   
stateChooser STC (.chooser(state_selector),
                  .state(STBegin));
                  
ledChooser LCS   (.led1(State1LEDr4),
                  .led2(State2LEDr4),
                  .led3(State3LEDr4),
                  .led4(State4LEDr4),
                  .led5(State5LEDr4),
                  .led6(State6LEDr4),
                  .selector(state_selector),
                  .ledOUT(LEDr4));
                  
states1 ST1  (.clk(PULSE),
              .st1Begin(STBegin[0]),
              .async_rs(RESET),
              .enabler(MODE4_ON),
              .out(State1LEDr4),
              .st1Over(STOver[0]));
              
states2 ST2  (.clk(PULSE),
              .st2Begin(STBegin[1]),
              .async_rs(RESET),
              .enabler(MODE4_ON),
              .out(State2LEDr4),
              .st2Over(STOver[1]));
              
states3 ST3  (.clk(PULSE),
              .st3Begin(STBegin[2]),
              .async_rs(RESET),
              .enabler(MODE4_ON),
              .out(State3LEDr4),
              .st3Over(STOver[2]));
              
states4 ST4  (.clk(PULSE),
              .st4Begin(STBegin[3]),
              .async_rs(RESET),
              .enabler(MODE4_ON),
              .out(State4LEDr4),
              .st4Over(STOver[3]));
              
states5 ST5  (.clk(PULSE),
              .st5Begin(STBegin[4]),
              .async_rs(RESET),
              .enabler(MODE4_ON),
              .out(State5LEDr4),
              .st5Over(STOver[4]));
              
states6 ST6  (.clk(PULSE),
              .st6Begin(STBegin[5]),
              .async_rs(RESET),
              .enabler(MODE4_ON),
              .out(State6LEDr4),
              .st6Over(STOver[5]));              
              
assign STATE = STATE_reg;
assign state = STATE;

endmodule
                 