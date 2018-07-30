### Title  
Effect modification and collapsability when estimating the effect of interventions: A Monte Carlo Simulation comparing classical multivariable regression adjustment versus the G-Formula based on a cancer epidemiology illustration  

### Authors
Miguel Angel Luque-Fernandez* 1,2,3; Daniel Redondo Sanchez 3; Michael Schomaker 4    

### Authors' affiliations  
1. Biomedical Research Institute of Granada. Non-Communicable and Cancer Epidemiology Group, University of Granada, Granada, Spain. 
2. Harvard T.H. Chan School of Public Health. Department of Epidemiology. Boston, U.S.    
3. Faculty of Epidemiology and Population Health. Department of Non-Communicable Disease Epidemiology. Cancer Survival Group. London School of Hygiene and Tropical Medicine, London, U.K.   
4. The University of Cape Town, School of Public Health and Family Medicine, Center for Infectious Disease Epidemiology and Research. Cape Town, South Africa.  

**Corresponding author**:  
Miguel Angel Luque-Fernandez, PhD  
miguel-angel.luque at lshtm.ac.uk  

### Supplement to the AJPH's editorial letter
The **American Journal of Public Health** series "Evaluating Public Health Interventions" is offering excellent practical guidance to researchers in public health.  In the 8<sup>th</sup> part of the series, a valuable introduction to effect estimation of time-invariant public health interventions was given.1 The authors of this commentary suggested that in terms of bias and efficiency there is no advantage of using modern causal inference methods over classical multivariable modeling.1 However, this statement is not always true. Most importantly, both “effect modification” and “collabsability” are important concepts when assessing the validty of using regression for causal effect estimation. Suppose we are interested in the effect of combined radio- and chemotherapy  versus chemotherapy only on 1 year mortality in patients diagnosed with colorectal cancer.  A clinician may ask: how would the risk of death have been had everyone received dual therapy compared to if everyone had received monotherapy? The causal marginal odds ratio (MOR) answers this question: each individual has a pair of potential outcomes: the outcome they would have received had they been exposed (A=1), denoted Y(1), and the outcome had they been unexposed, Y(0). The MOR is defined as [P(Y(1)=1)/(1-P(Y(1)=1))] / [P(Y(0)=1)/(1-P(Y(0)=1))]. A common approach would be to use logistic regression to model the odds of mortality given the intervention and adjusted for confounders (L) such as clinical stage, co-morbidities, and others. Note that this regression will estimate the conditional odds ratio (COR), which is [P(Y=1|A=1,L)/(1-P(Y=1|A=1,L))] / [P(Y=1|A=0,L)/(1-P(Y=1|A=0,L))]. MOR and COR are typically not identical. First, if there is effect modification, e.g. if the effect of dual therapy is different between patients with no co-morbidities compared to those having hypertension, then logistic regression will not provide a marginal effect estimate, but only one conditional on the respective morbidity. Second, the odds ratio is non-collapsible which means that the MOR is not necessarily equal to the stratum-specific OR, i.e the COR, even when L is only related to the outcome, and not the intervention, and thus not a confounder. 2,3 Figure 1 shows the results of a simulation based on the above described cancer scenario. The setting compares the bias with respect to the MOR for logistic regression versus the G-Formula4,5 (a causal inference method) - for different levels of effect modification (EM). The details of the setup can be found online (https://github.com/migariane/hetmor). One can see the bias of logistic regression, which is more pronounced under EM, but persists -due to non-collapsability- even under no EM.

#### Acknowledgements
MALF is supported by the Spanish National Institute of Health Carlos III Miguel Servet I Investigator Award (CP17/00206)  

#### Figure legends
**Figure 1**. Directed Acyclic Graph.  

![Figure Link](https://github.com/migariane/hetmor/blob/master/Figure1.png)  

**Figure 2**.  Results from the simulation described on https://github.com/migariane/hetmor. One wants to compare the mortality risk after 1 year of patients with dual therapy (radio- and chemotherapy) with patients on dual therapy (chemotherapy only). Known confounders are age, socioeconomic status, co-morbidities, and clinical stage. The absolute bias with respect to the marginal causal odds ratio is reported, based on a sample size of 5000, and 10.000 simulation runs.   

![Figure Link](https://github.com/migariane/hetmor/blob/master/Figure2.png)  

### References
1.	Spiegelman D, Zhou X. Evaluating Public Health Interventions: 8. Causal Inference for Time-Invariant Interventions. Am J Public Health. 2018:e1-e4.  
2.	Greenland S, Robins JM, Pearl J. Confounding and collapsibility in causal inference. Statistical Science. 1999;14(1):29-46.  
3.	Sjolander A, Dahlqwist E, Zetterqvist J. A Note on the Noncollapsibility of Rate Differences and Rate Ratios. Epidemiology. 2016;27(3):356-359.  
4.	Luque Fernandez MA, Schomaker M, Rachet B, Schnitzer ME. Targeted maximum likelihood estimation for a binary treatment: A tutorial. Stat Med. 2018;37:2530-2546.  
5.	Snowden JM, Rose S, Mortimer KM. Implementation of G-computation on a simulated data set: demonstration of a causal inference technique. Am J Epidemiol. 2011;173(7):731-738.  

