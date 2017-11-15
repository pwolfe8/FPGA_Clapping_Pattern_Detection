
# clap detector


# state machine for recording raw data (intervals between each clap)
    # philip will handle this to the point where you just get an array 
f_clk = 100e6
silence_time = 3 # seconds
T_END_SILENCE = f_clk*3
sample_resolution = log2(T_END_SILENCE)


# logic to normalize that interval_pattern (array with resolution 29 bits)


# logic to check which bounds it fits in & patterns it matches


# display logic

