# image-processing-using-VHDL-

System Overview:

The system's primary function is to process images affected by "salt and pepper" noise. 
Initially, it takes in a noisy image and transforms it into three MIF files, each containing color layers of the image.

The system applies a median filter to each color layer independently. 
This filter operates on a 3x3 kernel, processing one complete row at a time and receiving a sequence of three rows for each color channel.

After filtering, the system generates three output MIF files, each corresponding to a color channel of the image. These output files contain the filtered image data.


Components:
1. TOP: The file that includes all the components in the system and duplicates 3 copies of each component (except the SM) in order to process each color layer at the same time.
2. ROM: consists of 256 lines each containing 1280 bits.
3. RAM: consists of 256 lines each containing 1280 bits.
4. SM: The file consists of 3 different processes that communicate with each other. The first process is to advance read addresses from the rom and transfer states. A second process advances write addresses to the ram. The third process is a state machine with 5 states reset first line, all lines last line, stop, .
5. Pipeline: The component connects the ROM, the RAM, the Median Filter using BUFFER.
6. Median Filter: Package file containing all the types in the system and the filter itself. In addition contains the conversion functions of the variable types.

Operation:

The system receives 3 mif files which contain the color layers of the image.
The TOP produces the 3 components of ROM, RAM and PIPELINE.
As soon as the SM receives START, it starts the COUNTER which transfers the addresses to be read. The first and last row are read twice in order not to filter out undefined end values.
The PIPELINE receives the read line and converts it from a bit to a pixel consisting of 5 bits, that is, turns a line of 1280 bits into a line of 256 pixels. After the conversion they are transferred into the BUFFER and it sends them into the filter. Only after reading 3 lines is the ENABLE signal transferred to write into the RAM.

We specifically implemented the MEDIAN FILTER because we get an image with salt and pepper noise and this filter is the ideal filter for cleaning this noise.
The filter consists of three functions and operates on the filtering of one complete row, each time receiving a sequence of three rows. The filter is 3x3.
   
   
