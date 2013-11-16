#This linear perceptron is a basic example of a neural network.
#In this code, we use a simple classifier, which involves a threshold for decision making, and is then passed through the heave-side function.

# Importing libraries
from random import choice
from numpy import array, dot, random

#A simple heave-side (step function) function.
step = lambda x: 0 if x<1 else 1

#The first two variables are the input variables. and the third one among the triple is the dummy variable.
#The element inside "[]" and outside the parantheses of the triple is the result of an AND function of the given input elements.
training_data = [(array([0,0,1]), 0),(array([0,1,1]), 0),(array([1,0,1]), 0),(array([1,1,1]), 1),]

rand = random.rand(3) #We choose three random numbers b|w 0 and 1 for initial weights. Remember the rand function derieves the random nmbers from a Gaussian distribution.
