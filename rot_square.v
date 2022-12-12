module rot_square
(
	input clk,reset_n,
	input en,
	input cw,
	output [3:0] sel,
	output [7:0] sseg
);
localparam N=4_166_666;
reg [7:0] led3,led2,led1,led0;
reg [26:0] time_counter_reg,time_counter_next;
reg [2:0] pos_reg,pos_next;
wire en_db,cw_db;
db_fsm db_fsm_inst
(
	.clk(clk),
	.reset_n(reset_n),
	.sw(!en),
	.db(en_db)
);

db_fsm db_fsm_inst_2
(
	.clk(clk),
	.reset_n(reset_n),
	.sw(!cw),
	.db(cw_db)
);

 disp_mux disp_unit
        (.clk(clk), .reset(1'b0), .in0(led0), .in1(led1),
         .in2(led2), .in3(led3), .an(sel), .sseg(sseg));

always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)
	begin
		time_counter_reg <= 0;
		pos_reg <= 0;
	end
	else
	begin
		time_counter_reg <= time_counter_next;
		pos_reg <= pos_next;
	end
end
always @*
begin
	if(en_db)
	begin
		if(time_counter_reg == N-1)
			time_counter_next = 0;
		else
			time_counter_next = time_counter_reg + 1;
	end
	else
		time_counter_next = 0;
end

always @*
begin
	if(time_counter_reg == N-1 && en_db)
	begin
		if(cw_db)
			pos_next = pos_reg + 1;
		else
			pos_next = pos_reg -1;
	end
	else
		pos_next = pos_reg;
end
always @*
begin
	case(pos_reg)
		3'b000:
		begin
			led0=8'b1111_1111;
			led1=8'b1111_1111;
			led2=8'b1111_1111;
			led3=8'b1001_1100;
		end
		3'b001:
		begin
			led0=8'b1111_1111;
			led1=8'b1111_1111;
			led2=8'b1001_1100;
			led3=8'b1111_1111;
		end
		3'b010:
		begin
			led0=8'b1111_1111;
			led1=8'b1001_1100;
			led2=8'b1111_1111;
			led3=8'b1111_1111;
		end
		3'b011:
		begin
			led0=8'b1001_1100;
			led1=8'b1111_1111;
			led2=8'b1111_1111;
			led3=8'b1111_1111;
		end
           3'b100:
               begin
                   led0 = 8'b1110_0010;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1111_1111;
               end
           3'b101:
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1110_0010;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1111_1111;
               end
           3'b110:
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1110_0010;
                   led3 = 8'b1111_1111;
               end
           default:  // 3'b111
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1110_0010;
               end
	endcase
end
endmodule