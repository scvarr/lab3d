class_name КонструкцияКлетки
extends RefCounted

var модули: Array[Dictionary] = []
var профиль: ПрофильФункций = ПрофильФункций.new()

var органика_модулей: float = 0.0
var органика_тела: float = 0.0
var структурная_органика: float = 0.0


func получить_количество_функций() -> int:
	return модули.size()


func получить_теплоемкость() -> float:
	return структурная_органика
