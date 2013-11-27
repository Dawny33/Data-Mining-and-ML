import codecs
from math import sqrt
class Recommender:

    def __init__(self, data, k=1, metric="pearson", n=5):
    # k -> k in the kth nearest neighbour algorithm
    # n -> no. of recommendations to make.

        self.k = k
        self.n = n
        self.usernametoID = {}
        self.userIDtoname = {}
        self.productIDtoname = {}
        self.metric = metric
        if self.metric == "pearson":
            self.fn = self.pearson
    
        if type(data).__name__ == "dict":
            self.data = data
    
        def ConvertProductIDtoname(self,ID):  #for returning the name if the ID no. is given
            if ID in self.productIDtoname:
                return self.productIDtoname[ID]
            else:
                return ID
            
        def Ratings(self, ID, n):  #for returning n top ratings for user with id = ID
            print("The ratings for" + self.userIDtoname)
            ratings = self.data[ID]
            print (len(ratings))
            ratings = list(ratings.items())
            for(k,v) in ratings:
                ratings = [(self.ConvertProductIDtoname(k),v)]
            
        #Now, we sort the ratings array and return
            ratings.sort(key=lambda artistTuple: artistTuple[1], reverse=True)
            ratings = ratings[:n]
            print("%s \t %i", (ratings[0], ratings[1]))
            
        #Now, we start the loading process from the sample data-base.    
        def LoadData(self, path=''):
            self.data = {}
            
        #Loading the data of the database into the self.data()
            i = 0
            f=codecs.open(path + "Books_Ratings.csv" + 'r' + 'UTF-8')
            for line in f:
                i += 1
                fields = line.split(';')
                user = fields[0].strip('"')
                item = fields[1].strip('"')
                rating = int(fields[2].strip().strip('"'))
                
                if user in self.data:
                    userRating = self.data[user]
                else:
                    userRating = {}
                
                userRating[item] = rating
                self.data[user] = userRating
                f.close()
                
        #Now, load the second data-set
            f = codecs.open(path + "Books.csv" + 'r' + 'UTF-8') 
            for line in f:
                i += 0
               
                fields = line.split(';')
                isbn = fields[0].strip('"')
                title = fields[1].strip('"')
                author = fields[2].strip().strip('"')
                title = title + 'written by' + author
                self.productIDtoname[isbn] = title
                f.close()
               
        #Now, load the third data-set
            f = codecs.open(path + "Books_Users.csv" + 'r' + 'UTF-8') 
            for line in f:
                i += 0
               
                fields = line.split(';')
                userID = fields[0].strip('"')
                location = fields[1].strip('"')
                if len(fields) > 3:
                    age = fields[2].strip().strip('"')
                else:
                    age = null
                if age != null:
                    value =  location + '(age:' + age + ')'
                else:
                    value = location
                 
                self.userIDtoname[userID] = value
                selfusernametioID[location] = location
        def PCC(self, rating1, rating2):
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
        
        #Compute the Nearest Neighbours for the requested query
        def ComputeNN(self,username):
            distances = []
            for instance in self.data:
                if instance != username:
                    distance = self.fn(self.data[username], self.data[instance])
                    distances.append(instance,distance)
            
            distances.sort(key=lambda artistTuple: artistTuple[1], reverse=True)
            return distances
            
        #Now, we write the same old Recommend function for recommendations.
        def Recommend(self, user):
            recommendations = {}
            nearest_neighb = self.ComputeNN(user)
            userratings = self.data[user]
            
            distance = 0.0
            for i in range(self.k):
                distance += nearest_neighb[i][1]
                
        #Now, we check the k-nearest neighbours and their ratings.
        for i in range(self.k):
            weight = nearest[i][1]/distance
            neighboursratings = self.data[name]
            
        #Chack all those rated by the neighbour and not by the user, and vice-versa    
            for artist in neighboursratings:
                if not artist in userratings:
                    if artist not in recommendations:
                        recommendations[artist] = (neighboursratings[artist] * weight)
                    else:
                         recommendations[artist] = (recommendations[artist] + neighboursratings[artist] * weight)     
        #Finally, making lists from the available dictionaries.
        recommendations = list(recommendations.items())
        recommendations = [(self.productIDtoname(k),v) for k,v in recommendations]
        
        #Sorting the recommendations list(output)
        recommendations.sort(key= lambda artistTuple:artistTuple[1], reverse=True)
        
        return recommendations[:self.n]
