
# 🧠 EEGwsIITMandi2025

This repository contains code and resources for the **EEG-FieldTrip Workshop** organized at **IIT Mandi, India**, from **July 24–26, 2025**.

---

## 📂 Lecture slides
- **[Open-source EEG/MEG analysis software: FieldTrip toolbox in detail](https://)**
- **[Forward and inverse solutions for EEG/MEG source reconstruction](https://)**
- **[EEG/MEG source reconstruction using beamformers](https://)**
---

## 👉👉 Question channel
Ask you questions and doubts here: **[Questions??](https://docs.google.com/document/d/1m96PZiQVzDXJGZehgrLyG3b7Z3ZSNB8H8EwihHJh9_g/edit?usp=sharing)** 

## 📂 Test Data Description

The **60-channel unipolar EEG data** were recorded using a **Vectorview system** (MEGIN Oy, Espoo, Finland). These data were originally acquired alongside **306-channel MEG recordings**; however, **MEG channels have been removed** for this EEG-focused workshop.

The dataset is a subset of the official **MNE-Python tutorial datasets**.

👉 For the hands-on session, a **EEG-only version** is available at:  
**[Download hands-on data](https://drive.google.com/drive/folders/1VsYW37wIM7R8xNUFmQY9K_h37B-Q_w5F?usp=sharing)**

Please refer to the original dataset via the official **MNE-Python** website.

---

## 🧪 Major Analysis Steps

- Read and review data  
- Read triggers and define events  
- Bandpass filtering  
- Applying ICA  
- Data segmentation (epoching)  
- Omitting bad trials and channels  
- Trial averaging and visualization
- Sensor-level ERP analysis
- Time-frequency analysis
- MRI segmentation  
- MRI-EEG coregistration  
- Head model preparation  
- Forward model computation  
- Data and noise covariance computation  
- Beamformer (LCMV) filter computation  
- Source mapping and visualization  
- Multivariate pattern analysis (MVPA)

---

## 💻 System Requirements

- **RAM:** > 4 GB  
- **Disk space:** > 10 GB  

---

## 🧰 MATLAB and FieldTrip Installation Instructions

You will participate in hands-on sessions involving EEG recording and analysis.  
To ensure a smooth experience, please **pre-install** the following:

### 🔧 MATLAB Installation

- If your institute provides MATLAB access, use that to install.
- Otherwise, you can purchase MATLAB from the [official site](https://in.mathworks.com/).
- Or get a **30-day trial license**:  
  [https://in.mathworks.com/campaigns/products/trials.html?prodcode=ML&s_iid=isrch_trial_ZZ_bb](https://in.mathworks.com/campaigns/products/trials.html?prodcode=ML&s_iid=isrch_trial_ZZ_bb)

📌 Installation guide for different operating systems:  
[https://in.mathworks.com/help/install/ug/install-products-with-internet-connection.html](https://in.mathworks.com/help/install/ug/install-products-with-internet-connection.html)

### 🧠 FieldTrip Toolbox

We will use the **FieldTrip toolbox** in MATLAB for EEG analysis. Download it here:  
[https://www.fieldtriptoolbox.org/download.php](https://www.fieldtriptoolbox.org/download.php)

📌 Installation:
Download, extract (unzip) and add path to your MATLAB:  
addpath(‘fieldtrip directory on your drive’)  
ft_defaults	 


---


 