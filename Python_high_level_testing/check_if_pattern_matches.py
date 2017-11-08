# -*- coding: utf-8 -*-
"""
@date: 11/7/2017

@author: Matthew Arceri
"""

#Example pattern array and incoming detected clap data (inputs for function)
#patterns = [[[1.4,1.6],[1.8,2.2],[2.7,3.3],[0.9,1.1]],
#           [[0.9,1.1],[4.5,5.5],[5.4,6.6]],
#           [[9,11],[18,22],[13.5,16.5],[4,6]],
#           [[0.98,1.01],[4.0,6],[5.4,6.2]]]
#testArray= [250, 1250, 1500]

def check_if_pattern_matches(fixed_length_arr, len_used, stored_patterns):   
	# normalization
    smallest = min(fixed_length_arr)
    normal = []
    for interval in fixed_length_arr:
        normal.append(int(interval/smallest))
		
	# boundary comparison/pattern comparison
    matchedpatterns = []
    for i, pattern in enumerate(stored_patterns):
        match = True
        if len(pattern) == len_used:
            for j, bounds in enumerate(pattern):
                if (bounds[0] < fixed_length_arr[j]) and (bounds[1] < fixed_length_arr[j]):
                    match = True
                else:
                    match = False
        else:
            match = False
        if match == True:
            matchedpatterns.append(i)
    return matchedpatterns