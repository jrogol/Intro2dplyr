#### Prerequisites ####

# If you haven't already, run the '0 - Prerequisites.R' script to install/update
# packages we'll use in this workshop.
source("0 - Prerequisites.R")

#### The Data ####

# For the demonstration part of this workshop, we'll be using the 'starwars' 
# dataset from the latest (0.7.2) version of dplyr. First, we'll need to load 
# dplyr.
library(dplyr)

# Notice that the names of some functions in dplyr are the same as those
# in base R. While this won't be an issue today, it's good to be aware of for
# the future!

# We can take a look at the data as follows:
starwars

# We can gain more information about the dataset by entering a question mark
# before the name of the object. This is a handy shortcut if you ever would like
# to know more abut a function or package, too!
?starwars

# Notice that 'starwars' is a TIBBLE. TIBBLES are like Base R's DATA FRAMES, and
# form the main data struture of the tidyverse. To illustrate the differences,
# compare the output of 'starwars' to that of the ubiquitous 'iris' dataset.
iris

# What are some of the differences you notice between the TIBBLE and the DATA FRAME?

    # A: Tibble's don't display the entire output (row nor column wise). Tibbles
    # don't coerce strings to factors automatically, and can feature other data
    # types (i.e. lists) of values.

# Now that we've seen both the 'starwars' and 'iris' data sets, introduce 
# yourself to your neighbor. Consider some of dplyr's verbs to which you were 
# indroduced moments ago. With this in mind, what are some of the questions you
# might ask of these data sets?

#### select() ####

# In base R, we can select specific columns from a data set in a few ways. For
# example, if we wanted to see just the character names, we could use the following:
starwars$name

# Placing a dollar sign between the name of a DATA FRAME or TIBBLE and the
# variable in question allows us to select it. However, this only enables us to
# use a single variable.

# Alternatively, we can select multiple columns using their name(s) or
# location(s) using BRACKETS.

# The first argument in brackets is the row, and the second is the column. To
# select all the rows of characters' names, we leave the first argument empty as
# follows:
starwars[,'name']

# We can also select variables by their location within the dataset. 'name' is
# the first column, so we can use
starwars[,1]

# Selecting multiple columns is now possible, as well! Use c('var1','var2',...)
# as the second argument in brackets, inserting the desired variable names or locations for
# var1 and var2.
starwars[,c('name','homeworld')]
starwars[,c(1,4:6)]

# dplyr's select() streamlines this process, and perhaps makes it more human-readable.
select(starwars,'name')
select(starwars,1)

# The first argument of select() is the dataset (TIBBLE or DATA FRAME), and
# subsequent arguments (separated by commas) are the named columns.
select(starwars, 'homeworld', 'species')

# You don't need to use strings to name variables, either! I believe this is a
# newer addition to dplyr.
select(starwars, homeworld, 'species')

# You can also use variables to make your selections.
my_var <- "species"
select(starwars, my_var)

# dpyr also works with DATA FRAMES, as with the 'iris' data:
select(iris, Species, Petal.Length)

#### select() EXERCISES ####

# The sequence of variable names matters. How would you select the gender and names of all
# characters, in this order?
select(starwars, gender, name)

# How would you select the name, hair_color, skin_color, and eye_color?
select(starwars, name, hair_color, skin_color, eye_color)
select(starwars, c('name', 'hair_color', 'skin_color', 'eye_color'))


# dplyr includes some helper functions, such as ends_with(), which can help in
# selecting variables! These functions take the search pattern as a string.
select(starwars, name, ends_with('color'))
select(starwars, matches('.e.'))

# To see more of the helper functions and how they work:
?ends_with


#### filter() ####

# Selecting rows of date require CONDITIONS - equal to, not equal to, and, or, greater than etc. In base R, we can insert these
# conditions as the first argument in BRACKETS. Recall the various operators for conditions:
# == - equal to
# & - and
# | - or (that's a vertical line, not an l, nor capital I!)
# ! - not

# For example, we can see all of the human characters in the dataset:
starwars[starwars$species == "Human",]

# We can also use multiple conditions, such as all characters with a mass between 20 and 40:
starwars[starwars$mass >= 20 & starwars$mass < 40,]

# Similar to select(), filter() can help streamline the process:
filter(starwars, species == "Human")
# Using multiple conditions as arguments is the same as using &:
filter(starwars, mass >= 20 & mass < 40)
filter(starwars, mass >= 20, mass < 40)

# An example of all characters from Naboo OR with brown eyes:
filter(starwars, homeworld == "Naboo" | eye_color == "brown")

#### filter() EXERCISES ####


# Use filter() to determine how many characters are of the Droid species.
filter(starwars, species == "Droid")

# Of the above, how many have red eyes?
filter(starwars, species == "Droid" & eye_color == "red")

# Find all Gungan (species) with a height between 190 and 215.
filter(starwars, species == "Gungan", height > 190, height < 215)

# Sometimes we need to investigate missing data. How many characters are missing a species? How many are NOT?
filter(starwars, is.na(species))
filter(starwars, !is.na(species))


# CHALLENGE: Extract just the names of the red-eyed Droids by combining select() and filter()
select(
  filter(starwars, species == "Droid" & eye_color == "red"),
  name)

# Like select(), filter() has helper functions, like between(), which can help
# in these situations. Between takes three arguments - the first being the
# variable name, followed by the lower bound (>=)and the upper bound (<=).
filter(starwars, species == "Gungan", between(height, 190,215))


#### arrange() ####

# Now that we're able to select() and filter() or data, we can reorder the data as we see fit.

# For example, let's sort 'starwars' by characters' heights from shortest to tallest:
arrange(starwars, height)
# We can also reverse the order, by wrapping a variable with desc()
arrange(starwars, desc(height))

# Despite sorting starwars above, the original tibble remains in tact! arrange()
# does NOT reorder in place, preserving the originial tibble or data frame.

# arrange() also lets you stack sorts - perhaps we wanted to sort first by age
# (oldest to youngest), and then by height:
arrange(starwars, desc(birth_year), height)

# Note entries 6 and 7 here - both have a birth year of 92, but are increasing by height!

# Recall that when we sorted by descending height, some of the characters were
# missing a mass. We can select() the name, height, and mass of the characters,
# filter() the rows which are missing a mass, and then arrange() the characters
# by mass.

# How could we go about doing this? One option would be to save each step.
selected <- select(starwars, name, height, mass)
filtered <- filter(selected, !is.na(mass))
arranged <- arrange(filtered, mass)
arranged

# However, storing each step in memory will prove costly in the long run,
# especially if you're dealing with large data sets. 
rm(arranged, filtered, selected)

# As we saw in the challenge exercise above, the dplyr functions can stack atop
# or nest within one another.

# Remember: order matters! How might we try and nest these queries?

# A:
arrange(
  filter(
    select(starwars, name, height, mass),
    !is.na(mass))
  ,mass)

#### Ceci n'est pas un pipe (or: the Pipe %>%) ####

# Useful though nested queries can be, it's far from intuitive! The tidyverse 
# also supplies us with the PIPE as part of the magrittr package. As with other
# programming languages, the PIPE will take the output of one function, and use
# it as the input for the next one.

# The PIPE is represented by '%>%'. Think of it like the word "Then" in common
# English.

# You can also insert the PIPE using the keyboard shortcut:
# cmd (or ctrl, on windows) + shift + M

starwars %>% 
  select(name, height, mass) %>% 
  filter(!is.na(mass)) %>% 
  arrange(mass)

# This gives us the same output as before, but in a much more interpretable way!
# Take 'starwars' THEN select name, height, and mass; THEN filter; THEN arrange.
# Plus, fewer nested parentheses to worry about.

# Also note that you can pipe a dataset into a function (as the first argument).

#### mutate() ####

# Datasets don't always contain the exact information that we want, and we may
# need to derive new variables. mutate() will let us do just that.

# For example, let's assume that the we're back in a Physics class, and want to 
# know the weight of characters in Newtons. F = ma, so we can multiply the mass
# variable by Earth's gravity (a = 9.8m/s^2).

# Like other dplyr verbs, mutate() takes the dataset as the first argument, 
# followed by an equation (or more!). The left-hand side of the equation is the
# name of the new variable, while the equation is on the right.

mutate(starwars, newtons = mass*9.8)

# Granted, mutate() preserves the dataframe in tact, so the "newtons" variable
# is added at the very end of the tibble, and we can't see it.

# Instead, let's use the pipe to select a few variables of interest.
starwars %>% 
  select(name, height, mass) %>% 
  mutate(earth_newtons = mass*9.8)

# Newly created variables don't have to be numeric, either. The tidyverse comes 
# with the srtingr package, which aids in the manipulation of strings. While we 
# won't cover it in-depth today (sorry!), we can use the word() function to
# extract just the first name of the characters.
library(stringr)
starwars %>% 
  select(name, height, mass) %>% 
  mutate(first = word(name,1))

#### mutate() and pipe EXERCISES ####

# From what you know about adding multiple arguments to dplyr functions, how 
# might we mutate() two new variables:
# earth_newtons (a= 9.8) and moon_newtons (a=1.6).
# Select only name, mass and species, and arrange() by moon_newtons from high to low.

starwars %>% 
  select(name, mass, species) %>% 
  mutate(earth_newtons = mass*9.8, moon_newtons = mass*1.622) %>% 
  arrange(desc(moon_newtons))


# From ?starwars, we know that height is in centimeters. Convert this to Feet, where 1 cm = .033 ft.
starwars %>%
  select(name, height) %>% 
  mutate(feet = height * .033)

# Try to convert the decimal value of feet into both feet and inches.
# HINT: Integer division is %/% (i.e. 13 %/% 2 is 6), and the remainder is %% (i.e. 13 %% 2 is 1).

starwars %>% 
  select(name, height) %>% 
  mutate(foot = height  *.033) %>% 
  transmute(name = name, feet = foot %/% 1, inches = round(foot %% 1 *12,1))

starwars %>% 
  select(name, height) %>% 
  mutate(foot = height  *.033) %>% 
  transmute(name = name, feet = floor(foot), inches = floor(foot %% 1 *12))

# What is the difference in age between yourself and the characters? Order by
# the difference, youngest to oldest.

# Using a declared variable
my_age <- 33

starwars %>% 
  select(name, birth_year) %>% 
  mutate(age_delta = birth_year - my_age) %>% 
  arrange(age_delta)

# Mutating a column with the variable.
starwars %>% 
  select(name, birth_year) %>% 
  mutate(my_age = 30, age_delta = birth_year - my_age) %>% 
  arrange(age_delta)



#### summarize() ####

summarize(starwars, rows = n())

starwars %>%
  summarise(mean_age = mean(birth_year), median_mass = median(mass))

starwars %>% 
  filter(!is.na(birth_year) & !is.na(mass)) %>%
  summarise(mean_age = mean(birth_year), median_mass = median(mass))


#### group_by() ####

# Summarize is made even more powerful by creating groups using the group_by() 
# function. As we saw above, using n() to determine the count of observations
# wasn't the most insightful. Instead, we can break this down by species:

starwars %>% 
  group_by(species) %>% 
  summarise(species_count = n()) %>% 
  arrange(desc(species_count))

# Humans are the dominant species, so let's see if we can see if there are any
# similarities in homeworld:

starwars %>% 
  filter(species == "Human" & !is.na(homeworld)) %>% 
  group_by(homeworld) %>% 
  summarize(humans = n()) %>% 
  arrange(desc(humans))

# Alternatively, we can group by more than one variable and come up with individual counts.

starwars %>% 
  select(species, homeworld) %>% 
  filter(species == "Human" | species == "Droid", !is.na(homeworld)) %>% 
  group_by(species, homeworld) %>% 
  summarize(residents = n()) %>% 
  arrange(homeworld, desc(residents))


#### group_by() and summarize() EXERCISES ####

# Compute the BMI (kg/(m^2)) for Male characters. what is the mean BMI? the median?
starwars %>% 
  select(name, gender, height, mass) %>% 
  filter(gender == "male") %>% 
  mutate(BMI = mass/(height/100)^2) %>% 
  summarize(mean_BMI = mean(BMI, na.rm = T), median_BMI = median(BMI, na.rm = T))
 
# Compare the BMI between species.
starwars %>% 
  select(name, species, height, mass) %>% 
  filter(!is.na(height), !is.na(mass)) %>% 
  mutate(BMI = mass/(height/100)^2) %>% 
  group_by(species) %>% 
  summarize(count = n(), mean_BMI = mean(BMI), median_BMI = median(BMI)) %>% 
  filter(count > 1) %>% 
  ungroup() %>% 
  arrange(median_BMI)

# What is the 75th quantitle for human height? Group by gender.
quant75 <- starwars %>% 
  select(name, height, species, gender) %>% 
  filter(species == "Human") %>% 
  group_by(gender) %>% 
  summarize(q75 = quantile(height, .75, na.rm = T))

quant75

# CHALLENGE: Find all human characters above the 75th percentile of height, by his/her gender!

starwars %>% 
  select(name, height, species, gender) %>% 
  filter((species == "Human" & gender == 'male' & height >= 188) | 
           (species == "Human" & gender == 'female' & height >=165)) %>% 
  arrange(gender, desc(height))

starwars %>% 
  select(name, height, species, gender) %>% 
  filter((species == "Human" & gender == 'male' & height >= quant75$q75[quant75$gender == "male"]) | 
           (species == "Human" & gender == 'female' & height >= quant75$q75[quant75$gender != "male"])) %>% 
  arrange(gender, desc(height))


#### do() ####

models <- starwars %>% 
  group_by(species) %>% 
  filter(!is.na(height), !is.na(mass)) %>% 
  do(mod = lm(height~mass, data = .))

models$mod[models$species == "Human"]


# From Wickham's "Data Manipulation with dplyr" presentation, June 2014"
# Files available: https://www.dropbox.com/sh/i8qnluwmuieicxc/AAAgt9tIKoIm7WZKIyK25lh6a
library(zoo)
df <- data.frame(
  houseID = rep(1:10, each = 10),
  year = 1995:2004,
  price = ifelse(runif(10 * 10) > 0.50, NA, exp(rnorm(10 * 10)))
)

df %>%
  group_by(houseID) %>%
  do(na.locf(.))

df %>%
  group_by(houseID) %>%
  do(head(., 2))

df %>%
  group_by(houseID) %>%
  do(data.frame(year = .$year[1]))
