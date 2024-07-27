module mux_4_to_1(OPCODE,I0,I1,I2,I3,OUT);
parameter PATH_WIDTH = 48;

input      [PATH_WIDTH-1:0]I0,I1,I2,I3;
input      [1:0]OPCODE;
output reg [PATH_WIDTH-1:0]OUT;

always@(*)begin
    case(OPCODE)
        0:OUT=I0;
        1:OUT=I1;
        2:OUT=I2;
        3:OUT=I3;
    endcase
end
endmodule