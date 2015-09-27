`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnologico de Costa Rica
//
// Engineer: Luis Adrioàn Castillo J
//           Carlos Carranza
// 
// Create Date:    16:32:13 09/24/2015 
// Design Name: 
// Module Name:    ADC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ADC(
	input wire clk, rst,
	input wire dato_ser, EN,
	output wire rx_done,
	output wire [11:0] data_out,
	output reg cs
);

reg [11:0] reg_desp, reg_desp_next;
reg state,state_next;
wire desp_enable;
reg [3:0] counter, counter_next;

//Registro serial
//Begin
always@(negedge clk, posedge rst)
begin
	if(rst)
		reg_desp <= 12'b0;
	else
		reg_desp <= reg_desp_next;
end

always@*
begin
	reg_desp_next = reg_desp;
	if(desp_enable)
		reg_desp_next = {reg_desp[10:0],dato_ser};
end


//End



always@(posedge clk, posedge rst)
	if(rst)
	begin
		state <= 1'b0;
		counter <= 4'b0;
	end
	else
	begin
		state <= state_next;
		counter <=counter_next;
	end

always@*
begin
	state_next = state;
	counter_next = 4'b0;
	cs = 1'b0;
	case(state)
		1'b0:
			begin
				cs = 1'b1;
				state_next=1'b1;
			end
		1'b1:
			begin
				counter_next = counter + 1'b1;
				if(counter==4'd15)
				begin
					state_next = 1'b0;
				end
			end
	endcase		
end

assign desp_enable = state;
assign rx_done = ~state & EN;
assign data_out = reg_desp;

endmodule
