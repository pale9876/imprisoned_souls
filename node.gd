extends Node


func _enter_tree() -> void:
	#print(Hangul.transform("구글", "으로부터"))
	#print(Hangul.transform("437", "는"))
	#print(Hangul.split_phonemes("가양"))
	#print(Hangul.modify_sentence("{가영, 는} {철수, 을} 먹었다."))
	#print(Hangul.join_phonemes(["ㅇ", "ㅏ", "ㄴ"]))
	lets_animate()


func lets_animate() -> void:
	var sentence: String = "고양이"
	var splited: PackedStringArray = sentence.split("")
	var result: String = ""
	for i: int in range(splited.size()):
		var chr: String = splited[i]
		var phonemes: Array[String] = Hangul.split_phonemes(chr)
		var step: Array[String]
		step.resize(3)
		for j: int in range(phonemes.size()):
			step[j] = phonemes[j]
			if j == (phonemes.size() - 1):
				result += Hangul.join_phonemes(step)
				print(result)
				for k: int in range(step.size()):
					step[i] = ""
			else:
				print(result + Hangul.join_phonemes(step))


class HangulTypingMachine extends RefCounted:
	var sentence: String
	var splited: String
	var result: String
	var index: int
	
	
	
	
	func clear() -> void:
		sentence = ""
		splited = ""
		result = ""
	
	
