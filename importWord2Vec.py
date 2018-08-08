import csv
import matplotlib.pyplot as plt
import codecs
import gensim
import numpy as np
import unicodedata

model = gensim.models.KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin', binary=True)
vocab = model.vocab

interimVocabList = []
interimVocabVectors = []
vocabList = np.empty(len(vocab), dtype='|S6')
# vocabList = np.load("vocabList.npy")
vocabVectors = np.zeros((len(vocab), 300))

indexCounter = 0
for key in vocab:
	interimVocabList.append(key)
	interimVocabVectors.append(model[key])

vocabVectors = np.array(interimVocabVectors)
vocabList = np.array(interimVocabList)

np.save('vocabVectors', vocabVectors)
np.save('vocabList', vocabList)