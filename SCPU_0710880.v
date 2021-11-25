module SCPU(
    // Input signals
    clk,
    rst_n,
    in_valid,
    instruction,
    MEM_out,
	
    // Output signals
    busy,
    out_valid,
    out0,
    out1,
    out2,
    out3,
    out4,
    out5,
    out6,
    out7,
    out8,
    out9,
    out10,
    out11,
    out12,
    out13,
    out14,
    out15,
    WEN,
    ADDR,
    MEM_in
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------

input clk, rst_n, in_valid;
input [18:0] instruction; //instruction input
output reg busy, out_valid;

//output register:r0~r15
output reg signed [15:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15;

input signed [15:0] MEM_out; //store
output reg WEN; //determine load and store:wen=0 store,wen=1 load
output reg signed [15:0] MEM_in; //load
output reg [12:0] ADDR; //memory address of load and store


//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------

reg [18:0] instruction_ff,instruction_ff2; //store ins

reg signed [15:0] rs,rt,rd,rl; //ins [15:0] is same big to out
reg [3:0] func,func_ff; //0~4:and,or,xor,add,sub
						//r type consider function block 3~0

reg signed [15:0] rs_ff,rt_ff,rd_ff,rl_ff; //store rs,rt,rd,rl

reg signed [7:0] imm,imm_ff; //i type consider immediate block 7~0
reg signed [31:0] mul,mul_ff; //rs*rt=32 bits

reg signed [15:0] data_out,data_out_ff; //normal 16bit answer
reg signed [15:0] data_out2,data_out2_ff; //if have rd,rl two answer,rd = ans1,rl = ans2

//reg to used in ins
reg WEN_ff; 
reg signed [15:0] MEM_in_ff;
reg [12:0] ADDR_ff;

//---------------------------------------------------------------------
//   Design Description
//---------------------------------------------------------------------

//rs,rt,rd,rl:initialize
//posedge clk:read new ins
//negedge rst_n:reset 
always @(posedge clk or negedge rst_n) begin

	//reset
	if(!rst_n)begin
		rs <= 0;
		rd <= 0;
		rt <= 0;
		rl <= 0;
	end
	
	else begin
		if(in_valid) begin //when ins is valid,begin
		
			//op=0,r type,logic operation=+-*/^,rs,rt,rd
			if(instruction[18:16]==0) begin 
			
				func <= instruction[3:0] ;
				
				if( instruction[15:12] == 0 ) rs <= out0;
				else if( instruction[15:12] == 1 ) rs <= out1;
				else if( instruction[15:12] == 2 ) rs <= out2;
				else if( instruction[15:12] == 3 ) rs <= out3;
				else if( instruction[15:12] == 4 ) rs <= out4;
				else if( instruction[15:12] == 5 ) rs <= out5;
				else if( instruction[15:12] == 6 ) rs <= out6;
				else if( instruction[15:12] == 7 ) rs <= out7;
				else if( instruction[15:12] == 8 ) rs <= out8;
				else if( instruction[15:12] == 9 ) rs <= out9;
				else if( instruction[15:12] == 10 ) rs <= out10;
				else if( instruction[15:12] == 11 ) rs <= out11;
				else if( instruction[15:12] == 12 ) rs <= out12;
				else if( instruction[15:12] == 13 ) rs <= out13;
				else if( instruction[15:12] == 14 ) rs <= out14;
				else rs <= out15;
				
				if( instruction[11:8] == 0 ) rt <= out0;
				else if( instruction[11:8] == 1 ) rt <= out1;
				else if( instruction[11:8] == 2 ) rt <= out2;
				else if( instruction[11:8] == 3 ) rt <= out3;
				else if( instruction[11:8] == 4 ) rt <= out4;
				else if( instruction[11:8] == 5 ) rt <= out5;
				else if( instruction[11:8] == 6 ) rt <= out6;
				else if( instruction[11:8] == 7 ) rt <= out7;
				else if( instruction[11:8] == 8 ) rt <= out8;
				else if( instruction[11:8] == 9 ) rt <= out9;
				else if( instruction[11:8] == 10 ) rt <= out10;
				else if( instruction[11:8] == 11 ) rt <= out11;
				else if( instruction[11:8] == 12 ) rt <= out12;
				else if( instruction[11:8] == 13 ) rt <= out13;
				else if( instruction[11:8] == 14 ) rt <= out14;
				else rt <= out15;
				
				if( instruction[7:4] == 0 ) rd <= out0;
				else if( instruction[7:4] == 1 ) rd <= out1;
				else if( instruction[7:4] == 2 ) rd <= out2;
				else if( instruction[7:4] == 3 ) rd <= out3;
				else if( instruction[7:4] == 4 ) rd <= out4;
				else if( instruction[7:4] == 5 ) rd <= out5;
				else if( instruction[7:4] == 6 ) rd <= out6;
				else if( instruction[7:4] == 7 ) rd <= out7;
				else if( instruction[7:4] == 8 ) rd <= out8;
				else if( instruction[7:4] == 9 ) rd <= out9;
				else if( instruction[7:4] == 10 ) rd <= out10;
				else if( instruction[7:4] == 11 ) rd <= out11;
				else if( instruction[7:4] == 12 ) rd <= out12;
				else if( instruction[7:4] == 13 ) rd <= out13;
				else if( instruction[7:4] == 14 ) rd <= out14;
				else rd <= out15;
			end
			
			//op = 1,2,7,type = mult,beq,slt,rs,rt,rd,rl
			else if((instruction[18:16]==1)||(instruction[18:16]==2)||(instruction[18:16]==7)) begin 
				
				if( instruction[15:12] == 0 ) rs <= out0;
				else if( instruction[15:12] == 1 ) rs <= out1;
				else if( instruction[15:12] == 2 ) rs <= out2;
				else if( instruction[15:12] == 3 ) rs <= out3;
				else if( instruction[15:12] == 4 ) rs <= out4;
				else if( instruction[15:12] == 5 ) rs <= out5;
				else if( instruction[15:12] == 6 ) rs <= out6;
				else if( instruction[15:12] == 7 ) rs <= out7;
				else if( instruction[15:12] == 8 ) rs <= out8;
				else if( instruction[15:12] == 9 ) rs <= out9;
				else if( instruction[15:12] == 10 ) rs <= out10;
				else if( instruction[15:12] == 11 ) rs <= out11;
				else if( instruction[15:12] == 12 ) rs <= out12;
				else if( instruction[15:12] == 13 ) rs <= out13;
				else if( instruction[15:12] == 14 ) rs <= out14;
				else rs <= out15;
				
				if( instruction[11:8] == 0 ) rt <= out0;
				else if( instruction[11:8] == 1 ) rt <= out1;
				else if( instruction[11:8] == 2 ) rt <= out2;
				else if( instruction[11:8] == 3 ) rt <= out3;
				else if( instruction[11:8] == 4 ) rt <= out4;
				else if( instruction[11:8] == 5 ) rt <= out5;
				else if( instruction[11:8] == 6 ) rt <= out6;
				else if( instruction[11:8] == 7 ) rt <= out7;
				else if( instruction[11:8] == 8 ) rt <= out8;
				else if( instruction[11:8] == 9 ) rt <= out9;
				else if( instruction[11:8] == 10 ) rt <= out10;
				else if( instruction[11:8] == 11 ) rt <= out11;
				else if( instruction[11:8] == 12 ) rt <= out12;
				else if( instruction[11:8] == 13 ) rt <= out13;
				else if( instruction[11:8] == 14 ) rt <= out14;
				else rt <= out15;
				
				if( instruction[7:4] == 0 ) rd <= out0;
				else if( instruction[7:4] == 1 ) rd <= out1;
				else if( instruction[7:4] == 2 ) rd <= out2;
				else if( instruction[7:4] == 3 ) rd <= out3;
				else if( instruction[7:4] == 4 ) rd <= out4;
				else if( instruction[7:4] == 5 ) rd <= out5;
				else if( instruction[7:4] == 6 ) rd <= out6;
				else if( instruction[7:4] == 7 ) rd <= out7;
				else if( instruction[7:4] == 8 ) rd <= out8;
				else if( instruction[7:4] == 9 ) rd <= out9;
				else if( instruction[7:4] == 10 ) rd <= out10;
				else if( instruction[7:4] == 11 ) rd <= out11;
				else if( instruction[7:4] == 12 ) rd <= out12;
				else if( instruction[7:4] == 13 ) rd <= out13;
				else if( instruction[7:4] == 14 ) rd <= out14;
				else rd <= out15;
				
				if( instruction[3:0] == 0 ) rl <= out0;
				else if( instruction[3:0] == 1 ) rl <= out1;
				else if( instruction[3:0] == 2 ) rl <= out2;
				else if( instruction[3:0] == 3 ) rl <= out3;
				else if( instruction[3:0] == 4 ) rl <= out4;
				else if( instruction[3:0] == 5 ) rl <= out5;
				else if( instruction[3:0] == 6 ) rl <= out6;
				else if( instruction[3:0] == 7 ) rl <= out7;
				else if( instruction[3:0] == 8 ) rl <= out8;
				else if( instruction[3:0] == 9 ) rl <= out9;
				else if( instruction[3:0] == 10 ) rl <= out10;
				else if( instruction[3:0] == 11 ) rl <= out11;
				else if( instruction[3:0] == 12 ) rl <= out12;
				else if( instruction[3:0] == 13 ) rl <= out13;
				else if( instruction[3:0] == 14 ) rl <= out14;
				else rl <= out15;
			end
			
			//op = 3,4,5,6,i type,rs,rt
			else if((instruction[18:16]==3)||(instruction[18:16]==4)||(instruction[18:16]==5)||(instruction[18:16]==6)) begin
				
				imm <= instruction[7:0] ;
				if( instruction[15:12] == 0 ) rs <= out0;
				else if( instruction[15:12] == 1 ) rs <= out1;
				else if( instruction[15:12] == 2 ) rs <= out2;
				else if( instruction[15:12] == 3 ) rs <= out3;
				else if( instruction[15:12] == 4 ) rs <= out4;
				else if( instruction[15:12] == 5 ) rs <= out5;
				else if( instruction[15:12] == 6 ) rs <= out6;
				else if( instruction[15:12] == 7 ) rs <= out7;
				else if( instruction[15:12] == 8 ) rs <= out8;
				else if( instruction[15:12] == 9 ) rs <= out9;
				else if( instruction[15:12] == 10 ) rs <= out10;
				else if( instruction[15:12] == 11 ) rs <= out11;
				else if( instruction[15:12] == 12 ) rs <= out12;
				else if( instruction[15:12] == 13 ) rs <= out13;
				else if( instruction[15:12] == 14 ) rs <= out14;
				else rs <= out15;
				
				if( instruction[11:8] == 0 ) rt <= out0;
				else if( instruction[11:8] == 1 ) rt <= out1;
				else if( instruction[11:8] == 2 ) rt <= out2;
				else if( instruction[11:8] == 3 ) rt <= out3;
				else if( instruction[11:8] == 4 ) rt <= out4;
				else if( instruction[11:8] == 5 ) rt <= out5;
				else if( instruction[11:8] == 6 ) rt <= out6;
				else if( instruction[11:8] == 7 ) rt <= out7;
				else if( instruction[11:8] == 8 ) rt <= out8;
				else if( instruction[11:8] == 9 ) rt <= out9;
				else if( instruction[11:8] == 10 ) rt <= out10;
				else if( instruction[11:8] == 11 ) rt <= out11;
				else if( instruction[11:8] == 12 ) rt <= out12;
				else if( instruction[11:8] == 13 ) rt <= out13;
				else if( instruction[11:8] == 14 ) rt <= out14;
				else rt <= out15;
			end
			
			//op != 0~7 case,set all = 0
			else begin
				rs <= 0;
				rt <= 0;
				rd <= 0;
				rl <= 0;
				func <= 0;
				imm <= 0;
			end
			
			instruction_ff <= instruction ; //input to reg
		end
	end
end

//read new ins,pipeline
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
	//	WEN <= 1;
	end
	else begin
		rs_ff <= rs;
		rt_ff <= rt;
		instruction_ff2 <= instruction_ff ;
	end
end

//anytime when already read in new ins
always @ (*) begin
	//op = 0
	if(instruction_ff[18:16]==0) begin
		//function:0~4,simple alu
		case(func) 
			3'b000:		data_out= rs & rt ;   //and
			3'b001 : 	data_out = rs | rt ;  //or
			3'b010 : 	data_out = rs ^ rt ;  //xor	
			3'b011 :	data_out = rs + rt ;  //add
			3'b100 :	data_out = rs - rt ;  //sub	
		endcase
	end
	
	//op=1,mul,rd:high 16 bits,rl:low 16 bits
	else if(instruction_ff[18:16]==1) begin 
		mul = rs * rt;
	end
	
	//op=2,beq,test rs==rt
	else if(instruction_ff[18:16]==2) begin 
		if(rs==rt) begin
			data_out = 1;
			data_out2 = 0;
		end
		else begin
			data_out = 0;
			data_out2 = 1;
		end
	end
	
	//op=3,addi
	else if(instruction_ff[18:16]==3) begin
		data_out = rs + imm ;
	end
	//op=4,subi
	else if(instruction_ff[18:16]==4) begin
		data_out = rs - imm ;
	end
	
	//store
	if(instruction_ff[18:16]==5) begin
		WEN = 0; //write data into memory,men_in will be written in
		ADDR = rs[12:0] + imm;
		MEM_in = rt;
	end
	
	//load
	else if(instruction_ff[18:16]==6) begin
		WEN = 1; //load data from memory,load data mem_out from memory
		ADDR = rs[12:0] + imm;
	end
	
	//slt
	else if(instruction_ff[18:16]==7) begin
		if(rs<rt) begin
			data_out = 1; //rd
			data_out2 = 0; //rl
		end
		else begin
			data_out = 0;  //rd
			data_out2 = 1;  //rl
		end
	end
	
	else begin
		ADDR = 0;
		ADDR_ff <= 0;
		MEM_in_ff <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin

	//reset all
	if(!rst_n)begin
		out0 <= 0;
		out1 <= 0;
		out2 <= 0;
		out3 <= 0;
		out4 <= 0;
		out5 <= 0;
		out6 <= 0;
		out7 <= 0;
		out8 <= 0;
		out9 <= 0;
		out10 <= 0;
		out11 <= 0;
		out12 <= 0;
		out13 <= 0;
		out14 <= 0;
		out15 <= 0;
		out_valid <= 0;
		MEM_in <= 0;
		busy <= 0;
	end
	
	else begin
		data_out_ff <= data_out;
		data_out2_ff <= data_out2;
		mul_ff <= mul;
		
		//r type,rd=ins[7:4]
		if(instruction_ff2[18:16]==0) begin
			out_valid <= 1; //check the answer
			
			if( instruction_ff2[7:4] == 0 ) out0 <= data_out_ff;
			else if( instruction_ff2[7:4] == 1 ) out1 <= data_out_ff;
			else if( instruction_ff2[7:4] == 2 ) out2 <= data_out_ff;
			else if( instruction_ff2[7:4] == 3 ) out3 <= data_out_ff;
			else if( instruction_ff2[7:4] == 4 ) out4 <= data_out_ff;
			else if( instruction_ff2[7:4] == 5 ) out5 <= data_out_ff;
			else if( instruction_ff2[7:4] == 6 ) out6 <= data_out_ff;
			else if( instruction_ff2[7:4] == 7 ) out7 <= data_out_ff;
			else if( instruction_ff2[7:4] == 8 ) out8 <= data_out_ff;
			else if( instruction_ff2[7:4] == 9 ) out9 <= data_out_ff;
			else if( instruction_ff2[7:4] == 10 ) out10 <= data_out_ff;
			else if( instruction_ff2[7:4] == 11 ) out11 <= data_out_ff;
			else if( instruction_ff2[7:4] == 12 ) out12 <= data_out_ff;
			else if( instruction_ff2[7:4] == 13 ) out13 <= data_out_ff;
			else if( instruction_ff2[7:4] == 14 ) out14 <= data_out_ff;
			else out15 <= data_out_ff;
		end
		
		//op=1,2,7,rd=ins[7:4],rl=ins[3:0]
		//op=1,mult
		else if(instruction_ff2[18:16]==1) begin 
			//divided into rd=[7:4],rl=[3:0],rd for high 16 bits,rl for low 16 bits
			out_valid <= 1;
			if( instruction_ff2[7:4] == 0 ) out0 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 1 ) out1 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 2 ) out2 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 3 ) out3 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 4 ) out4 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 5 ) out5 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 6 ) out6 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 7 ) out7 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 8 ) out8 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 9 ) out9 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 10 ) out10 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 11 ) out11 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 12 ) out12 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 13 ) out13 <= mul_ff[31:16];
			else if( instruction_ff2[7:4] == 14 ) out14 <= mul_ff[31:16];
			else out15 <= mul_ff[31:16];
			
			if( instruction_ff2[3:0] == 0 ) out0 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 1 ) out1 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 2 ) out2 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 3 ) out3 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 4 ) out4 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 5 ) out5 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 6 ) out6 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 7 ) out7 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 8 ) out8 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 9 ) out9 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 10 ) out10 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 11 ) out11 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 12 ) out12 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 13 ) out13 <= mul_ff[15:0];
			else if( instruction_ff2[3:0] == 14 ) out14 <= mul_ff[15:0];
			else out15 <= mul_ff[15:0];
		end
		
		//op=2,beq
		else if(instruction_ff2[18:16]==2) begin
			out_valid <= 1;
			
			if( instruction_ff2[7:4] == 0 ) out0 <= data_out_ff;
			else if( instruction_ff2[7:4] == 1 ) out1 <= data_out_ff;
			else if( instruction_ff2[7:4] == 2 ) out2 <= data_out_ff;
			else if( instruction_ff2[7:4] == 3 ) out3 <= data_out_ff;
			else if( instruction_ff2[7:4] == 4 ) out4 <= data_out_ff;
			else if( instruction_ff2[7:4] == 5 ) out5 <= data_out_ff;
			else if( instruction_ff2[7:4] == 6 ) out6 <= data_out_ff;
			else if( instruction_ff2[7:4] == 7 ) out7 <= data_out_ff;
			else if( instruction_ff2[7:4] == 8 ) out8 <= data_out_ff;
			else if( instruction_ff2[7:4] == 9 ) out9 <= data_out_ff;
			else if( instruction_ff2[7:4] == 10 ) out10 <= data_out_ff;
			else if( instruction_ff2[7:4] == 11 ) out11 <= data_out_ff;
			else if( instruction_ff2[7:4] == 12 ) out12 <= data_out_ff;
			else if( instruction_ff2[7:4] == 13 ) out13 <= data_out_ff;
			else if( instruction_ff2[7:4] == 14 ) out14 <= data_out_ff;
			else out15 <= data_out_ff;
			
			if( instruction_ff2[3:0] == 0 ) out0 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 1 ) out1 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 2 ) out2 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 3 ) out3 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 4 ) out4 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 5 ) out5 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 6 ) out6 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 7 ) out7 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 8 ) out8 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 9 ) out9 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 10 ) out10 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 11 ) out11 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 12 ) out12 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 13 ) out13 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 14 ) out14 <= data_out2_ff;
			else out15 <= data_out2_ff;
		end
		
		//op=7
		else if(instruction_ff2[18:16]==7) begin
			out_valid <= 1;
			
			if( instruction_ff2[7:4] == 0 ) out0 <= data_out_ff;
			else if( instruction_ff2[7:4] == 1 ) out1 <= data_out_ff;
			else if( instruction_ff2[7:4] == 2 ) out2 <= data_out_ff;
			else if( instruction_ff2[7:4] == 3 ) out3 <= data_out_ff;
			else if( instruction_ff2[7:4] == 4 ) out4 <= data_out_ff;
			else if( instruction_ff2[7:4] == 5 ) out5 <= data_out_ff;
			else if( instruction_ff2[7:4] == 6 ) out6 <= data_out_ff;
			else if( instruction_ff2[7:4] == 7 ) out7 <= data_out_ff;
			else if( instruction_ff2[7:4] == 8 ) out8 <= data_out_ff;
			else if( instruction_ff2[7:4] == 9 ) out9 <= data_out_ff;
			else if( instruction_ff2[7:4] == 10 ) out10 <= data_out_ff;
			else if( instruction_ff2[7:4] == 11 ) out11 <= data_out_ff;
			else if( instruction_ff2[7:4] == 12 ) out12 <= data_out_ff;
			else if( instruction_ff2[7:4] == 13 ) out13 <= data_out_ff;
			else if( instruction_ff2[7:4] == 14 ) out14 <= data_out_ff;
			else out15 <= data_out_ff;
			
			if( instruction_ff2[3:0] == 0 ) out0 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 1 ) out1 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 2 ) out2 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 3 ) out3 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 4 ) out4 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 5 ) out5 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 6 ) out6 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 7 ) out7 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 8 ) out8 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 9 ) out9 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 10 ) out10 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 11 ) out11 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 12 ) out12 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 13 ) out13 <= data_out2_ff;
			else if( instruction_ff2[3:0] == 14 ) out14 <= data_out2_ff;
			else out15 <= data_out2_ff;
		end
		
		//addi,rt = ins[11:8]
		else if(instruction_ff2[18:16]==3) begin
			out_valid <= 1;
			
			if( instruction_ff2[11:8] == 0 ) out0 <= data_out_ff;
			else if( instruction_ff2[11:8] == 1 ) out1 <= data_out_ff;
			else if( instruction_ff2[11:8] == 2 ) out2 <= data_out_ff;
			else if( instruction_ff2[11:8] == 3 ) out3 <= data_out_ff;
			else if( instruction_ff2[11:8] == 4 ) out4 <= data_out_ff;
			else if( instruction_ff2[11:8] == 5 ) out5 <= data_out_ff;
			else if( instruction_ff2[11:8] == 6 ) out6 <= data_out_ff;
			else if( instruction_ff2[11:8] == 7 ) out7 <= data_out_ff;
			else if( instruction_ff2[11:8] == 8 ) out8 <= data_out_ff;
			else if( instruction_ff2[11:8] == 9 ) out9 <= data_out_ff;
			else if( instruction_ff2[11:8] == 10 ) out10 <= data_out_ff;
			else if( instruction_ff2[11:8] == 11 ) out11 <= data_out_ff;
			else if( instruction_ff2[11:8] == 12 ) out12 <= data_out_ff;
			else if( instruction_ff2[11:8] == 13 ) out13 <= data_out_ff;
			else if( instruction_ff2[11:8] == 14 ) out14 <= data_out_ff;
			else out15 <= data_out_ff;
		end
		
		//subi,rt = ins[11:8]
		else if(instruction_ff2[18:16]==4) begin
			out_valid <= 1;
		
			if( instruction_ff2[11:8] == 0 ) out0 <= data_out_ff;
			else if( instruction_ff2[11:8] == 1 ) out1 <= data_out_ff;
			else if( instruction_ff2[11:8] == 2 ) out2 <= data_out_ff;
			else if( instruction_ff2[11:8] == 3 ) out3 <= data_out_ff;
			else if( instruction_ff2[11:8] == 4 ) out4 <= data_out_ff;
			else if( instruction_ff2[11:8] == 5 ) out5 <= data_out_ff;
			else if( instruction_ff2[11:8] == 6 ) out6 <= data_out_ff;
			else if( instruction_ff2[11:8] == 7 ) out7 <= data_out_ff;
			else if( instruction_ff2[11:8] == 8 ) out8 <= data_out_ff;
			else if( instruction_ff2[11:8] == 9 ) out9 <= data_out_ff;
			else if( instruction_ff2[11:8] == 10 ) out10 <= data_out_ff;
			else if( instruction_ff2[11:8] == 11 ) out11 <= data_out_ff;
			else if( instruction_ff2[11:8] == 12 ) out12 <= data_out_ff;
			else if( instruction_ff2[11:8] == 13 ) out13 <= data_out_ff;
			else if( instruction_ff2[11:8] == 14 ) out14 <= data_out_ff;
			else out15 <= data_out_ff;
		end
		
		//store,rt data to memory,rt is same
		else if(instruction_ff2[18:16]==5) begin
			out_valid <= 1;
		end
		
		//load,rt = ins[11:8]
		else if(instruction_ff2[18:16]==6) begin
			out_valid <= 1;
		
			if( instruction_ff2[11:8] == 0 ) out0 <= MEM_out;
			else if( instruction_ff2[11:8] == 1 ) out1 <= MEM_out;
			else if( instruction_ff2[11:8] == 2 ) out2 <= MEM_out;
			else if( instruction_ff2[11:8] == 3 ) out3 <= MEM_out;
			else if( instruction_ff2[11:8] == 4 ) out4 <= MEM_out;
			else if( instruction_ff2[11:8] == 5 ) out5 <= MEM_out;
			else if( instruction_ff2[11:8] == 6 ) out6 <= MEM_out;
			else if( instruction_ff2[11:8] == 7 ) out7 <= MEM_out;
			else if( instruction_ff2[11:8] == 8 ) out8 <= MEM_out;
			else if( instruction_ff2[11:8] == 9 ) out9 <= MEM_out;
			else if( instruction_ff2[11:8] == 10 ) out10 <= MEM_out;
			else if( instruction_ff2[11:8] == 11 ) out11 <= MEM_out;
			else if( instruction_ff2[11:8] == 12 ) out12 <= MEM_out;
			else if( instruction_ff2[11:8] == 13 ) out13 <= MEM_out;
			else if( instruction_ff2[11:8] == 14 ) out14 <= MEM_out;
			else out15 <= MEM_out;
		end
		else begin
			out_valid <= 0;
			MEM_in <= 0;
		end
	end
end


endmodule