

split_pdf <- function(pdf_path, output_directory, pages_per_split) {
  # Create a reader object for the PDF
  pdf <- pdf_length(pdf_path)
  
  # Calculate the number of splits needed
  num_splits <- ceiling(pdf / pages_per_split)
  
  # Split the PDF into chunks
  for (split_num in 1:num_splits) {
    # Define the range of pages for this split
    start_page <- (split_num - 1) * pages_per_split + 1
    end_page <- min(split_num * pages_per_split, pdf)
    
    # Define output file name
    output_file <- sprintf("%s/split_%d.pdf", output_directory, split_num)
    
    # Extract the range of pages
    pdf_subset(pdf_path, pages = start_page:end_page, output = output_file)
  }
  
  message(sprintf("PDF split into %d parts with up to %d pages each in '%s'", num_splits, pages_per_split, output_directory))
}

# example, splitted into 2-pages

split_pdf("C:/Users/myfolder/myfile.pdf", 
          "C:/Users/myfolder/", 
          2)
