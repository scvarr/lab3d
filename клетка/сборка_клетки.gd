class_name СборкаКлетки
extends RefCounted

var геном_hex: String = ""
var полный_геном: PackedByteArray = PackedByteArray()
var доступные_участки: Array[Dictionary] = []
var конструкция: КонструкцияКлетки
