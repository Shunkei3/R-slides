library(dplyr)


nscg17 <- rio::import("Data/nscg17small.dta")

nrow(nscg17)
head(nscg17)


# jobsatis: he employment status of the respondent at the time of the survey
unique(nscg17$jobsatis)
	# •	1 = Employed full-time
	# •	2 = Employed part-time
	# •	3 = Unemployed
	# •	4 = Not in labor force

# jobins:  whether the respondent’s job is related to their highest degree or field of study. This variable helps in understanding the relevance of the respondent’s education to their current employment.
unique(nscg17$jobins)

# marsta: the marital status of the respondent.
unique(nscg17$marsta)
	# •	1 = Married
	# •	2 = Living with a partner
	# •	3 = Divorced
	# •	4 = Separated
	# •	5 = Widowed
	# •	6 = Never married

# lfstat: the labor force status of the respondent. This variable indicates whether the respondent is part of the labor force and, if so, their specific status within the labor force.
unique(nscg17$lfstat)
  # •	1 = Employed
  # •	2 = Unemployed
  # •	3 = Not in labor

# salary vs earn
# salary: the annual salary or wage income that the respondent earns from their main job. This is typically the regular income before taxes and other deductions.
# earn:  total earnings, which can include a broader range of income sources beyond the base salary. 
# === Part 1 === #
nscg17 <- rio::import("Data/nscg17small.dta")


# === Part 2 === #
nscg17$ID <- 1:nrow(nscg17)

# === Part 3 === #
nscg17$z_hrswk1 <- (nscg17$hrswk - mean(nscg17$hrswk)) / sd(nscg17$hrswk)
nscg17$z_hrswk2 <- with(nscg17, (hrswk - mean(hrswk)) / sd(hrswk))
identical(nscg17$z_hrswk1, nscg17$z_hrswk2)


# === Part 4=== #
# mean(nscg17$hrswk)
# create a logical vector that indicates whether the hours worked is above average
above_avg_hrswk <- with(nscg17, hrswk > mean(hrswk))
# subset the data
nscg17_above_avg_hrswk <- nscg17[above_avg_hrswk, ]
# calculate the share of observations with above average hours worked
share_above_avg_hrswk <- nrow(nscg17_above_avg_hrswk) / nrow(nscg17)



test_above_avg_hrswk <- nscg17$z_hrswk > mean(nscg17$z_hrswk)
nrow(nscg17[test_above_avg_hrswk, ])/nrow(nscg17)
# calculate the share of observations with above average hours worked
share_above_avg_hrswk <- nrow(nscg17_above_avg_hrswk) / nrow(nscg17)



# === Part 5 === #
summary(nscg17$salary)
nscg17[nscg17$salary==median(nscg17$salary),] %>% head()
