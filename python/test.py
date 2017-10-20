from bayes_filter import BayesFilter
import matplotlib.pyplot as plt


observations = [0,0,0,0,0,0,0,1,1,1,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0]
delay = 5
print '************', observations[0]

BF = BayesFilter(delay, observations[0])

for i in range(2,len(observations)):
	BF.filtering(observations[i])
	if i > delay:
		BF.smoothing()

print BF.prob
print BF.smoothed_prob

index_0 = range(len(observations))
index_1 = range(len(BF.prob))
index_2 = range(len(BF.smoothed_prob))

plt.plot(index_0, observations,'g')
plt.plot(index_1, BF.prob,'r')
plt.plot(index_2, BF.smoothed_prob,'k')
plt.show()