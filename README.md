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
The wave chaotic cavity used for the experiment is an old vacuum chamber that has been turned into a reverberation chamber to act as an electromagnetic cavity with a volume of 1.92 cubic meters. A mode stirrer is used to generate different realizations and collect statistics.

The S parameters of the cavity are measured with a PNA-X N5241A vector network analyzer in a 2-port measurements configuration. In the nominal setup, port 1 is connected to an X-band horn antenna at the far end of the cavity and port 2 is connected to a loop antenna at the bottom of the cavity.

The mode stirrer is controlled by a stepper motor, the Aerotech SM50, which is driven by a Haydon PCM 4826 drive. The motor has 200 full steps per revolution (1.8 degrees per step) and can be driven at 1/64 steps, resulting in 12800 steps (1/64) per revolution.

![Experimental Wave Chaotic Cavity Setup](images/cavity.png)

Getting Started
=========================================================================================
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

Detailed Breakdown
==========================================================================================
## Step 1: Calibrate the PNA 
This step either uses the electronic calibration module or a manual calibration step. The HP calibration kit consisting of short, open, and broadband impedance connections is available for manual calibration.

## Step 2: Collect measured S parameters 
The mode stirrer is positioned a specified number of times to create mulitple realizations of the cavity - the mode stirrer is driven by a stepper motor typically connected serially
through COM5. There are a specified number of points collected in time and frequency from the PNA (given as NOP). First a frequency domain measurement
is taken which provides *Scav*. Second, a set of 10 frequency domain measurements are made with different time gating to get an estimate of *Srad*.
Finally, a time domain measurement is taken of *Scav*.

Once this step is complete, all values (*Scav_time*, *Scav_freq*, *Srad*, *time*, *freq*) are saved in an HDF5 file, with the settings from the
configuration file saved as attributes. 

Nominal values are given as *NumberOfPoints = 32001*, *NumberOfRealizations = 50*, *CavityVolume = 1.92 m^3*, *AntennaElectricalLength = 0.5*.

## Step 3: Compute *Tau*  
*Tau* is the 1/e fold energy decay time and allows us to estimate alpha for the cavity. To estimate tau, the time domain measurements of *Scav* are used
and *tau* is computed for each element of *S* (*S11*, *S12*, *S21*, and *S22*)

## Step 4: Compute *Alpha* 
This step uses the value of *tau* to estimate *alpha* and *Q* for the cavity and is applied for each of the 4 cases in Step 3.

## Step 5: Transform measured S parameters to impedance (Z) 
This step transforms the measurements to impedance space using *Z = Z0(I+S)(I-S)^{-1}Z0*, where Z0 is a diagonal matrix containing the square roots of the
impedances connected to the ports (assumed to be 50 ohms). This step is performed for both the frequency domain measurements of *Srad* and *Scav*.

## Step 6: Normalize impedance 
This step normalizes the impedance matrix through the equation *Zn = Re(Zrad)^{-0.5}[Zcav - jIm(Zrad)]Re(Zrad)^{-0.5}*.

## Step 7: Generate Measured Distributions 
This step generates histograms of the measured data to determine the PMF.

## Step 8: Generate RCM Distributions 
This step generates expected histograms according to the RCM.