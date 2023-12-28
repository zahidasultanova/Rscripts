
# This script is to convert large pdf files to smaller versions.
# It converts pdf files into lower quality jpgs and then merges them to become a smaller pdf.
# More useful for image-based pdfs.

# Necessary packages 
library(magick)
library(pdftools)

compress_pdf <- function(pdf_path, output_dir, output_pdf_name, dpi) {
  # Extract the file name without extension
  file_name <- tools::file_path_sans_ext(basename(pdf_path))
  
  # Create a unique new directory based on the base path and current timestamp
  timestamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
  new_output_dir <- file.path(output_dir, paste0(file_name, "_", timestamp))
  
  # Create the new output directory
  if (!dir.exists(new_output_dir)) {
    dir.create(new_output_dir, recursive = TRUE)
  }
  
  # Define a simple output file pattern for the converted JPEGs
  output_file_pattern <- file.path(new_output_dir, "%d.jpg")
  
  # Convert the PDF to a set of images and save them in the new directory
  pdf_info <- pdftools::pdf_info(pdf_path)
  pdftools::pdf_convert(pdf_path, format = "jpg", dpi = dpi, pages = 1:pdf_info$pages, filenames = output_file_pattern)
  message(sprintf("PDF converted to JPG and saved in '%s'", new_output_dir))
  
  # Merge the JPG files into a single PDF
  jpg_files <- list.files(new_output_dir, pattern = "\\.jpg$", full.names = TRUE)
  
  if (length(jpg_files) > 0) {
    images <- magick::image_read(jpg_files[1])
    if (length(jpg_files) > 1) {
      for (i in 1:length(jpg_files)) {
        images <- c(images, magick::image_read(jpg_files[i]))
      }
    }
    
    output_pdf_path <- file.path(output_dir, output_pdf_name)
    magick::image_write(images, output_pdf_path, format = "pdf")
    message(sprintf("JPG files merged into a single PDF: '%s'", output_pdf_path))
    
    # Delete the temporary directory with JPEG files
    unlink(new_output_dir, recursive = TRUE)
    message(sprintf("Temporary directory deleted: '%s'", new_output_dir))
    
  } else {
    stop("No JPG files found in the directory.")
  }
}



# Example usage for 60 dpi
compress_pdf("C:/Users/myfolder/myfile.pdf",
             "C:/Users/myfolder",
             "compressed_myfile.pdf",
             60)
