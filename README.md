# PNAS_2022-05407

Code and data for Palmer Foster 2022

Regarding the primary model, data files are .mat, while code is .m.

For each instance of running code, ensure your directory contains all functions required in the main script.

steadystateNutEx, LVfunc_EX, and LVfunc_Ex_NoDeg are the only functions required to run with the primary scripts.

If running code to recreate a PIP from the paper, make sure you are use all 3 parts of the code. First run Part 1, then Part 2, and finally Part 3. Part 1 is by far the most time consuming. However, I found it to be good practice to save the data from part 1, then examine the data from part 2, before proceeding to part 3. If you'd like to generate PIPs to examine the production rate ESS underlying the spectrum ESS, you can use GammaOnTheDiag.m after running part 1 and part 2. You have to choose the point on the X-axis of the figure generated by Part 2. Give this a try, it should be intuitive.

Part 1 can be quite slow (~2-4 hours), so I've included the data files generated by running the scripts for part 1. You can simply run the script all the way up until the main loops that cycle through the ODE solver in order to set all of the parameters appropriately, then just load the data file provided. You can then run Part 2 and Part 3 which are very fast, and the PIP of the manuscript will be automatically generated.

All plots shown in the paper are generated by the scripts written in this repository. In some instances, adobe illustrator was used to clarify data (i.e. when two variables followed identical trajectories, I manually offset the lines in illustrator, though made sure to always keep them in contact with one another.

For the statistical models, the two main scrips are BinaryPGLMM.R and MCMCglmm.R. They are annotated to make it clear which data files correspond to which script.

Please contact me via email with any enquiries and I will happily assist. Thank you for reading and your interest in my work.

Current institutional email: jacob [dot] palmer [at] biology [dot] ox [dot] ac [dot] uk

Personal email: jdpalmer40 [at] gmail [dot] com
