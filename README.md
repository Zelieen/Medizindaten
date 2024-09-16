This project does some basic data wrangling and plotting in R and Python.

My goal was to transfer what I already can do in R and replicate it in Python by producing comparable results.

The used data was taken from https://agence-prd.ansm.sante.fr/php/ecodex/telecharger/telecharger.php on the 15th of August 2024.  
The scripts do the following steps:  
-import the raw data (as .xlsx)  
-assess general data metrics and deepen understanding of data arrangement  
-clean up data by dropping unwanted rows  
-optimize memory usage and internal data representation (string, categorical, numerical and date formats)  
-draw 3 plots (R uses ggplot, Python uses seaborn)  
-subset data for Influenza associated medicines  
-harmonize medicine manufacturer names  
-count medicine numbers by manufacturer name  
-draw plot ordered by medicine numbers
