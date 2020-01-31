module mode2 (input PULSE,               
              input RESET,
              input MODE2_ON,
              output [17:0]LEDr2,
              output [2:0]state); 
              
// MODE2: odd-cycling state
      
wire [5:0]STBegin, STOver; //begin and over state indicator
wire [2:0]STATE;
wire [17:0]State1LEDr2;
wire [17:0]State2LEDr2;
wire [17:0]State3LEDr2;
wire [17:0]State4LEDr2;
wire [17:0]State5LEDr2;
wire [17:0]State6LEDr2;

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
         begin
            STATE_reg <= STATE_next;   //else update the states
            if (MODE2_ON == 0) STATE_reg <= state1;
         end
   end
   
always @ (STATE_reg, STOver)
   begin 
   // store current state as next
   STATE_next = STATE_reg; // required: when no case statement is satisfied
      case(STATE_reg)
         state1:
            if (STOver[0]) STATE_next = state3; //if state 1 is over change to state 3
         state3:
            if (STOver[2]) STATE_next = state5; //if state 3 is over change to state 4        
         state5:
            if (STOver[4]) STATE_next = state1; //if state 5 is over change to state 1
      endcase
   end //always


stateChooser STC (.chooser(STATE),
                  .state(STBegin));
                  
ledChooser LCS   (.led1(State1LEDr2),
                  .led2(State2LEDr2),
                  .led3(State3LEDr2),
                  .led4(State4LEDr2),
                  .led5(State5LEDr2),
                  .led6(State6LEDr2),
                  .selector(STATE),
                  .ledOUT(LEDr2));
                  
states1 ST1  (.clk(PULSE),
              .st1Begin(STBegin[0]),
              .async_rs(RESET),
              .enabler(MODE2_ON),
              .out(State1LEDr2),
              .st1Over(STOver[0]));
              
states3 ST3  (.clk(PULSE),
              .st3Begin(STBegin[2]),
              .async_rs(RESET),
              .enabler(MODE2_ON),
              .out(State3LEDr2),
              .st3Over(STOver[2]));
             
states5 ST5  (.clk(PULSE),
              .st5Begin(STBegin[4]),
              .async_rs(RESET),
              .enabler(MODE2_ON),
              .out(State5LEDr2),
              .st5Over(STOver[4]));

assign STATE = STATE_reg;
assign state = STATE;

endmodule
                 