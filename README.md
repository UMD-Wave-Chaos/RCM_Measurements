Description
==========================================================================================
Random Coupling Model (RCM) Measurement and Analysis for Wave Chaos

Author: Ben Frazier 

Main GIT Repo: https://github.com/UMD-Wave-Chaos/RCM_Measurements.git

RCM Description: http://anlage.umd.edu/RCM/

PNA Online Help: http://na.support.keysight.com/pna/help/latest/help.htm

Haydon Kerk PCM 4826 Online Programming Manual: https://www.haydonkerkpittman.com/-/media/ametekhaydonkerk/downloads/products/drives/idea_drive_communication_manual.pdf?la=en

Acknowledgements
==========================================================================================
Many thanks to Bisrat Addissie, who started this project for his PhD work and provided the baseline code that allowed me to continue.

Experimental Setup
==========================================================================================
The wave chaotic cavity used for the experiment is a vacuum chamber that has been repurposed into a reverberation chamber to act as an electromagnetic cavity with a volume of 1.92 cubic meters. A mode stirrer is used to generate different realizations and collect statistics.

The S parameters of the cavity are measured with a PNA-X N5241A vector network analyzer in a 2-port measurements configuration. In the nominal setup, port 1 is connected to an X-band horn antenna at the far end of the cavity and port 2 is connected to a loop antenna at the bottom of the cavity.

The mode stirrer is controlled by a stepper motor, the Aerotech 50SM, which is driven by a Haydon PCM 4826 drive. The motor has 200 full steps per revolution (1.8 degrees per step) and can be driven at 1/64 steps, resulting in 12800 steps (1/64) per revolution.

Both the PNA and stepper motor are controlled through a Windows PC using the Matlab Instrumentation Toolbox. The PNA is connected through either a VISA-TCPIP connection or a GPIB connection and the stepper motor is connected through a serial connection on COM5.

![Experimental Wave Chaotic Cavity Setup](./images/cavity.png "Experimental Wave Chaotic Cavity Setup")

Getting Started
==========================================================================================
Follow the steps below to get started
1. Clone the repository 
2. Open Matlab and cd to the directory containing the repository 
3. Run *start.m* to open the GUI 
4. Select *Edit Config* to open the .xml configuration file in the Matlab editor 
5. Select *Reload Config* to reload the configuration file prior to running
6. If **NOT** using the electronic calibration module, make sure to manually calibrate the PNA 
7. Select *Measure Data* once all Connections are made to take a data set and analyze 
8. Select *Analyze Data* to analyze an existing data set 

Potential Connectivity Issues
==========================================================================================
## 1. Instrument Toolbox Connections Remain Open
Occasionally, the Matlab code will crash with a bug and will not gracefully disconnect from the instrument toolbox connections. When this
happens, the code will throw an error that the instrument is not available and refuse to reconnect. The fix is to either restart Matlab or
force the instrumentation toolbox to close the open devices. You can find the devices through the "instrfind" command:

```
out = instrfind()
```

This will return an array and will indicate whether or not each device is open or closed. All devices that show up as **open** need to be closed
through the fclose command:

```
fclose(out(index));
```
## 2. Serial Port Not Opening
Occasionally, the COM port will remain open after the GUI closes and Matlab will not be able to open it or make a connection. This is a Windows problem that typically occurs when the computer has been powered on for a long time and requires rebooting the machine to fix.


Measurement Process
==========================================================================================
## Step 1: Calibrate the PNA 
This step either uses the electronic calibration module or a manual calibration step. The HP calibration kit consisting of short, open, and broadband impedance connections is available for manual calibration. After starting up the GUI or reloading a configuration file, the existing calibration file will be unselected from the PNA and will need to be reselected if a previous calibration file is to be used. The calibration file can be loaded through the PNA menu by selecting Response --> Cal --> Manage Cals --> Cal Set.

## Step 2: Collect measured S parameters 
The mode stirrer is positioned a specified number of times to create mulitple realizations of the cavity - the mode stirrer is driven by a stepper motor typically connected serially
through COM5. There are a specified number of points collected in time and frequency from the PNA (given as NOP). This step captures frequency domain measurements of the S parameters at each mode stirrer position.

## Step 3: Save Data to HDF5 File
The frequency and  S parameters are saved to an HDF5 file with the settings from the
configuration file saved as attributes. 

Analysis Process
==========================================================================================
## Step 1: Compute Srad
This step computes the free space radiation S parameters through time gating.

## Step 2: Compute Time Domain S Parameters
This step computes the S Parameters in time domain through an inverse Fourier transform.

## Step 3: Compute Power Decay Profile and Estimate Tau 
Tau is the 1/e fold energy decay time and allows us to estimate alpha for the cavity. 

## Step 4: Compute Alpha
This step uses the value of Tau to estimate alpha and Q for the cavity and is applied for each of the 4 cases in Step 3.

## Step 5: Transform measured S parameters to impedance (Z) 
This step transforms the measurements to impedance space using the bilinear equations

## Step 6: Normalize impedance 
This step normalizes the impedance matrix for comparison with the RCM

## Step 7: Generate Measured Distributions 
This step generates histograms of the measured data to determine the PMF.

## Step 8: Generate RCM Distributions 
This step generates expected histograms according to the RCM.

## Step 9: Save Data to HDF5 File
All intermediate analytical values are saved in an HDF5 file named "analysisResults.h5" and all generated plots are saved in a folder with the same name as the provided input file.

References
==========================================================================================
## Determination of Srad Through Time Gating
1. Addissie et al, “Extraction of the coupling impedance in overmoded cavities”, Wave Motion (2018), https://doi.org/10.1016/j.wavemoti.2018.09.011

2. Addissie et al, "Application of the Random Coupling Model to Lossy Ports in Complex Enclosures", IEEE Metrology for Aerospace (MetroAeroSpace) Conference, 214-219 (2015).

## Reverberation Chamber Measurements
1. Holloway et al, “Reverberation Chamber Techniques for Determining the Radiation and Total Efficiency of Antennas, IEEE Transactions on Antennas and Propagation, 60, 4, 2012

2. Holloway et al, “Early Time Behavior in Reverberation Chambers and its Effect on the Relationships Between Coherence Bandwidth, Chamber Decay Time, RMS Delay Spread, and the Chamber Buildup Time”, IEEE Transactions on Electromagnetic Compatibility, 54,4, 2012

## RCM Theory
1. Zheng et al, "Statistics of Impedance and Scattering Matrices in Chaotic Microwave Cavities: Single Channel Case," Electromagnetics 26, 3 (2006).

2. Zheng et al, "Statistics of Impedance and Scattering Matrices of Chaotic Microwave Cavities with Multiple Ports," Electromagnetics 26, 37 (2006).

3. Hart et al, "Scattering a pulse from a chaotic cavity: Transitioning from algebraic to exponential decay," Phys. Rev. E 79, 016208 (2009).

## RCM Measurements
1. Hemmady et al, "Universal Statistics of the Scattering Coefficient of Chaotic Microwave Cavities," Phys. Rev. E 71, 056215 (2005).

2. Hemmady et al, "Universal Impedance Fluctuations in Wave Chaotic Systems," Phys. Rev. Lett. 94, 014102 (2005).

3. Hemmady et al, "Universal Properties of 2-Port Scattering, Impedance and Admittance Matrices of Wave Chaotic Systems," Phys. Rev. E 74 , 036213 (2006).


