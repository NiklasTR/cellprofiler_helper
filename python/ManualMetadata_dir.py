''' A script to create a list of all the metadata combinations present in a given CSV
This is designed to be called from the command line with
$ python ManualMetadata.py pathtocsv/csvfile.csv "['Metadata_Metadata1','Metadata_Metadata2']"
'''
from __future__ import print_function

import pandas as pd
import sys
import ast
import os

def __main_manual(pattern_start = "metadata_", pattern_end = ".csv"):
    path=sys.argv[1] #/home/ubuntu/bucket/metadata/000012070903_2019-01-10T20_04_27-Measurement_3
    pattern_custom=sys.argv[3] # a pattern to for example a specific channel

    csv_list = os.listdir(path)
    csv_list = [i for i in csv_list if pattern_start in i]
    csv_list = [i for i in csv_list if pattern_end in i]
    csv_list = [i for i in csv_list if pattern_custom in i]

    metadatalist=ast.literal_eval(sys.argv[2])

    for dir in csv_list:
        csv = os.path.join(path, dir)
        incsv=pd.read_csv(csv)
        manmet=open(csv[:-4]+'batch.txt','w')
        print(incsv.shape)
        done=[]
        for i in range(incsv.shape[0]):
                metadatatext='{"Metadata": "'
                for j in metadatalist:
                    metadatatext+=j+'='+str(incsv[j][i])+','
                metadatatext=metadatatext[:-1]+'"}, \n'
                if metadatatext not in done:
                    manmet.write(metadatatext)
                    done.append(metadatatext)
        manmet.close()
        print(str(len(done)), 'batches found')

if __name__ == '__main__':
    __main_manual()
