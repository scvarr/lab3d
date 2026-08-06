extends RefCounted


static func hex_в_байты(hex: String) -> Dictionary:
	var строка: String = hex.strip_edges().to_upper()

	if строка.is_empty():
		return {
			"байты": PackedByteArray()
		}

	if строка.length() % 2 != 0:
		return {
			"ошибка": "HEX-строка должна содержать чётное количество символов."
		}

	if not строка.is_valid_hex_number():
		return {
			"ошибка": "HEX-строка содержит недопустимые символы."
		}

	var количество_байтов: int = строка.length() / 2
	var байты := PackedByteArray()
	байты.resize(количество_байтов)

	for номер: int in range(количество_байтов):
		байты[номер] = строка.substr(номер * 2, 2).hex_to_int()

	return {
		"байты": байты
	}


static func байты_в_hex(байты: PackedByteArray) -> String:
	var части := PackedStringArray()
	части.resize(байты.size())

	for номер: int in range(байты.size()):
		части[номер] = "%02X" % байты[номер]

	return "".join(части)
