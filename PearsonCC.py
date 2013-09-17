from math import sqrt
users = { "Raj":{"Ice":7, "Water":5, "Gas": 6},
"Rohit":{"Ice":4, "Water":8, "Gas":7},
"Dawny":{"Ice":2, "Water":2, "Gas":9},
"Annie":{"Ice":4, "Water":3, "Gas": 7},
"Jaimie":{"Ice":6, "Water":4, "Gas":5},
"Lisa":{"Ice":4, "Water":5.5, "Gas":4.8},
"Laurent":{"Ice":5.4, "Water":7.8, "Gas":3.5}
}


def PCC(rating1, rating2):
    sum_xy = 0
    sum_x = 0
    sum_y = 0
    sum_x2 = 0
    sum_y2 = 0
    n = 0
    for key in rating1:
        if key in rating2:
            n += 1
            x = rating1[key]
            y = rating2[key]
            sum_xy += x*y
            sum_x += x
            sum_y += y
            sum_x2 += x**2
            sum_y2 += y**2
    denom = sqrt(sum_x2 - (sum_x**2)/n) * sqrt(sum_y2 - (sum_y**2)/n)    
    if denom == 0:
        return 0
    else:
        return (sum_xy - (sum_x*sum_y)/n)/denom
