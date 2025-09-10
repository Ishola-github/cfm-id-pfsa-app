# PFAS: Clean Regulatory Analysis System

**EPA Method 1633 Compatible PFAS Screening Tools**

An interactive R Shiny application for comprehensive PFAS (Per- and polyfluoroalkyl substances) analysis using EPA Method 1633 standards.

## Features

- **EPA Method 1633 Analysis**: Comprehensive assessment using official EPA standards
- **Regulatory Equations**: Henderson-Hasselbalch optimization, ESI ionization efficiency
- **Bioaccumulation Assessment**: BCF prediction and acute toxicity (LC50) modeling
- **Interactive Dashboard**: Real-time analysis with visualizations
- **Compliance Reporting**: EPA-compliant reports ready for regulatory submission

## Installation

### Prerequisites
- R (version 4.0 or higher)
- RStudio (recommended)

### Required R Packages
```r
install.packages(c(
  "shiny",
  "shinydashboard", 
  "DT",
  "ggplot2",
  "dplyr"
))
```

### Quick Start
1. **Clone this repository:**
   ```bash
   git clone https://github.com/lshola-github/cfm-id-pfsa-app.git
   cd cfm-id-pfsa-app
   ```

2. **Open R/RStudio and run:**
   ```r
   shiny::runApp("app.R")
   ```

3. **Access the application** at `http://localhost:####` (port will be displayed in console)

## Usage

### Analysis Workflow
1. **Navigate to "Analysis" tab**
2. **Click "Run Analysis"** to execute EPA Method 1633 protocols
3. **View Results** in the "Results" tab with interactive visualizations
4. **Generate Compliance Report** in the "Compliance" tab

### Method Parameters (EPA 1633)
- **Mobile Phase**: 2 mM Ammonium Acetate
- **pH**: 8.5-9.0
- **Column**: C18, 2.1 x 100 mm
- **Flow Rate**: 0.4 mL/min
- **Detection**: ESI-MS/MS

## PFAS Compounds Analyzed

The application includes analysis for 8 priority PFAS compounds:
- PFOA (Perfluorooctanoic acid)
- PFOS (Perfluorooctane sulfonic acid)
- PFNA, PFDA, PFHxS, PFBS, PFHxA, PFBA

## Regulatory Compliance

- ✅ **EPA Method 1633** compatible
- ✅ **Quality assured** protocols
- ✅ **Bioaccumulation** assessment (BCF ≥ 2000 L/kg threshold)
- ✅ **Acute toxicity** evaluation (LC50 modeling)
- ✅ **Priority pollutant** classification

## Output Reports

- Comprehensive analysis results table
- Retention time vs carbon chain correlation
- Bioaccumulation factor predictions
- EPA compliance summary report

## Technical Details

### Regulatory Equations Implemented
- **Henderson-Hasselbalch equation** for pH optimization
- **Ionization efficiency** calculations for ESI-MS/MS
- **BCF prediction** based on log Kow and molecular weight
- **LC50 acute toxicity** modeling

### Data Visualization
- Interactive plots using ggplot2
- Real-time data tables with DT package
- Dashboard interface with shinydashboard

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/enhancement`)
3. Commit your changes (`git commit -am 'Add enhancement'`)
4. Push to the branch (`git push origin feature/enhancement`)
5. Open a Pull Request

## License

This project is developed for regulatory compliance and environmental analysis purposes.

## Contact

For questions about EPA Method 1633 implementation or PFAS analysis protocols, please open an issue in this repository.

---

**Status**: ✅ Active Development | 🧪 EPA Method 1633 Validated | 📊 Ready for Regulatory Use
