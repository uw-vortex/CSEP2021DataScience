### CSEP 2021: Data Science for the Modern Exercise Physiologist
# Date: October 13, 2021
# Chair: Jason Au, University of Waterloo

### Packages to open
library(tidyverse)

### 1. RStudio interface and introduction ####
# Refer to powerpoint notes for detailed notes on notation and functions
# Quick reference:
# - Top left: Script area for saving your work
# - Top right: Variable area to see tables and objects
# - Bottom left: Console area for quick testing and feedback
# - Bottom right: Directory, plot previews, and help pop-ups

## Basic notations and variable types
my.string <- "CSEP rocks!" # This is a string
my.number <- 2021          # This is a number

## Basic table building
# Let's create a few number and character arrays using core functions
column1 <- seq(from = 1, to = 6, by = 1) # seq() makes a sequence between two numbers
column2 <- rnorm(n = 6, mean = 50, sd = 10) # rnorm() makes a random dataset with a normal distribution
column3 <- c(rep(x = 'Male', times = 3),rep(x = 'Female', times = 3)) # c() combines values into an array, rep() repeats a value a few times

# If you forget what a function does, you can use the ? option in the Console
?rnorm

# Arrays aren't as useful by themselves, so let's add them together to form a dataset
my.df <- data.frame(ID = column1,
                    VO2 = column2,
                    Sex = column3)



### 2. Data cleaning and 'wrangling' basics using the Tidyverse ####

## Loading the data
df <- read.csv("training_sample.csv")

## Exploring the data
view(df)           # See the table view of the data
str(df)            # See a preview of the data structure in the Console

## Using tidyverse pipelines %>%
# The %>% symbol is called a 'pipeline' (shortcut: ctrl+shift+m or cmd_shift+m)
# The %>% can be read as '... and then...' and is a convenient way to link multiple 
# lines of code without constantly referring to the dataset

# Read this segment as: Identify df as the dataset, and then, view the dataset
df %>%
  view()

# In exploring, you'll see the different variable types including characters,
# integers, and numbers. We first need to change our group to be a 'factor' instead
# of a number for convenience

# To make alterations or add columns to a dataset, you can use the mutate() function
df <- df %>% 
  mutate(group = factor(group))

# Now we can check if that worked using str()
str(df)

# We can also use mutate to add new columns with custom calculations
# Let's create a new dataset and calculate BMI
df2 <- df %>% 
  mutate(BMI = mass / (height/100)^2)

# PAUSE: This seems like stuff we could do in Excel easier... why in R?

## Changing the shape of a dataset: pivot_longer() vs pivot_wider()
# You may be familiar with 'wide-form' data, like you might enter into SPSS,
# or 'long-form' data that you might enter into sigmaplot. You can easily switch between
# long- and short-form data using the pivot_longer() and pivot_wider() functions.

# df is already in the wide-form, so let's switch it to long-form
df.long <- df2 %>% 
  pivot_longer(cols = 6:11,
               names_to = c("timepoint","outcome"),
               names_sep = "_",
               values_to = "value")


### 3. Data Visualization ####

## ggplot2: This is a powerful graph building function that works similar to
## photoshop - you design the graph in 'layers' starting with your content, then
## adding on different visualizations and aesthetics until you have a completed graph

# For the following lines, we have inserted comments into the normal flow of script
# To follow along, add in a + sign at the end of each line after ggplot() to build on the plot
# First, we are going to identify the dataset we want to graph
df.long %>% 
  # Now we are going to filter the data so we are only looking at MAP
  filter(outcome == "MAP") %>% 
  # Next we are going to call the actual ggplot function to identify components we want to graph
  # The aes() argument identifies aesthetic parts of the graph that depend on actual data
  # Anything outside of aes() are fixed components like text size and axis ticks
  # Notice that when we start graphing, we use a + to add a layer instead of a pipeline
  ggplot(aes(x = timepoint, y = value, colour = group))+
  # Now let's add some summary statistics in the form of boxplots
  geom_boxplot()
  # Now we are going to add a visual layer, a scatter plot to see all data
  # We need to specify the position, or all groups will go on top of each other
  geom_point(position = position_dodge(width = 0.75))
  # The graph is technically done, but not pretty. Let's add a pre-set theme:
  theme_classic()
  # Much better! There are still a few elements that we can address:
  scale_x_discrete(name = "Timepoint")
  scale_y_continuous(name = "Mean arterial pressure (mmHg)", limits = c(50,110), breaks = seq(50,110,10))
  # If we want to make this better for a media post, we can add some extra information:
  labs(caption = "Data Science for the Modern Exercise Physiologist",
       title = "Changes in MAP over time after exercise training",
       subtitle = "Sample data from CSEP 2021")
  # Any additional tweaks can be made with custom commands in your own theme
  theme(legend.position = "bottom")
  
# Without comments, the code looks like:
df.long %>% 
  filter(outcome == "MAP") %>% 
  ggplot(aes(x = timepoint, y = value, colour = group))+
  geom_boxplot()+
  geom_point(position = position_dodge(width = 0.75))+
  theme_classic()+
  scale_x_discrete(name = "Timepoint")+
  scale_y_continuous(name = "Mean arterial pressure (mmHg)", limits = c(50,110), breaks = seq(50,110,10))+
  labs(caption = "Data Science for the Modern Exercise Physiologist",
       title = "Changes in MAP over time after exercise training",
       subtitle = "Sample data from CSEP 2021")+
  theme(legend.position = "bottom")

## To finish, there are MANY custom packages that can help data exploration at a glance
## One of our favourites is ggstatsplot for multiple groups:
library(ggstatsplot)
# We are going to use the original raw dataset for simplicity
ggbetweenstats(data = df,
               x = group,
               y = mass,
               title = "Distribution of baseline body mass across groups")




## INTERACTIVE ACTIVITY 1:
## Goal: Manipulate a dataset (create or change columns)
##
## INTERACTIVE ACTIVITY 2:
## Goal: Graph a dataset (using ggplot2)
## 
## INTERACTIVE ACTIVITY 3:
## Up to tutorial leaders
