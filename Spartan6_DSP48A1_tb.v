module Spartan6_DSP48A1_tb();


  // Parameters
  parameter A0REG = 0;
  parameter A1REG = 1;
  parameter B0REG = 0;
  parameter B1REG = 1;
  parameter CREG = 1;
  parameter DREG = 1;
  parameter MREG = 1;
  parameter PREG = 1;
  parameter CARRYINREG = 1;
  parameter CARRYOUTREG = 1;
  parameter OPMODEREG = 1;
  parameter CARRYINSEL = "OPMODE5";
  parameter B_INPUT = "DIRECT";
  parameter RSTTYPE = "SYNC";

  // Outputs for first dut
  wire [35:0] M_1;
  wire [47:0] P_1, PCOUT_1;
  wire CARRYOUT_1, CARRYOUTF_1;
  wire [17:0] BCOUT_1;

  // Outputs for second dut
  wire [35:0] M_2;
  wire [47:0] P_2, PCOUT_2;
  wire CARRYOUT_2, CARRYOUTF_2;
  wire [17:0] BCOUT_2;
  
  // Inputs
  reg [17:0] A, B, D, BCIN;
  reg [47:0] C,PCIN;
  reg CARRYIN;
  reg clk;
  reg [7:0] OPMODE;
  reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
  reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;

  // Instantiate the Design Under Test (DUT)
  spartan6_DSP48A1 #(.CARRYINSEL("OPMODE5"),.B_INPUT("DIRECT"),.RSTTYPE("SYNC")) dut1 (
    .A(A), .B(B), .C(C), .D(D), .CARRYIN(CARRYIN), .M(M_1), .P(P_1), .CARRYOUT(CARRYOUT_1), .CARRYOUTF(CARRYOUTF_1),
    .clk(clk), .OPMODE(OPMODE), .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
    .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
    .BCOUT(BCOUT_1), .BCIN(BCIN), .PCOUT(PCOUT_1), .PCIN(PCIN)
  );

  spartan6_DSP48A1 #(.CARRYINSEL("CARRYIN"),.B_INPUT("CASCADED"),.RSTTYPE("ASYNC")) dut2 (
    .A(A), .B(B), .C(C), .D(D), .CARRYIN(CARRYIN), .M(M_2), .P(P_2), .CARRYOUT(CARRYOUT_2), .CARRYOUTF(CARRYOUTF_2),
    .clk(clk), .OPMODE(OPMODE), .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
    .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
    .BCOUT(BCOUT_2), .BCIN(BCIN), .PCOUT(PCOUT_2) ,.PCIN(PCIN)
  );

  initial begin
    clk=0;
    forever begin
      #5 clk=~clk;
    end
  end

  initial begin
    // Initialize Inputs
    A = 0;
    B = 0;
    C = 0;
    D = 0;
    CARRYIN = 0;
    OPMODE = 8'b00000000;
    CEA = 1;
    CEB = 1;
    CEC = 1;
    CECARRYIN = 1;
    CED = 1;
    CEM = 1;
    CEOPMODE = 1;
    CEP = 1;
    RSTA = 0;
    RSTB = 0;
    RSTC = 0;
    RSTCARRYIN = 0;
    RSTD = 0;
    RSTM = 0;
    RSTOPMODE = 0;
    RSTP = 0;
    BCIN = 0;
    #1;
    RSTA = 1;
    RSTB = 1;
    RSTC = 1;
    RSTCARRYIN = 1;
    RSTD = 1;
    RSTM = 1;
    RSTOPMODE = 1;
    RSTP = 1;
    @(negedge clk)
    RSTA = 0;
    RSTB = 0;
    RSTC = 0;
    RSTCARRYIN = 0;
    RSTD = 0;
    RSTM = 0;
    RSTOPMODE = 0;
    RSTP = 0;
    // Apply Stimulus(case one)
    A = 18'd1; 
    B = 18'd0; 
    C = 48'd5; 
    D = 18'd10;
    BCIN=18'd6;
    PCIN=48'd6; 
    OPMODE = 8'b00011101; 
    CEA = 1;
    CEB = 1;
    CEC = 1;
    CECARRYIN = 1;
    CED = 1;
    CEM = 1;
    CEOPMODE = 1;
    CEP = 1;
    #200; 
    //end(case one)

    // Apply Stimulus(case two)
    A = 18'd10; 
    B = 18'd15; 
    C = 48'd32; 
    D = 18'd15;
    BCIN=18'd3;
    PCIN=48'd87;  
    OPMODE = 8'b00110101; 
    #200;
    //end(case two)

    // Apply Stimulus(case three)
    A = 18'd2; 
    B = 18'd50; 
    C = 48'd526; 
    D = 18'd100;
    BCIN=18'd3;
    PCIN=48'd87;  
    OPMODE = 8'b11001010; 
    #200;
    //end(case three)

    // Apply Stimulus(case four)
    A = 18'd1; 
    B = 18'd2; 
    C = 48'd3; 
    D = 18'd10;
    BCIN=18'd3;
    PCIN=48'd87;  
    OPMODE = 8'b00111111; 
    #200;
    //end(case four)

    // Apply Stimulus(case five)
    A = 18'd1000; 
    B = 18'd2000; 
    C = 48'd0; 
    D = 18'd1789;
    BCIN=18'd0;
    PCIN=48'd8;  
    OPMODE = 8'b00010000; 
    #200;
    //end(case five)

    // Apply Stimulus(case six)
    A = 18'd1023; 
    B = 18'd150; 
    C = 48'd5082; 
    D = 18'd1500;
    BCIN=18'd100;
    PCIN=48'd400;  
    OPMODE = 8'b10111001; 
    #200;
    //end(case six)

    // Apply Stimulus(case seven)
    A = 18'd1353; 
    B = 18'd0; 
    C = 48'd0; 
    D = 18'd0;
    BCIN=18'd132;
    PCIN=48'd784965254;  
    OPMODE = 8'b10110100; 
    #200;
    //end(case seven)

    // Apply Stimulus(case eight)
    A = 18'd1000; 
    B = 18'd1500; 
    C = 48'd320; 
    D = 18'd150;
    BCIN=18'd30;
    PCIN=48'd870;  
    OPMODE = 8'b11110100; 
    #200;
    //end(case eight)

    // Apply Stimulus(case nine)
    A = 18'd0; 
    B = 18'd0; 
    C = 48'd0; 
    D = 18'd0;
    BCIN=18'd0;
    PCIN=48'd0;  
    OPMODE = 8'b00010101;
    CEA = 1;
    CEB = 1;
    CEC = 1;
    CECARRYIN = 1;
    CED = 1;
    CEM = 1;
    CEOPMODE = 1;
    CEP = 0; 
    #200;
    //end(case nine)

    // Apply Stimulus(case ten)
    A = 18'd2000; 
    B = 18'd262144; 
    C = 48'd369874; 
    D = 18'd10100;
    BCIN=18'd56;
    PCIN=48'd78948541;  
    OPMODE = 8'b00110101;
    CEA = 1;
    CEB = 1;
    CEC = 1;
    CECARRYIN = 1;
    CED = 1;
    CEM = 1;
    CEOPMODE = 0;
    CEP = 0;
    #200;
    //end(case ten)

    // Finish simulation after some time
     $stop;
  end

  // Monitor
  initial begin
    $monitor("Time: %0d | A: %h | B: %h | C: %h | D: %h | OPMODE: %b | M_1: %h | P_1: %h | CARRYOUT_1: %b | M_2: %h | P_2: %h | CARRYOUT_2: %b",
             $time, A, B, C, D, OPMODE, M_1, P_1, CARRYOUT_1, M_2, P_2, CARRYOUT_2);
  end



endmodule