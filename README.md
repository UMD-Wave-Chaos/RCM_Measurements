Description
==========================================================================================
Random Coupling Model (RCM) Measurement and Analysis for Wave Chaos

Author: Ben Frazier 

Main GIT Repo: https://github.com/UMD-Wave-Chaos/RCM_Measurements.git

RCM Description: http://anlage.umd.edu/RCM/

Acknowledgements
==========================================================================================
Many thanks to Bisrat Addissie, who started this project for his PhD work and provided the baseline code that allowed me to continue.

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
out = instrfind
```

This will return an array and will indicate whether or not each device is open or closed. All devices that show **open** need to be closed
through the fclose command:

```
fclose(out(index));
```

Detailed Breakdown
==========================================================================================
# Step 1: Collect measured S parameters 
This step

# Step 2: Transform measured S parameters to impedance (Z) 
This step

# Step 3: Normalize impedance 
This step

# Step 4: Generate Distributions 
This step