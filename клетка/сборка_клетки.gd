class_name СборкаКлетки
extends RefCounted

var геном_hex: String = ""
var полный_геном: PackedByteArray = PackedByteArray()
var доступные_участки: Array[Vector2i] = []
var конструкция: КонструкцияКлетки
var морфология: МорфологияКлетки
