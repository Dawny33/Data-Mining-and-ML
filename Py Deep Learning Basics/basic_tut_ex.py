import theano

a = theano.tensor.vector()
out = a + a**10

f = theano.function([a],out)

print f([0,1,2])


a = theano.tensor.scalar()
b = theano.tensor.scalar()
out = a**2+b**2+2*a*b

f = theano.function([a,b],out)
print f(1,2)


a = theano.tensor.vector()
b = theano.tensor.vector()
out = a**2+b**2+2*a*b

f = theano.function([a,b],out)
print f([1,2],[4,5])
