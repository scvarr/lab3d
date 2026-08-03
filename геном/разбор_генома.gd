extends RefCounted

const КодыМодулей = preload("res://геном/коды_модулей.gd")
const ГенПоглощения = preload("res://модули/ген_поглощения.gd")
const ГенНакопления = preload("res://модули/ген_накопления.gd")

static func прочитать(геном: String) -> Dictionary:
	var модули: Array[Dictionary] = []

	for текст_гена in геном.split(";"):
		var ген: String = текст_гена.strip_edges()

		if ген.is_empty():
			continue

		var части: PackedStringArray = ген.split(",")
		var код: String = части[0].strip_edges().to_upper()

		if код.length() != 2 or not код.is_valid_hex_number():
			return {
				"ошибка": "Некорректный код модуля: '%s'" % код
			}

		var код_модуля: int = код.hex_to_int()
		var результат: Dictionary = {}

		match код_модуля:
			КодыМодулей.ПОГЛОЩЕНИЕ:
				результат = ГенПоглощения.прочитать(части)
			КодыМодулей.НАКОПЛЕНИЕ:
				результат = ГенНакопления.прочитать(части)
			_:
				return {
					"ошибка": "Среда не умеет развивать модуль с кодом %s." % код
				}
			
		if результат.has("ошибка"):
			return результат

		модули.append(результат)

	if модули.is_empty():
		return {
			"ошибка": "Геном не содержит распознанных генов."
		}

	return {
		"модули": модули
	}
