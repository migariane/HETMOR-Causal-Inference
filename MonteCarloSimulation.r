#######################################################################################################
# Miguel Angel Luque Fernandez, Daniel Redondo Sanchez and Michael Schomaker
# American Journal of Public Health (AJPH)
# Letter to the Editor 
# Title:
# Evaluating the effectiveness of public health interventions under non-collapsability 
# of the marginal odds ratio and effect modification: A Monte Carlo Simulation comparing classical
# multivariable regression adjustment versus the G-Formula based on a cancer epidemiology illustration
#######################################################################################################

# Copyright (c) 2018  <Miguel Angel Luque-Fernandez, Daniel Redondo Sanchez and Michael Schomaker>
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

##############################################################################################

# Install R packages
# install.packages(c("simcausal","SuperLearner","tmle","ltmle","ggplot2"))
library(simcausal)
library(SuperLearner)
library(tmle)
library(ltmle)
library(ggplot2)

##############################################################################################################################################
# Structural setting for the relationship between variables extracted from a population-based cancer epidemiology example aiming to estimate
# the impact of only chemotherapy versus dual therapy (chemotherapy plus radiotheraphty) on one year mortality among colorectal cancer patients
###############################################################################################################################################

# Setting the structural framework of the relationship between variables for the Monte Carlo simulation
# We generated data, denoted as the set of i.i.d variables O = (W=(W1, W2, W3, W4), A, Y), based on
# the directed acyclic graph1 illustrated in Figure 1 (Directed Acyclic Graph): 
# w1: age, was generated as Bernoulli variable with probability 0.6. 
# w2: comorbidities, w2: socieconomic status and w3: cancer stage, were generated as ordinal variables
# with five, six and four levels, respectively. 
# The treatment vairable contrasted the effect of only chemotherapy versus chemotherapy + radiotherapy; 
# A = 0 chemotherapy and A = 1 chemotherapy + radiotherapy.
# The treatment variable (A) and the potential outcomes (Y(1), Y(0)) were generated as binary indicators using log-linear models. 
# In the treatment and outcome models, we included an interaction term between treatment with comorbidities (W2) and cancer stage (W4) based 
# on plausible biological mechanisms such as an increased risk of comorbidities among older adults.

# Using library simcausal to simulate the data 
M <- DAG.empty()
M <- M + 
  node("w1", #age (0/1); 1 -> Advanced age
       distr = "rbern",prob = 0.6) + 
  node("w2", #ses (1/2/3/4/5); Advanced age, higher probability of belonging to higher socioeconomic status
       distr = "rcat.b1",
       probs = { 
         plogis(-3.10 - 0.05 * w1);    # 1 = upper middle class, 4% 
         plogis(-1.25 - 0.04 * w1);    # 2 = middle class, 22%
         plogis(-0.05 - 0.03 * w1);    # 3 = lower middle 49%
         plogis(-1.65 - 0.02 * w1)     # 4 = working class 16%
           }) +                        # 5 = last class comes from "normalizing", about 9%
  node("w3", #comorbidities (1/2/3/4/5); 
       distr = "rcat.b1",
       probs = {
         plogis(-0.5 + 0.010 * w1 + 0.15 * w2)      # 1 = none
         plogis(-1.8 + 0.005 * w1 + 0.10 * w2);     # 2 = Hypertension
         plogis(-1.6 + 0.010 * w1 + 0.12 * w2);     # 3 = Diabetes II
         plogis(-1.5 + 0.010 * w1 + 0.15 * w2);     # 4 = other
         plogis(-2.5 + 0.020 * w1 + 0.20 * w2);     # 5 = alzheimer
         plogis(-2.3 + 0.015 * w1 + 0.15 * w2)}) +  # 6 = previous heart attack
  node("w4", # cancer stage (1/2/3/4); 
       distr = "rcat.b1",
       probs = {
         plogis(-0.4 + 0.02 * w1 - 0.050 * w2);    
         plogis(-1.0 + 0.03 * w1 - 0.055 * w2);
         plogis(-1.2 + 0.01 * w1 - 0.040 * w2)}) + 
  node("a", #a = 1 -> chemotherapy + radiotherapy; a = 0 chemo 
       distr = "rbern",
       prob = plogis(-2.3 + 0.05 * w2 + 0.25 * w3 + w4)) 

# 4 setups for the outcome under different levels of effect modification: no-effect, mild and strong effects      
M1 <- M + node("y", distr = "rbern", prob = 1 - plogis(4.25 + 2.9 * a - 0.65 * w1 - 0.25*w2 - 0.2 * w3 - 0.75 * w4))
M2 <- M + node("y", distr = "rbern", prob = 1 - plogis(4.25 + 2.9 * a - 0.65 * w1 - 0.25*w2 - 0.2 * w3 - 0.75 * w4 - 0.10 * a * w2 - 0.20 * a * w3))
M3 <- M + node("y", distr = "rbern", prob = 1 - plogis(4.25 + 2.9 * a - 0.65 * w1 - 0.25*w2 - 0.2 * w3 - 0.75 * w4 - 0.25 * a * w2 - 0.35 * a * w3))
M4 <- M + node("y", distr = "rbern", prob = 1 - plogis(4.25 + 2.9 * a - 0.65 * w1 - 0.25*w2 - 0.2 * w3 - 0.75 * w4 - 0.35 * a * w2 - 0.45 * a * w3))


# Simulate small sample (n = 5000) to appreciate the structure of the data
Mset <- set.DAG(M2)
Odat <- simcausal::sim(DAG = Mset, n = 5000, rndseed = 345, verbose = F)
Odat1 <- Odat
Odat1$w1 <- factor(Odat$w1, levels = c(0,1),labels = c("young", "old"))
Odat1$w2 <- factor(Odat$w2, levels = c(1,2,3,4,5),label = c("1_upper middle", "2_middle", "3_lower middle", "4_working", "5_non-working"))
Odat1$w3 <- factor(Odat$w3, levels = c(1:6),labels = c("none", "hypertension", "diabetes", "other", "alzheimer", "heart attack"))
Odat1$w4 <- factor(Odat$w4, levels = c(1:4),labels = c("stage 1", "stage 2", "stage 3", "stage 4"))
Odat$a <- factor(Odat$a, levels = c(0,1),labels = c("chemo", "chemo+radio"))
summary(Odat1)

# Estimate TRUE marginal causal odds ratio  for all 4 data setups: 
# M1 under no interaction betwee treatament and covariates = homogeneous treatment effect
# M2 mild interaction betwee treatament and covariates = mild heterogeneous treatment effect
# M3 interaction betwee treatament and covariates = heterogeneous treatment effect
# M4 strong interaction betwee treatament and covariates = stronger heterogeneous treatment effect

############################
# Under M1 (no interaction)
############################
Mset <- set.DAG(M1)
a1 <- node("a", distr = "rbern", prob = 1)
Mset <- Mset + action("a1", nodes = a1)
a0 <- node("a", distr = "rbern", prob = 0)
Mset <- Mset + action("a0", nodes = a0)

dat <- simcausal::sim(DAG = Mset, actions = c("a1", "a0"), n = 10000000, rndseed = 666, verbose=F)

Mset <- set.targetE(Mset, outcome = "y", param = "a1")
M1y1 <- eval.target(Mset, data = dat)$res              # P(death with chemo and radio) = 0.0352066 
Mset <- set.targetE(Mset, outcome = "y", param = "a0")  
M1y0 <- eval.target(Mset, data = dat)$res              # P(death with chemo) = 0.3253395
Mset <- set.targetE(Mset, outcome = "y", param = "a1-a0") 
True_ATE_M1 <- eval.target(Mset, data = dat)$res       # Evaluate true ATE

# True Marginal Odds Ratio of Treatment M1
# True_mor_M1 <- (0.0352066 /(1-0.0352066)) / (0.3253395 / (1 - 0.3253395)); True_mor_M1
True_mor_M1 <- M1y1 * (1 - M1y0) / ((1 - M1y1) * M1y0); cat("MOR_M1:",True_mor_M1[[1]])

##############################
# Under M2 (mild interaction)
##############################
Mset <- set.DAG(M2)
a1 <- node("a", distr = "rbern", prob = 1)
Mset <- Mset + action("a1", nodes = a1)
a0 <- node("a", distr = "rbern", prob = 0)
Mset <- Mset + action("a0", nodes = a0)

dat <- simcausal::sim(DAG = Mset, actions = c("a1", "a0"), n = 10000000, rndseed = 666, verbose=F)

Mset <- set.targetE(Mset, outcome = "y", param = "a1")
M2y1 <- eval.target(Mset, data = dat)$res               # P(death with chemo and radio) = 0.0869532  
Mset <- set.targetE(Mset, outcome = "y", param = "a0")   
M2y0 <- eval.target(Mset, data = dat)$res               # P(death with chemo) = 0.3253395 
Mset <- set.targetE(Mset, outcome = "y", param = "a1-a0")
True_ATE_M2 <- eval.target(Mset, data = dat)$res        # Evaluate true ATE

# True Marginal Odds Ratio of Treatment M2
# True_mor_M2  <- (0.0869532  /(1-0.0869532))/(0.3253395/(1-0.3253395)); True_mor_M2
True_mor_M2 <- M2y1 * (1 - M2y0) / ((1 - M2y1) * M2y0); cat("MOR_M2:", True_mor_M2[[1]])

#########################
# Under M3 (interaction)
#########################
Mset <- set.DAG(M3)
a1 <- node("a", distr = "rbern", prob = 1)
Mset <- Mset + action("a1", nodes = a1)
a0 <- node("a", distr = "rbern", prob = 0)
Mset <- Mset + action("a0", nodes = a0)

dat <- simcausal::sim(DAG = Mset, actions = c("a1", "a0"), n = 10000000, rndseed = 666, verbose=F)

Mset <- set.targetE(Mset, outcome = "y", param = "a1")
M3y1 <- eval.target(Mset, data = dat)$res               # P(death with chemo and radio) = 0.1830828  
Mset <- set.targetE(Mset, outcome = "y", param = "a0")    
M3y0 <- eval.target(Mset, data = dat)$res               # P(death with chemo) = 0.3253395
Mset <- set.targetE(Mset, outcome = "y", param = "a1-a0")
True_ATE_M3 <- eval.target(Mset, data = dat)$res        # Evaluate true ATE

# True Marginal Odds Ratio of Treatment M3
# True_mor_M3  <- (0.1830828 /(1-0.1830828))/(0.3253395/(1-0.3253395))
True_mor_M3 <- M3y1 * (1 - M3y0) / ((1 - M3y1) * M3y0); cat("MOR_M3:",True_mor_M3[[1]])

#################################
# Under M4 (stronger interaction)
#################################
Mset <- set.DAG(M4)
a1 <- node("a", distr = "rbern", prob = 1)
Mset <- Mset + action("a1", nodes = a1)
a0 <- node("a", distr = "rbern", prob = 0)
Mset <- Mset + action("a0", nodes = a0)

dat <- simcausal::sim(DAG = Mset, actions = c("a1", "a0"), n = 10000000, rndseed = 666, verbose=F)

Mset <- set.targetE(Mset, outcome = "y", param = "a1")
M4y1 <- eval.target(Mset, data = dat)$res               # P(death with chemo and radio) = 0.2687067
Mset <- set.targetE(Mset, outcome = "y", param = "a0")  
M4y0 <- eval.target(Mset, data = dat)$res               # P(death with chemo) = 0.3253395
Mset <- set.targetE(Mset, outcome = "y", param = "a1-a0")
True_ATE_M4 <- eval.target(Mset, data = dat)$res        # Evaluate true ATE

# True Marginal Odds Ratio of Treatment M3
# True_mor_M4  <- (0.2687067   /(1-0.2687067))/(0.3253395/(1-0.3253395))
True_mor_M4 <- M4y1 * (1 - M4y0) / ((1 - M4y1) * M4y0); cat("MOR_M4:",True_mor_M4[[1]])

# Plot for the Directed Acyclic Graph
pdf("plot-dag.pdf", width = 10, height = 6)
plotDAG(Mset, xjitter = 0.3, yjitter = 0.04,
        edge_attrs = list(width = 0.5, arrow.width = 0.2, arrow.size = 0.3),
        vertex_attrs = list(size = 12, label.cex = 0.8))
dev.off()

##########################
# Monte Carlo Simulation #
##########################

# The absolute bias with respect to the marginal causal odds ratio is reported, based on a sample size of 5000, and 10.000 simulation runs.

R <- 10000

results_reg <- matrix(NA,ncol = 4,nrow = R)
results_g   <- matrix(NA,ncol = 4,nrow = R)

for(r in 1:R)try({
    if (r%%10 == 0) cat(paste("This is simulation run number",r, "\n"))
# M1
###########################
Mset <- suppressWarnings(set.DAG(M1, verbose = F))
simdat <- suppressWarnings(simcausal::sim(DAG = Mset, n = 5000, verbose = F))
#
results_reg[r,1] <- exp(coefficients(glm(y ~ a + w1 + w2 + w3 + w4, data = simdat, family = binomial)))[2]
#
is1 <- simdat
is1$a <- rep(1,dim(simdat)[1])
is2 <- simdat
is2$a <- rep(0,dim(simdat)[1])
ms1 <- glm(y ~ a + w1 + w2 + w3 + w4, data = simdat, family = binomial)
results_g[r,1] <- ((mean(predict(ms1,type = "response", newdata=is1))) / (1 - mean(predict(ms1,type = "response", newdata = is1)))) / ((mean(predict(ms1,type = "response",newdata = is2))) / (1 - mean(predict(ms1,type = "response", newdata = is2))))
# M2
##########################
Mset <- suppressWarnings(set.DAG(M2, verbose=F))
simdat <- suppressWarnings(simcausal::sim(DAG = Mset, n = 5000, verbose=F))
#
results_reg[r,2] <- exp(coefficients(glm(y ~ a + w1 + w2 + w3 + w4, data = simdat, family=binomial)))[2]
#
is1 <- simdat
is1$a <- rep(1,dim(simdat)[1])
is2 <- simdat
is2$a <- rep(0,dim(simdat)[1])
ms1 <- glm(y ~ a + w1 + w2 + w3 + w4 + a * w2 + a * w3, data = simdat, family = binomial)
results_g[r,2] <- ((mean(predict(ms1,type = "response", newdata = is1))) / (1 - mean(predict(ms1,type = "response",newdata=is1))))/((mean(predict(ms1,type="response",newdata=is2)))/(1-mean(predict(ms1,type="response",newdata=is2))))
# M3
##########################
Mset <- suppressWarnings(set.DAG(M3, verbose = F))
simdat <- suppressWarnings(simcausal::sim(DAG = Mset, n = 5000, verbose = F))
#
results_reg[r,3] <- exp(coefficients(glm(y ~ a + w1 + w2 + w3 + w4, data = simdat, family=binomial)))[2]
#
is1 <- simdat
is1$a <- rep(1,dim(simdat)[1])
is2 <- simdat
is2$a <- rep(0,dim(simdat)[1])
ms1 <- glm(y ~ a + w1 + w2 + w3 + w4 + a*w2 + a*w3, data = simdat, family = binomial)
results_g[r,3] <- ((mean(predict(ms1,type = "response", newdata = is1))) / (1 - mean(predict(ms1, type = "response", newdata = is1)))) / ((mean(predict(ms1,type = "response",newdata=is2))) / (1 - mean(predict(ms1,type = "response",newdata = is2))))
# M4
##########################
Mset <- suppressWarnings(set.DAG(M4, verbose = F))
simdat <- suppressWarnings(simcausal::sim(DAG = Mset, n = 5000, verbose=F))
#
results_reg[r,4] <- exp(coefficients(glm(y ~ a + w1 + w2 + w3 + w4, data = simdat, family = binomial)))[2]
#
is1 <- simdat
is1$a <- rep(1,dim(simdat)[1])
is2 <- simdat
is2$a <- rep(0,dim(simdat)[1])
ms1 <- glm(y ~ a + w1 + w2 + w3 + w4 + a*w2 + a*w3, data = simdat, family = binomial)
results_g[r,4] <- ((mean(predict(ms1,type = "response",newdata = is1)))/(1 - mean(predict(ms1,type = "response",newdata = is1)))) / ((mean(predict(ms1,type = "response",newdata = is2)))/(1 - mean(predict(ms1, type = "response",newdata = is2))))
##########################
})

# Estimating BIAS classic naive regression analysis versus G-Methods based on G-Formula
BIAS_reg <- abs(apply(results_reg,2,mean)-c(True_mor_M1,True_mor_M2,True_mor_M3,True_mor_M4))
BIAS_g   <- abs(apply(results_g,2,mean)-c(True_mor_M1,True_mor_M2,True_mor_M3,True_mor_M4))

# Plot Bias.pdf
pdf("Figure 1.pdf", width = 8) 
plot(NA, xlab = "Setting",ylab = "|Bias|", cex.lab = 1.5, lwd = 2,axes = F,ylim = c(-0.001, 0.12), xlim = c(0.8,4.2))
axis(side = 1, at = c(1,2,3,4),labels = c("no EM", "some EM", "EM", "strong EM"))
axis(side = 2, at = c(0,0.02,0.04,0.06,0.08,0.1,0.12),las = 1)   # ),labels=c("","2%","4%","6%","8%","10%","12%"))
title(main = "Absolute bias with respect to \n the marginal causal odds ratio")
abline(h = 0,lwd = 2,lty = 2,col = "blue")  
lines(c(1,2,3,4), BIAS_reg, type = "p",cex = 2, lwd = 2,col = "red", pch = 18)
lines(c(1,2,3,4), BIAS_g, type = "p",cex = 2, lwd = 2,col = "black", pch = 17)
legend("topleft",c("Multivariable Logistic Regression", "G-Formula: G-Computation"),col = c("red", "black"), pch = c(18,17), cex = 1.5,bty = "n")
dev.off()

# Plot Bias.tiff
tiff("Figure 1.tiff", width = 520)
plot(NA,xlab = "Setting", ylab = "|Bias|", cex.lab = 1.5, lwd = 2, axes = F, ylim = c(-0.001, 0.12), xlim = c(0.8,4.2))
axis(side = 1, at = c(1, 2, 3, 4), labels = c("no EM", "some EM", "EM", "strong EM"))
axis(side = 2, at = c(0, 0.02, 0.04, 0.06, 0.08, 0.1, 0.12),las = 1)   # ),labels = c("", "2%", "4%", "6%", "8%", "10%", "12%"))
title(main = "Absolute bias with respect to \n the marginal causal odds ratio")
abline(h = 0,lwd = 2,lty = 2,col = "blue")  
lines(c(1, 2, 3, 4), BIAS_reg, type = "p",cex = 2, lwd = 2,col = "red", pch = 18)
lines(c(1, 2, 3, 4), BIAS_g, type = "p" , cex = 2, lwd = 2,col = "black" ,pch = 17)
legend("topleft", c("Logistic regression", "G-Formula: G-Computation"), col =c("red","black"), pch = c(18, 17), cex = 1.5, bty= "n")
dev.off()

# Cite as: "Miguel Angel Luque-Fernandez, Daniel Redondo Sanches, Michael Schomaker (2018). 
# Evaluating the effectiveness of public health interventions under non-collapsability 
# of the marginal odds ratio and effect modification: A Monte Carlo Simulation comparing classical
# multivariable regression adjustment versus the G-Formula based on a cancer epidemiology illustration"