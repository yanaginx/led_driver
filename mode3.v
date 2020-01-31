module mode3 (input PULSE,               
              input RESET,
              input MODE3_ON,
              output [17:0]LEDr3,
              output [2:0]state); 
              
// MODE3: even-cycling state
      
wire [5:0]STBegin, STOver; //begin and over state indicator
wire [2:0]STATE;
wire [17:0]State1LEDr3;
wire [17:0]State2LEDr3;
wire [17:0]State3LEDr3;
wire [17:0]State4LEDr3;
wire [17:0]State5LEDr3;
wire [17:0]State6LEDr3;

reg [2:0]STATE_reg, STATE_next;

initial STATE_reg = 1;

localparam  // 6 states are required
    state1 = 3'b000, //STBegin[0] = 1
    state2 = 3'b001, //STBegin[1] = 1
    state3 = 3'b010, //STBegin[2] = 1
    state4 = 3'b011, //STBegin[3] = 1
    state5 = 3'b100, //STBegin[4] = 1
    state6 = 3'b101; //STBegin[5] = 1 
    
always @ (posedge PULSE, posedge RESET) //using the divided clock to operate
   begin
      if (RESET == 1) STATE_reg <= state2; //go to state 1 if reset
      else 
         begin
            STATE_reg <= STATE_next;   //else update the states
            if (MODE3_ON == 0) STATE_reg <= state2;
         end
   end
   
always @ (STATE_reg, STOver)
   begin 
   // store current state as next
   STATE_next = STATE_reg; // required: when no case statement is satisfied
      case(STATE_reg)
         state2:
            if (STOver[1]) STATE_next = state4; //if state 2 is over change to state 4
         state4:
            if (STOver[3]) STATE_next = state6; //if state 4 is over change to state 6        
         state6:
            if (STOver[5]) STATE_next = state2; //if state 6 is over change to state 2
      endcase
   end //always


stateChooser STC (.chooser(STATE),
                  .state(STBegin));
                  
ledChooser LCS   (.led1(State1LEDr3),
                  .led2(State2LEDr3),
                  .led3(State3LEDr3),
                  .led4(State4LEDr3),
                  .led5(State5LEDr3),
                  .led6(State6LEDr3),
                  .selector(STATE),
                  .ledOUT(LEDr3));
                 
              
states2 ST2  (.clk(PULSE),
              .st2Begin(STBegin[1]),
              .async_rs(RESET),
              .enabler(MODE3_ON),
              .out(State2LEDr3),
              .st2Over(STOver[1]));

states4 ST4  (.clk(PULSE),
              .st4Begin(STBegin[3]),
              .async_rs(RESET),
              .enabler(MODE3_ON),
              .out(State4LEDr3),
              .st4Over(STOver[3]));

states6 ST6  (.clk(PULSE),
              .st6Begin(STBegin[5]),
              .async_rs(RESET),
              .enabler(MODE3_ON),
              .out(State6LEDr3),
              .st6Over(STOver[5]));              
              
assign STATE = STATE_reg;
assign state = STATE;

endmodule
                 