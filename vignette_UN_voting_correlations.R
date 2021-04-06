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

library(ggraph)
library(igraph)

cors_filtered <- cors %>%
        filter(correlation > .6)

continents <- tibble(country = unique(un_votes$country)) %>%
        filter(country %in% cors_filtered$item1 |
                       country %in% cors_filtered$item2) %>%
        mutate(continent = countrycode(country, "country.name", "continent"))

set.seed(2017)

cors_filtered %>%
        graph_from_data_frame(vertices = continents) %>%
        ggraph() +
        geom_edge_link(aes(edge_alpha = correlation)) +
        geom_node_point(aes(color = continent), size = 3) +
        geom_node_text(aes(label = name), check_overlap = TRUE, vjust = 1, hjust = 1) +
        theme_void() +
        labs(title = "Network of countries with correlated United Nations votes")
