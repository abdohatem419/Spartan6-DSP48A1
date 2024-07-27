module spartan6_DSP48A1(A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,clk,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,BCOUT,BCIN,PCIN,PCOUT);

parameter A0REG       =0;
parameter A1REG       =1;
parameter B0REG       =0;
parameter B1REG       =1;
parameter CREG        =1;
parameter DREG        =1;
parameter MREG        =1;
parameter PREG        =1;
parameter CARRYINREG  =1;
parameter CARRYOUTREG =1;
parameter OPMODEREG   =1;
parameter CARRYINSEL  ="OPMODE5";
parameter B_INPUT     ="DIRECT";
parameter RSTTYPE     ="SYNC";

input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input CARRYIN;
output [35:0] M;
output [47:0] P,PCOUT;
output CARRYOUT,CARRYOUTF;
input clk;
input [7:0] OPMODE;
input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
output [17:0] BCOUT;

wire [17:0] b_selected,b_pre_adder_subtract,d_pre_adder_subtract,b_d_result_adder_subtract,pre_adder_subtract_selected,a_port,multiplier_in_bd,multiplier_in_a;
wire [47:0] multiplier_out,m_mux_in;
wire [47:0] abd_concatenated,mux_x_selected,mux_z_selected,post_adder_subtract_out,c_port;
wire carryin_selected,carryin_port,carryout_port;
wire [7:0] opmode_reg;
wire [47:0]input_mux_zero;

assign input_mux_zero=0;
assign PCOUT=P;
assign CARRYOUTF=CARRYOUT;
assign b_selected=(B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADED")?BCIN:0;
Reg_Mux #(.PATH_WIDTH(18),.REG_ON(DREG),.RSTTYPE(RSTTYPE)) ffm1 (.I0(D),.OUT(d_pre_adder_subtract),.clk(clk),.rst(RSTD),.clk_enable(CED));
Reg_Mux #(.PATH_WIDTH(18),.REG_ON(B0REG),.RSTTYPE(RSTTYPE)) ffm2 (.I0(b_selected),.OUT(b_pre_adder_subtract),.clk(clk),.rst(RSTB),.clk_enable(CEB));
Reg_Mux #(.PATH_WIDTH(18),.REG_ON(A0REG),.RSTTYPE(RSTTYPE)) ffm3 (.I0(A),.OUT(a_port),.clk(clk),.rst(RSTA),.clk_enable(CEA));
Reg_Mux #(.PATH_WIDTH(48),.REG_ON(CREG),.RSTTYPE(RSTTYPE)) ffm4 (.I0(C),.OUT(c_port),.clk(clk),.rst(RSTC),.clk_enable(CEC));
Reg_Mux #(.PATH_WIDTH(8),.REG_ON(OPMODEREG),.RSTTYPE(RSTTYPE)) ffm5 (.I0(OPMODE),.OUT(opmode_reg),.clk(clk),.rst(RSTOPMODE),.clk_enable(CEOPMODE));

assign abd_concatenated={d_pre_adder_subtract[11:0],multiplier_in_a,multiplier_in_bd};
assign b_d_result_adder_subtract=(opmode_reg[6]==0)?b_pre_adder_subtract+d_pre_adder_subtract:d_pre_adder_subtract-b_pre_adder_subtract;
assign pre_adder_subtract_selected=(opmode_reg[4]==0)?b_pre_adder_subtract:b_d_result_adder_subtract;

Reg_Mux #(.PATH_WIDTH(18),.REG_ON(B1REG),.RSTTYPE(RSTTYPE)) ffm6 (.I0(pre_adder_subtract_selected),.OUT(multiplier_in_bd),.clk(clk),.rst(RSTB),.clk_enable(CEB));
Reg_Mux #(.PATH_WIDTH(18),.REG_ON(A1REG),.RSTTYPE(RSTTYPE)) ffm7 (.I0(a_port),.OUT(multiplier_in_a),.clk(clk),.rst(RSTA),.clk_enable(CEA));

assign BCOUT=multiplier_in_bd;
assign multiplier_out=multiplier_in_a*multiplier_in_bd;
Reg_Mux #(.PATH_WIDTH(48),.REG_ON(MREG),.RSTTYPE(RSTTYPE)) ffm8 (.I0(multiplier_out),.OUT(m_mux_in),.clk(clk),.rst(RSTM),.clk_enable(CEM));

genvar i;
generate
    for(i=0;i<36;i=i+1)begin
        buf(M[i],m_mux_in[i]);
    end
endgenerate

mux_4_to_1 mx (.OPCODE(opmode_reg[1:0]),.I0(input_mux_zero),.I1(m_mux_in),.I2(P),.I3(abd_concatenated),.OUT(mux_x_selected));
mux_4_to_1 mz (.OPCODE(opmode_reg[3:2]),.I0(input_mux_zero),.I1(PCIN),.I2(P),.I3(c_port),.OUT(mux_z_selected));

assign carryin_selected=(CARRYINSEL=="OPMODE5")?opmode_reg[5]:(CARRYINSEL=="CARRYIN")?CARRYIN:0;
Reg_Mux #(.PATH_WIDTH(1),.REG_ON(CARRYINREG),.RSTTYPE(RSTTYPE)) ffm9 (.I0(carryin_selected),.OUT(carryin_port),.clk(clk),.rst(RSTCARRYIN),.clk_enable(CECARRYIN));

assign {carryout_port,post_adder_subtract_out}=(opmode_reg[7]==0)?mux_z_selected+mux_x_selected+carryin_port:mux_z_selected-mux_x_selected-carryin_port;
Reg_Mux #(.PATH_WIDTH(48),.REG_ON(PREG),.RSTTYPE(RSTTYPE)) ffm10 (.I0(post_adder_subtract_out),.OUT(P),.clk(clk),.rst(RSTP),.clk_enable(CEP));
Reg_Mux #(.PATH_WIDTH(1),.REG_ON(CARRYOUTREG),.RSTTYPE(RSTTYPE)) ffm11 (.I0(carryout_port),.OUT(CARRYOUT),.clk(clk),.rst(RSTCARRYIN),.clk_enable(CECARRYIN));


endmodule
