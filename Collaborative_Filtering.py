users = { "Raj":{"Ice":7, "Water":5, "Gas": 6},
"Rohit":{"Ice":4, "Water":8, "Gas":7},
"Dawny":{"Ice":2, "Water":2, "Gas":9},
"Annie":{"Ice":4, "Water":3, "Gas": 7},
"Jaimie":{"Ice":6, "Water":4, "Gas":5},
"Lisa":{"Ice":4, "Water":5.5, "Gas":4.8},
"Laurent":{"Ice":5.4, "Water":7.8, "Gas":3.5}
}

def Manhattan_dist(r1, r2):
  dist = 0
  for key in r1:
    if key in r2:
      dist += abs(r1[key]-r2[key])
  return dist 
  
def Compute_NN(username, users):
    distances = []
    for user in users:
        if user != username:
            dist = Manhattan(users[user], users[username])
            distances.append((dist,user))
    distances.sort()
    return distances 
	
def Reccomend(username, users):
    near = Compute_NN(username,users)[0][1]
    recommendations = []
    neighbour_rate = users[near]
    user_rate = users[username]
    for item in neighbour_rate:
        if not item in user_rate:
            recommendations.append((item, neighbour_rate[item]))
    return sorted(recommendations, key=lambda itemTuple: itemTuple[1], reverse = True)
