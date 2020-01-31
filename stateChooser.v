module stateChooser (input [2:0]chooser,
                     output [5:0]state);

reg [5:0] r_state;

always @ (chooser, state)
   begin
      case (chooser)
            3'b000: r_state = 6'b000001;
            3'b001: r_state = 6'b000010;
            3'b010: r_state = 6'b000100;
            3'b011: r_state = 6'b001000;
            3'b100: r_state = 6'b010000;
            3'b101: r_state = 6'b100000;
            default: r_state = 6'b000001;
         endcase //case chooser
   end //always chooser
   
assign state = r_state;   
                     
endmodule
                     