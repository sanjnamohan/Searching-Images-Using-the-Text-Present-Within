         # DIRECTORY SET TO THE REPOSITORY FOLDER
setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images")
library(magick)
library(rlist)
list_data<-list()

fun <- function(x){
  
  img_train <- x # #for reading all image paths in to a list image train .

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


#adding each extracted test from each image in each iteration  to a list .
list_data<-c(list_data,text_01)

 return(list_data)
#The Extracted text is saved as Text file (optional)
setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
#capture.output(print(list_data), file = "MyNewFile.txt",append = TRUE)
dput(list_data, "MyNewFile.txt")
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
# 
