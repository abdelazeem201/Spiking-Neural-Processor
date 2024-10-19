/*
    ---------------------------------------------------------------------------
    Module: LIF_neuron
    Author: Ahmed Abdelazeem
    Position: ASIC Design Engineer 
    ---------------------------------------------------------------------------
    Description:
        This module implements a Leaky Integrate-and-Fire (LIF) neuron model,
        which is a simplified representation of a biological neuron. The neuron
        integrates incoming spikes, leaks over time, and generates an output
        spike when its membrane potential reaches a defined threshold. This
        model is suitable for use in spiking neural networks, where energy-efficient
        processing and real-time response are essential.

    Parameters:
        DATA_WIDTH : Defines the width of the membrane potential and spike weights.
        THRESHOLD   : Defines the spike threshold for the neuron.
        LEAK_RATE   : The amount by which the membrane potential decreases each cycle.
        RESET_VAL   : The value to reset the membrane potential after a spike.
    
    Inputs:
        clk              : Clock signal for synchronization.
        rst              : Active high reset signal to reset the neuron's state.
        spike_in         : Incoming spike input that increases the membrane potential.
        weight           : Weight of the incoming spike (DATA_WIDTH bits).

    Outputs:
        spike_out        : Output spike signal indicating that the neuron has fired.
        mem_potential     : Current membrane potential of the neuron (DATA_WIDTH bits).

    Operation:
        - The neuron integrates incoming spikes (weighted by the input weight).
        - The membrane potential leaks over time based on the LEAK_RATE.
        - When the membrane potential reaches the THRESHOLD, the neuron generates
          an output spike and resets its potential to RESET_VAL.
    ---------------------------------------------------------------------------
*/

module LIF_neuron
#(
    parameter DATA_WIDTH = 16,           // Width of the membrane potential
    parameter THRESHOLD  = 100,          // Spike threshold for the neuron
    parameter LEAK_RATE  = 1,            // Leak rate of the membrane potential
    parameter RESET_VAL  = 0             // Membrane potential reset value after spike
)
(
    input  wire                   clk,          // Clock signal
    input  wire                   rst,          // Reset signal
    input  wire                   spike_in,     // Incoming spike input
    input  wire [DATA_WIDTH-1:0]  weight,       // Weight of the incoming spike
    output reg                    spike_out,    // Output spike
    output reg  [DATA_WIDTH-1:0]  mem_potential // Membrane potential of the neuron
);

    // Internal signal to store accumulated potential
    reg [DATA_WIDTH-1:0] accum_potential;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accum_potential <= RESET_VAL;   // Reset membrane potential
            spike_out <= 0;                 // Reset spike output
        end else begin
            if (spike_in) begin
                // Integrate incoming spike (add weighted input to membrane potential)
                accum_potential <= accum_potential + weight;
            end

            // Leak potential over time
            if (accum_potential > LEAK_RATE) begin
                accum_potential <= accum_potential - LEAK_RATE;
            end else begin
                accum_potential <= 0;   // No negative values for potential
            end

            // Check if membrane potential exceeds threshold
            if (accum_potential >= THRESHOLD) begin
                spike_out <= 1;                  // Generate output spike
                accum_potential <= RESET_VAL;    // Reset membrane potential
            end else begin
                spike_out <= 0;                  // No spike
            end
        end
    end

    // Output the current membrane potential
    assign mem_potential = accum_potential;

endmodule
