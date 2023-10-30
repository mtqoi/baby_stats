library('readr')
health_filepath <- 'data/apple_health_export/export.xml'
health_file <- substr(read_file(health_filepath), 1, 2000)
print(health_file)

#%%

library("XML")

# here are some ones that I think I might need
library("dplyr")

# parse the xml file
health <- xmlParse(health_filepath)
summary(health)

#%%

health_df <- XML:::xmlAttrsToDataFrame(health["//Record"], stringsAsFactors = FALSE) |>
  as_tibble() |>
  mutate(value = as.numeric(value)) |>
  select(-device)

#%%
library(ggplot2)
health_df %>%
  group_by(type) %>%
  summarise(n = n()) %>%
  mutate(ToHighlight = ifelse(grepl('walk', tolower(type), fixed=TRUE), "yes", "no")) %>%
  ggplot(aes(y = reorder(type, n), x = n, fill = ToHighlight)) +
  geom_bar(stat = 'identity') +
  scale_fill_manual(values = c("yes" = "tomato", "no" = "gray"), guide = FALSE)