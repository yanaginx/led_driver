module LEDdriver (input CLOCK_50,
                  input [8:0] SW, //[1:0]SW: mode selector, [4:2]SW: state selector for mode 4, [8:5]SW: Select clock divider
                  input KEY0, //synchronous reset
                  output [17:0]  LEDR,
                  output [6:0]   HEX0,
                  output [6:0]   HEX1,
                  output [6:0]   HEX2,
                  output [6:0]   HEX3,
                  output [6:0]   HEX4
                  );

   wire [1:0]   running_mode;
   wire [2:0]   mode1running_state;
   wire [2:0]   mode2running_state;
   wire [2:0]   mode3running_state;
   wire [2:0]   mode4running_state;
   wire onebitconcate = 1'b0;
   wire [1:0]  twobitconcate = 2'b00;
   wire PULSE;
   wire [3:0]  mode_indicator;
   wire [1:0]  mode_sel;
   wire [2:0]  state_sel;
   wire [17:0] mode1LEDR;
   wire [17:0] mode2LEDR;
   wire [17:0] mode3LEDR;
   wire [17:0] mode4LEDR;
   wire rv_KEY0;

   //assign mode_sel = SWmode;
   //assign state_sel = SWstate;
   //assign running_mode = SWmode;
   assign mode_sel = SW[1:0];
   assign state_sel = SW[4:2];
   assign running_mode = SW[1:0];
   assign rv_KEY0 = !KEY0;

   led7seg LEDHEX0 (.bcd_in({twobitconcate,running_mode}),
                    .enabler(1'b1),
                    .out_7seg(HEX0));
                    
   led7seg LEDHEX1 (.bcd_in({onebitconcate,mode1running_state}),
                    .enabler(mode_indicator[0]),
                    .out_7seg(HEX1));

   led7seg LEDHEX2 (.bcd_in({onebitconcate,mode2running_state}),
                    .enabler(mode_indicator[1]),
                    .out_7seg(HEX2));
                    
   led7seg LEDHEX3 (.bcd_in({onebitconcate,mode3running_state}),
                    .enabler(mode_indicator[2]),
                    .out_7seg(HEX3));

   led7seg LEDHEX4 (.bcd_in({onebitconcate,mode4running_state}),
                    .enabler(mode_indicator[3]),
                    .out_7seg(HEX4));                 

   clock_div CLOCKDIV (.clk(CLOCK_50), 
                       .reset(1'b1), 
                       .hz_in(SW[8:5]),
                       .hz_out(PULSE));

   ledChooserforMode LCM (.ledmode1(mode1LEDR),
                          .ledmode2(mode2LEDR),
                          .ledmode3(mode3LEDR),
                          .ledmode4(mode4LEDR),
                          .reset(rv_KEY0),
                          .modeselector(mode_sel),
                          .ledmodeOut(LEDR));

   modeChooser MC (.selector(mode_sel),
                   .mode(mode_indicator));

   //real time runnin
   mode4 M4(.PULSE(PULSE),               
            .RESET(rv_KEY0),
            .MODE4_ON(mode_indicator[3]),
            .state_selector(state_sel),
            .LEDr4(mode4LEDR),
            .state(mode4running_state)); 

   mode3 M3 (.PULSE(PULSE),               
             .RESET(rv_KEY0),
             .MODE3_ON(mode_indicator[2]),
             .LEDr3(mode3LEDR),
             .state(mode3running_state)); 
                 
   mode2 M2 (.PULSE(PULSE),               
             .RESET(rv_KEY0),
             .MODE2_ON(mode_indicator[1]),
             .LEDr2(mode2LEDR),
             .state(mode2running_state));      

   mode1 M1 (.PULSE(PULSE),               
             .RESET(rv_KEY0),
             .MODE1_ON(mode_indicator[0]),
             .LEDr1(mode1LEDR),
             .state(mode1running_state));                

   //simulatin
//   mode4 M4(.PULSE(CLOCK_50),               
//            .RESET(rv_KEY0),
//            .MODE4_ON(mode_indicator[3]),
//            .state_selector(state_sel),
//            .LEDr4(mode4LEDR),
//            .state(mode4running_state)); 
//
//   mode3 M3 (.PULSE(CLOCK_50),               
//             .RESET(rv_KEY0),
//             .MODE3_ON(mode_indicator[2]),
//             .LEDr3(mode3LEDR),
//             .state(mode3running_state)); 
//                 
//   mode2 M2 (.PULSE(CLOCK_50),               
//             .RESET(rv_KEY0),
//             .MODE2_ON(mode_indicator[1]),
//             .LEDr2(mode2LEDR),
//             .state(mode2running_state));      
//
//   mode1 M1 (.PULSE(CLOCK_50),               
//             .RESET(rv_KEY0),
//             .MODE1_ON(mode_indicator[0]),
//             .LEDr1(mode1LEDR),
//             .state(mode1running_state));                

             
endmodule
          