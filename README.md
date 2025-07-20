# EEGwsIITMandi2025
This repository includes codes for the EEG-FieldTrip workshop organized at IIT Mandi, India, on July 24-26, 2025.

Test data description
---
The 60-channel unipolar EEG data were recorded using a Vectorview system (MEGIN Oy, Espoo, Finland). These data were originally acquired alongside 306-channel MEG recordings; however, the MEG channels have been removed for the purposes of this EEG-focused workshop.

The dataset is part of the MNE-Python tutorial datasets.
For the hands-on session, the modified EEG-only version is available until July 27, 2025, at the following link:
https://transfer.megin.services/

After this date, please refer to the original dataset available through the MNE-Python website.

Major analysis steps
---
* Read and review data
* Read triggers and define events
* Bandpass filtering
* Applying ICA
* Data segmentation or epoching
* Omitting bad trials and channels 
* Trials averaging and visualization
* MRI segmentation
* MRI-EEG coregistration
* Head model preparation
* Forward model computation
* Data and noise covariance
* Beamformer (LCMV) filter computation
* Source mapping and visualization

System requirements
---
* RAM (Memory) > 4 GB
* Disk space > 10 GB

MATLAB and FieldTrip installation instructions
---
As part of the workshop, you will participate in hands-on sessions that involve EEG recording and analysis. For a smooth learning experience, please make sure you have MATLAB installed and FieldTrip downloaded on your laptop. 
* To install MATLAB, first check if your institute provides MATLAB access. If not, you can buy MATLAB from the official MATLAB website: https://in.mathworks.com/
* Alternatively, you can get a 30-day trial license from the following link: https://in.mathworks.com/campaigns/products/trials.html?prodcode=ML&s_iid=isrch_trial_ZZ_bb 
* Please follow the installation process as per your laptop operating system: 
https://in.mathworks.com/help/install/ug/install-products-with-internet-connection.html 
* We will use the FieldTrip toolbox in MATLAB for the EEG analysis; please download from this link: https://www.fieldtriptoolbox.org/download.php
- Note: Please do the installation in advance to utilize the sessions to the maximum.
 