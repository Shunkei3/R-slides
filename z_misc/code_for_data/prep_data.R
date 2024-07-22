library(here)
library(rio)
library(data.table)
library(dplyr)


# /*===========================================*/
#'= Weather data  =
# /*===========================================*/






# /*===========================================*/
#'=  USDA-NASS =
# /*===========================================*/
#' See Taro's slides
#' First, get an API key from this (https://quickstats.nass.usda.gov/api)


library(tidyUSDA)

# IL_NE_ir_corn_yield <-
#   tidyUSDA::getQuickstat(
#     key = nass_api_key, # you need to replace it with your API key
#     program = "SURVEY",
#     data_item = "CORN, GRAIN, IRRIGATED - YIELD, MEASURED IN BU / ACRE",
#     geographic_level = "COUNTY",
#     state = c("ILLINOIS", "NEBRASKA"),
#     year = as.character(2000:2005),
#     geometry = FALSE
#   )

# saveRDS(
#   IL_NE_ir_corn_yield,
#   here("Data/IL_NE_ir_corn_yield.rds")
# )




#/*--------------------------------*/
#' ## Get Yield data (one time)
#/*--------------------------------*/
nass_api_key <- "EA406A30-11F2-3BB9-AF19-5960BD37DBBE"

# ls_corn_states <- c("MN", "IA", "IL", "NE", "SD", "ND", "WI", "IN", "OH", "MI")
ls_corn_states <- c("Minnesota", "Iowa", "Illinois", "Nebraska", "South Dakota", "North Dakota", "Wisconsin", "Indiana", "Ohio", "Michigan")

# library(foreach)

# corn_yield_dt <- 
#   foreach(tmp_state = ls_corn_states, .combine = rbind) %do% {
#     corn_yield <-
#       tidyUSDA::getQuickstat(
#         key = nass_api_key, # you need to replace it with your API key
#         program = "SURVEY",
#         data_item = "CORN, GRAIN - YIELD, MEASURED IN BU / ACRE",
#         geographic_level = "COUNTY",
#         state = tmp_state,
#         year = as.character(2000:2005),
#         geometry = FALSE
#       )
  # }

# Save raw data
# saveRDS(
#   corn_yield_dt,
#   here("Data0/corn_yield_raw.rds")
# )


corn_yield_dt <- 
  foreach(tmp_state = ls_corn_states, .combine = rbind) %do% {
    corn_yield <-
      tidyUSDA::getQuickstat(
        key = nass_api_key, # you need to replace it with your API key
        program = "SURVEY",
        data_item = "CORN, GRAIN - YIELD, MEASURED IN BU / ACRE",
        geographic_level = "COUNTY",
        state = tmp_state,
        year = as.character(2000:2005),
        geometry = FALSE
      )
  }


#/*--------------------------------*/
#' ## Modification
#/*--------------------------------*/
corn_yield_dt <- readRDS(here("Data0/corn_yield_raw.rds"))

sort(names(corn_yield_dt))

# select some important columns
corn_yield_simple <- 
  data.table(corn_yield_dt) %>%
  .[,.(
    state_fips_code, county_code, state_alpha, county_name, year, short_desc, Value, agg_level_desc
    )] %>%



saveRDS(
  as.data.frame(corn_yield_simple),
  here("Data/corn_yield_dt.rds")
)


corn_yield_simple
# + create a fips code column


county_mean_corn_yield <-
  corn_yield_simple %>%
  .[, fips_code := paste0(state_fips_code, county_code)] %>%
  .[,.(mean_corn_yield = mean(Value)), by = .(fips_code)]


corn_yield_simple[year == 2020, .(average_yield = mean(value)), by = .(state_alpha)]




