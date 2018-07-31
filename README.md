### Title  
Effect modification and collapsibility when estimating the effect of interventions: A Monte Carlo Simulation comparing classical multivariable regression adjustment versus the G-Formula based on a cancer epidemiology illustration  

### Authors
Miguel Angel Luque-Fernandez* 1,2,3; Daniel Redondo Sanchez 1; Michael Schomaker 4    

### Authors' affiliations  
1. Biomedical Research Institute of Granada. Non-Communicable and Cancer Epidemiology Group, University of Granada, Granada, Spain. 
2. Harvard T.H. Chan School of Public Health. Department of Epidemiology. Boston, U.S.    
3. Faculty of Epidemiology and Population Health. Department of Non-Communicable Disease Epidemiology. Cancer Survival Group. London School of Hygiene and Tropical Medicine, London, U.K.   
4. The University of Cape Town, School of Public Health and Family Medicine, Center for Infectious Disease Epidemiology and Research. Cape Town, South Africa.  

**Corresponding author**:  
Miguel Angel Luque-Fernandez, PhD  
miguel-angel.luque at lshtm.ac.uk  

### Supplement to the AJPH's editorial letter
The **American Journal of Public Health** series "Evaluating Public Health Interventions" is offering excellent practical guidance to researchers in public health.  In the 8<sup>th</sup> part of the series, a valuable introduction to effect estimation of time-invariant public health interventions was given.[1] The authors of this article suggested that in terms of bias and efficiency there is no advantage of using modern causal inference methods over classical multivariable modeling.[1] However, this statement is not always true. Most importantly, both **“effect modification”** and **“collabsability”** are important concepts when assessing the validity of using regression for causal effect estimation. Suppose we are interested in the effect of combined radio- and chemotherapy versus chemotherapy only on one year mortality in patients diagnosed with colorectal cancer. A clinician may ask: how would the risk of death have been had everyone received dual therapy compared to if everyone had received monotherapy? The causal marginal odds ratio (MOR) answers this question: each individual has a pair of potential outcomes: the outcome they would have received had they been exposed (A=1), denoted Y(1), and the outcome had they been unexposed, Y(0). The MOR is defined as [P(Y(1)=1)/(1-P(Y(1)=1))] / [P(Y(0)=1)/(1-P(Y(0)=1))]. A common approach would be to use logistic regression to model the odds of mortality given the intervention and adjusted for confounders (W) such as clinical stage, co-morbidities, and others. Note that this regression will estimate the conditional odds ratio (COR), which is [P(Y=1|A=1,W)/(1-P(Y=1|A=1,W))] / [P(Y=1|A=0,W)/(1-P(Y=1|A=0,W))]. MOR and COR are typically not identical. First, if there is effect modification, e.g. if the effect of dual therapy is different between patients with no co-morbidities compared to those having hypertension, then logistic regression will not provide a marginal effect estimate, but only one conditional on the respective morbidity. Second, the odds ratio is non-collapsible which means that the MOR is not necessarily equal to the stratum-specific OR, i.e. the COR, even when W is only related to the outcome, and not the intervention, and thus not a confounder.[2,3] 

To identify the MOR, classical epidemiologic methods, such as standard multivariable logistic regression models where the treatment is included as a covariate in the analysis, require the assumption that the effect measure of the treatment of interest is constant across the levels of confounders included in the model.[4] However, in observational studies evaluating the effect of public health interventions, this is often not the case (i.e. the effect of the intervention might differ across individuals with different susceptibilities or characteristics. The effect is assumed to be heterogeneous at a population level). In 1986, a seminal paper [5] demonstrated that under untestable causal assumptions (conditional exchangeability, positivity, consistency, and non-interference), a consistent estimate of the MOR can be obtained using the G-formula [5] (a generalization of standardization with respect to the confounder distribution) as follows: 

![Figure Link](https://github.com/migariane/hetmor/blob/master/MOR.png)  
where P(W=w) refers to the marginal probability of w.  
 
G-computation,[6] based on the estimation of the components in the G-formula, allows for a treatment effect that may vary across the levels of the confounders. 

To prove the above statements, we develop a Monte Carlo simulation describing the above population-based cancer epidemiology scenario. Briefly, we want to estimate one-year mortality risk of death (odds ratio) (Y) for cancer patients treated with monotherapy (only chemotherapy; A=0) versus dual therapy (treatment with radiotherapy and chemotherapy; A=1) while controlling for possible confounders (W). It is a relevant research question that answered at a population level may have an important public health impact for cancer patients. In order to be able to consistently estimate the MOR, the data must satisfy the following assumptions: i) Cancer treatment is independent of the potential mortality outcomes (Y(0),Y(1)) after conditioning on W. This assumption is often referred to as “conditional exchangeability” and one cannot test it using the observed data. It implies that (within the strata of W) the mortality risk under the potential treatment A=1, i.e. P(Y(1)=1|A=1,W) equals the one under treatment A=0, i.e. P(Y(1)=1|A=0,W). In other words: the risk of death for those treated would have been the same as for those untreated if untreated subjects had received, contrary to the fact, the treatment. This is equivalent to assuming that all confounders have been measured. ii) We also assume that within strata of W every patient had a nonzero probability of receiving either of the two treatment conditions, i.e. 0 <P(A=1|W)<1 (positivity). iii) We assume consistency, which states that we observe the potential outcome corresponding with the observed treatment, i.e. for any individual, Y = AY(1) + (1 – A)Y(0). Also, iv) in defining an individual’s counterfactual outcome as only a function of their own treatment, we assume non-interference, meaning that the counterfactual outcome of one subject was not influenced by the treatment of any other. Thus, if we believe these assumptions to hold and the sample size to be sufficient, we may interpret our estimate of the MOR approximately as the marginal causal riks of one-year mortality for cancer patients treated with monotherapy versus dual therapy. 

**Data generation process**  
We generated data, denoted as the set of i.i.d variables O = (W = (W1, W2, W3, W4), A, Y), based on the directed acyclic graph illustrated in Figure 1.   
**Figure 1** Directed Acyclic Graph    

![Figure Link](https://github.com/migariane/hetmor/blob/master/Figure1.png)  

Briefly, we used the R-package simcausal [7] to generate  O = (W= (w1, w2, w3, w4), A, Y). w1: age, was generated as Bernoulli variable with probability 0.6 (advanced age); w2: socioeconomic status, w3: comorbidities, and w3: cancer stage, were generated as categorical variables based with five, six and four levels, respectively. The treatment variable contrasted the effect of only chemotherapy versus chemotherapy + radiotherapy (A = 0 chemotherapy and A = 1 chemotherapy + radiotherapy). The treatment variable (A), the confounders (W) and the potential outcomes (Y(1), Y(0)) were generated as binary indicators using log-linear models (see Rscript for more details). In the treatment and outcome models, we included an interaction term between treatment with comorbidities (W2) and cancer stage (W4) based on plausible biological mechanisms such as an increased risk of comorbidities among older adults. Then, we generated a sample size of 5000, and run 10.000 simulations for four different scenarios to estimate the MOR. 

Figure 2 shows the results of a simulation based on the above-described cancer scenario. The setting compares the bias with respect to the MOR for logistic regression versus the G-Formula [6,8] for four different levels of effect modification (EM) (i.e., no effect modification, mild effect modification, effect modification and strong effect modification).  

**Figure 2** Absolute bias with respect the marginal causal odds ratio comparing the conditional odds ratio from classical multivariable logistic regression models versus the marginal odds ratio from G-computation based on the G-Formula, n = 5,000 and 10,000 simulation runs.

![Figure Link](https://github.com/migariane/hetmor/blob/master/Figure2.png)  

One can see the bias of logistic regression is more pronounced under EM but persists -due to non-collapsibility- even under no EM. One explanation for a discrepancy between the conditional and marginal odds ratio could be that w is a confounder; this would typically be the argument for adjusting for w requiring that w is associated with both A and Y. However, the conditional odds ratio may differ from the marginal odds ratio **even when w is independent of A**. This numerical artifact is often referred to as non-collapsibility.[2]

#### Acknowledgements
MALF is supported by the Spanish National Institute of Health Carlos III Miguel Servet I Investigator Award (CP17/00206)  
#### Figure legends
**Figure 1**. Directed Acyclic Graph.  

**Figure 2**. Results from the simulation described on https://github.com/migariane/hetmor. One wants to compare the mortality risk after 1 year of patients with dual therapy (radio- and chemotherapy) with patients on dual therapy (chemotherapy only). Known confounders are age, socioeconomic status, comorbidities, and clinical stage. The absolute bias with respect to the marginal causal odds ratio is reported, based on a sample size of 5000, and 10.000 simulation runs.   

#### Thank you  
Thank you for reading through this epidemiological material.  
If you have updates or changes that you would like to make, please send <a href="https://github.com/migariane/hetmor" target="_blank">me</a> a pull request.
Alternatively, if you have any questions, please e-mail us at miguel-angel.luque at lshtm.ac.uk

You can **cite** this repository as:        
Luque-Fernandez MA, Daniel Redondo Sanchez, Michael Schomaker (2018). Effect modification and collapsibility when estimating the effect of interventions: A Monte Carlo Simulation comparing classical multivariable regression adjustment versus the G-Formula based on a cancer epidemiology illustration . GitHub repository, https://github.com/migariane/hetmor.    
**Twitter** `@WATZILEI`  

### References
1.	Spiegelman D, Zhou X. Evaluating Public Health Interventions: 8. Causal Inference for Time-Invariant Interventions. Am J Public Health. 2018:e1-e4.  
2.	Greenland S, Robins JM, Pearl J. Confounding and collapsibility in causal inference. Statistical Science. 1999;14(1):29-46.  
3.	Sjolander A, Dahlqwist E, Zetterqvist J. A Note on the Noncollapsibility of Rate Differences and Rate Ratios. Epidemiology. 2016;27(3):356-359.  
4.	Keil AP, Edwards JK, Richardson DB, Naimi AI, Cole SR. The parametric g-formula for time-to-event data: intuition and a worked example. Epidemiology. 2014;25(6):889-897.  
5. Greenland S, Robins JM. Identifiability, exchangeability, and epidemiological confounding. International journal of epidemiology. 1986;15(3):413--419  
6. Snowden JM, Rose S, Mortimer KM. Implementation of G-computation on a simulated data set: demonstration of a causal inference technique. Am J Epidemiol. 2011;173(7):731-738. 
7. Sofrygin O, van der Laan MJ, Neugebauer R (2015). simcausal: Simulating Longitudinal Data with Causal Inference Applications. R package version 0.5.  
8. Luque Fernandez MA, Schomaker M, Rachet B, Schnitzer ME. Targeted maximum likelihood estimation for a binary treatment: A tutorial. Stat Med. 2018;37:2530-2546. 


