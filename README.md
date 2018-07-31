### Title  
Effect modification and collapsibility when estimating the effect of public health interventions: A Monte Carlo Simulation comparing classical multivariable regression adjustment versus the G-Formula based on a cancer epidemiology illustration  

### Authors
Miguel Angel Luque-Fernandez, Daniel Redondo Sanchez and Michael Schomaker   
  
### Supplement to the AJPH's editorial letter

The **American Journal of Public Health** series "Evaluating Public Health Interventions" is offering excellent practical guidance to researchers in public health.  In the 8<sup>th</sup> part of the series, a valuable introduction to effect estimation of time-invariant public health interventions was given.[1] The authors of this article suggested that in terms of bias and efficiency there is no advantage of using modern causal inference methods over classical multivariable modeling.[1] However, this statement is not always true. Most importantly, both **“effect modification”** and **“collapsibility”** are important concepts when assessing the validity of using regression for causal effect estimation.  

**Cancer epidemiology example**  

To discuss these concepts we are looking at an example from cancer epidemiology. In this example, we are interested in the effect of dual treatment therapy (radio- and chemotherapy, compared to single therapy (chemotherapy only) on the probability of one-year survival among colorectal cancer patients. We know that there exist confounders which affect both treatment assignment and the outcome, namely clinical stage, socioeconomic status, comorbidities, and age. Evidence shows that older patients with comorbidities have a lower probability of being offered more aggressive treatments and therefore they usually get less effective curative options. Also, colorectal cancer patients from lower socioeconomic status have a higher probability of presenting an advanced clinical stage at diagnosis thus they usually do not get treatment with the curative intent being offered just palliative treatments.  

**Our structural assumptions in the cancer epidemiology example**  

The assumptions from above can be encoded in a directed acyclic graph (DAG) (Figure 1). Here, each circle represents a variable and an arrow from A to B (A -> B) means that we assume that A causes B. The combination of these structural assumptions and appropriate statistical methods allow us to estimate the causal effect of dual therapy versus monotherapy on colorectal cancer patients' survival.  

**Figure 1** Directed Acyclic Graph    

![Figure Link](https://github.com/migariane/hetmor/blob/master/Figure1.png)  

**The question we want to answer**  

A clinician may be interested in the following:     
how different would the risk of death have been had everyone received dual therapy compared to if everyone had experienced monotherapy? The causal marginal odds ratio (MOR) answers this question. Statisticians call this a “target quantity.” Each individual has a pair of potential outcomes: the outcome they would have received had they been exposed to dual treatment (A=1), denoted Y(1), and the outcome had they been unexposed, Y(0). The MOR is defined as:  

![Figure Link](https://github.com/migariane/hetmor/blob/master/MOR1.png)

A common approach would be to use logistic regression to model the odds of mortality given the intervention, and adjust for the confounders (W) which are clinical stage, comorbidities, socioeconomic status and age. Note that this regression will estimate the conditional odds ratio (COR), which is: 

![Figure Link](https://github.com/migariane/hetmor/blob/master/COR1.png)  

MOR and COR are typically not identical. First, if there is effect modification, e.g. if the effect of dual therapy is different for patients with no comorbidities compared to those having hypertension, then logistic regression (possibly including an interaction of treatment with one of the confounders) will not provide a marginal effect estimate, but only one conditional on the respective morbidity. To be more precise: we obtain an odds ratio that is valid for a given group of people, say those with hypertension, but it will not give us a marginal estimate. However, we are interested in a marginal estimate because we want to know if the dual therapy works in general. Of course, one may be specifically interested in patients with hypertension, but then the OR for this group is again conditional on the other variables, for example for elderly people, from a low socio-economic level, and advanced stage.        

Second, the odds ratio is non-collapsible which means that the MOR is not necessarily equal to the stratum-specific OR, i.e. the COR. This statement holds even when W is only related to the outcome, and not the intervention, and thus not a confounder.[2,3] In fact, it is even possible that the conditional odds ratio shows a benefit of the intervention in every stratum, but no benefit overall, i.e. marginally. This case is known as Simpson’s paradox. We encourage the reader to read the below references 2 and 3 plus Judea Pearls' new book, **The book of why**. Please note that while the odds ratio in non-collapsible, other measures of association like the risk-difference and the risk ratios are collapsible.   

**Multivariable regression versus the G-Formula**

To identify the MOR, classical epidemiologic methods, such as standard multivariable logistic regression models where the treatment is included as a covariate in the analysis, require the assumption that the effect measure of the treatment of interest is constant across the levels of confounders included in the model.[4] However, in observational studies evaluating the effect of public health interventions, this is often not the case (i.e. the effect of the intervention might differ across individuals with different susceptibilities or characteristics. The effect is assumed to be heterogeneous at a population level). This is essentially the first point we made in the paragraph above. The second point says that certain effect measures, like the odds ratio, suffer from non-collapsibility.     

Thus, in summary, as pointed out by Spiegelmann et al [1] it can a be an option to use regression models to adjust for confounding; but we need to assume  no effect modification and we need to choose  a measure that is collapsible, like the **risk difference**, rather than the odds ratio.    

An alternative to using multivariable regression adjustment is the **G-Formula** [5] (a generalization of standardization with respect to the confounder distribution). In 1986, a seminal paper [5] demonstrated that under assumptions (conditional exchangeability, positivity, consistency, and non-interference), a consistent estimate of the MOR can be obtained using the G-formula. Under the assumption that the DAG above (Figure 1) is correct and the other assumptions, we can estimate the MOR using the g-formula as follows:    

![Figure Link](https://github.com/migariane/hetmor/blob/master/MOR.png)  
where P(W=w) refers to the marginal probability of w. 

This means we are still using a logistic regression model in the first step, but then we standardize the conditional odds ratio with respect to the confounder distribution (W), to obtain a marginal estimate. Furthermore, to identify the MOR, classical epidemiologic methods, such as standard multivariable logistic regression models where the treatment is included as a covariate in the analysis, require the assumption that the effect measure of the treatment of interest is constant across the levels of confounders included in the model.[4] However, in observational studies evaluating the effect of public health interventions, this is often not the case (i.e. the effect of the intervention might differ across individuals with different susceptibilities or characteristics. The effect of the intervention is difficult to be considered as homogeneous at a population level). G-computation,[6] based on the estimation of the components in the G-formula, allows for a treatment effect that may vary across the levels of the confounders.  

**A Monte-Carlo simulation**  

To prove the above statements, we develop a Monte Carlo simulation describing the above population-based cancer epidemiology scenario and provide the R code for replication in this GitHub repository: ([R script for simulation](https://github.com/migariane/hetmor/blob/master/MonteCarloSimulation.r)). Briefly, we want to estimate one-year mortality risk of death (odds ratio) (Y) for cancer patients treated with monotherapy (only chemotherapy; A=0) versus dual therapy (treatment with radiotherapy and chemotherapy; A=1) while controlling for possible confounders (W). It is a relevant research question that answered at a population level may have important public health implications for cancer patients.  

In order to be able to consistently estimate the MOR, the data must satisfy the following assumptions: i) Cancer treatment is independent of the potential mortality outcomes (Y(0), Y(1)) after conditioning on W. This assumption is often referred to as “conditional exchangeability” and one cannot test it using the observed data. It implies that (within the strata of W) the mortality risk under the potential treatment A=1, i.e. P(Y(1)=1|A=1,W) equals the one under treatment A=0, i.e. P(Y(1)=1|A=0,W). In other words: the risk of death for those treated would have been the same as for those untreated if untreated subjects had received, contrary to the fact, the treatment. This is equivalent to assuming that all confounders have been measured. ii) We also assume that within strata of W every patient had a nonzero probability of receiving either of the two treatment conditions, i.e. 0 <P(A=1|W)<1 (positivity). iii) We assume consistency, which states that we observe the potential outcome corresponding with the observed treatment, i.e. for any individual, Y = AY(1) + (1 – A)Y(0). Also, iv) in defining an individual’s counterfactual outcome as only a function of their own treatment, we assume non-interference, meaning that the counterfactual outcome of one subject was not influenced by the treatment of any other. Thus, if we believe these assumptions to hold and the sample size to be sufficient, we may interpret our estimate of the MOR approximately as the marginal causal riks of one-year mortality for cancer patients treated with monotherapy versus dual therapy.   

**Data generation process**  

We used the R-package simcausal [7] to generate data according to the DAG introduced above.  The data are (W= (w1, w2, w3, w4), A, Y) where w1 refers to age, w2 to socioeconomic status, w3 to comorbidities, and w4 to cancer stage. The detailed setup can be found here ([R script for simulations](https://github.com/migariane/hetmor/blob/master/MonteCarloSimulation.r)). In the outcome model, we included an interaction term between treatment A and both comorbidities (W2) and cancer stage (W4), based on the plausible biological mechanism that there is an increased risk of comorbidities among older adults and a different treatment effect for those patients with and without comorbidities and advanced cancer stage. The simulation is based on a sample size of 5000, and 10.000 simulation runs. We estimate the bias with respect to the MOR. Figure 2 shows the results of the above described Monte Carlo simulation.           

**Figure 2** Absolute bias with respect the marginal causal odds ratio comparing the conditional odds ratio from classical multivariable logistic regression models versus the marginal odds ratio from G-computation based on the G-Formula, n = 5,000 and 10,000 simulation runs.  

![Figure Link](https://github.com/migariane/hetmor/blob/master/Figure2.png)  

Briefly, one can see the bias of the multivariable logistic regression model is more pronounced under effect modification but persists -due to non-collapsibility- even under no effect modification. One explanation for a discrepancy between the conditional and marginal odds ratio could be that w is a confounder; this would typically be the argument for adjusting for w requiring that w is associated with both A and Y. However, the conditional odds ratio may differ from the marginal odds ratio even when **w is independent of A**. This numerical artifact is often referred to as the non-collapsibility of the odds ratio.[2]

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
Luque-Fernandez MA, Daniel Redondo Sanchez, Michael Schomaker (2018). Effect modification and collapsibility when estimating the effect of interventions: A Monte Carlo Simulation comparing classical multivariable regression adjustment versus the G-Formula based on a cancer epidemiology illustration. GitHub repository, https://github.com/migariane/hetmor.    
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


