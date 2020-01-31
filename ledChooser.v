module ledChooser (input [17:0]led1,
                   input [17:0]led2,
                   input [17:0]led3,
                   input [17:0]led4,
                   input [17:0]led5,
                   input [17:0]led6,
                   input [2:0] selector,
                   output [17:0]ledOUT);
                   
reg [17:0]r_ledOUT;


always @ (selector, led1, led2, led3, led4, led5, led6)
   begin
      case (selector)
         3'b000: r_ledOUT = led1;
         3'b001: r_ledOUT = led2;
         3'b010: r_ledOUT = led3;
         3'b011: r_ledOUT = led4;   
         3'b100: r_ledOUT = led5;
         3'b101: r_ledOUT = led6;
         default: r_ledOUT = led1;
      endcase //case selector 
   end //always selector
   
assign ledOUT = r_ledOUT;

endmodule

   