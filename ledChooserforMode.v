module ledChooserforMode (input [17:0]ledmode1,
                          input [17:0]ledmode2,
                          input [17:0]ledmode3,
                          input [17:0]ledmode4,
                          input [1:0]modeselector,
                          input reset,
                          output [17:0]ledmodeOut);
                          
reg [17:0] r_ledmodeOut;


always @ (reset, modeselector, ledmode1, ledmode2, ledmode3, ledmode4)
   begin
   if (reset) r_ledmodeOut = 18'b0000_0000_0000_0000_00;
   else
      case (modeselector)
         2'b00: r_ledmodeOut = ledmode1;
         2'b01: r_ledmodeOut = ledmode2;   
         2'b10: r_ledmodeOut = ledmode3;   
         2'b11: r_ledmodeOut = ledmode4;   
      endcase
   end
   
assign ledmodeOut = r_ledmodeOut;

endmodule

   