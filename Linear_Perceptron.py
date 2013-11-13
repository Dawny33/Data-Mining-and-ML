#This linear perceptron is a basic example of a neural network.
#In this code, we use a simple classifier, which involves a threshold for decision making, and is then passed through the heave-side function.

# Importing libraries
from random import choice
from numpy import array, dot, random

step = lambda x: 0 if x<1 else 1

