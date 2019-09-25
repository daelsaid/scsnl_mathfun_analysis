import pandas as pd
import sys
import numpy as np
import os


path='/Users/daelsaid/Downloads/subjectlist'

datafile_to_merge=os.path.join(path,'data_eff_wide_revised.csv')
datafile_final=os.path.join(path,'all_subj_ordered.csv')


datafile_to_merge_df=pd.read_csv(datafile_to_merge,dtype='str')
datafile_final_df=pd.read_csv(datafile_final,dtype='str')


datafile_final_df.merge(datafile_to_merge_df,on='pid',how='left',copy=False)
