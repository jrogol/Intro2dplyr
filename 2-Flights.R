# Load the NYC Flights data package.
# install.packages("nycflights13")
library(nycflights13)

# Explore the five data sets: 
airlines # Airlines and their carrier notations
airports # Geographic and time data for U.S. Airports
flights # Flights departing New York airports in 2013
planes # Details on individual planes
weather # Hourly weather data for New York City airports in 2013.

# What kind of questions can you ask of the data? How might you use dplyr to 
# tackle these?

# This dataset is tailor-made for practicing not only single-table dplyr 
# techniques, but also dplyr's relational (two-table) functions. For an
# introduction, see: http://r4ds.had.co.nz/relational-data.html