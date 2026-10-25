# import libraries that allow to create database connection
library(DBI)
library(RPostgres)

# 1. Establish the connection to PostgreSQL database
con <- dbConnect(
  RPostgres::Postgres(),
  host     = "localhost",          # host where database is running which is currently locally
  port     = 5432,                 # Default PostgreSQL port is 5432
  dbname   = "your_database_name", # database name
  user     = "postgres",      # Database username
  password = "07288"       # Database password
)

# 2. Check if the connection works by listing all available tables
tables <- dbListTables(con)

# 3. Print the tables to the console
if (length(tables) == 0) {
  cat("Connection successful, but no tables were found in this database.\n")
} else {
  cat("Connection successful! Found the following tables:\n")
  print(tables)
}

# 4. Always disconnect when you are done exploring
# (Uncomment the line below when you are ready to close the connection)
# dbDisconnect(con)
