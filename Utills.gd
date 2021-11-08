extends Node

func project_path():
	var path = ProjectSettings.globalize_path("res://")
	path = path.split("/")
	path = el(path, 0, len(path) - 2)
	var path2 = ""
	for i in path:
		path2 += i + "/"
	return path2

func file_exists_eas(file, public = "private"):
	
	var path
	
	if public == "absolute":
		path = ""
	if public == "public":
		path = "user://"
	elif public == "private":
		path = "res://"
	var file2check = File.new()
	return file2check.file_exists(path + file) 

func read_file(file_name, public = "private"):
	
	var output
	
	var file = File.new()
	var path
	if public == "public":
		path = "user://"
	else:
		path = "res://"
	file.open(path + file_name, file.READ)
	output = file.get_as_text()
	file.close()
	
	return output

func write_file(data, file_name, public = "private"):
	
	var file = File.new()
	var path
	if public == "public":
		path = "user://"
	else:
		path = "res://"
	file.open(path + file_name, file.WRITE)
	file.store_string(str(data))
	file.close()

func ungerade_menge(num):
	
	if len(num) % 2 == 1:
		return true

func list_to_str(list):
	
	var output = ""
	var output1 = ""
	var count1 = 0
	var count2 = 0
	
	for i in list:
		count1 += 1
		count2 += 1
		output1 += str(i)
		if count2 == int(sqrt(len(list))) or count1 == len(list):
			output += output1
			output1 = ""
	
	return output

func split_all(text, length = 1):
	
	var output = []
	var output1 = ""
	
	for i in range(len(text) / length):
		for x in range(length):
			output1 += text[(i * length) + x]
		output += [output1]
		output1 = ""
	return output

func count_up_bin(bin):
	
	for i in range(len(bin)):
		if bin[len(bin)-1-i] == "0":
			bin[len(bin)-1-i] = "1"
			break
		else:
			bin[len(bin)-1-i] = "0"
	return(bin)

func el(array, from, to):
	
	var output = []
	
	if str(to) == "end":
		to = len(array)
	for i in range(from, to):
		output += [array[i]]
	
	return output

func x_char(character, x):
	
	var output = ""
	
	for i in range(x):
		output += character
	
	return output

func capital(text):

	if str(text).capitalize() == text:
		return true
	else:
		return false

func remove_char(character, text):
	
	var char_position = []
	
	if character in text:
		for x in range(len(text)):
			for i in range(len(text)):
				if character in text:
					if text.findn(character, i+1) == -1:
						char_position.append(i)
						text[i] = ""
						break
	
	return([text] + char_position)
