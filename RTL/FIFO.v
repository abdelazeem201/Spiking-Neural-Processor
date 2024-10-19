/*
    ---------------------------------------------------------------------------
    Module: fifo
    Author: Ahmed Abdelazeem
    Position: ASIC Design Engineer 
    ---------------------------------------------------------------------------
    Description:
        This FIFO (First-In-First-Out) module provides temporary storage for 
        buffering data between different stages of a pipeline. The design is 
        intended for digital systems, such as Spiking Neural Network (SNN) 
        processors, where efficient data handling is required.

        The FIFO is parameterizable in terms of data width, depth, and address
        width, making it adaptable to various application-specific requirements.

    Parameters:
        DATA_WIDTH : Defines the width of the data that the FIFO will store.
        FIFO_DEPTH : Defines the maximum number of entries the FIFO can store.
        ADDR_WIDTH : The width of the write/read pointer, based on log2(FIFO_DEPTH).
    
    Inputs:
        clk      : Clock signal for synchronization.
        rst      : Active high reset signal to reset the FIFO state.
        wr_en    : Write enable signal, when high data is written to the FIFO.
        rd_en    : Read enable signal, when high data is read from the FIFO.
        wr_data  : Data input to the FIFO (DATA_WIDTH bits).

    Outputs:
        rd_data  : Data output from the FIFO (DATA_WIDTH bits).
        full     : Flag indicating the FIFO is full.
        empty    : Flag indicating the FIFO is empty.

    Operation:
        - Data is written into the FIFO at the write pointer location when wr_en 
          is high and the FIFO is not full.
        - Data is read from the FIFO at the read pointer location when rd_en is 
          high and the FIFO is not empty.
        - The `fifo_count` register tracks the number of elements in the FIFO, 
          controlling the full and empty conditions.
    ---------------------------------------------------------------------------
*/

module fifo
#(
    parameter DATA_WIDTH = 32,          // Width of the data to be stored in the FIFO
    parameter FIFO_DEPTH = 16,          // Depth of the FIFO (number of elements it can store)
    parameter ADDR_WIDTH = 4            // Width of the address pointers (log2(FIFO_DEPTH))
)
(
    input  wire                  clk,        // Clock signal
    input  wire                  rst,        // Reset signal
    input  wire                  wr_en,      // Write enable signal
    input  wire                  rd_en,      // Read enable signal
    input  wire [DATA_WIDTH-1:0] wr_data,    // Data to be written to the FIFO
    output wire [DATA_WIDTH-1:0] rd_data,    // Data read from the FIFO
    output wire                  full,       // FIFO full flag
    output wire                  empty       // FIFO empty flag
);

    // Internal memory to store data
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];   // Memory array to hold FIFO data

    // Write and read pointers to track FIFO positions
    reg [ADDR_WIDTH-1:0] wr_ptr;                      // Write pointer
    reg [ADDR_WIDTH-1:0] rd_ptr;                      // Read pointer

    // Counter to track the number of elements in the FIFO
    reg [ADDR_WIDTH:0]   fifo_count;                  // Counter to track the number of elements in the FIFO

    // Write operation: Store data in the FIFO when wr_en is high and FIFO is not full
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;   // Reset the write pointer
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= wr_data;   // Write data into the FIFO
            wr_ptr <= wr_ptr + 1;          // Increment write pointer
        end
    end

    // Read operation: Retrieve data from the FIFO when rd_en is high and FIFO is not empty
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;   // Reset the read pointer
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;   // Increment read pointer
        end
    end

    // FIFO count logic: Keeps track of how many elements are in the FIFO
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fifo_count <= 0;   // Reset the counter
        end else if (wr_en && !full && !(rd_en && !empty)) begin
            fifo_count <= fifo_count + 1;   // Increment count when writing
        end else if (rd_en && !empty && !(wr_en && !full)) begin
            fifo_count <= fifo_count - 1;   // Decrement count when reading
        end
    end

    // Output the data from the FIFO at the current read pointer position
    assign rd_data = fifo_mem[rd_ptr];

    // Full flag: Indicates FIFO is full when count equals FIFO depth
    assign full = (fifo_count == FIFO_DEPTH);

    // Empty flag: Indicates FIFO is empty when count is zero
    assign empty = (fifo_count == 0);

endmodule
