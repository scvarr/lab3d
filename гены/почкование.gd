extends RefCounted

const КодыГенов = preload("res://геном/коды_генов.gd")


static func прочитать(части: PackedStringArray) -> Dictionary:
	if части.size() != 5:
		return {
			"ошибка": "Ген почкования должен иметь формат: 07,органика,пропорция_x,пропорция_y,пропорция_z;"
		}

	var текст_органики: String = части[1].strip_edges()
	var текст_x: String = части[2].strip_edges()
	var текст_y: String = части[3].strip_edges()
	var текст_z: String = части[4].strip_edges()

	if not текст_органики.is_valid_float():
		return {
			"ошибка": "Органика модуля почкования должна быть числом."
		}

	if not текст_x.is_valid_float() or not текст_y.is_valid_float() or not текст_z.is_valid_float():
		return {
			"ошибка": "Пропорции модуля почкования должны быть числами."
		}

	var органика: float = текст_органики.to_float()
	var пропорции := Vector3(
		текст_x.to_float(),
		текст_y.to_float(),
		текст_z.to_float()
	)

	if органика <= 0.0:
		return {
			"ошибка": "Органика модуля почкования должна быть больше нуля."
		}

	if пропорции.x <= 0.0 or пропорции.y <= 0.0 or пропорции.z <= 0.0:
		return {
			"ошибка": "Пропорции модуля почкования должны быть больше нуля."
		}

	return {
		"тип": КодыГенов.ПОЧКОВАНИЕ,
		"органика": органика,
		"пропорции": пропорции
	}
