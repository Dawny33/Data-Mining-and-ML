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
        if id in self.productIDtoname:
            return self.productIDtoname[ID]
        else:
            return ID
