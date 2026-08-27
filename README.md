# Spacecraft Early Analysis Model (SEAM)

**An MBSE Framework for Early Analysis of Spacecraft Behavior**

The Spacecraft Early Analysis Model (SEAM) is an open-source, modular, and reusable framework that enables early functional simulation of spacecraft systems using a model-based systems engineering (MBSE) approach. Designed to support system definition and behavioral analysis in the preliminary design phase, the SEAM allows users to define spacecraft modes, functions, and mission operations, and simulate the resulting behavior using SysML, MATLAB, STK, and Excel.

---

## 📦 Features

- 🔧 **Modular Design** – Clean separation between Mission, System, Operations, Requirements, and Project modules.
- 📜 **SysML-Based** – Built in Cameo Systems Modeler using SysML 1.5 and executable constructs (fUML).
- 📊 **Simulation Ready** – Integrates with MATLAB and STK to simulate spacecraft behavior based on user-defined Flight Operations Procedures (FOPs).
- 💡 **Behavioral Innovation** – Separates spacecraft *functionality* from *behavior*, allowing flexible ConOps-driven simulations.
- 🔁 **Reusable Template** – Easily adapted to multiple spacecraft missions and architectures.

---

## 📁 Repository Structure

```bash
SEAM/
├── SEAM Case Studies/          # Application examples (Biomass and ExoMars coming soon)
├── SEAM Framwork/              # SEAM SysML model (Cameo project) and scripts
├── SEAM Ontology/              # SEAM Ontology SysML model
└── README.md
```

---

## 🧠 How It Works

The SEAM models a spacecraft using five key modules:

| Module        | Purpose |
|---------------|---------|
| **Project**   | Project team, references, data dictionary |
| **Requirements** | Structured, model-based verification of constraints |
| **Mission**   | External entities, mission phases, and orbit/environment profiles |
| **System**    | Logical and functional architecture using modes and functions |
| **Operations**| Flight Operations Procedures (FOPs), including telecommands and decisions |

Each module can be independently modified and updated, but they come together during simulation to provide a comprehensive view of spacecraft behavior.

---

## ▶️ Getting Started

### 🔽 Download

```bash
git clone https://github.com/joegregoryphd/SEAM.git
cd SEAM
```

### ⚙️ Prerequisites

- [Cameo Systems Modeler](https://www.nomagic.com/products/cameo-systems-modeler)
- [Cameo Simulation Toolkit](https://www.nomagic.com/product-addons/cameo-simulation-toolkit)
- [MATLAB](https://www.mathworks.com/products/matlab.html)
- [Ansys STK](https://www.ansys.com/products/missions/ansys-stk) (optional but recommended)
- Microsoft Excel

### ▶️ Run a Simulation

1. **Open the Model**  
   Launch Cameo Systems Modeler and open the `SEAM` project.
2. **Define Your System**  
   Customize spacecraft functions, modes, mission profiles, and FOPs.
3. **Run STK Analysis (Optional)**  
   Use the provided MATLAB script to calculate access windows and store them in Excel.
4. **Start Simulation**  
   Run the mission execution activity in Cameo with the Simulation Toolkit.
5. **Visualize**  
   Use the GUI to observe subsystem modes, function execution, and telemetry flows in real time.

---

## 📚 Publications

| Paper Title | Publication | Year | Link |
|--------------|---------|--|--|
|The ‘Spacecraft Early Analysis Model': An MBSE Framework for Early Analysis of Spacecraft Behavior|IEEE Transactions on Systems, Man, and Cybernetics: Systems|2025|tbd|
|A Model-Based Framework for Early-Stage Analysis of Spacecraft|PhD Thesis, University of Bristol|2022|[![](https://img.shields.io/badge/UoB-PhD%20Thesis-indigo)](https://research-information.bris.ac.uk/files/332123430/Final_Copy_2022_07_29_Gregory_J_PhD_Redacted.pdf)|
|Investigating the Flexibility of the MBSE Approach to the Biomass Mission|IEEE Transactions on Systems, Man, and Cybernetics: Systems|2021|[![](https://img.shields.io/badge/IEEE-Paper-blue)](https://ieeexplore.ieee.org/document/8986828)|
|There's no ‘I’ in SEAM—An Interim Report on the ‘Spacecraft Early Analysis Model’|IEEE Aerospace Conference|2020|[![](https://img.shields.io/badge/IEEE-Paper-blue)](https://ieeexplore.ieee.org/document/9172702)|



---

## ✨ Future Work

- Automated document generation
- Built-in support for sensitivity and trade-off analysis
- Integration with ontologies for semantic reasoning
- Expansion to support rovers, constellations, and human spaceflight

---

## 🤝 Acknowledgements

The SEAM was developed between 2020-2022 as part of Joe Gregory's PhD research while at the University of Bristol, UK. It was revised for publication in 2025. Its development and the research it supported were done in collaboration with Airbus Defence and Space. Special thanks to Dassault Systèmes for licensing support.

---

## 📜 License

The **Spacecraft Early Analysis Model (SEAM)**, including the SysML/Cameo models, SEAM Ontology, Excel models, and documentation contained in this repository, is licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0) License](https://creativecommons.org/licenses/by/4.0/).

MATLAB source code (`.m` files) contained in this repository is licensed separately under the [MIT License](LICENSE-MIT).

Copyright © Joe R. Gregory.

Where third-party material is identified, that material remains subject to its original copyright and licensing terms.

### Citation

If you use SEAM in academic or research work, please cite the relevant SEAM publication(s) listed above.

---

## 📬 Contact

To provide feedback or to ask questions about the SEAM:

**Joe Gregory**  
📧 joegregory@arizona.edu  
📍 Systems and Industrial Engineering, University of Arizona
