import pandas as pd                                                                                                                                            
import numpy as np
import matplotlib.pyplot as plt
#%pylab inline

df = pd.ExcelFile("C:\\Users\\acer\\Desktop\\Coursera-DSTK\\BTP\\arunachalpradesh.xlsx")
df = df.parse("t1",index_col=None, na_values=['NA'])
#df.head()

df.columns  = df.columns.map(lambda x: x.lower())
#print df.columns

split_col_name = df.columns.map(lambda x: x.split(' '))
#print df.columns
print df.shape

names = ('Tawang', 'W Kameng', 'E Kameng', 'Papum Pare', 'U Subansiri', 'W Siang', 'E Siang', 'U Siang', 'Changlang', 'Tirap', 'L Subansiri', 'Kurung V', 'Dibang V','L. Dibang V', 'Lohit','Anjaw')
y_pos = np.arange(len(names))
population = df["Total Population Person"]

plt.barh(y_pos, population, align='center', alpha=0.4)
plt.yticks(y_pos, names)
plt.xlabel('Total Population')
plt.title('Population Analysis')

plt.show()
