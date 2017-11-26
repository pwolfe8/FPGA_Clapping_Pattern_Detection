import scipy.io.wavfile
import numpy as np
import matplotlib.pyplot as plt
import numpy as np

def plotThis(y):
	x = range(0, len(y))
	plotting = plt.plot(x,y, '-')
	l1= plotting
	plt.setp(l1, linewidth=1.5, color='b')	
	plt.grid()
	plt.show()

rate, data = scipy.io.wavfile.read("sample6.wav")
print rate
data = data[2000:]
plotThis(data)

short_term_duration = 20
long_term_duration = 500
threshold_constant = 10000
max_allowed_clap_duration = 600
s = []


def get_actual_timestamps(arr):
	ans = []
	num = arr[0]
	for i in range(1, len(arr)):
		if arr[i] < arr[i-1] + 600:
			pass
		else:
			ans.append(num)
			num = arr[i]
	ans.append(num)

	return ans

i = 500

clap_durations = []
while i < len(data):
	short_term_average = np.mean([data[i-short_term_duration:i]])

	long_term_average = np.mean([data[i-long_term_duration:i]])
	threshold = threshold_constant + long_term_average
	
	j = i
	clap_duration = 0

	while short_term_average > threshold:
		short_term_average = np.mean([data[j-short_term_duration:j]])
		j = j + 1
		clap_duration = clap_duration + 1

	if clap_duration > max_allowed_clap_duration:
		i = i + clap_duration
		clap_duration = 0

	if clap_duration != 0:
		s.append(i)
		clap_durations.append(clap_duration)
		i = i + clap_duration
	else:
		i = i + 1

print get_actual_timestamps(s) 