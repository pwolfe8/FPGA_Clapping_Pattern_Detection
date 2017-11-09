from gen_signal import gen_signal

# Choose a pattern to test
interval_pattern = [1.5, 2.0, 3.0, 1.0] # intervals between claps (5 claps total)
    # potential other patterns:
    #   clap_pattern:     10011010100011
    #   interval_pattern: [3,1,2,2,4,1]

# generate the actual signal (introduce noise by calling Gen_Signal.py)
signal = gen_signal(interval_pattern)

# enter simulation where we loop through at clock speed (f_sys) and feed in signal one sample at a time
for sampled_value in signal:
    


