`timescale 1ns / 1ps

module spi_master (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] tx_data,
    input wire miso,
    output reg mosi,
    output reg sck,
    output reg ss,
    output reg [7:0] rx_data,
    output reg done
);

    localparam IDLE     = 2'b00;
    localparam START    = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam STOP     = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_count <= 0;
            sck <= 0;
            ss <= 1;
            mosi <= 0;
            done <= 0;
            rx_data <= 8'b0;
            shift_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    ss <= 1;
                    sck <= 0;
                    done <= 0;
                    bit_count <= 0;
                    if (start) begin
                        state <= START;
                        shift_reg <= tx_data;
                    end
                end

                START: begin
                    ss <= 0;
                    mosi <= shift_reg[7];
                    state <= TRANSFER;
                end

                TRANSFER: begin
                    sck <= ~sck;
                    if (~sck) begin
                        shift_reg[0] <= miso;
                    end else begin
                        if (bit_count == 7) begin
                            state <= STOP;
                        end else begin
                            shift_reg <= {shift_reg[6:0], 1'b0};
                            mosi <= shift_reg[6];
                            bit_count <= bit_count + 1;
                        end
                    end
                end

                STOP: begin
                    ss <= 1;
                    rx_data <= shift_reg;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule