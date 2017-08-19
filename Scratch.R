

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




temp <- "name"


starwars %>% group_by(species) %>% summarise(n=n()) %>% arrange(desc(n))

starwars %>% 
  select(name) %>% head()


# For teaching joins
band_instruments
band_instruments2
band_members

# for practicing joins
install.packages("nycflights13")
library(nycflights13)
airports
flights
airlines
planes
