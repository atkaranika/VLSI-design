# VLSI Design Project: Standard Cell Library

## Overview

This project focuses on the creation and characterization of a standard cell library using Cadence Virtuoso, Calibre for DRC/LVS/Parasitic Extraction, and PrimeLib for Liberty. This project involves the design and characterization of 9 cells: INV, AND, NAND, OR, NOR, AOI21, XOR, XNOR, and AOI22. The technology node for this project is 65 nm.

## Project Goals

1. **Cell Design:** Design, layout, and verify 9 standard cells using Cadence Virtuoso.
2. **Design Verification:** Use Calibre for Design Rule Check (DRC), Layout vs. Schematic (LVS), Parasitic Extraction(PEX)
3. **Liberty File Generation:** Utilize PrimeLib to generate Liberty files (.lib) that encapsulate timing, power, and other relevant characteristics of the standard cells.

## Simulation Details

- **HSPICE Simulation:** Each cell was simulated using HSPICE to ensure correct functionality.
- **Input Slew Rate:** The input slew rate for simulations was set to 40 ps (0.1*Vdd to 0.9*Vdd and vice versa).

## Project Structure

```plaintext
|-- /Standard Cell Library                  # Contains individual cell layouts

|-- README.md               # Project documentation

