module states5 (input clk,
                input st5Begin, //states 5 will be running
                input async_rs, //asynchronous reset
                input enabler,  //if it's on to be running
                output [17:0] out,
                output st5Over); //states 5 has done
                
reg signed [17:0] r_out;
reg r_st5Over;
reg finishloading;
reg localReset;

initial 
   begin 
      r_out = 18'b1000_0000_0000_0000_00;
      r_st5Over = 0;
      finishloading = 0;
      localReset = 0;
   end

always @ (posedge clk, posedge async_rs, posedge localReset) 
   begin
            if (async_rs == 1 || localReset == 1) 
               begin
                  r_out <= 18'b1000_0000_0000_0000_00;
                  finishloading <= 0;
                  localReset <= 0;
                  r_st5Over <= 0;
               end //if async_rs = 1 or the cycle has been over => reset all value
            else 
               begin 
                  if (st5Begin == 1 && enabler == 1)
                     begin               
                        if (finishloading == 0) 
                           begin
                              r_out <= r_out >>> 1;
                              if (r_out == 18'b1111_1111_1111_1111_11) finishloading <= 1; //finished loading all led on
                           end //first cycle: loading led
                        else 
                           begin 
                              r_out <= r_out << 1;
                              if (r_out == 18'b1000_0000_0000_0000_00) r_st5Over <= 1; //prepare to end the state
                              if (r_out == 18'b0000_0000_0000_0000_00) localReset <= 1; //prepare to reset cycle
                           end //second cycle: unloading led
                     end //st5 started running
                  if (enabler == 0 || st5Begin == 0) 
                     begin
                        r_out <= 18'b1000_0000_0000_0000_00;
                        finishloading <= 0;
                        localReset <= 0;
                        r_st5Over <= 0;
                     end
            end //else reset = 0
   end //always clk
 
assign out = r_out;
assign st5Over = r_st5Over;

endmodule



                