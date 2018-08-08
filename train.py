from random import randint
import tensorflow as tf
import numpy as np
import datetime
import gensim
import csv
import re

def getTrainBatch():
	labels = []
	arr = np.zeros([batchSize, maxSeqLength])
	for i in range(batchSize):
		if (i % 2 == 0): 
			num = randint(1,11499)
			labels.append([1,0])
		else:
			num = randint(13499,24999)
			labels.append([0,1])
		arr[i] = ids[num-1:num]
	return arr, labels

def getTestBatch():
	labels = []
	arr = np.zeros([batchSize, maxSeqLength])
	for i in range(batchSize):
		num = randint(11499,13499)
		if (num <= 12499):
			labels.append([1,0])
		else:
			labels.append([0,1])
		arr[i] = ids[num-1:num]
	return arr, labels

# RNN Model hyperparameters
maxSeqLength = 36
numDimensions = 300 
batchSize = 24
lstmUnits = 64
numClasses = 5
iterations = 100000

wordsList = np.load('vocabList.npy')
wordsList = wordsList.tolist() 
wordVectors = np.load('vocabVectors.npy')

# Create Graph
tf.reset_default_graph()

labels = tf.placeholder(tf.float32, [batchSize, numClasses])
input_data = tf.placeholder(tf.int32, [batchSize, maxSeqLength])

data = tf.Variable(tf.zeros([batchSize, maxSeqLength, numDimensions]),dtype=tf.float32)
data = tf.nn.embedding_lookup(wordVectors,input_data)

lstmCell = tf.contrib.rnn.BasicLSTMCell(lstmUnits)
lstmCell = tf.contrib.rnn.DropoutWrapper(cell=lstmCell, output_keep_prob=0.75)
value, _ = tf.nn.dynamic_rnn(lstmCell, data, dtype=tf.float32)

weight = tf.Variable(tf.truncated_normal([lstmUnits, numClasses]))
bias = tf.Variable(tf.constant(0.1, shape=[numClasses]))
value = tf.transpose(value, [1, 0, 2])
last = tf.gather(value, int(value.get_shape()[0]) - 1)
prediction = (tf.matmul(last, weight) + bias)

correctPred = tf.equal(tf.argmax(prediction,1), tf.argmax(labels,1))
accuracy = tf.reduce_mean(tf.cast(correctPred, tf.float32))

loss = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=prediction, labels=labels))
optimizer = tf.train.AdamOptimizer().minimize(loss)

tf.summary.scalar('Loss', loss)
tf.summary.scalar('Accuracy', accuracy)
merged = tf.summary.merge_all()
logdir = "tensorboard/" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S") + "/"
writer = tf.summary.FileWriter(logdir, sess.graph)

sess = tf.InteractiveSession()
saver = tf.train.Saver()
sess.run(tf.global_variables_initializer())
sess.run(embedding_init, feed_dict={embedding_placeholder:wordVectors})

for i in range(iterations):
	#Next Batch of reviews
	nextBatch, nextBatchLabels = getTrainBatch();
	sess.run(optimizer, {input_data: nextBatch, labels: nextBatchLabels})
   
	#Write summary to Tensorboard
	if (i % 50 == 0):
		summary = sess.run(merged, {embedding_placeholder:wordVectors, input_data: nextBatch, labels: nextBatchLabels})
		writer.add_summary(summary, i)

	#Save the network every 10,000 training iterations
	if (i % 10000 == 0 and i != 0):
		save_path = saver.save(sess, "models/pretrained_lstm.ckpt", global_step=i)
		print("saved to %s" % save_path)
writer.close()