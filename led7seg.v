module led7seg(input [3:0]bcd_in,
               input enabler,
               output [6:0]out_7seg);

reg [6:0] r_out_7seg;
                    
always @(bcd_in, enabler)
   begin
      if (enabler)
         case (bcd_in)
            4'd0: r_out_7seg = 7'b1000000;
            4'd1: r_out_7seg = 7'b1111001;
            4'd2: r_out_7seg = 7'b0100100;
            4'd3: r_out_7seg = 7'b0110000;
            4'd4: r_out_7seg = 7'b0011001;
            4'd5: r_out_7seg = 7'b0010010;
            4'd6: r_out_7seg = 7'b0000010;
            4'd7: r_out_7seg = 7'b1111000;
            4'd8: r_out_7seg = 7'b0000000;
            4'd9: r_out_7seg = 7'b0010000;
            default: r_out_7seg = 7'b1111111;
         endcase
      else r_out_7seg = 7'b1111111;
   end //always
   
assign out_7seg = r_out_7seg;

endmodule
