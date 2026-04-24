extends Node


func _enter_tree() -> void:
	print(Hangul.transform("구글", "으로부터"))
	print(Hangul.transform("437", "는"))
	print(Hangul.split_phonemes("가양"))
	print(Hangul.modify_sentence("{가영, 는} {철수, 을} 먹었다."))
	print(Hangul.join_phonemes(["ㅇ", "ㅏ", "ㄴ"]))
