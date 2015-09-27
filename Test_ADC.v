`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:39:40 09/27/2015
// Design Name:   ADC
// Module Name:   C:/Xilinx/Trabajos/Proyecto 3/Proyect3/Test_ADC.v
// Project Name:  Proyect3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ADC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Test_ADC;

	// Inputs
	reg clk;
	reg rst;
	reg dato_ser;
	reg EN;

	// Outputs
	wire rx_done;
	wire [11:0] data_out;
	wire cs;

	// Instantiate the Unit Under Test (UUT)
	ADC uut (
		.clk(clk), 
		.rst(rst), 
		.dato_ser(dato_ser), 
		.EN(EN), 
		.rx_done(rx_done), 
		.data_out(data_out), 
		.cs(cs)
	);

	integer i,j,Comportamiento;
	reg [15:0] mensaje [0:100];
	reg [11:0] datos [0:100];
	reg [11:0] aux;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		dato_ser = 0;
		EN = 0;
		i = 0;
		j=0;
		$readmemb("señal.txt", datos);
		Comportamiento = $fopen("Comportamiento.txt","w");
		for(j=0;j<101;j=j+1)
		begin
			mensaje[j]={4'h0,datos[j]};
		end
		$fwrite(Comportamiento,"  Entrada     	Salida\n");
		
	end
	
	initial begin
		#1 rst =0;
		@(posedge cs) EN = 1'b1;
		for(j=0;j<100;j=j+1)
			begin
				@(negedge cs) aux=mensaje[j];
				for(i = 15; i>-1; i=i-1)
				begin
					dato_ser = aux[i];
					@(posedge clk);
				end
				dato_ser = 1;
				@(posedge cs) $fwrite(Comportamiento,"%b	%b\n",datos[j],data_out);
			end
		@(posedge clk);
		EN = 1'b0;
		$stop;
	end
	
	initial forever begin
		#5 clk = ~clk;
	end
 
endmodule

