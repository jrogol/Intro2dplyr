

iris
str(iris)
library(tibble)
as_tibble(iris)
str(as_tibble(iris))

library(dplyr)
starwars
str(starwars
  )

starwars %>% filter(name == "Luke Skywalker") %>% select(films) %>% as.data.frame()