class Recommender

def __init__(self, dats, k=1, metric="pearson", n=5):
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
        
    
        