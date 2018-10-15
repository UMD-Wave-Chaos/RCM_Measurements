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
4. Select *Measure Data* once all Connections are made to take a data set and analyze
5. Select *Analyze Data* to analyze an existing data set

Usage
==========================================================================================


Potential Connectivity Issues
==========================================================================================
Occasionally, the Matlab code will crash with a bug and will not gracefully disconnect from the instrument toolbox connections. When this
happens, the code will throw an error that the instrument is not available and refuse to reconnect. The fix is to either restart Matlab or
force the instrumentation toolbox to close the open devices. You can find the devices through the "instrfind" command:

out = instrfind

This will return an array and will indicate whether or not each device is open or closed. All devices that show **open** need to be closed
through the fclose command:

fclose(out(index));
