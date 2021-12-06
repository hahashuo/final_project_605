#!/bin/bash                                                                                                                                                                                                

# untar your R installation                                                                                                                                                                                
tar -xzf R402.tar.gz
tar -xzf textstem_0.1.4.tar.gz
tar -xzf tm_0.7-8.tar.gz

# make sure the script will use your R installation,                                                                                                                                                       
# and the working directory as its home location                                                                                                                                                           
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

# run your script                                                                                                                                                                                          
Rscript cleanData.R $1

