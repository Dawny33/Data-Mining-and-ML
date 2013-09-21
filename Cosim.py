from math import sqrt
users = { "Raj":{"Ice":7, "Water":5, "Gas": 6},
"Rohit":{"Ice":4, "Water":8, "Gas":7},
"Dawny":{"Ice":2, "Water":2, "Gas":9},
"Annie":{"Ice":4, "Water":3, "Gas": 7},
"Jaimie":{"Ice":6, "Water":4, "Gas":5},
"Lisa":{"Ice":4, "Water":5.5, "Gas":4.8},
"Laurent":{"Ice":5.4, "Water":7.8, "Gas":3.5}
}

def cosim(a, b):
    if len(a) != len(b):
        raise ValueError,  
    numerator = 0
    denomx = 0
    denomy = 0
    for i in a:       
    	ai = a[i]             
    	bi = b[i]
    	numerator += ai*bi     
    	denomx += ai*ai       
    	denomy += bi*bi
    result = numerator / (sqrt(denomx)*sqrt(denomy))
    return result
