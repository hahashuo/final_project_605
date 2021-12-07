#!/bin/bash                                                                                                                                                                                               \
                                                                                                                                                                                                           

# untar your R installation                                                                                                                                                                               \
                                                                                                                                                                                                           
tar -xzf R402.tar.gz

# make sure the script will use your R installation,                                                                                                                                                      \
                                                                                                                                                                                                           
# and the working directory as its home location                                                                                                                                                          \
                                                                                                                                                                                                           
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R


# run your script                                                                                                                                                                                         \
                                                                                                                                                                                                           
Rscript combineTFs.R $1

