class_name МорфологияКлетки
extends RefCounted

var меш: ArrayMesh
var визуальный_масштаб: float = 1.0

var типы_модулей: PackedInt32Array = PackedInt32Array()
var цвета_модулей: PackedColorArray = PackedColorArray()
var центры_модулей: Array[Vector3] = []
var размеры_модулей: Array[Vector3] = []
var ориентации_модулей: Array[Basis] = []
var точки_сцепки: PackedVector3Array = PackedVector3Array()
