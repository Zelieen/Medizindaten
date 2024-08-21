#clear the environment
rm(list = ls())

#load libraries
library(ggplot2)
library(readxl)
library(stringr)

#load data
raw_data <- read.csv(file = "K:/AlpinInsight/Projekte/Medizindaten/data/fr_Export_medicines_en.csv", sep = ";",  header = T) # From France: http://agence-prd.ansm.sante.fr/php/ecodex/telecharger/telecharger.php

#inspect raw data
dim(raw_data) #2433 rows and 1023 columns
head(raw_data) #too many columns... and unwieldy names
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

#inspect data and decide on how to use it
class(data_cleaned$Category) #Is character. I want it to be a factor
data_cleaned$Category <- as.factor(data_cleaned$Category)

head(data_test$Category) #good as factor
head(data_cleaned$Name.of.medicine) #good as character
tail(data_cleaned$EMA.product.number) #does all EMA numbers start with EMEA/H/C/ ? i.e. can I drop the pre-fix and store as numeric instead?
length(grep(data_cleaned$EMA.product.number, pattern = "EMEA\\/H\\/C\\/")) # 2091
length(data_cleaned$EMA.product.number) # 2433 no
length(grep(data_cleaned$EMA.product.number, pattern = "EMEA\\/H\\/C\\/")) == length(data_cleaned$EMA.product.number) #FALSE

different_EMA <- grep(data_cleaned$EMA.product.number, pattern = "EMEA\\/H\\/C\\/", invert = T)
head(data_cleaned$EMA.product.number[different_EMA]) #OK there are different prefixes for the numbers. Too bad. Needs to remain as character.

colnames(data_cleaned)

# I really do not like the way excel messed up the data and names when it exported to csv. It is cumbersome.

##try importing the excel sheet directly instead of exporting it from Excel to csv. I will need the 'readxl' library for this. Base R can not read excel.
excel_raw_data <- read_excel(path = "K:/AlpinInsight/Projekte/Medizindaten/data/fr_medicines_output_medicines_en.xlsx")

dim(excel_raw_data) #2441 rows and 39 columns
head(excel_raw_data) #lots of NA?
excel_raw_data[1:15,2] #seems that the data starts at row 8 with the column names
clean_excel <- as.data.frame(excel_raw_data[9:dim(excel_raw_data)[1],]) #drop the first 8 rows

colnames(clean_excel) <- excel_raw_data[8,] #write proper column names

summary(clean_excel)

#excel import has much nicer column names. Csv import has mangled names from exporting it out of excel --> use excel
cleaned_data <- clean_excel
#clean column names from '\n' --> I noticed that this will mess with the code!
colnames(cleaned_data) <- str_replace_all(colnames(cleaned_data), "\\n", " ")
#all columns are of character class. Which columns need a different class?
colnames(cleaned_data)
head(cleaned_data$Category) #this should be a factorial category, not a character string for example
##either as factor (in categories), as date or as numbers
### as factors
cleaned_data$Category <- as.factor(cleaned_data$Category)
cleaned_data$`Medicine status` <- as.factor(cleaned_data$`Medicine status`)
cleaned_data$`Opinion status` <- as.factor(cleaned_data$`Opinion status`)
cleaned_data$`Patient safety` <- as.factor(cleaned_data$`Patient safety`)
cleaned_data$`Pharmacotherapeutic group (human)` <- as.factor(cleaned_data$`Pharmacotherapeutic group (human)`)
cleaned_data$`Pharmacotherapeutic group (veterinary)` <- as.factor(cleaned_data$`Pharmacotherapeutic group (veterinary)`)
cleaned_data$`Accelerated assessment` <- as.factor(cleaned_data$`Accelerated assessment`)
cleaned_data$`Additional monitoring` <- as.factor(cleaned_data$`Additional monitoring`)
cleaned_data$`Advanced therapy` <- as.factor(cleaned_data$`Advanced therapy`)
cleaned_data$Biosimilar <- as.factor(cleaned_data$Biosimilar)
cleaned_data$`Conditional approval` <- as.factor(cleaned_data$`Conditional approval`)
cleaned_data$`Exceptional circumstances` <- as.factor(cleaned_data$`Exceptional circumstances`)
cleaned_data$`Generic or hybrid` <- as.factor(cleaned_data$`Generic or hybrid`) # wonderful, the answer to an or question is either yes or no -.-' Is a yes to hybrid or generic?
cleaned_data$`Orphan medicine` <- as.factor(cleaned_data$`Orphan medicine`)
cleaned_data$`PRIME: priority medicine` <- as.factor(cleaned_data$`PRIME: priority medicine`)
### as date
cleaned_data$`European Commission decision date` <- as.Date(cleaned_data$`European Commission decision date`, format = "%d/%m/%Y")
cleaned_data$`Start of rolling review date` <- as.Date(cleaned_data$`Start of rolling review date`, format = "%d/%m/%Y")
cleaned_data$`Start of evaluation date` <- as.Date(cleaned_data$`Start of evaluation date`, format = "%d/%m/%Y")
cleaned_data$`Opinion adopted date` <- as.Date(cleaned_data$`Opinion adopted date`, format = "%d/%m/%Y")
cleaned_data$`Withdrawal of application date` <- as.Date(cleaned_data$`Withdrawal of application date`, format = "%d/%m/%Y")
cleaned_data$`Marketing authorisation date` <- as.Date(cleaned_data$`Marketing authorisation date`, format = "%d/%m/%Y")
cleaned_data$`Refusal of marketing authorisation date` <- as.Date(cleaned_data$`Refusal of marketing authorisation date`, format = "%d/%m/%Y")
cleaned_data$`Withdrawal / expiry / revocation / lapse of marketing authorisation date` <- as.Date(cleaned_data$`Withdrawal / expiry / revocation / lapse of marketing authorisation date`, format = "%d/%m/%Y")
cleaned_data$`Suspension of marketing authorisation date` <- as.Date(cleaned_data$`Suspension of marketing authorisation date`, format = "%d/%m/%Y")
cleaned_data$`First published date` <- as.Date(cleaned_data$`First published date`, format = "%d/%m/%Y")
cleaned_data$`Last updated date` <- as.Date(cleaned_data$`Last updated date`, format = "%d/%m/%Y")
# as numeric
cleaned_data$`Revision number` <- as.numeric(cleaned_data$`Revision number`)

#make a smaller dataframe for exploratory plotting
plot_data <- data.frame(cleaned_data$`Name of medicine`)
colnames(plot_data) <- "Name"
plot_data <- cbind(plot_data, Category = as.factor(cleaned_data$Category))

ggplot(data = plot_data, aes(Category)) +
  geom_bar() +
  theme_classic() +
  labs(title = "Medicines in France")

#now use the full data set
#Target species
ggplot(cleaned_data, 
       aes(Category, 
           fill = Category)) +
  geom_bar() +
  geom_text(stat = "count",
            aes(label=..count..), vjust= -0.5) +
  theme_classic() +
  labs(title = "Medicines in France")

#authorization status
ggplot(cleaned_data, 
       aes(`Medicine status`, 
           fill = `Medicine status`)) +
  geom_bar() +
  geom_text(stat = "count",
            aes(label=..count..), vjust= -0.5) +
  theme_classic() +
  labs(title = "Medicines in France") +
  theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust = 1))

#first published
ggplot(cleaned_data, 
       aes(`First published date`)) +
  geom_area(stat = "bin") +
  theme_classic() +
  labs(title = "Medicines in France") +
  theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust = 1)) +
  scale_x_date(breaks = "years", date_labels =  "%Y")
