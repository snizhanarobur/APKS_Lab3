`timescale 1ns / 1ps

module tb_spi_master;
    reg clk;
    reg rst;
    reg start;
    reg [7:0] tx_data;
    reg miso;
    wire mosi;
    wire sck;
    wire ss;
    wire [7:0] rx_data;
    wire done;

    spi_master uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .tx_data(tx_data),
        .miso(miso),
        .mosi(mosi),
        .sck(sck),
        .ss(ss),
        .rx_data(rx_data),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        tx_data = 8'h00;
        miso = 0;

        #20 rst = 0;
        
        #10;
        tx_data = 8'hA5;
        start = 1;
        #10 start = 0;

        #20 miso = 1; 
        #20 miso = 0; 
        #20 miso = 1; 
        #20 miso = 1; 
        #20 miso = 0; 
        #20 miso = 1; 
        #20 miso = 0; 
        #20 miso = 1; 

        #50;
        
        tx_data = 8'h3C;
        start = 1;
        #10 start = 0;
        
        #20 miso = 0; 
        #20 miso = 0; 
        #20 miso = 1; 
        #20 miso = 1; 
        #20 miso = 1; 
        #20 miso = 1; 
        #20 miso = 0; 
        #20 miso = 0; 

        #100 $finish;
    end
endmodule