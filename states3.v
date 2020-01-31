module states3 (input clk,
                input st3Begin, //states 3 will be running
                input async_rs, //asynchronous reset
                input enabler,  //if it's on to be running 
                output [17:0] out,
                output st3Over); //states 3 has done
                
reg [17:0] r_out;
reg signed [8:0] r_right;
reg [8:0] r_left;
reg [5:0] counter;
reg r_st3Over;
reg localReset;

initial 
   begin
      r_out = 18'b0000_0000_0000_0000_00;
      r_right = 9'b1000_0000_0;
      r_left = 9'b0000_0000_1;
      r_st3Over = 0;
      counter = 0;
      localReset = 0;
   end

always @ (posedge clk, posedge async_rs, posedge localReset) 
   begin
            if (async_rs == 1 || localReset == 1) 
               begin
                  r_out <= 18'b0000_0000_0000_0000_00;
                  r_left <= 9'b0000_0000_1;
                  r_right <= 9'b1000_0000_0;
                  counter <= 0;
                  localReset <= 0;
                  r_st3Over <= 0;
               end //if async_rs = 1 or the cycle has been over => reset all value
            else 
               begin 
                  if (st3Begin == 1 && enabler == 1)
                     begin
                        if (counter[0] == 0) 
                           begin
                              r_right <= (r_right >>> 1); 
                              r_left <= (r_left << 1) + 1'b1;
                              r_out <= {r_left,r_right}; 
                           end //counter even
                        else r_out <= 18'b0000_0000_0000_0000_00; //counter odd
                        counter = counter + 1'b1;
                        if (r_out == 18'b111111111_111111111) r_st3Over <= 1;  //prepare to end the state
                        if (counter == 19) localReset <= 1; //prepare to reset cycle
                     end
                  if (enabler == 0 || st3Begin == 0)
                     begin
                        r_out <= 18'b0000_0000_0000_0000_00;
                        r_left <= 9'b0000_0000_1;
                        r_right <= 9'b1000_0000_0;
                        counter <= 0;
                        localReset <= 0;
                        r_st3Over <= 0;
                     end
               end //else reset = 0
   end //always clk
 
assign out = r_out;
assign st3Over = r_st3Over;

endmodule



                