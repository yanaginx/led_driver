module states6 (input clk,
                input st6Begin, //states 6 will be running
                input async_rs, //asynchronous reset
                input enabler,
                output [17:0] out,
                output st6Over); //states 6 has done
                
reg [17:0] r_out;
reg r_st6Over;
reg finishloading;
reg localReset;

initial 
   begin 
      r_out = 18'b0000_0000_0000_0000_01;
      r_st6Over = 0;
      finishloading = 0;
      localReset = 0;
   end

always @ (posedge clk, posedge async_rs, posedge localReset) 
   begin
            if (async_rs == 1 || localReset == 1) 
               begin
                  r_out <= 18'b0000_0000_0000_0000_01;
                  r_st6Over <= 0;
                  finishloading <= 0;
                  localReset <= 0;
               end //if async_rs = 1 or the cycle has been over => reset all value
            else 
               begin 
                  if (st6Begin == 1 && enabler == 1)
                     begin               
                        if (finishloading == 0) 
                           begin
                              r_out <= (r_out << 1) + 1'b1;
                              if (r_out == 18'b1111_1111_1111_1111_11) finishloading <= 1; //finished loading all led on
                           end //first cycle: loading led
                        else 
                           begin 
                              r_out <= r_out >> 1;
                              if (r_out == 18'b0000_0000_0000_0000_01) r_st6Over <= 1; //prepare to end the state
                              if (r_out == 18'b0000_0000_0000_0000_00) localReset <= 1; //prepare to reset cycle
                           end //second cycle: unloading led
                     end //st6 started running            
                  if (enabler == 0 || st6Begin == 0)
                     begin
                        r_out <= 18'b0000_0000_0000_0000_01;
                        r_st6Over <= 0;
                        finishloading <= 0;
                        localReset <= 0;
                     end
               end //else reset = 0
   end //always clk
 
assign out = r_out;
assign st6Over = r_st6Over;

endmodule



                