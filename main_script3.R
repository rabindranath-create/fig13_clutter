# main_script1.R




# Make sure working directory is the same as the script location (implicitly handled in GitHub Actions)
# Print working directory
cat("Working directory:", getwd(), "\n")

# Set up and confirm output folder
output_dir <- file.path(getwd(), "outputs/script3")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
cat("Created directory:", output_dir, "\n")

# Confirm contents before saving
print("Files in 'outputs' before saving:")
print(list.files("outputs", recursive = TRUE))

# Save dummy test file just to verify
writeLines("test", file.path(output_dir, "test.txt"))




# Load the helper script
source("RD_and_DT_Algorithm_copy.R")  # Ensure this file is in the same directory

lambda <- 2




results_250 <- data.frame(
  Run = integer(),
  N_c = integer(),
  Length = numeric(),
  Cost = numeric(),
  NumDisambigs = integer()
)


for (i in 1:100) {
  set.seed(400+i)
  obs_gen_para <- c(gamma = 0.3, d = 5, noPoints = 250)
  result <- TACS_Alg_C(obs_gen_para, alpha = 0.5, lambda)
  
  results_250[i, ] <- list(
    Run = i,
    N_c = 250,
    Length = result$Length_total,
    Cost = result$Cost_total,
    NumDisambigs = length(result$Disambiguate_state)
  )
}

saveRDS(results_250, file.path(output_dir, "data_50_4_5.rds"))






results_275 <- data.frame(
  Run = integer(),
  N_c = integer(),
  Length = numeric(),
  Cost = numeric(),
  NumDisambigs = integer()
)

for (i in 1:100) {
  set.seed(400+i)
  obs_gen_para <- c(gamma = 0.3, d = 5, noPoints = 275)
  result <- TACS_Alg_C(obs_gen_para, alpha = 0.5, lambda)
  
  results_275[i, ] <- list(
    Run = i,
    N_c = 275,
    Length = result$Length_total,
    Cost = result$Cost_total,
    NumDisambigs = length(result$Disambiguate_state)
  )
}

saveRDS(results_275, file.path(output_dir, "data_50_4_6.rds"))






# Combine all results into one table
results <- rbind(results_250, results_275)

# Format output
results_out <- data.frame(
  Index = paste0('"', 1:nrow(results), '"'),  # Quoted index
  results[, c("N_c", "Length", "Cost", "NumDisambigs")]  # Make sure column names match
)

# Define the custom header (space-separated, quoted)
header <- '"n_c" "length" "cost" "number of disambiguations"'

# Define output path
txt_path <- file.path(output_dir, "results_ACS4_clutter.txt")

# Write header manually
writeLines(header, txt_path)

# Append data
write.table(
  results_out,
  file = txt_path,
  append = TRUE,
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE,
  sep = " "
)

cat("✅ Text results saved to:", txt_path, "\n")
