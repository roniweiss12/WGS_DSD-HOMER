library(arrow)

# Load command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if any arguments were passed
if (length(args) == 0) {
  cat("No arguments provided.\n 
      Usage: Rscript convert_output_to_final_format.R homer_output.csv path/to/intervals.bed")
}

homer_output_file <- args[1]
intervals_file <- args[2]

homer_output <- read.csv(homer_output_file)
intervals <- read.table(intervals_file, sep = "\t", header = FALSE)
colnames(intervals) <- c("chr", "start", "end", "interval_ID")

# Merge the two data frames based on matching IDs
merged_data <- merge(homer_output, intervals, by.x = "PositionID", by.y = "interval_ID", all.x = TRUE)

result_df <- merged_data[,c("chr", "start", "end", "Sequence","MotifScore", "Strand", "Motif.Name")]
result_df$source <- "HOMER"
write_parquet(result_df, "homer_TFBS_results.prq")
