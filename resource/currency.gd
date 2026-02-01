extends Resource
class_name Currency

# 프랑스 화폐
# 1 리브르 == 20 솔(수우) == 240 데니어
# 1 페니가 약 3000원 4000원 정도인 걸로 추정


enum Unit
{
	LIVRE,
	SOL,
	DENIER,
}


@export var livre: int = 0:
	set(value):
		livre = value
@export var sol: int = 0:
	set(value):
		sol = value
@export var denier: int = 0:
	set(value):
		denier = value


func get_total_denier() -> int:
	return (livre * 240) + (sol * 12) + denier
