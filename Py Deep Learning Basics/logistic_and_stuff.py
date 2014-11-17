import theano.tensor as T
from theano import function
from theano import pp
import numpy

'''
Basic Logistic function demo.
'''
x = T.dmatrix("x")
s = 1/(1+T.exp(-x))
