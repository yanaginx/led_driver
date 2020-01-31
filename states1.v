module states1 (input clk,
                input st1Begin, //state 1 will be running
                input async_rs, //asynchronous reset
                input enabler,  //if it's on to be running
                output [17:0]out,
                output st1Over); //state 1 has done

reg [17:0] r_out;
reg r_st1Over;
reg localReset;
reg rs;


initial 
   begin
      r_out <= 18'b1100_0000_0000_0000_00;
      r_st1Over <= 0;
      localReset <= 0;
   end
   
always @ (posedge clk, posedge async_rs, posedge localReset)
	begin
            if (localReset == 1 || async_rs == 1)  
               begin
                  r_out <= 18'b1100_0000_0000_0000_00;
                  r_st1Over <= 0;
                  localReset <= 0;
               end //the cycle has been over => reset all value
            else
               begin
                  if (st1Begin == 1 && enabler == 1) 
                     begin
                        r_out <= (r_out >> 1);
                        if (r_out == 6) r_st1Over <= 1'b1; //prepare to end the state
                        if (r_out == 3) localReset <= 1'b1; //prepare to reset cycle
                     end
                  if (enabler == 0 || st1Begin == 0)
                     begin
                        r_out <= 18'b1100_0000_0000_0000_00;
                        r_st1Over <= 0;
                        localReset <= 0;
                     end
               end //else localReset = 0
	end //always clk
	
assign st1Over = r_st1Over;
assign out = r_out;

endmodule
 
	
	
