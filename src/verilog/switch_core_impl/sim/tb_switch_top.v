`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/03 14:06:20
// Design Name: 
// Module Name: tb_switch_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_switch_top();

reg clk;
reg rstn;

real CYCLE = 5; 
integer file;
always begin 
    clk = 0; #(CYCLE / 2); 
    clk = 1; #(CYCLE / 2); 
end 
initial begin
    file = $fopen("qlen_output.txt", "w");
    rstn        = 1'b1 ;
    #618 rstn     = 1'b0 ;
    #618 rstn     = 1'b1 ;
end


wire data_wr, i_cell_ptr_fifo_wr;
wire [15:0] i_cell_ptr_fifo_din;

wire [47:0] qlen_all_0;
wire [47:0] qlen_all_1;
wire [47:0] qlen_all_2;
wire [47:0] qlen_all_3;
wire [10:0] qlen_0[3:0];
wire [10:0] qlen_1[3:0];
wire [10:0] qlen_2[3:0];
wire [10:0] qlen_3[3:0];
assign {qlen_0[3], qlen_0[2], qlen_0[1], qlen_0[0]} = qlen_all_0;
assign {qlen_1[3], qlen_1[2], qlen_1[1], qlen_1[0]} = qlen_all_1;
assign {qlen_2[3], qlen_2[2], qlen_2[1], qlen_2[0]} = qlen_all_2;
assign {qlen_3[3], qlen_3[2], qlen_3[1], qlen_3[0]} = qlen_all_3;

wire headdrop_out_0, out_0;
wire headdrop_out_1, out_1;
wire headdrop_out_2, out_2;
wire headdrop_out_3, out_3;
wire [3:0] headdrop_out_port_0;
wire [3:0] headdrop_out_port_1;
wire [3:0] headdrop_out_port_2;
wire [3:0] headdrop_out_port_3;
wire [3:0] out_port_0;
wire [3:0] out_port_1;
wire [3:0] out_port_2;
wire [3:0] out_port_3;

integer clk_count = 0;
always @(posedge clk) begin
    clk_count = clk_count + 1;
    $fwrite(file, "%0t, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h \n", 
      $time, 
      qlen_0[1], qlen_0[0], headdrop_out_0, headdrop_out_port_0, out_0, out_port_0, 
      qlen_1[1], qlen_1[0], headdrop_out_1, headdrop_out_port_1, out_1, out_port_1,
      qlen_2[1], qlen_2[0], headdrop_out_2, headdrop_out_port_2, out_2, out_port_2,
      qlen_3[1], qlen_3[0], headdrop_out_3, headdrop_out_port_3, out_3, out_port_3
    );
    if (clk_count == 180000) begin 
      $fclose(file);
      $finish;
    end
end

switch_top sw_t (
    .clk(clk),
    .rstn(rstn),
    .data_wr(data_wr),
    .i_cell_ptr_fifo_din(i_cell_ptr_fifo_din),
    .i_cell_ptr_fifo_wr(i_cell_ptr_fifo_wr)
);


switch_core_v2 #(
  .TOP_ENABLE_HEADDROP(0),
  .TOP_USE_DRR(1'b0)
) sw_0 (
    .clk(clk),
    .rstn(rstn),
    .data_wr(data_wr),
    .i_cell_ptr_fifo_din(i_cell_ptr_fifo_din),
    .i_cell_ptr_fifo_wr(i_cell_ptr_fifo_wr),

    .data_valid(),
    .qlen(qlen_all_0),
    .out_signal(out_0),
    .out_port(out_port_0),
    .headdrop_out(headdrop_out_0),
    .headdrop_out_port(headdrop_out_port_0)
);

switch_core_v2 #(
  .TOP_ENABLE_HEADDROP(1),
  .TOP_USE_DRR(1'b0)
)sw_1  (
    .clk(clk),
    .rstn(rstn),
    .data_wr(data_wr),
    .i_cell_ptr_fifo_din(i_cell_ptr_fifo_din),
    .i_cell_ptr_fifo_wr(i_cell_ptr_fifo_wr),

    .data_valid(),
    .qlen(qlen_all_1),
    .out_signal(out_1),
    .out_port(out_port_1),
    .headdrop_out(headdrop_out_1),
    .headdrop_out_port(headdrop_out_port_1)
);

switch_core_v2 #(
  .TOP_ENABLE_HEADDROP(0),
  .TOP_USE_DRR(1'b1)
)sw_2 (
    .clk(clk),
    .rstn(rstn),
    .data_wr(data_wr),
    .i_cell_ptr_fifo_din(i_cell_ptr_fifo_din),
    .i_cell_ptr_fifo_wr(i_cell_ptr_fifo_wr),

    .data_valid(),
    .qlen(qlen_all_2),
    .out_signal(out_2),
    .out_port(out_port_2),
    .headdrop_out(headdrop_out_2),
    .headdrop_out_port(headdrop_out_port_2)
);

switch_core_v2 #(
  .TOP_ENABLE_HEADDROP(1),
  .TOP_USE_DRR(1'b1)
)sw_3 (
    .clk(clk),
    .rstn(rstn),
    .data_wr(data_wr),
    .i_cell_ptr_fifo_din(i_cell_ptr_fifo_din),
    .i_cell_ptr_fifo_wr(i_cell_ptr_fifo_wr),

    .data_valid(),
    .qlen(qlen_all_3),
    .out_signal(out_3),
    .out_port(out_port_3),
    .headdrop_out(headdrop_out_3),
    .headdrop_out_port(headdrop_out_port_3)
);

endmodule
