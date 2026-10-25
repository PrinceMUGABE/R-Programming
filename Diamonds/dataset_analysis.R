# ==============================================================================
# DATA ANALYTICS STUDY: INITIAL STRUCTURAL AUDIT
# DATASET: Diamonds (50,000+ records tracking gemstone dimensions)
# ==============================================================================

# 1. LOAD REQUIRED PACKAGES
# The tidyverse activates readr (importing), dplyr (cleaning), and ggplot2 (plotting).
library(tidyverse)

# 2. ASSIGN DATASET TO WORKING MEMORY
# We map the built-in 'diamonds' data to a script variable named 'my_data'.
my_data <- diamonds

# 3. AUDIT THE DATA SHAPE (DIMENSIONS)
# Returns the total counts: [1] Number of Rows  [2] Number of Columns.
dim(my_data)

#. We use str function to check the dataset structure with data type for each variable
str(my_data)

# 4. INSPECT COLUMN STRUCTURE AND DATA TYPES
# Flips the table sideways so we can read every column name, its R data type 
# (like <dbl> for decimal numbers, or <ord> for ranked text categories), and sample values.
glimpse(my_data)

# 5. SCAN FOR MISSING VALUES (NULLS)
anyNA(my_data)


# 6. CHECK FOR DUPLICATE ROWS
# 'duplicated(my_data)' checks every single row against previous rows.
# 'sum()' adds up all the TRUE matches to give us a single total number of duplicates.
sum(duplicated(my_data))

 #=================================================
# PHASE 2: VARIABLE TYPE ANALYSIS (CONTINUOUS VS. CATEGORICAL)
#====================================================


