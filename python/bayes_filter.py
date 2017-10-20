from __future__ import division
import numpy as np
from collections import deque

class BayesFilter():
	def __init__(self, d, init_O):
		# transition model, given previous collision, what's the probability of
		# anotehr collision?
		self.T = np.array([[0.9, 0.1],[0.001,0.999]])
		
		# sensor model, given collision, what's the probability of observe
		# collision?
		self.P_O_T = np.array([[0.7, 0.3], #given collision, the prob of observation
							   [0.01, 0.99]]) #given no collision, the prob of observation
		
		# O matrix for simplified matrix algorithm 
		# O = np.array([[P_O_T[0,1-init_O], 0]
		# 				[0, P_O_T[1,1-init_O]]])
		self.O_list = deque()
		#self.O_list.append(O)

		# initial f = f1 = P(x1|o1)		  
		f = np.array([[0.9, 0.1],[0.1,0.9]])
		f = f[1-init_O][:]
		self.f_list = deque()
		self.f_list.append(f)
		# list of the probability of anomaly
		self.prob = [f[0]]
		self.smoothed_prob = []
		# number of delay
		self.d = d
	def filtering(self, observation):
		O = np.array([[self.P_O_T[0,1-observation], 0],
         			  [0, self.P_O_T[1,1-observation]]])
		self.O_list.append(O)
		
		f = np.dot(np.dot(O, self.T.T), self.f_list[-1])
		f = f/sum(f)
		print f.shape
		self.f_list.append(f)
		self.prob.append(f[0])

	def smoothing(self):
		b = np.eye(2)
		for i in range(self.d):
			b = np.dot(b, np.dot(self.T,self.O_list[i]))
		b = np.dot(b, np.array([1,0]))
		print b.shape
		# remove the non-useful O matrix
		self.O_list.popleft()

		smoothed = self.f_list.popleft() * b
		smoothed = smoothed/sum(smoothed)
		self.smoothed_prob.append(smoothed[0])
