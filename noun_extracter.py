from nltk.tag import pos_tag


sentence = "Located in northeastern Spain, Barcelone is one of the country's top travel destinations. Unique to Barcelona; are the marvels of Antoni Gaudi, like Casa Batllo and the famous Sagrada Familia"
tagged_sent = pos_tag(sentence.split())
# [('Michael', 'NNP'), ('Jackson', 'NNP'), ('likes', 'VBZ'), ('to', 'TO'), ('eat', 'VB'), ('at', 'IN'), ('McDonalds', 'NNP')]

print tagged_sent

propernouns = [word for word,pos in tagged_sent if pos == 'NNP']
# ['Michael','Jackson', 'McDonalds']

print propernouns


