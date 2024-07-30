module Reg_Mux(I0,OUT,clk,rst,clk_enable);
parameter PATH_WIDTH = 1;
parameter REG_ON=1;
parameter RSTTYPE="SYNC";

input      [PATH_WIDTH-1:0]I0;
input      clk,rst,clk_enable;
output     [PATH_WIDTH-1:0]OUT;
reg        [PATH_WIDTH-1:0]I0_REG_SYNC,I0_REG_ASYNC;

always@(posedge clk or posedge rst) begin
        if(rst)begin
            I0_REG_ASYNC<=0;
        end
        else begin
            if(clk_enable)begin
            I0_REG_ASYNC<=I0;
        end
    end
end

always@(posedge clk) begin
        if(rst)begin
            I0_REG_SYNC<=0;
        end
        else begin
            if(clk_enable)begin
            I0_REG_SYNC<=I0;
        end
    end
end

assign OUT=(!REG_ON)?I0:(RSTTYPE=="SYNC")?I0_REG_SYNC:I0_REG_ASYNC;

endmodule