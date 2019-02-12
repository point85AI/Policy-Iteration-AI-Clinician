# Policy Iteration for Treating Sepsis Patients

This is the companion GitHub repository for the point85 blog post found [here](https://point85.ai/artificial-intelligence-clinician).

In the post we attempt to recreate the AI Clinician detailed by Komorowski, et al. in their _Nature Medicine_ article ["The Artificial Intelligence Clinician learns optimal treatment strategies for sepsis in intensive care."](https://www.nature.com/articles/s41591-018-0213-5)  This repository contains the MATLAB code used to recreate their AI clinician, and produce the individual patient dosing figures in that post.

## Getting Started
To replicate our results, simply clone the repository, navigate to the **model_generation** directory, and run the *main.m* script.  This will generate 500 models according to the methods in "The Artificial Intelligence Clinician learns optimal treatment strategies for sepsis in intensive care."

After generating the models (which will be stored in the **data** directory), navigate to the **analysis** directory and run the *run_analysis.m* script.  This will generate the figure comparing the clinician and AI Clinician expected policy values and will begin generating the figures that show the recommendations the AI Clinician makes with individual patients.

**CAUTION:**  The main script can be quite computationally expensive.  We have provided the .mat files for 500 models in the **data** directory to assist the readers with their own analysis.

### Directory Structure

    .
    ├── data                  # Normalized data and pre-generated models
    ├── analysis              # Code to perform our analysis of the models.
    ├── model_generation      # Code to generate the AI Clinician models.
    ├── LICENSE
    └── README.md

### Prerequisites
All code was written and tested using MATLAB 2018a and MATLAB 2018b for OSX and Linux.  There should not be any additional packages that are needed to replicate our analysis.  If you find this is not the case, please let us know.

### Data
The data that has been supplied is data from 5,366 septic patients in the [MIMIC III](https://mimic.physionet.org/) dataset after normalization (though, we have included the raw MAP values to compare the AI Clinician recommendations to the patients' MAP values).  Obtaining raw MIMIC III data requires creating a PhysioNet Works account.  Please see [here](https://mimic.physionet.org/gettingstarted/access/) for more details.  

## Authors

* **Russell Jeter** - *AI Clinician Implementation* - [SwankyFrobenius](https://github.com/SwankyFrobenius)

The rest of the authors contributed to the post at point85 and were heavily involved in the critical analysis of the original work.
* **Christopher Josef** - [aegis20](https://github.com/aegis20)
* **Shamim Nemati**  - [shamimNemati](https://github.com/shamimNemati)
* **Supreeth Shashikumar** - [supreethprajwal](https://github.com/supreethprajwal)

To cite this work, please cite the arXiv publication:

R. Jeter, C. Josef, S. Shashikumar, and S. Nemati, “Does the "Artificial Intelligence Clinician" learn optimal treatment strategies for sepsis in intensive care?,” [arXiv:1902.03271 [cs.AI]](https://arxiv.org/abs/1902.03271), February 2019.

## Contact
If you have any questions or concerns, please direct them to [admin@point85.ai](admin@point85.ai).
## License

This project is licensed and shared under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode) This means reproduction of the work is allowed provided that it is for non-commercial applications and the creating authors are cited.
