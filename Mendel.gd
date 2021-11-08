extends Panel

var screen_size
export var elements = 9
var procent = 0.0
var direct = OS.get_user_data_dir()
var chars = {}
signal settings

var Utills = preload("Utills.gd").new()

#---------------------------------------------------
func _ready():
	screen_size = get_viewport_rect().size
	$Kreuzungsschema.max_columns = sqrt(elements)
	#margin_right = screen_size.x
	#margin_bottom = screen_size.y
	
	for i in range(1000):
		chars[char(i)] = i
	
	print("Project path: " + Utills.project_path())
	
	$Mendel.show()
	$MultiGen.hide()
	$Generationen.hide()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			if $Multigen.pressed:
				_on_MultiGen_pressed()
			else:
				_on_Mendel_pressed()
#---------------------------------------------------

func procent(summand):
	if $Multigen.pressed == false:
		procent += summand
		print("|" + Utills.x_char("-", int(clamp(int(procent + 0.1), 0, 48))) + Utills.x_char(" ", int(48 - clamp(int(procent + 0.1), 0, 48))) + str(procent) + Utills.x_char("-", int(procent + 0.1 - 48 + 1 - len(str(procent)))) + Utills.x_char(" ", int((100 - clamp(int(procent + 0.1), 48, 100) + (1 - len(str(procent)) + clamp(int(procent - 48 + 0.1), 0, 3)) * (1 -  clamp(int(procent + 0.1 - 48 + 1 - len(str(procent))), 0, 1))))) + "|")

func count_up_bin(bin):
	
	for i in range(len(bin)):
		if bin[len(bin)-1-i] == "0":
			bin[len(bin)-1-i] = "1"
			break
		else:
			bin[len(bin)-1-i] = "0"
	return(bin)

func bin_to_garmets(bin_list, Parental, char_pos):
	
	var output = []
	var count = 0
	var bin_split
	
	for i in range(len(Parental)):
		if char_pos.find(i + count +1) != -1:
			Parental[i] += "'"
			count += 1
			
	for i in bin_list:
		bin_split = Utills.split_all(i)
		for x in range(len(bin_split)):
			bin_split[x] = Parental[2*x + int(bin_split[x])]
		i = Utills.list_to_str(bin_split)
		output += [i]
	
	return output

func get_garmets(Parental, ap_pos):
	
	var bin_count = Utills.x_char("0", len(Parental) / 2)
	var garmets = []
	
	Parental = Utills.split_all(Parental)
	for i in range($Kreuzungsschema.max_columns - 1):
		garmets += [bin_count]
		bin_count = count_up_bin(bin_count)
	garmets = bin_to_garmets(garmets, Parental, ap_pos)
	
	return garmets

func add_garmets(garmet1, garmet2):
	
	var ap_pos1 = []
	var ap_pos2 = []
	var gen = []
	
	
	for i in range(1, len(Utills.remove_char("'", garmet1))):
		ap_pos1.append(Utills.remove_char("'", garmet1)[i])
	garmet1 = Utills.split_all(str(Utills.remove_char("'", garmet1)[0]))
	for i in range(1, len(Utills.remove_char("'", garmet2))):
		ap_pos2.append(Utills.remove_char("'", garmet2)[i])
	garmet2 = Utills.split_all(str(Utills.remove_char("'", garmet2)[0]))
	for i in range(len(ap_pos1)):
		garmet1[ap_pos1[i] - (len(ap_pos1) - i)] += "'"
	for i in range(len(ap_pos2)):
		garmet2[ap_pos2[i] - (len(ap_pos2) - i)] += "'"
	for i in range(len(garmet1)):
		if str(garmet1[i]).capitalize() != str(garmet1[i]) and str(garmet2[i]).capitalize() == str(garmet2[i]):
			gen += [garmet2[i] + garmet1[i]]
		elif len(garmet1[i]) > len(garmet2[i]):
			gen += [garmet2[i] + garmet1[i]]
		else:
			gen += [garmet1[i] + garmet2[i]]
	return Utills.list_to_str(gen)

func phaenotyp(genotyp):
	
	var gen = []
	var genotyp_noap = []
	var phaenotyp = []
	var phaenotyp_ = {}
	var ap_pos = []
	var genotyp_noap_len = len(str(Utills.remove_char("'", str(genotyp[0]).split(",")[1])[0]))
	var counter = 0
	var count = 0
	var gens
	var pot = 0
	var ix = 0
	var xx = 0
	
	procent(0.1)
	
	ix = floor(sqrt(len(genotyp)))
	xx = ceil(sqrt(len(genotyp)))
	
	while (ix + 1) * xx < len(genotyp):
		ix += 1
	
	while (ix + 1) * xx > len(genotyp):
		xx -= 1
	xx += 1
	var rest = len(genotyp) - (ix + 1) * xx
	var genotyp_noap1 = []
	var ap_pos1 = []
	for i in range(ix + 1):
		for x in range(xx):
			ap_pos1.append([])
			if (i * xx + x) == len(genotyp):
				break
			genotyp_noap1 += Utills.split_all(str(Utills.remove_char("'", str(genotyp[i * xx + x]).split(",")[1])[0]))
			for y in range(1 ,len(Utills.remove_char("'", str(genotyp[i * xx + x]).split(",")[1]))):
				ap_pos1[x].append(Utills.remove_char("'", str(genotyp[i * xx + x]).split(",")[1])[y])
			if (int((i * xx + x)*160))/len(genotyp) == count:
				procent(0.1)
				count += 1 
		if i != 0:
			genotyp_noap1 = genotyp_noap1
		if i != 0:
			ap_pos1 = ap_pos1
		genotyp_noap += genotyp_noap1
		ap_pos += ap_pos1
		genotyp_noap1 = []
		ap_pos1 = []
	procent = 99.4
	procent(0.1)
	for i in range(len(ap_pos)):
		ap_pos[i].invert()
	for i in range(len(ap_pos)):
		count = 0
		for x in range(len(ap_pos[i])):
			genotyp_noap[i * genotyp_noap_len - 1 + (ap_pos[i][x] - count)] += "'"
			count += 1
	procent(0.1)
	for i in range(len(genotyp)):
		for x in range(genotyp_noap_len / 2):
			if genotyp_noap[i * genotyp_noap_len + 2 * x] == genotyp_noap[i * genotyp_noap_len + 2 * x + 1]:
				gen.append(genotyp_noap[i * genotyp_noap_len + 2 * x])
			elif Utills.capital(genotyp_noap[i * genotyp_noap_len + 2 * x]):
				if not Utills.capital(genotyp_noap[i * genotyp_noap_len + 2 * x + 1]):
					gen.append(genotyp_noap[i * genotyp_noap_len + 2 * x])
				else:
					gen.append(genotyp_noap[i * genotyp_noap_len + 2 * x])
					gen.append(genotyp_noap[i * genotyp_noap_len + 2 * x + 1])
			else:
				gen.append(genotyp_noap[i * genotyp_noap_len + 2 * x])
				gen.append(genotyp_noap[i * genotyp_noap_len + 2 * x + 1])
		phaenotyp.append("")
		for x in range(len(gen)):
			phaenotyp[i] += str(gen[x])
		phaenotyp[i] += "," + str(genotyp[i]).split(",")[0]
		gen = []
		if str(phaenotyp[i]).split(",")[0] in phaenotyp_:
			phaenotyp_[str(phaenotyp[i]).split(",")[0]] += float(str(phaenotyp[i]).split(",")[1])
		else:
			phaenotyp_[str(phaenotyp[i]).split(",")[0]] = float(str(phaenotyp[i]).split(",")[1])
		phaenotyp_
		
	procent(0.1)
	
	phaenotyp = []
	for i in phaenotyp_:
		phaenotyp += [str(phaenotyp_[i]) + "," + str(i)]
	
	procent(0.1)
	
	phaenotyp.sort()
	
	return phaenotyp

#---------------------------------------------------
func _on_Mendel_pressed(parental1 = "false", parental2 = "false", multigen = false):
	
	var ap_pos1 = []
	var ap_pos2 = []
	var Parental1
	var Parental2
	var Garmets1 = []
	var Garmets2 = []
	var table = []
	var write_table = ""
	var genotyp = {}
	var genotyp_ = []
	var phaenotyp
	procent = 0.0
	
	if $Multigen.pressed == false:
		print(Utills.x_char("-", 10))
		print("starting...")
		$Genotypen.show()
		$Phaenotypen.show()
	$Mendel.hide()
	$Error_Label.text = ""
	$Kreuzungsschema.clear()
	$Kreuzungsschema.show()
	
	if parental1 == "false":
		Parental1 = $Elter1.text
	else:
		Parental1 = parental1
	if parental2 == "false":
		Parental2 = $Elter2.text
	else:
		Parental2 = parental2
	
	ap_pos1 = Utills.el(Utills.remove_char("'", Parental1),  1, "end")
	Parental1 = str(Utills.remove_char("'", Parental1)[0])
	ap_pos2 = Utills.el(Utills.remove_char("'", Parental2), 1, "end")
	Parental2 = str(Utills.remove_char("'", Parental2)[0])
	
	procent(0.1)
	
	if multigen == true:
		$Kreuzungsschema.hide()
	
	if len(Parental1) != len(Parental2):
		$Error_Label.text = "Error!\nUngleiche Genmänge!"
		$Kreuzungsschema.hide()
		$Mendel.show()
		return
	
	if Utills.ungerade_menge(Parental1):
		$Error_Label.text = "Error!\nUngerade Allelmenge!"
		$Kreuzungsschema.hide()
		$Mendel.show()
		return
	
	elements = pow((pow(2, len(Parental1) / 2) + 1), 2)
	
	$Kreuzungsschema.max_columns = int(sqrt(elements))
	if $Kreuzungsschema.max_columns > 6 and multigen == false:
		$Error_Label.text = "Zu viele Allele um dargestellt zu werden!\nSuchen sie die automatisch erstellte Textdatei\nmit dem Kreuzungsschema auf."
		$Kreuzungsschema.hide()
		$Genotypen.hide()
		$Phaenotypen.hide()
	
	Garmets1 = get_garmets(Parental1, ap_pos1)
	Garmets2 = get_garmets(Parental2, ap_pos2)
	
	table.append([])
	table[0].append("")
	
	procent(0.1)
	
	for i in range(len(Garmets1)):
		table[0].append(Garmets1[i])
	procent(0.1)
	for i in range(len(Garmets2)):
		table.append([])
		table[i + 1].append(Garmets2[i])
	procent(0.1)
	var count = 0
	var table1 = []
	var factor
	if len(Garmets2) < 200:
		factor = 6
	elif len(Garmets2) < 300:
		factor = 3
	elif len(Garmets2) < 600:
		factor = 2
	else:
		factor = 1
	for i in range(len(Garmets2)):
		for x in range(len(Garmets1)):
			table1.append(add_garmets(Garmets1[x], Garmets2[i]))
		table[i + 1] += table1
		table1 = []
		if (i * 600 / factor) / len(Garmets2) == count:
			procent(0.1 * factor)
			count += 1
	
	procent = 60.4
	procent(0.1)
	count = 0
	var write_table1 = ""
	for i in range(len(Garmets2) + 1):
		for x in range(len(Garmets1)+1):
			write_table1 += table[i][x] + ";"
		write_table += write_table1
		write_table1 = ""
		write_table += "\n"
		if (i*130)/len(Garmets2) >= count:
			procent(0.1)
			count += 1 
	
	procent = 73.6
	procent(0.1)
	for i in range(len(Garmets2) + 1):
		for x in range(len(Garmets1)+1):
			$Kreuzungsschema.add_item(table[i][x])
	
	procent(0.1)
	var data = 0
	if Utills.file_exists_eas("FileCount.txt"):
		data = int(Utills.read_file("FileCount.txt"))
		Utills.write_file(data + 1, "FileCount.txt")
	else:
		Utills.write_file(1, "FileCount.txt")
	procent(0.1)
	if multigen == false:
		Utills.write_file(write_table, "Kreuzungsschema" + str(data) + ".csv", "public")
	$Mendel.show()
	#---------------------------------------------------
	if not $Genotypen_.pressed and multigen == false:
		OS.shell_open(direct)
		return
	#---------------------------------------------------
	for i in range(len(table)):
		for x in range(len(table[i])):
			if table[i][x] in genotyp:
				genotyp[table[i][x]] += 0.0001
			else:
				genotyp[table[i][x]] = 0.0001
	procent(0.1)
	
	count = 0
	var count1 = 0
	var genotyp1_ = []
	var count2 = 0
	var count3 = 0
	var genotyp2 = {}
	
	
	for i in genotyp:
		count1 += 1
		count2 += 1
		if not(len(Utills.remove_char("'", i)[0]) < len(Utills.remove_char("'", table[1][1])[0])):
			genotyp1_ += [str(float(genotyp[i])) + "," + i]
			if multigen == true:
				genotyp2[i] = genotyp[i]
		if count2 == int(sqrt(len(genotyp))) or count1 == len(genotyp):
			genotyp_ += genotyp1_
			genotyp1_ = []
			count2 = 0
		
		if (count1*40)/len(genotyp) >= count:
			procent(0.1)
			count += 1
	
	procent(0.1)
	
	#---------------------------------------------------
	if multigen == true:
		return genotyp2
	#---------------------------------------------------
	
	genotyp_.sort()
	
	genotyp = "Genotypen:\n"
	var Genotypentext = ""
	var Genotypentext1 = "Genotypen:\n"
	var genotyp1 = ""
	count = 0
	count1 = 0
	
	for i in genotyp_:
		count1 += 1
		count2 += 1
		Genotypentext1 += "\n" + str(round(float(str(i).split(",")[0]) * 10000)) + " x " + str(i).split(",")[1]
		genotyp1 += "\n" + str(round(float(str(i).split(",")[0]) * 10000)) + ";" + str(i).split(",")[1]
		if count2 == int(sqrt(len(genotyp_))) or count1 == len(genotyp_):
			Genotypentext += Genotypentext1
			genotyp += genotyp1
			Genotypentext1 = ""
			genotyp1 = ""
			count2 = 0
		
		if (count1*40)/len(genotyp_) >= count:
			procent(0.1)
			count += 1
	$Genotypen.text = Genotypentext
	
	procent(0.1)
	Utills.write_file(Utills.read_file("Kreuzungsschema" + str(data) + ".csv", "public")+ "\n" + genotyp, "Kreuzungsschema" + str(data) + ".csv", "public")
	procent(0.1)
	phaenotyp = phaenotyp(genotyp_)
	procent(0.1)
	$Phaenotypen.text = "Phaenotypen:\n"
	var phaenotyp_ = "Phaenotypen:\n"
	for i in phaenotyp:
		$Phaenotypen.text = $Phaenotypen.text + "\n" + str(round(10000 * float(str(i).split(",")[0]))) + " x " + str(i).split(",")[1]
		phaenotyp_ = phaenotyp_ + "\n" + str(round(10000 * float(str(i).split(",")[0]))) + ";" + str(i).split(",")[1]
	procent(0.1)
	Utills.write_file(Utills.read_file("Kreuzungsschema" + str(data) + ".csv", "public")+ "\n" + Utills.x_char("\n", 4) + phaenotyp_, "Kreuzungsschema" + str(data) + ".csv", "public")
	print("Es wurden " + str(elements) + " Elemente generiert")
	print("Gespeichert in: " + direct)
	OS.shell_open(direct)
	print("done!")
	print(Utills.x_char("-", 10))

func _on_MultiGen_pressed():
	
	var Parental1 = $Elter1.text
	var Parental2 = $Elter2.text
	var genotyp = {}
	var genotyp1 = {}
	var genotyp2 = {}
	var count1 = 0
	var count2 = 0
	var summ = 0.0
	var f
	var genotypen = {}
	var genotypen_ = []
	
	print(Utills.x_char("-", 10))
	print("starting...")
	genotyp = _on_Mendel_pressed(Parental1, Parental2, true)
	for i in genotyp:
		f = genotyp[i]
		genotyp2[i] = f
	
	for x in genotyp:
		for y in genotyp:
			genotyp1 = _on_Mendel_pressed(x, y, true)
			genotypen[str(x) + str(y)] = genotyp1
			genotypen_ += [str(x) + str(y)]
	
	
	print("Generation:")
	for i in range(int($Generationen.text)):
		for x in genotyp:
			for y in genotyp:
				if not str(x) + str(y) in genotypen_:
					genotyp1 = _on_Mendel_pressed(x, y, true)
					genotypen[str(x) + str(y)] = genotyp1
					genotypen_ += [str(x) + str(y)]
				if count2 >= count1:
					if x == y:
						if i > 2:
							for z in genotypen[str(x) + str(y)]:
								genotypen[str(x) + str(y)][z] *= (genotyp[x] * 10000) 
						else:
							for z in genotypen[str(x) + str(y)]:
								genotypen[str(x) + str(y)][z] *= ((genotyp[x] * 10000) - 1) 
					else:
						for z in genotypen[str(x) + str(y)]:
							genotypen[str(x) + str(y)][z] *= (genotyp[x] *10000 * genotyp[y] * 10000)
					for z in genotypen[str(x) + str(y)]:
						if z in genotyp2:
							genotyp2[z] += genotypen[str(x) + str(y)][z]
						else:
							genotyp2[z] = genotypen[str(x) + str(y)][z]
				count2 += 1
			count1 += 1
			count2 = 0
		count1 = 0
		for j in genotyp2:
			f = genotyp2[j]
			genotyp[j] = f
		if i > 2:
			summ = 0
			for j in genotyp:
				summ += genotyp[j]
			summ = ceil(log(summ) / log(10))
			for j in genotyp:
				genotyp[j] /= pow(10, summ - 2)
		print(genotyp)
		print(Utills.x_char(" ", 10) + str(i + 1) + " / " + $Generationen.text)
	summ = 0
	for i in genotyp:
		summ += genotyp[i]
	for i in genotyp:
		genotyp[i] /= summ / 100
	print(genotyp)
	
	print("done!")
	print(Utills.x_char("-", 10))
#---------------------------------------------------

func _on_Clear_pressed():
	$Elter1.clear()
	$Elter2.clear()
	$Genotypen.text = "Genotypen:"
	$Phaenotypen.text = "Phänotypen:"
	$Kreuzungsschema.clear()

func _on_Button_pressed():
	emit_signal("settings")

func _on_Multigen_pressed():
	if $Multigen.pressed:
		$Mendel.hide()
		$MultiGen.show()
		$Generationen.show()
	else:
		$Mendel.show()
		$MultiGen.hide()
		$Generationen.hide()
