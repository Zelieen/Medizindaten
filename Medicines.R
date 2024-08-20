#clear the environment
rm(list = ls())

#load libraries
library(ggplot2)

#load data
raw_data <- read.csv(file = "K:/AlpinInsight/Projekte/Medizindaten/Export_medicines_en.csv", sep = ";",  header = T)

#inspect data
dim(raw_data) #2433 rows and 1023 columns
head(raw_data) #too many columns...
raw_data[1:5,1:5]
head(raw_data[,500]) #look at first few data points in column 500 -> NAs
colnames(raw_data) #there seems to be a large amount of garbage nonsense columns named X.number
head(grep(colnames(raw_data), pattern = "X\\.")) # returns 'row' numbers that match
#sort_out <- grep(colnames(raw_data), pattern = "X\\.")
keep <- grep(colnames(raw_data), pattern = "X", invert = T) #there is also a garbage 'X' column
raw_data[1,keep[1:3]]

#clean data
data_cleaned <- as.data.frame(raw_data[,keep])
summary(data_cleaned) #seems all values are stored as character

typeof(data_cleaned$Category) #Is character. I want it to be factor
data_cleaned$Category <- as.factor(data_cleaned$Category)

head(data_test$Category) #good as factor
head(data_cleaned$Name.of.medicine) #good as character
tail(data_cleaned$EMA.product.number) #does all EMA numbers start with EMEA/H/C/ ?
length(grep(data_cleaned$EMA.product.number, pattern = "EMEA\\/H\\/C\\/")) # 2091
length(data_cleaned$EMA.product.number) # 2433 no
length(grep(data_cleaned$EMA.product.number, pattern = "EMEA\\/H\\/C\\/")) == length(data_cleaned$EMA.product.number) #FALSE

different_EMA <- grep(data_cleaned$EMA.product.number, pattern = "EMEA\\/H\\/C\\/", invert = T)
head(data_cleaned$EMA.product.number[different_EMA]) #OK there are differnt prefixes for the numbers

colnames(data_cleaned)

