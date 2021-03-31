# Source: https://cran.r-project.org/web/packages/widyr/vignettes/united_nations.html

library(dplyr)
library(unvotes)

un_votes

library(widyr)

cors <- un_votes %>%
        mutate(vote = as.numeric(vote)) %>%
        pairwise_cor(country, rcid, vote, use = "pairwise.complete.obs", sort = TRUE)

cors

UK_cors <- cors %>%
        filter(item1 == "United Kingdom")
UK_cors %>% head(20)
