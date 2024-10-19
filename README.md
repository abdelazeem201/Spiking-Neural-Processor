# Spiking Neural Network (SNN) Processor

## Project Overview
This repository contains the design and implementation of a **Spiking Neural Network (SNN) Processor**. Spiking Neural Networks are a biologically-inspired class of artificial neural networks, where neurons communicate by sending discrete spikes. These models closely mimic how the brain processes information, enabling energy-efficient computation and real-time processing.

This project aims to build a hardware-accelerated SNN processor optimized for neuromorphic computing applications. The design is intended for use in edge computing, robotics, and other areas where low-power, real-time neural processing is essential.

## Features
- **Spiking Neuron Models**: Implements several neuron models such as:
  - Leaky Integrate-and-Fire (LIF)
  - Izhikevich model
- **SNN Processor Architecture**: Designed to support efficient spike communication, with dedicated modules for:
  - Neuron computation
  - Synapse management
  - Spike event queuing and propagation
- **Low-Power Design**: Optimized for low-power applications, making it suitable for edge computing and IoT devices.
- **FIFO Buffers**: Implemented to handle spike data buffering between stages of the network.

## Architecture Overview
The SNN Processor consists of the following core components:
- **Neuron Processing Unit (NPU)**: Handles the computation of neuron states and updates based on incoming spikes.
- **Spike Queue Manager**: Uses FIFO structures to buffer spike events and ensure orderly processing.
- **Synapse Array**: A structure that handles spike propagation to target neurons, including configurable synaptic weights.
- **Control Unit**: Manages spike events, ensuring correct synchronization between different parts of the processor.

## Hardware Design
The SNN processor is built using Verilog, with key components including:
- **FIFO Module**: A parameterizable FIFO buffer designed to handle neuron spike data efficiently. The module is designed to support configurable depth and width for flexibility.
- **Neuron Models**: Verilog implementations of LIF and Izhikevich neuron models.

## Getting Started

### Prerequisites
To simulate and synthesize the design, you will need the following tools:
- **Verilog HDL**: The hardware description language used for the design.
- **Simulator**: Tools like ModelSim or QuestaSim for simulation.
- **Synthesis Tools**: Any standard ASIC or FPGA synthesis tool (e.g., Synopsys Design Compiler, Xilinx Vivado).

### Running Simulations
1. Clone the repository:
   ```bash
   git clone https://github.com/abdelazeem201/Spiking-Neural-Processor.git
2.	Navigate to the project directory and run the testbench for the system or neuron modules:
    ```bash
     cd Spiking-Neural-Processor/sim
     make run
3.	View the waveform output to verify the spike propagation and neuron behavior.

# Future Work

	•	Add support for learning algorithms such as Spike-Timing Dependent Plasticity (STDP).
	•	Optimize the design for low-latency applications.
	•	Integrate with real-world sensor data for robotics and IoT use cases.

# Contribution

Feel free to fork this project, open issues, and submit pull requests to contribute.

# License

This project is licensed under the MIT License - see the LICENSE file for details.
    
