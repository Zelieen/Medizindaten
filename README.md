This project does some basic data wrangling and plotting in R and Python.

My goal was to transfer what I already can do in R and replicate it in Python by producing comparable results.

The used data was taken from https://agence-prd.ansm.sante.fr/php/ecodex/telecharger/telecharger.php on the 15th of August 2024. /n
The scripts do the following steps: /n
-import the raw data (as .xlsx) /n
-assess general data metrics and deepen understanding of data arrangement /n
-clean up data by dropping unwanted rows /n
-optimize memory usage and internal data representation (string, categorical, numerical and date formats) /n
-draw 3 plots (R uses ggplot, Python uses seaborn) /n
-subset data for Influenza associated medicines /n
-harmonize medicine manufacturer names /n
-count medicine numbers by manufacturer name /n
-draw plot ordered by medicine numbers
