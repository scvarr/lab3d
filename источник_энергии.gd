extends Node3D

@export var радиус: float = 5.0


func получить_энергию_в_точке(точка: Vector3) -> float:
	var расстояние := global_position.distance_to(точка)

	if расстояние >= радиус:
		return 0.0

	return 1.0 - расстояние / радиус
