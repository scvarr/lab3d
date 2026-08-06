class_name ВыраженнаяФункция
extends RefCounted

var тип: int = 0
var органика: float = 0.0
var пропорции: Vector3 = Vector3.ONE
var параметры: Dictionary = {}
var участки_генома: Array[Vector2i] = []


func получить_параметр(имя: StringName, значение_по_умолчанию: Variant = null) -> Variant:
	return параметры.get(имя, значение_по_умолчанию)


func установить_параметр(имя: StringName, значение: Variant) -> void:
	параметры[имя] = значение


func содержит_параметр(имя: StringName) -> bool:
	return параметры.has(имя)


func получить_значение_поля(имя: StringName) -> Variant:
	match имя:
		&"органика":
			return органика

		&"пропорции":
			return пропорции

		_:
			return параметры.get(имя)


func содержит_поле(имя: StringName) -> bool:
	return имя == &"органика" or имя == &"пропорции" or параметры.has(имя)


func дублировать() -> ВыраженнаяФункция:
	var копия := ВыраженнаяФункция.new()
	копия.тип = тип
	копия.органика = органика
	копия.пропорции = пропорции
	копия.параметры = параметры.duplicate(true)

	for участок: Vector2i in участки_генома:
		копия.участки_генома.append(участок)

	return копия
