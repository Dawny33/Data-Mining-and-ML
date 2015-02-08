import re

p = re.compile("[a-z]+")
#print p

m = p.search(":::  message")

#print m.group()
#print m.start()
#print m.end()
#print m.span()


p2 = re.compile("\d+")
iterator = p2.finditer("12 drummers drumming, 11 pipers piping, 10 lords a-leaping")

#for match in iterator:
#    print match.span()

    
print re.match(r'.', "Business agreement")

