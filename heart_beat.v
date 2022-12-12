module heart_beat
(
	input clk,reset_n,
	output [3:0] sel,
	output [7:0] sseg
);
localparam N=694_444;
reg [7:0] led3,led2,led1,led0;
reg [21:0] time_counter_reg,time_counter_next;
reg [1:0] pos_reg,pos_next;

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
	if(time_counter_reg == N-1)
		time_counter_next = 0;
	else
		time_counter_next = time_counter_reg + 1;
end

always @*
begin
	if(time_counter_reg == N-1)
	begin
		pos_next = (pos_reg==2'b10)? 0 : pos_reg + 1;
	end
	else
		pos_next = pos_reg;
end

    always @*
    begin
        case (pos_reg)
            2'b00:
                begin
                    led0 = 8'b1111_1111;
                    led1 = 8'b1111_1001;
                    led2 = 8'b1100_1111;
                    led3 = 8'b1111_1111;
                end
            2'b01:
                begin
                    led0 = 8'b1111_1111;
                    led1 = 8'b1100_1111;
                    led2 = 8'b1111_1001;
                    led3 = 8'b1111_1111;
                end
            2'b10:
                begin
                    led0 = 8'b1100_1111;
                    led1 = 8'b1111_1111;
                    led2 = 8'b1111_1111;
                    led3 = 8'b1111_1001;
                end  
            default:  // we shouldn't be here
                begin
                    led0 = 8'b1111_1111;
                    led1 = 8'b1111_1111;
                    led2 = 8'b1111_1111;
                    led3 = 8'b1111_1111;
                end
       endcase
    end
endmodule