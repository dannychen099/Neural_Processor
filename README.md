# Neural_Processor_CE493
## Neural Network Processor - Digit Classifier

Data File -> contains all test input, label, bias, weight data in text file formate

bias_hidden_mem.v -> store hidden layer bias in memory

bias_output_mem.v -> store output layer bias in memory

weight_hidden_mem.v -> store hidden layer weight in memory

weight_output_meme.v -> store output layer weight in memory

register.v -> store and load the memory data of output value of the hidden layer that are inputs of the output layer

weight_mux.v / bias_mux.v / input_mux.v -> multiplexers to select appropriate values based on controller's state.

data_mem.v / label_mem.v -> load the pre-train data from text file

PE.v -> Processing Element will take bias and weight's values and compute the data

ReLU.v -> Each PE will compute the label value. The maximum value between output of all neruons will be selected. ReLU function is considered as an activation function.
