module states2 (input clk,
					 input st2Begin, //state 2 will be running
					 input async_rs, //asynchronous reset
                input enabler,  //if it's on to be running
					 output [17:0]out,
					 output st2Over); //state 2 has done

reg [17:0] r_out;
reg r_st2Over;
reg localReset;

initial 
   begin
      r_out <= 18'b0000_0000_0000_0001_11;
      r_st2Over <= 0;
      localReset <= 0;
   end
always @ (posedge clk, posedge async_rs, posedge localReset)
	begin
            if (async_rs == 1 || localReset == 1) 
               begin
                  r_out <= 18'b0000_0000_0000_0001_11;
                  r_st2Over <= 0;
                  localReset <= 0;
               end //if async_rs = 1 or the cycle has been over => reset all value
            else
               begin
                  if (st2Begin == 1 && enabler == 1) 
                     begin
                        r_out <= (r_out << 1);
                        if (r_out == 18'b0111_0000_0000_0000_00) r_st2Over <= 1'b1; //prepare to end the state
                        if (r_out == 18'b1110_0000_0000_0000_00) localReset <= 1'b1; //prepare to reset cycle
                     end
                  if (enabler == 0 || st2Begin == 0)
                     begin
                        r_out <= 18'b0000_0000_0000_0001_11;
                        r_st2Over <= 0;
                        localReset <= 0;
                     end
               end //else async_rs = 0

	end //always clk
	
assign st2Over = r_st2Over;
assign out = r_out;

endmodule
 
	
	