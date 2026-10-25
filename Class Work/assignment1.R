# import libraries that help to create a database connection
llibrary(DBI)
library(RPostgres)

# 1. Connect to PostgreSQL database (must already exist)
# Define your connection parameters
db_host     <- "localhost"
db_port     <- 5432
db_name     <- "learning_r_database"
db_user     <- "postgres"
db_password <- "07288"

# Safely attempt to connect
con <- tryCatch({
  connection <- dbConnect(
    RPostgres::Postgres(),
    host     = db_host,
    port     = db_port,
    dbname   = db_name,
    user     = db_user,
    password = db_password
  )
  
  # If successful, print a clear visual confirmation
  cat("[STATUS] Database connected successfully! ✅\n")
  cat("Connected to:", db_name, "on host:", db_host, "\n\n")
  
  # Return the connection object to the variable 'con'
  connection
  
}, error = function(e) {
  # If an error happens, print a failure message instead of crashing
  cat("[STATUS] Database is NOT connected. ❌\n")
  cat("Error details:", e$message, "\n\n")
  
  # Return NULL so 'con' is explicitly empty
  NULL
})

# 2. Create the 3 relational tables
dbExecute(con, "
  CREATE TABLE IF NOT EXISTS student (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    enrollment_year INT NOT NULL
  );
")

dbExecute(con, "
  CREATE TABLE IF NOT EXISTS course (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL
  );
")

dbExecute(con, "
  CREATE TABLE IF NOT EXISTS marks (
    mark_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES student(student_id) ON DELETE CASCADE,
    course_id INT REFERENCES course(course_id) ON DELETE CASCADE,
    score INT NOT NULL CHECK (score BETWEEN 0 AND 100)
  );
")

# 3. Insert base lookup data (Students and Courses)
# Generate mock student names
first_names <- c("John", "Mary", "David", "Sarah", "James", "Elena", "Robert", "Linda", "Michael", "Patricia")
last_names <- c("Smith", "Jones", "Miller", "Davis", "Garcia", "Rodriguez", "Wilson", "Thomas", "Martinez", "Anderson")

set.seed(42) # For reproducible random data
mock_students <- data.frame(
  name = paste(sample(first_names, 40, replace = TRUE), sample(last_names, 40, replace = TRUE)),
  enrollment_year = sample(2023:2026, 40, replace = TRUE)
)

mock_courses <- data.frame(
  course_name = c("Introduction to R", "Database Systems", "Linear Models", "Data Structures", "Machine Learning"),
  credits = c(3, 4, 3, 4, 4)
)

# Write students and courses to DB
dbWriteTable(con, "student", mock_students, append = TRUE, row.names = FALSE)
dbWriteTable(con, "course", mock_courses, append = TRUE, row.names = FALSE)

# 4. Generate and insert 200 random mark records linking them
# Fetch the generated database IDs to avoid foreign key violations
student_ids <- dbGetQuery(con, "SELECT student_id FROM student;")$student_id
course_ids <- dbGetQuery(con, "SELECT course_id FROM course;")$course_id

mock_marks <- data.frame(
  student_id = sample(student_ids, 200, replace = TRUE),
  course_id = sample(course_ids, 200, replace = TRUE),
  score = sample(50:100, 200, replace = TRUE) # Scores between 50 and 100
)

# Write the 200 records to the marks table
dbWriteTable(con, "marks", mock_marks, append = TRUE, row.names = FALSE)

cat("Database setup complete! Created tables and inserted 200 mock records.\n")




# Check if tables created
print(dbListTables(con))


# Calling database tables into R
course_df <- dbReadTable(con, "course")
(head(course_df))

student_df <- dbReadTable(con, "student")
(head(student_df))

marks_df <- dbReadTable(con, "marks")
(tail(marks_df))
