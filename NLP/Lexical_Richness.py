def lexical_richness(text):
	return len(text)/len(set(text))

def percentage(x, text):
	return 100*text.count(x)/len(text)