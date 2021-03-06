import theano.tensor as T
from theano import function
from theano import pp
import numpy

'''
1. In Theano, all variables must be typed.
2. T.dscalar is the type we assign to 0-dimensional arrays[in short, they are scalars] of doubles.
3. dscalar is not a class; so X and Y are instances of TheanoVariable class; and they are assigned theano type "scalar".
'''
X = T.dscalar("x")
print type(X)
Y = T.dscalar("y")

z = X+Y

f = function([X,Y], z)
#print type(f)
print f(2,3)

'''
pp() - Pretty prints the function
'''
print pp(z)

'''
Adding matrices in Theano
'''
X = T.dmatrix("x")
Y = T.dmatrix("y")
z = X + Y
f = function([X,Y],z)

print f(numpy.array([[1, 2], [3, 4]]), numpy.array([[10, 20], [30, 40]]))

