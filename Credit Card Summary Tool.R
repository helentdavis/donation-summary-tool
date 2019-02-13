## Created 11 January 2019 by Helen Davis
## for Farestart tip summary table
## Run code line by line by highlighting line and hitting "run" or by hitting ctrl + enter
## Inputs - excel dataframe containing full name, tip amount, and closed date
## Outputs - excel dataframe containing full name, tip amount, closed date, and total tip sum at last entry for each donor


## install and run packages
install.packages(c("readxl","xlsx","dplyr")
packagelist <- c("readxl","xlsx","dplyr")  
lapply(packagelist, require, character.only = TRUE)

## Set working directory path
setwd(choose.dir(default = "", caption = "Select folder"))
# Verify successfully changed
print(getwd())

## Read input file
b  <- read_excel(print(file.choose()))

## Summarize tip amounts by name, this may take a minute
tb <- aggregate(b$`Tip Amount`, by=list(Category=b$`Full Name`), FUN=sum)

eb <- b %>% 
  group_by(b$`Full Name`) %>% 
  arrange(b$`Closed Date`, b$`Full Name`) %>%
  do(tail(., 1))

## Merge summarized data with original dataset
names(tb)[1]<-"Full Name"
names(eb)[5]<-"Full Name"
m1 <- merge(eb, tb, by = "Full Name", all=T)
m1$UID <- paste(m1$`Full Name`, m1$`Closed Date`)
b$UID <- paste(b$`Full Name`, b$`Closed Date`)
m2 <- merge(b, m1, by = "UID", all=T)

## Clean up dataframe
fin <- m2[,c(6:8,19)]
names(fin) <- c("Full_Name", "Tip_Amount", "Closed_Date", "Tip_Total")

# Export to working directory, this may take a minute
write.xlsx(fin, "Credit Card Transaction Detail List_Summary Table.xlsx")
