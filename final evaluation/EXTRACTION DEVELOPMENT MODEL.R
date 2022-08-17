setwd('/Users/rohith/Desktop/PROJECTS AND WORK FILES/test')   # DIRECTORY SET TO THE REPOSITORY FOLDER


img_train<-list.files() # #for reading all image paths in to a list image train .

list_data<-list() # This list will later hold the text 
                  #extracted from each image in succesive levels of a list

#Image processing module starts here . Image undergoes various Processing for enhancement so that 
#text extraction becomes easy
library(magick)
for(i in 1:length(img_train)){   #loop until all the images in the folder are read
input <- image_read(img_train[i])
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
list_data[i]<-c(text_01)
 }

#The Extracted text is saved as Text file (optional)
setwd("/Users/rohith/Desktop")
capture.output(print(list_data), file = "MyNewFile.txt")

#Module to find list of paths where search keyword and extracted text match
setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/test")
id <- grep("R", list_data,ignore.case = TRUE)

list_of_paths<-list()
for(i in 1:length(id)){
  list_of_paths[i]<-c(img_train[id[i]])}
#list_of_paths
#output<-image_read(list_of_paths[[1]][1])
#output



