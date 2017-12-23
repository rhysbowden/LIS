# LIS

A project for finding the intersection of all longest monotonic (typically, increasing) subsequences of a sequence. 

This method has been applied to bitcoin block header timestamp data to clean the data. All timestamps that were in all of the longest increasing subsequences of the chain were marked as reliable. All unreliable timestamps were resampled between the nearest adjacent reliable timestamps as though the process was Poisson, that is, the times were independently uniformly distributed and then placed in ascending order. 

The resulting data set is included (times\_and\_targets\_interp2.txt): the first column is the original timestamps as integer numbers of seconds in the order in which the blocks arrived. The second column is the new, resampled timestamps. The third column is a 1 if the two timestamps are the same, 0 otherwise.
