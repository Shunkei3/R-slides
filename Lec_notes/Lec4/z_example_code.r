###################################################
### chunk number 1: setup
###################################################

library("AER")

suppressWarnings(RNGversion("3.5.0"))

set.seed(1071)

###################################################
### chunk number 2: data-journals
###################################################
data("Journals")

journals <- Journals[, c("subs", "price")]

journals$citeprice <- Journals$price/Journals$citations

summary(journals)
      subs          price        citeprice     
 Min.   :   2   Min.   :  20   Min.   : 0.005  
 1st Qu.:  52   1st Qu.: 134   1st Qu.: 0.464  
 Median : 122   Median : 282   Median : 1.321  
 Mean   : 197   Mean   : 418   Mean   : 2.548  
 3rd Qu.: 268   3rd Qu.: 541   3rd Qu.: 3.440  
 Max.   :1098   Max.   :2120   Max.   :24.459  

###################################################
### chunk number 3: linreg-plot eval=FALSE
###################################################
## plot(log(subs) ~ log(citeprice), data = journals)
## jour_lm <- lm(log(subs) ~ log(citeprice), data = journals)
## abline(jour_lm)


###################################################
### chunk number 4: linreg-plot1
###################################################
plot(log(subs) ~ log(citeprice), data = journals)

jour_lm <- lm(log(subs) ~ log(citeprice), data = journals)

abline(jour_lm)

###################################################
### chunk number 5: linreg-class
###################################################
class(jour_lm)
[1] "lm"

###################################################
### chunk number 6: linreg-names
###################################################
names(jour_lm)
 [1] "coefficients"  "residuals"     "effects"      
 [4] "rank"          "fitted.values" "assign"       
 [7] "qr"            "df.residual"   "xlevels"      
[10] "call"          "terms"         "model"        

###################################################
### chunk number 7: linreg-summary
###################################################
summary(jour_lm)

Call:
lm(formula = log(subs) ~ log(citeprice), data = journals)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.7248 -0.5361  0.0372  0.4662  1.8481 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)
(Intercept)      4.7662     0.0559    85.2   <2e-16
log(citeprice)  -0.5331     0.0356   -15.0   <2e-16

Residual standard error: 0.75 on 178 degrees of freedom
Multiple R-squared:  0.557,     Adjusted R-squared:  0.555 
F-statistic:  224 on 1 and 178 DF,  p-value: <2e-16


###################################################
### chunk number 8: linreg-summary
###################################################
jour_slm <- summary(jour_lm)

class(jour_slm)
[1] "summary.lm"

names(jour_slm)
 [1] "call"          "terms"         "residuals"    
 [4] "coefficients"  "aliased"       "sigma"        
 [7] "df"            "r.squared"     "adj.r.squared"
[10] "fstatistic"    "cov.unscaled" 

###################################################
### chunk number 9: linreg-coef
###################################################
jour_slm$coefficients
               Estimate Std. Error t value   Pr(>|t|)
(Intercept)      4.7662    0.05591   85.25 2.954e-146
log(citeprice)  -0.5331    0.03561  -14.97  2.564e-33

###################################################
### chunk number 10: linreg-anova
###################################################
anova(jour_lm)
Analysis of Variance Table

Response: log(subs)
                Df Sum Sq Mean Sq F value Pr(>F)
log(citeprice)   1    126   125.9     224 <2e-16
Residuals      178    100     0.6               

###################################################
### chunk number 11: journals-coef
###################################################
coef(jour_lm)
   (Intercept) log(citeprice) 
        4.7662        -0.5331 

###################################################
### chunk number 12: journals-confint
###################################################
confint(jour_lm, level = 0.95)
                 2.5 %  97.5 %
(Intercept)     4.6559  4.8765
log(citeprice) -0.6033 -0.4628

###################################################
### chunk number 13: journals-predict
###################################################
predict(jour_lm, newdata = data.frame(citeprice = 2.11),
+    interval = "confidence")
    fit   lwr   upr
1 4.368 4.247 4.489

predict(jour_lm, newdata = data.frame(citeprice = 2.11), 
+    interval = "prediction")
    fit   lwr   upr
1 4.368 2.884 5.853

###################################################
### chunk number 14: predict-plot eval=FALSE
###################################################
## lciteprice <- seq(from = -6, to = 4, by = 0.25)
## jour_pred <- predict(jour_lm, interval = "prediction",
##   newdata = data.frame(citeprice = exp(lciteprice)))  
## plot(log(subs) ~ log(citeprice), data = journals)
## lines(jour_pred[, 1] ~ lciteprice, col = 1)    
## lines(jour_pred[, 2] ~ lciteprice, col = 1, lty = 2)
## lines(jour_pred[, 3] ~ lciteprice, col = 1, lty = 2)


###################################################
### chunk number 15: predict-plot1
###################################################
lciteprice <- seq(from = -6, to = 4, by = 0.25)

jour_pred <- predict(jour_lm, interval = "prediction",
+    newdata = data.frame(citeprice = exp(lciteprice)))  

plot(log(subs) ~ log(citeprice), data = journals)

lines(jour_pred[, 1] ~ lciteprice, col = 1)    

lines(jour_pred[, 2] ~ lciteprice, col = 1, lty = 2)

lines(jour_pred[, 3] ~ lciteprice, col = 1, lty = 2)

###################################################
### chunk number 16: journals-plot eval=FALSE
###################################################
## par(mfrow = c(2, 2))
## plot(jour_lm)
## par(mfrow = c(1, 1))


###################################################
### chunk number 17: journals-plot1
###################################################
par(mfrow = c(2, 2))

plot(jour_lm)

par(mfrow = c(1, 1))

###################################################
### chunk number 18: journal-lht
###################################################
linearHypothesis(jour_lm, "log(citeprice) = -0.5")
Linear hypothesis test

Hypothesis:
log(citeprice) = - 0.5

Model 1: restricted model
Model 2: log(subs) ~ log(citeprice)

  Res.Df RSS Df Sum of Sq    F Pr(>F)
1    179 100                         
2    178 100  1     0.484 0.86   0.35

###################################################
### chunk number 19: CPS-data
###################################################
data("CPS1988")

summary(CPS1988)
      wage         education      experience   ethnicity   
 Min.   :   50   Min.   : 0.0   Min.   :-4.0   cauc:25923  
 1st Qu.:  309   1st Qu.:12.0   1st Qu.: 8.0   afam: 2232  
 Median :  522   Median :12.0   Median :16.0               
 Mean   :  604   Mean   :13.1   Mean   :18.2               
 3rd Qu.:  783   3rd Qu.:15.0   3rd Qu.:27.0               
 Max.   :18777   Max.   :18.0   Max.   :63.0               
  smsa             region     parttime   
 no : 7223   northeast:6441   no :25631  
 yes:20932   midwest  :6863   yes: 2524  
             south    :8760              
             west     :6091              
                                         
                                         

###################################################
### chunk number 20: CPS-base
###################################################
cps_lm <- lm(log(wage) ~ experience + I(experience^2) +
+    education + ethnicity, data = CPS1988)

###################################################
### chunk number 21: CPS-visualization-unused eval=FALSE
###################################################
## ex <- 0:56
## ed <- with(CPS1988, tapply(education, 
##   list(ethnicity, experience), mean))[, as.character(ex)]
## fm <- cps_lm
## wago <- predict(fm, newdata = data.frame(experience = ex, 
##   ethnicity = "cauc", education = as.numeric(ed["cauc",])))
## wagb <- predict(fm, newdata = data.frame(experience = ex, 
##   ethnicity = "afam", education = as.numeric(ed["afam",])))
## plot(log(wage) ~ experience, data = CPS1988, pch = ".", 
##   col = as.numeric(ethnicity))
## lines(ex, wago)
## lines(ex, wagb, col = 2)


###################################################
### chunk number 22: CPS-summary
###################################################
summary(cps_lm)

Call:
lm(formula = log(wage) ~ experience + I(experience^2) + education + 
    ethnicity, data = CPS1988)

Residuals:
   Min     1Q Median     3Q    Max 
-2.943 -0.316  0.058  0.376  4.383 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)
(Intercept)      4.321395   0.019174   225.4   <2e-16
experience       0.077473   0.000880    88.0   <2e-16
I(experience^2) -0.001316   0.000019   -69.3   <2e-16
education        0.085673   0.001272    67.3   <2e-16
ethnicityafam   -0.243364   0.012918   -18.8   <2e-16

Residual standard error: 0.584 on 28150 degrees of freedom
Multiple R-squared:  0.335,     Adjusted R-squared:  0.335 
F-statistic: 3.54e+03 on 4 and 28150 DF,  p-value: <2e-16


###################################################
### chunk number 23: CPS-noeth
###################################################
cps_noeth <- lm(log(wage) ~ experience + I(experience^2) +
+    education, data = CPS1988)

anova(cps_noeth, cps_lm)
Analysis of Variance Table

Model 1: log(wage) ~ experience + I(experience^2) + education
Model 2: log(wage) ~ experience + I(experience^2) + education + ethnicity
  Res.Df  RSS Df Sum of Sq   F Pr(>F)
1  28151 9720                        
2  28150 9599  1       121 355 <2e-16

###################################################
### chunk number 24: CPS-anova
###################################################
anova(cps_lm)
Analysis of Variance Table

Response: log(wage)
                   Df Sum Sq Mean Sq F value Pr(>F)
experience          1    840     840    2462 <2e-16
I(experience^2)     1   2249    2249    6597 <2e-16
education           1   1620    1620    4750 <2e-16
ethnicity           1    121     121     355 <2e-16
Residuals       28150   9599       0               

###################################################
### chunk number 25: CPS-noeth2 eval=FALSE
###################################################
## cps_noeth <- update(cps_lm, formula = . ~ . - ethnicity)


###################################################
### chunk number 26: CPS-waldtest
###################################################
waldtest(cps_lm, . ~ . - ethnicity)
Wald test

Model 1: log(wage) ~ experience + I(experience^2) + education + ethnicity
Model 2: log(wage) ~ experience + I(experience^2) + education
  Res.Df Df   F Pr(>F)
1  28150              
2  28151 -1 355 <2e-16

###################################################
### chunk number 27: CPS-spline
###################################################
library("splines")

cps_plm <- lm(log(wage) ~ bs(experience, df = 5) +
+    education + ethnicity, data = CPS1988)

###################################################
### chunk number 28: CPS-spline-summary eval=FALSE
###################################################
## summary(cps_plm)


###################################################
### chunk number 29: CPS-BIC
###################################################
cps_bs <- lapply(3:10, function(i) lm(log(wage) ~
+    bs(experience, df = i) + education + ethnicity,
+    data = CPS1988))

structure(sapply(cps_bs, AIC, k = log(nrow(CPS1988))),
+    .Names = 3:10)
    3     4     5     6     7     8     9    10 
49205 48836 48794 48795 48801 48797 48799 48802 

###################################################
### chunk number 30: plm-plot eval=FALSE
###################################################
## cps <- data.frame(experience = -2:60, education =
##   with(CPS1988, mean(education[ethnicity == "cauc"])),
##   ethnicity = "cauc")
## cps$yhat1 <- predict(cps_lm, newdata = cps)
## cps$yhat2 <- predict(cps_plm, newdata = cps)
## 
## plot(log(wage) ~ jitter(experience, factor = 3), pch = 19,
##   col = rgb(0.5, 0.5, 0.5, alpha = 0.02), data = CPS1988)
## lines(yhat1 ~ experience, data = cps, lty = 2)
## lines(yhat2 ~ experience, data = cps)
## legend("topleft", c("quadratic", "spline"), lty = c(2,1),
##   bty = "n")


###################################################
### chunk number 31: plm-plot1
###################################################
cps <- data.frame(experience = -2:60, education =
+    with(CPS1988, mean(education[ethnicity == "cauc"])),
+    ethnicity = "cauc")

cps$yhat1 <- predict(cps_lm, newdata = cps)

cps$yhat2 <- predict(cps_plm, newdata = cps)

plot(log(wage) ~ jitter(experience, factor = 3), pch = 19,
+    col = rgb(0.5, 0.5, 0.5, alpha = 0.02), data = CPS1988)

lines(yhat1 ~ experience, data = cps, lty = 2)

lines(yhat2 ~ experience, data = cps)

legend("topleft", c("quadratic", "spline"), lty = c(2,1),
+    bty = "n")

###################################################
### chunk number 32: CPS-int
###################################################
cps_int <- lm(log(wage) ~ experience + I(experience^2) +
+    education * ethnicity, data = CPS1988)

coeftest(cps_int)

t test of coefficients:

                         Estimate Std. Error t value Pr(>|t|)
(Intercept)              4.313059   0.019590  220.17   <2e-16
experience               0.077520   0.000880   88.06   <2e-16
I(experience^2)         -0.001318   0.000019  -69.34   <2e-16
education                0.086312   0.001309   65.94   <2e-16
ethnicityafam           -0.123887   0.059026   -2.10    0.036
education:ethnicityafam -0.009648   0.004651   -2.07    0.038


###################################################
### chunk number 33: CPS-int2 eval=FALSE
###################################################
## cps_int <- lm(log(wage) ~ experience + I(experience^2) +
##   education + ethnicity + education:ethnicity,
##   data = CPS1988)


###################################################
### chunk number 34: CPS-sep
###################################################
cps_sep <- lm(log(wage) ~ ethnicity /
+    (experience + I(experience^2) + education) - 1,
+    data = CPS1988)

###################################################
### chunk number 35: CPS-sep-coef
###################################################
cps_sep_cf <- matrix(coef(cps_sep), nrow = 2)

rownames(cps_sep_cf) <- levels(CPS1988$ethnicity)

colnames(cps_sep_cf) <- names(coef(cps_lm))[1:4]

cps_sep_cf
     (Intercept) experience I(experience^2) education
cauc       4.310    0.07923      -0.0013597   0.08575
afam       4.159    0.06190      -0.0009415   0.08654

###################################################
### chunk number 36: CPS-sep-anova
###################################################
anova(cps_sep, cps_lm)
Analysis of Variance Table

Model 1: log(wage) ~ ethnicity/(experience + I(experience^2) + education) - 
    1
Model 2: log(wage) ~ experience + I(experience^2) + education + ethnicity
  Res.Df  RSS Df Sum of Sq    F  Pr(>F)
1  28147 9582                          
2  28150 9599 -3     -16.8 16.5 1.1e-10

###################################################
### chunk number 37: CPS-sep-visualization-unused eval=FALSE
###################################################
## ex <- 0:56
## ed <- with(CPS1988, tapply(education, list(ethnicity, 
##   experience), mean))[, as.character(ex)]
## fm <- cps_lm
## wago <- predict(fm, newdata = data.frame(experience = ex, 
##   ethnicity = "cauc", education = as.numeric(ed["cauc",])))
## wagb <- predict(fm, newdata = data.frame(experience = ex, 
##   ethnicity = "afam", education = as.numeric(ed["afam",])))
## plot(log(wage) ~ jitter(experience, factor = 2), 
##   data = CPS1988, pch = ".", col = as.numeric(ethnicity))
## 
## 
## plot(log(wage) ~ as.factor(experience), data = CPS1988, 
##   pch = ".")
## lines(ex, wago, lwd = 2)
## lines(ex, wagb, col = 2, lwd = 2)
## fm <- cps_sep
## wago <- predict(fm, newdata = data.frame(experience = ex, 
##   ethnicity = "cauc", education = as.numeric(ed["cauc",])))
## wagb <- predict(fm, newdata = data.frame(experience = ex, 
##   ethnicity = "afam", education = as.numeric(ed["afam",])))
## lines(ex, wago, lty = 2, lwd = 2)
## lines(ex, wagb, col = 2, lty = 2, lwd = 2)


###################################################
### chunk number 38: CPS-region
###################################################
CPS1988$region <- relevel(CPS1988$region, ref = "south")

cps_region <- lm(log(wage) ~ ethnicity + education +
+    experience + I(experience^2) + region, data = CPS1988)

coef(cps_region)
    (Intercept)   ethnicityafam       education      experience 
       4.283606       -0.225679        0.084672        0.077656 
I(experience^2) regionnortheast   regionmidwest      regionwest 
      -0.001323        0.131920        0.043789        0.040327 

###################################################
### chunk number 39: wls1
###################################################
jour_wls1 <- lm(log(subs) ~ log(citeprice), data = journals,
+    weights = 1/citeprice^2)

###################################################
### chunk number 40: wls2
###################################################
jour_wls2 <- lm(log(subs) ~ log(citeprice), data = journals,
+    weights = 1/citeprice)

###################################################
### chunk number 41: journals-wls1 eval=FALSE
###################################################
## plot(log(subs) ~ log(citeprice), data = journals)
## abline(jour_lm)
## abline(jour_wls1, lwd = 2, lty = 2)
## abline(jour_wls2, lwd = 2, lty = 3)
## legend("bottomleft", c("OLS", "WLS1", "WLS2"),
##   lty = 1:3, lwd = 2, bty = "n")


###################################################
### chunk number 42: journals-wls11
###################################################
plot(log(subs) ~ log(citeprice), data = journals)

abline(jour_lm)

abline(jour_wls1, lwd = 2, lty = 2)

abline(jour_wls2, lwd = 2, lty = 3)

legend("bottomleft", c("OLS", "WLS1", "WLS2"),
+    lty = 1:3, lwd = 2, bty = "n")

###################################################
### chunk number 43: fgls1
###################################################
auxreg <- lm(log(residuals(jour_lm)^2) ~ log(citeprice),
+    data = journals)

jour_fgls1 <- lm(log(subs) ~ log(citeprice), 
+    weights = 1/exp(fitted(auxreg)), data = journals)

###################################################
### chunk number 44: fgls2
###################################################
gamma2i <- coef(auxreg)[2]

gamma2 <- 0

while(abs((gamma2i - gamma2)/gamma2) > 1e-7) {
+    gamma2 <- gamma2i
+    fglsi <- lm(log(subs) ~ log(citeprice), data = journals, 
+      weights = 1/citeprice^gamma2)
+    gamma2i <- coef(lm(log(residuals(fglsi)^2) ~
+      log(citeprice), data = journals))[2]
+  }

jour_fgls2 <- lm(log(subs) ~ log(citeprice), data = journals,
+    weights = 1/citeprice^gamma2)

###################################################
### chunk number 45: fgls2-coef
###################################################
coef(jour_fgls2)
   (Intercept) log(citeprice) 
        4.7758        -0.5008 

###################################################
### chunk number 46: journals-fgls
###################################################
plot(log(subs) ~ log(citeprice), data = journals)

abline(jour_lm)

abline(jour_fgls2, lty = 2, lwd = 2)

###################################################
### chunk number 47: usmacro-plot eval=FALSE
###################################################
## data("USMacroG")
## plot(USMacroG[, c("dpi", "consumption")], lty = c(3, 1),
##   plot.type = "single", ylab = "")
## legend("topleft", legend = c("income", "consumption"),
##   lty = c(3, 1), bty = "n")


###################################################
### chunk number 48: usmacro-plot1
###################################################
data("USMacroG")

plot(USMacroG[, c("dpi", "consumption")], lty = c(3, 1),
+    plot.type = "single", ylab = "")

legend("topleft", legend = c("income", "consumption"),
+    lty = c(3, 1), bty = "n")

###################################################
### chunk number 49: usmacro-fit
###################################################
library("dynlm")

cons_lm1 <- dynlm(consumption ~ dpi + L(dpi), data = USMacroG)

cons_lm2 <- dynlm(consumption ~ dpi + L(consumption), 
+    data = USMacroG)

###################################################
### chunk number 50: usmacro-summary1
###################################################
summary(cons_lm1)

Time series regression with "ts" data:
Start = 1950(2), End = 2000(4)

Call:
dynlm(formula = consumption ~ dpi + L(dpi), data = USMacroG)

Residuals:
   Min     1Q Median     3Q    Max 
-190.0  -56.7    1.6   49.9  323.9 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) -81.0796    14.5081   -5.59  7.4e-08
dpi           0.8912     0.2063    4.32  2.4e-05
L(dpi)        0.0309     0.2075    0.15     0.88

Residual standard error: 87.6 on 200 degrees of freedom
Multiple R-squared:  0.996,     Adjusted R-squared:  0.996 
F-statistic: 2.79e+04 on 2 and 200 DF,  p-value: <2e-16


###################################################
### chunk number 51: usmacro-summary2
###################################################
summary(cons_lm2)

Time series regression with "ts" data:
Start = 1950(2), End = 2000(4)

Call:
dynlm(formula = consumption ~ dpi + L(consumption), data = USMacroG)

Residuals:
    Min      1Q  Median      3Q     Max 
-101.30   -9.67    1.14   12.69   45.32 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)
(Intercept)     0.53522    3.84517    0.14     0.89
dpi            -0.00406    0.01663   -0.24     0.81
L(consumption)  1.01311    0.01816   55.79   <2e-16

Residual standard error: 21.5 on 200 degrees of freedom
Multiple R-squared:     1,      Adjusted R-squared:     1 
F-statistic: 4.63e+05 on 2 and 200 DF,  p-value: <2e-16


###################################################
### chunk number 52: dynlm-plot eval=FALSE
###################################################
## plot(merge(as.zoo(USMacroG[,"consumption"]), fitted(cons_lm1),
##   fitted(cons_lm2), 0, residuals(cons_lm1),
##   residuals(cons_lm2)), screens = rep(1:2, c(3, 3)),
##   lty = rep(1:3, 2), ylab = c("Fitted values", "Residuals"),
##   xlab = "Time", main = "")
## legend(0.05, 0.95, c("observed", "cons_lm1", "cons_lm2"), 
##   lty = 1:3, bty = "n")


###################################################
### chunk number 53: dynlm-plot1
###################################################
plot(merge(as.zoo(USMacroG[,"consumption"]), fitted(cons_lm1),
+    fitted(cons_lm2), 0, residuals(cons_lm1),
+    residuals(cons_lm2)), screens = rep(1:2, c(3, 3)),
+    lty = rep(1:3, 2), ylab = c("Fitted values", "Residuals"),
+    xlab = "Time", main = "")

legend(0.05, 0.95, c("observed", "cons_lm1", "cons_lm2"), 
+    lty = 1:3, bty = "n")

###################################################
### chunk number 54: encompassing1
###################################################
cons_lmE <- dynlm(consumption ~ dpi + L(dpi) +
+    L(consumption), data = USMacroG)

###################################################
### chunk number 55: encompassing2
###################################################
anova(cons_lm1, cons_lmE, cons_lm2)
Analysis of Variance Table

Model 1: consumption ~ dpi + L(dpi)
Model 2: consumption ~ dpi + L(dpi) + L(consumption)
Model 3: consumption ~ dpi + L(consumption)
  Res.Df     RSS Df Sum of Sq      F  Pr(>F)
1    200 1534001                            
2    199   73550  1   1460451 3951.4 < 2e-16
3    200   92644 -1    -19094   51.7 1.3e-11

###################################################
### chunk number 56: encompassing3
###################################################
encomptest(cons_lm1, cons_lm2)
Encompassing test

Model 1: consumption ~ dpi + L(dpi)
Model 2: consumption ~ dpi + L(consumption)
Model E: consumption ~ dpi + L(dpi) + L(consumption)
          Res.Df Df      F  Pr(>F)
M1 vs. ME    199 -1 3951.4 < 2e-16
M2 vs. ME    199 -1   51.7 1.3e-11

###################################################
### chunk number 57: pdata.frame
###################################################
data("Grunfeld", package = "AER")

library("plm")

Attaching package: 'plm'

The following objects are masked from 'package:dplyr':

    between, lag, lead

The following object is masked from 'package:data.table':

    between


gr <- subset(Grunfeld, firm %in% c("General Electric",
+    "General Motors", "IBM"))

pgr <- pdata.frame(gr, index = c("firm", "year"))

###################################################
### chunk number 58: plm-pool
###################################################
gr_pool <- plm(invest ~ value + capital, data = pgr, 
+    model = "pooling")

###################################################
### chunk number 59: plm-FE
###################################################
gr_fe <- plm(invest ~ value + capital, data = pgr, 
+    model = "within")

summary(gr_fe)
Oneway (individual) effect Within Model

Call:
plm(formula = invest ~ value + capital, data = pgr, model = "within")

Balanced Panel: n = 3, T = 20, N = 60

Residuals:
   Min. 1st Qu.  Median 3rd Qu.    Max. 
-167.33  -26.14    2.09   26.84  201.68 

Coefficients:
        Estimate Std. Error t-value Pr(>|t|)
value     0.1049     0.0163    6.42  3.3e-08
capital   0.3453     0.0244   14.16  < 2e-16

Total Sum of Squares:    1890000
Residual Sum of Squares: 244000
R-Squared:      0.871
Adj. R-Squared: 0.861
F-statistic: 185.407 on 2 and 55 DF, p-value: <2e-16

###################################################
### chunk number 60: plm-pFtest
###################################################
pFtest(gr_fe, gr_pool)

        F test for individual effects

data:  invest ~ value + capital
F = 57, df1 = 2, df2 = 55, p-value = 4e-14
alternative hypothesis: significant effects


###################################################
### chunk number 61: plm-RE
###################################################
gr_re <- plm(invest ~ value + capital, data = pgr, 
+    model = "random", random.method = "walhus")

summary(gr_re)
Oneway (individual) effect Random Effect Model 
   (Wallace-Hussain's transformation)

Call:
plm(formula = invest ~ value + capital, data = pgr, model = "random", 
    random.method = "walhus")

Balanced Panel: n = 3, T = 20, N = 60

Effects:
                 var std.dev share
idiosyncratic 4389.3    66.3  0.35
individual    8079.7    89.9  0.65
theta: 0.837

Residuals:
   Min. 1st Qu.  Median 3rd Qu.    Max. 
-187.40  -32.92    6.96   31.43  210.20 

Coefficients:
             Estimate Std. Error z-value Pr(>|z|)
(Intercept) -109.9766    61.7014   -1.78    0.075
value          0.1043     0.0150    6.95  3.6e-12
capital        0.3448     0.0245   14.06  < 2e-16

Total Sum of Squares:    1990000
Residual Sum of Squares: 258000
R-Squared:      0.87
Adj. R-Squared: 0.866
Chisq: 383.089 on 2 DF, p-value: <2e-16

###################################################
### chunk number 62: plm-plmtest
###################################################
plmtest(gr_pool)

        Lagrange Multiplier Test - (Honda)

data:  invest ~ value + capital
normal = 15, p-value <2e-16
alternative hypothesis: significant effects


###################################################
### chunk number 63: plm-phtest
###################################################
phtest(gr_re, gr_fe)

        Hausman Test

data:  invest ~ value + capital
chisq = 0.04, df = 2, p-value = 1
alternative hypothesis: one model is inconsistent


###################################################
### chunk number 64: EmplUK-data
###################################################
data("EmplUK", package = "plm")

###################################################
### chunk number 65: plm-AB
###################################################
empl_ab <- pgmm(log(emp) ~ lag(log(emp), 1:2) + lag(log(wage), 0:1) +
+    log(capital) + lag(log(output), 0:1) | lag(log(emp), 2:99),
+    data = EmplUK, index = c("firm", "year"),
+    effect = "twoways", model = "twosteps")

###################################################
### chunk number 66: plm-AB-summary
###################################################
summary(empl_ab)     
Twoways effects Two-steps model Difference GMM 

Call:
pgmm(formula = log(emp) ~ lag(log(emp), 1:2) + lag(log(wage), 
    0:1) + log(capital) + lag(log(output), 0:1) | lag(log(emp), 
    2:99), data = EmplUK, effect = "twoways", model = "twosteps", 
    index = c("firm", "year"))

Unbalanced Panel: n = 140, T = 7-9, N = 1031

Number of Observations Used: 611
Residuals:
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-0.6191 -0.0256  0.0000 -0.0001  0.0332  0.6410 

Coefficients:
                       Estimate Std. Error z-value Pr(>|z|)
lag(log(emp), 1:2)1      0.4742     0.1854    2.56  0.01054
lag(log(emp), 1:2)2     -0.0530     0.0517   -1.02  0.30605
lag(log(wage), 0:1)0    -0.5132     0.1456   -3.53  0.00042
lag(log(wage), 0:1)1     0.2246     0.1419    1.58  0.11353
log(capital)             0.2927     0.0626    4.67  3.0e-06
lag(log(output), 0:1)0   0.6098     0.1563    3.90  9.5e-05
lag(log(output), 0:1)1  -0.4464     0.2173   -2.05  0.03996

Sargan test: chisq(25) = 30.11 (p-value = 0.22)
Autocorrelation test (1): normal = -1.538 (p-value = 0.124)
Autocorrelation test (2): normal = -0.2797 (p-value = 0.78)
Wald test for coefficients: chisq(7) = 142 (p-value = <2e-16)
Wald test for time dummies: chisq(6) = 16.97 (p-value = 0.00939)

###################################################
### chunk number 67: systemfit
###################################################
library("systemfit")
Loading required package: Matrix

Please cite the 'systemfit' package as:
Arne Henningsen and Jeff D. Hamann (2007). systemfit: A Package for Estimating Systems of Simultaneous Equations in R. Journal of Statistical Software 23(4), 1-40. http://www.jstatsoft.org/v23/i04/.

If you have questions, suggestions, or comments regarding the 'systemfit' package, please use a forum or 'tracker' at systemfit's R-Forge site:
https://r-forge.r-project.org/projects/systemfit/

gr2 <- subset(Grunfeld, firm %in% c("Chrysler", "IBM"))

pgr2 <- pdata.frame(gr2, c("firm", "year"))

###################################################
### chunk number 68: SUR
###################################################
gr_sur <- systemfit(invest ~ value + capital,
+    method = "SUR", data = pgr2)

summary(gr_sur, residCov = FALSE, equations = FALSE)

systemfit results 
method: SUR 

        N DF  SSR detRCov OLS-R2 McElroy-R2
system 40 34 4114   11022  0.929      0.927

          N DF  SSR   MSE  RMSE    R2 Adj R2
Chrysler 20 17 3002 176.6 13.29 0.913  0.903
IBM      20 17 1112  65.4  8.09 0.952  0.946


Coefficients:
                     Estimate Std. Error t value Pr(>|t|)
Chrysler_(Intercept)  -5.7031    13.2774   -0.43  0.67293
Chrysler_value         0.0780     0.0196    3.98  0.00096
Chrysler_capital       0.3115     0.0287   10.85  4.6e-09
IBM_(Intercept)       -8.0908     4.5216   -1.79  0.09139
IBM_value              0.1272     0.0306    4.16  0.00066
IBM_capital            0.0966     0.0983    0.98  0.33951

###################################################
### chunk number 69: nlme eval=FALSE
###################################################
## library("nlme")
## g1 <- subset(Grunfeld, firm == "Westinghouse")
## gls(invest ~ value + capital, data = g1, correlation = corAR1())
