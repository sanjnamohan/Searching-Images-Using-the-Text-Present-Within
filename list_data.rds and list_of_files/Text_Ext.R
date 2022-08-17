         # DIRECTORY SET TO THE REPOSITORY FOLDER
setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
library(magick)
library(rlist)

if(!file.exists("list_data.rds")){
  setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
  list_data<-list()
  saveRDS(list_data, "list_data.rds")
  
}

if(!file.exists("list_of_files.rds")){
  setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
  list_of_files<-list()
  saveRDS(list_of_files, "list_of_files.rds")
  
}



getcount <- function(){
  setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images") #Function to get the no. of files in the folder.For list appending
  y<-list.files()
  return(length(y))
}

# keeporder <- function(q){                 #function to keep the order of files in list_data and display when searched in sync.Can't just use list.files(),displays random images.
#   setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
#   list_of_files<- readRDS("list_of_files.rds")
#   k<-getcount()
#   list_of_files[k] <- q
#   saveRDS(list_of_files, "list_of_files.rds")
#   return(list_of_files)
# }

fun <- function(x,y){
  setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
  img_train <- x 
  
   #for reading all image paths in to a list image train .
  list_data <- readRDS("list_data.rds")
  list_of_files <- readRDS("list_of_files.rds")
  # This list will later hold the text 
  #extracted from each image in succesive levels of a list
  
  #Image processing module starts here . Image undergoes various Processing for enhancement so that 
  #text extraction becomes easy
  
  
  #loop until all the images in the folder are read
  input <- image_read(img_train)
  input <- image_scale(input, "800")
  input <- image_quantize(input, colorspace = 'gray')
  input <- image_negate(input)
  input <- image_deskew(input, threshold = 40)
  
  input <- image_reducenoise(input, radius = 1L)
  input <- image_contrast(input, sharpen = 3)
  input <- image_enhance(input)
  
  #text extraction module. The enhanced image is given to the tessearct module 
  #for text extraction
  text <- input %>%
    image_resize("3000x") %>%
    image_convert(type = 'Grayscale') %>%
    image_trim(fuzz = 30) %>%
    image_write(format = 'png', density = '300x300') %>%
    tesseract::ocr() 
  
  
  #The extracted text for each image will append to text_01
  text_01 <- strsplit(text, "\n")
  
  k<-getcount()
  #adding each extracted test from each image in each iteration  to a list .
  #list_data <- readRDS("list_data.rds")
  list_data[k]<-c(text_01)
  setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
  saveRDS(list_data, "list_data.rds")
  list_of_files[k]<-y
  saveRDS(list_of_files, "list_of_files.rds")
  return(list_data)
  
  
  #The Extracted text is saved as Text file (optional)
  
  #capture.output(print(list_data), file = "MyNewFile.txt",append = TRUE)
  
}

# setwd('/Users/rohith/Desktop/PROJECTS AND WORK FILES/test') 
# cur_dir <- '/Users/rohith/Desktop/PROJECTS AND WORK FILES/test'
# dest_dir <- '/Users/rohith/Desktop/Extracted' 
# 
# #if (dir.exists(dest_dir)){
#   #cat("Copying file to:", destDir,"\n")
#   
#   file.copy(from=cur_dir,to=dest_dir,copy.mode = TRUE)
#   
# 
# 
# #Module to find list of paths where search keyword and extracted text match
# setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/test")
# id <- grep("R", list_data,ignore.case = TRUE)
# capture.output(print(list_of_paths), file = "Extracted.txt")
# list_of_paths<-list()
# for(i in 1:length(id)){
#   list_of_paths[i]<-c(img_train[id[i]])}
# #list_of_paths
# #output<-image_read(list_of_paths[[1]][1])
# #output
# 
# 
