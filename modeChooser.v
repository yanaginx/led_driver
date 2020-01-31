module modeChooser (input [1:0]selector,
                    output [3:0]mode);
                    
reg [3:0]r_mode;

always @ (selector, mode)
   begin 
      case (selector)
         2'b00: r_mode = 4'b0001;
         2'b01: r_mode = 4'b0010;
         2'b10: r_mode = 4'b0100;
         2'b11: r_mode = 4'b1000;
      endcase
   end

assign mode = r_mode;

endmodule

