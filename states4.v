module states4 (input clk,
                input st4Begin, //states 4 will be running
                input async_rs, //asynchronous reset
                input enabler,  //if it's on to be running
                output [17:0] out,
                output st4Over); //states 4 has done
                
reg [17:0] r_out;
reg signed [8:0] r_left;
reg [8:0] r_right;
reg r_st4Over;
reg localReset;

initial 
   begin
      r_out <= 18'b1111_1111_1111_1111_11;
      r_right <= 9'b1111_1111_1;
      r_left <= 9'b1111_1111_1;
      r_st4Over <= 0;
      localReset <= 0;
   end

always @ (posedge clk, posedge async_rs, posedge localReset) 
   begin
            if (async_rs == 1 || localReset == 1) 
               begin
                  r_out <= 18'b1111_1111_1111_1111_11;
                  r_right <= 9'b1111_1111_0;
                  r_left <= 9'b0111_1111_1; 
                  localReset <= 0;
                  r_st4Over <= 0;
               end //if async_rs = 1 or the cycle has been over => reset all value
            else 
               begin 
                  if (st4Begin == 1 && enabler == 1)
                     begin               
                        r_out <= {r_left,r_right};
                        r_left <= (r_left >> 1); 
                        r_right <= (r_right << 1);
                        if (r_out == 18'b000000001_100000000) r_st4Over <= 1; //prepare to end the state
                        if (r_out == 18'b000000000_000000000) localReset <= 1; //prepare to reset cycle
                     end
                  if (enabler == 0 || st4Begin == 0)
                     begin
                        r_out <= 18'b1111_1111_1111_1111_11;
                        r_right <= 9'b1111_1111_0;
                        r_left <= 9'b0111_1111_1; 
                        localReset <= 0;
                        r_st4Over <= 0;
                     end
               end //else reset = 0 
   end //always clk
 
assign out = r_out;
assign st4Over = r_st4Over;

endmodule



                