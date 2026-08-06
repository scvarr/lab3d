extends Node3D

const ФабрикаКлеток = preload("res://клетка/фабрика_клеток.gd")

@onready var кнопка_добавить_клетку: Button = $Интерфейс/ДобавитьКлетку
@onready var поле_генома: LineEdit = $Интерфейс/ГеномHex

var следующая_позиция: Vector3 = Vector3(4.0, 0.0, 0.0)


func _ready() -> void:
	кнопка_добавить_клетку.pressed.connect(добавить_клетку)


func добавить_клетку() -> void:
	var геном_hex: String = поле_генома.text.strip_edges()

	if геном_hex.is_empty():
		push_error("HEX-строка генома не должна быть пустой.")
		return

	var результат: Dictionary = ФабрикаКлеток.создать_из_hex(геном_hex)

	if результат.has("ошибка"):
		push_error(результат["ошибка"])
		return

	var клетка: Клетка = результат["клетка"]
	клетка.position = следующая_позиция
	add_child(клетка)

	следующая_позиция.x += 4.0
