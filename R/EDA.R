####  ---- CREATIVITY AS FORAGING -----  ####
# Malaie, Spivey, Marghetis, Cuesta

## ------------ Libraries ----------------
library(tidyverse)
library(lubridate)         # for working with the data 
library(skimr)             # generate a text-based overview of the data 
library(visdat)            # generate plots visualizing data types and missingness
library(plotly)            # quickly create interactive plots
library(zipfR)             # Word Freq library
library(readxl)            # Read .xlsx   

## -------------- READ DATA ----------------- 
stem_task_data <- read.csv('data/stem_task.csv') # RAW
stems_root_data <- read.csv('data/stems_root.csv') # RAW
raw_data <- read.csv('data/master_file_01.csv')

## Word Fz Dataset (COCA) 60k FreeDataSet from: https://www.wordfrequency.info/samples.asp 
df_word_freq <- read_excel('wordFrequency60k.xlsx', sheet = 'lemmas') #RAW

## Word Fz Dataset Small
df_word_freq_small <- read_excel('wordFrequency60k.xlsx', sheet = 'lemmas') %>% 
  select(c('rank','lemma','freq'))
word_freq_data

## Steam task Data Frame Small
df_stem_task_data_small <- read.csv('stem_task.csv') %>% 
  select(c('subject_id', 'time_elapsed', 'rt', 'response', 'letter_set'))
df_stem_task_data_small

## ---------- Main Questions ??? ------------

# Relationship between Time Response and Word Frequency
# Relationship between Time Response and Semantic Similarity 


## --------------- EDA -------------------- 

# Merge the datasets by the word
combined_data <- merge(df_stem_task_data_small, df_word_freq_small, by.x = "response", by.y = "lemma")
  

## Check the normality

## ---------- Check Normality and Linearity ---------------

# Histograms to assess the distribution visually
hist(combined_data$rt, main="Response Time Distribution", xlab="Time Response")
hist(combined_data$freq, main="Word Frequency Distribution", xlab="Frequency")

# Q-Q Plots to check for deviations from normality
qqnorm(combined_data$rt)
qqline(combined_data$rt)
qqnorm(combined_data$freq)
qqline(combined_data$freq)

# Shapiro-Wilk test for normality, we are going to use p.value > 0.05 
shapiro.test(combined_data$rt) # Response Time -> W = 0.80598, p-value < 2.2e-16 ----- NO NORMALITY ----
shapiro.test(combined_data$freq) # Frequency -> W = 0.46676, p-value < 2.2e-16 ------- NO NORMALITY ----


## ---------------- Word Frequency --------------------
# Scatterplot to visualize the relationship between Response Time and Word Frequency
plot(combined_data$freq, combined_data$rt, main="Scatterplot of Frequency vs. Time Response",
     xlab="Word Frequency", ylab="Time Response")

## ---------- Correlation Test ---------------

# Both no normality, then we are going to use Spearman

cor_test_result <- cor.test(combined_data$rt, combined_data$freq, method="spearman")
print(cor_test_result)

# Kendall's tau
cor.test(combined_data$rt, combined_data$freq, method="kendall")

## ----------- Semantic Distance ------------



