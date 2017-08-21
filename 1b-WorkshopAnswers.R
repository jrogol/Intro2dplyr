#### 0 - Prerequisites ####

# If you haven't already, run the '0-Prerequisites.R' script to install/update
# packages we'll use in this workshop.
source("0-Prerequisites.R")

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

# Now that we've seen both the 'starwars' and 'iris' data sets, consider some of
# dplyr's verbs to which you were indroduced moments ago. With this in mind,
# what are some of the questions you might ask of these data sets?

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

# You can also use variables to make your selections:
my_var <- "species"
select(starwars, my_var)

# The '-' prefix will exclude those columns from selection, either individually:
select(starwars, -name, -height, -birth_year)
# Or via negating a vector (concatenating terms with 'c()')
select(starwars, -c(name, height, birth_year))

# dpyr also works with DATA FRAMES, as with the 'iris' data:
select(iris, Species, Petal.Length)

#### select() EXERCISES ####

# Q: The sequence of variable names matters. How would you select the gender and names of all
# characters, in this order?
select(starwars, gender, name)

# Q: How would you select the name, hair_color, skin_color, and eye_color?
select(starwars, name, hair_color, skin_color, eye_color)
select(starwars, c('name', 'hair_color', 'skin_color', 'eye_color'))


# dplyr includes some helper functions, such as ends_with(), which can help in
# selecting variables! These functions take the search pattern as a string.
select(starwars, name, ends_with('color'))

# To see more of the helper functions and how they work:
?ends_with


#### filter() ####

# Selecting rows of date require CONDITIONS - equal to, not equal to, and, or,
# greater than etc. In base R, we can insert these conditions as the first
# argument in BRACKETS. Recall some of the various operators for conditions:

# == - equal to
# & - and
# | - or (that's a vertical line, not an l, nor capital I!)
# ! - not

# For example, we can see all of the human characters in the dataset:
starwars[starwars$species == "Human",]

# We can also use multiple conditions, such as all characters with a mass between 20 and 40:
starwars[starwars$mass >= 20 & starwars$mass < 40,]

# Within dplyr, filter() can help streamline this process, much like select()
filter(starwars, species == "Human")

# Including multiple conditions as arguments is the same as using &:
filter(starwars, mass >= 20 & mass < 40)
filter(starwars, mass >= 20, mass < 40)

# The other operators, will work, as well. For example, of all characters from
# Naboo OR with brown eyes:
filter(starwars, homeworld == "Naboo" | eye_color == "brown")

# Sometimes we need to investigate missing data. Filter those characters missing
# a species. Filter the characters who are NOT missing the species.
filter(starwars, is.na(species))
filter(starwars, !is.na(species))



#### filter() EXERCISES ####


# Q: Use filter() to determine how many characters are of the Droid species.
filter(starwars, species == "Droid")

# Q: Of the above, how many have red eyes?
filter(starwars, species == "Droid" & eye_color == "red")

# Q: Find all of the Gungan (species) or characters with a height between 190 and 215.
filter(starwars, species == "Gungan" | (height >= 190 & height <= 215))


# Like select(), filter() has helper functions, like between(), which can help
# in these situations. Between takes three arguments - the first being the
# variable name, followed by the lower bound (>=) and the upper bound (<=).
filter(starwars, species == "Gungan" | between(height, 190,215))

# CHALLENGE: Extract just the names of the red-eyed Droids by combining select() and filter()
select(
  filter(starwars, species == "Droid" & eye_color == "red"),
  name)

#### arrange() ####

# Now that we're able to select() and filter() our data, we can reorder the data
# as we see fit (similar to what you might do in Excel!)

# For example, let's sort 'starwars' by characters' heights from shortest to 
# tallest. Again, the data is the first argument, followed by the variable(s) of
# note:
arrange(starwars, height)

# We can also reverse the order, by wrapping a variable with desc()
arrange(starwars, desc(height))

# Despite sorting starwars above, the original tibble remains in tact!
# arrange(), like the rest of the dplyr family, does NOT work in place,
# preserving the originial tibble or data frame.

# arrange() also lets you stack sorts - they'll be sorted in the order by which
# the arguments are entered.

# Perhaps we wanted to sort first by age (oldest to youngest), and then by
# height:
arrange(starwars, desc(birth_year), height)

# Note entries 6 and 7 here - both have a birth year of 92, but are increasing by height!

# As mentioned earlier, some of the characters are missing values for various 
# characteristics. Let's say we want to look at the name, height, and mass of
# characters, but filter out those missing a mass, and then sort by mass.

# One option would be to save each step:
selected <- select(starwars, name, height, mass)
filtered <- filter(selected, !is.na(mass))
arranged <- arrange(filtered, mass)
arranged

# However, storing each step in memory will prove costly in the long run,
# especially if you're dealing with large data sets. Remove these objects.
rm(arranged, filtered, selected)

# As we saw in the challenge exercise above, the dplyr functions can stack atop
# or nest within one another.

#### arrange() EXERCISE ####

# Q: How might we try and nest these queries? Remember: order matters! 
arrange(
    filter(
      select(starwars, name, height, mass),
      !is.na(mass)
    ),
  mass)


#### Ceci n'est pas un pipe (or: the Pipe - %>%) ####

# Useful though nested queries can be, they're far from intuitive! The tidyverse 
# also supplies the PIPE as part of the magrittr package. As with other 
# programming languages, the PIPE will take the output of one function, and use 
# it as the input for the next one.

# The PIPE is represented by '%>%'. Think of it like the word "Then" in common
# English.

# You can also insert the PIPE using the keyboard shortcut:
# cmd (or ctrl, on windows) + shift + M

# We can use the PIPE to recreate the exerise above:
starwars %>% select(name, height, mass) %>% filter(!is.na(mass)) %>% arrange(mass)

# This is easier to read than nesting functions, and likely more intuitive:
# Take 'starwars' THEN select name, height, and mass; THEN filter; THEN arrange.

# Also note that you can pipe a dataset into a function (as the first argument),
# and use the pipe alongside other R code:
iris %>% summary()


#### mutate() ####

# Datasets don't always contain the exact features we need, and we may
# need to derive new variables. mutate() will let us do just that.

# Let's assume that the we're back in a Physics class, and want to measure the 
# characters in Newtons (Force = mass*acceleration). We can mutate a new
# variable by taking the mass variable and multiplying it by Earth's gravity (a
# = 9.8m/s^2).

# Like other dplyr verbs, mutate() takes the dataset as the first argument, 
# followed by one or more equations, separated by commas. The left-hand side of
# the equation is the name of the new variable, while the equation is on the
# right.

mutate(starwars, earth_newtons = mass*9.8)

# Where'd it go? mutate() keeps the data in tact, so the "newtons" variable
# is added at the very end of the tibble, and we can't see it.

# Instead, let's use the pipe to select a few variables of interest, alongside
# our newly mutated variable.
starwars %>% 
  select(name, height, mass) %>% 
  mutate(earth_newtons = mass*9.8)

# Newly created variables don't have to be numeric, either. The tidyverse comes 
# with the stringr package, which aids in the manipulation of strings/text data. While we 
# won't cover it in-depth today (sorry!), we can use the word() function to
# extract just the first and last names of the characters.
library(stringr)
starwars %>% 
  select(name, height, mass) %>% 
  mutate(first = word(name,1), last = word(name, -1))

#### mutate() and pipe EXERCISES ####

# Q: From what you now know about adding multiple arguments to dplyr functions, how
# might we mutate() two new variables:
          # earth_newtons (a= 9.8) and moon_newtons (a=1.6, or earth_newtons*.1632).
# Select only name, mass and species, and arrange() by moon_newtons from high to low.
starwars %>% 
	  select(name, mass, species) %>% 
	  mutate(earth_newtons = mass*9.8,
	         moon_newtons = earth_newtons*.1632) %>% 
	  arrange(desc(moon_newtons))


# Q: What is the difference in age between yourself and the characters? Order by
# the difference, youngest to oldest.

# Using a declared variable
my_age <- 33

starwars %>% 
  select(name, birth_year) %>% 
  mutate(age_delta = birth_year - my_age) %>% 
  arrange(age_delta)


#### summarize() ####

# You may be familiar with summary statistics from base R:
summary(iris)

# dplyr's summarize() (or summarise(), as Hadley's a Kiwi) function works like
# summary(): it reduces the data to a single value. Some summary statistics from base R
# include:

# sum() - summation
# mean() - the arithmatic mean
# sd() - standard deviation
# min() - minimum
# IQR() - interquartile range

# dplyr also includes n() to count observations (within summarize, mutate, and
# filter. It takes no arguments), and n_distinct(), which is faster than length(unique(x)).

# Examine the standard deviation of height, mean age, median mass, and the total
# number of characters.
starwars %>% 
  summarize(sd(height),
            mean(birth_year),
            median(mass),
            n())

# The names of the summary stats default to the function names, but our
# summaries didn't calculate! Why?

# We could work around this by including the na.rm argument:
starwars %>% 
  summarise(sd_height = sd(height, na.rm = T),
            mean_age = mean(birth_year, na.rm = T),
            median_mass = median(mass, na.rm = T),
            count = n())


# Or by filtering only the COMPLETE CASES (note how the count differs):
starwars %>% 
  filter(!is.na(birth_year) & !is.na(mass) & !is.na(height)) %>%
  summarise(sd_height = sd(height),
            mean_age = mean(birth_year),
            median_mass = median(mass),
            count = n())


#### group_by() ####

# Summarize is made even more powerful after creating groups using the 
# group_by() function. By using 'species' as the argument of group_by(), we can 
# count the number of observations within each group, and sort by frequency:

starwars %>% 
  group_by(species) %>% 
  summarise(species_count = n()) %>% 
  arrange(desc(species_count))

# Using multiple variables as arguments to group_by() will a series of
# heirarchical subgroups. 

# By using 'species' as the first argument, and 'homeworld' as the second, 
# 'homeworld' becomes a subgroup of species. We can then summarize the number of
# observations in each subgroup (filtering on Humans or Droids for simplicity):

starwars %>% 
  select(species, homeworld) %>% 
  filter(species == "Human" | species == "Droid") %>% 
  group_by(species, homeworld) %>% 
  summarize(residents = n()) %>% 
  arrange(homeworld, desc(residents))


#### group_by() and summarize() EXERCISES ####
# Let's put it all together now!
 
# Q: Compare the mean and median BMI (kg/(m^2)) between species. Only include
# species with more than one character in the dataset.
# Remember: mass is in kg, but height is in centimeters!
starwars %>% 
  select(species, height, mass) %>% 
  mutate(BMI = mass/(height/100)^2) %>% 
  group_by(species) %>% 
  summarize(count = n(),
            mean_BMI = mean(BMI, na.rm = T),
            median_BMI = median(BMI, na.rm = T)) %>% 
  filter(count > 1) %>% 
  arrange(median_BMI)

# Q: What is the 75th quantitle for human height? (HINT: use quantile()). Group by gender.
starwars %>% 
  select(name, height, species, gender) %>% 
  filter(species == "Human") %>% 
  group_by(gender) %>% 
  summarize(q75 = quantile(height, .75, na.rm = T))



# CHALLENGE: Find all human characters above the 75th percentile of height, by his/her gender!
starwars %>% 
  select(name, height, species, gender) %>% 
  filter((species == "Human" & gender == 'male' & height >= 188) | 
           (species == "Human" & gender == 'female' & height >=165)) %>% 
  arrange(gender, desc(height))


#### do() ####

# One last, powerful feature of dplyr is the do() function. It will let you run 
# computations using the manipulated data and store the results in a list.

# We can create a simple linear model for the full dataset, where a character's
# height is a function of his/her mass:

all <- lm(height~mass, data = starwars)
all

# How well does this model fit the data?
summary(all)$r.squared

# Employing this same syntax along with group_by() and do(), we can build models
# for multiple groups at the same time. For example, if we group by species: 
models <- starwars %>% 
  group_by(species) %>% 
  filter(!is.na(height), !is.na(mass)) %>% # remove observations with missing values
  do(mod = lm(height~mass, data = .))

# the '.' in the last line refers to the function's input; in this case, it's
# the filtered data from the line of code above do().
models

# As you can see, 'mod' is a new variable, where each entry is a list. Each
# element of the list contains the model for a given species. We can examine 
# the results for Humans:
models$mod[models$species == "Human"]

# Since lm() produces a list, you can call additional arguments to extract
# additional information, like the R-squared values of each of the models:
models %>% 
  summarise(species = species, r_squared = summary(mod)$r.squared) %>% 
  arrange(desc(r_squared))

# You can also use do() to extract the coefficients of all the models. Note that
# each observation/row in the 'models' object is referenced by the '.' when
# calling coef().
models %>% 
  do(as.data.frame(coef(.$mod)))

# Below are some additional examples of how do() can be useful in wrangling one's data
# Adapted from Wickham's "Data Manipulation with dplyr" presentation, June 2014"
# Files available: https://www.dropbox.com/sh/i8qnluwmuieicxc/AAAgt9tIKoIm7WZKIyK25lh6a

# zoo, while primarily a package for dealing with time series, contains a
# function - na.locf() - which can help deal with missing data. In this case, it
# copies the last valid value present - the Last Observation Carried Forward.
library(zoo)

# Create a data frame of dummy data (10 houses, and randomized prices over 10
# years, 2008-2017). Don't worry if the syntax doesn't make sense yet!
houses <- data.frame(
  houseID = rep(1:10, each = 10),
  year = 2008:2017,
  price = ifelse(runif(10 * 10) > 0.50, NA, exp(rnorm(10 * 10)))
)

# Using do(), we can replace the missing values by carrying the last valid entry
# forward for each ID:
houses %>%
  group_by(houseID) %>%
  do(na.locf(.))

# do() can also be used to show the first two observations within each group in
# conjunction with head(). Here, the '.' refers to each group within the data frame.
houses %>%
  group_by(houseID) %>%
  do(head(., 2))