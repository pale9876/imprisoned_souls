extends Node


@onready var label: Label = $Label


func _enter_tree() -> void:
	#print(Hangul.transform("구글", "으로부터"))
	#print(Hangul.transform("437", "는"))
	#print(Hangul.split_phonemes("가양"))
	#print(Hangul.modify_sentence("{가영, 는} {철수, 을} 먹었다."))
	#print(Hangul.join_phonemes(["ㅇ", "ㅏ", "ㄴ"]))
	
	TypingMachine.create("안녕하세요")
	pass


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


class TypingMachine extends RefCounted:
	var sentence: String
	var splited: PackedStringArray
	var result: String
	var index: int = -1
	
	
	static func create(_sentence: String) -> TypingMachine:
		var machine: TypingMachine = TypingMachine.new()
		
		machine.sentence = _sentence
		machine.splited = _sentence.split("")
		machine.result = ""
		
		
		
		return machine
	
	
	
	
	
	func clear() -> void:
		sentence = ""
		splited = []
		result = ""
		index = -1
	
