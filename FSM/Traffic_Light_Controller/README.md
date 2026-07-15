# Traffic Light Controller (Moore FSM)

## Overview

This project implements a **Traffic Light Controller** using a **Moore Finite State Machine (FSM)** in Verilog HDL. The controller manages traffic flow at a four-way intersection by prioritizing the main road while allowing side-street traffic when requested. A counter-based timer is used to control the duration of each traffic light state.

---

## Features

- Moore FSM implementation
- Counter-based timer (no derived clocks)
- Parameterized timing values
- Side-street vehicle detection
- Main road priority
- Verified using Icarus Verilog and GTKWave

---

## State Encoding

| State | Binary | Description |
|:-----:|:------:|-------------|
| S0 | `2'b00` | Main Road = Green, Street = Red |
| S1 | `2'b01` | Main Road = Yellow, Street = Red |
| S2 | `2'b10` | Main Road = Red, Street = Green |
| S3 | `2'b11` | Main Road = Red, Street = Yellow |

---

## Input Encoding

| Input (`in[1:0]`) | Description |
|:-----------------:|-------------|
| `00` | No vehicles detected |
| `01` | Vehicle on side street |
| `10` | Vehicle on main road |
| `11` | Vehicles on both roads |

---

## Output

The output `out[1:0]` represents the encoded current FSM state shown in the **State Encoding** table.

---

## State Diagram

<p align="center">
<img src="state_diagram_traffic_light.png" width="650">
</p>

---

## Simulation Waveform

<p align="center">
<img src="waveform_traffic_light.png" width="850">
</p>

The waveform verifies:

- Proper reset initialization
- Counter-based timing
- Timer expiration (`timer_elapsed`)
- Correct FSM transitions:
  - S0 → S1
  - S1 → S2
  - S2 → S3
  - S3 → S0

---

## Project Structure

```
Traffic_Light_Controller/
│
├── traffic_light.v
├── traffic_light_tb.v
├── state_diagram_traffic_light.png
├── waveform_traffic_light.png
└── README.md
```

---

## Simulation

Compile the design and testbench:

```bash
iverilog -o sim traffic_light.v traffic_light_tb.v
```

Run the simulation:

```bash
vvp sim
```

View the waveform:

```bash
gtkwave traffic_light_control.vcd
```

---

## Tools Used

- Verilog HDL
- Visual Studio Code
- Icarus Verilog
- GTKWave
- Git & GitHub

---

## Learning Outcomes

This project demonstrates:

- Moore FSM design
- Sequential and combinational logic separation
- Counter-based timer implementation
- Parameterized RTL design
- FSM verification using testbenches
- Waveform analysis using GTKWave

---

## Author

**Atharva Vemulapalli**
