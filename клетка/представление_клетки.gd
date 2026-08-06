class_name ПредставлениеКлетки
extends Node3D

@onready var оболочка: MeshInstance3D = $Оболочка
@onready var диагностика: Node3D = $Диагностика

static var сфера_модуля: SphereMesh
static var сфера_точки_сцепки: SphereMesh
static var материал_клетки: StandardMaterial3D
static var материал_прозрачной_клетки: StandardMaterial3D
static var материал_гибели: StandardMaterial3D
static var материал_точки_сцепки: StandardMaterial3D
static var материалы_модулей: Dictionary = {}

var морфология: МорфологияКлетки


func построить(
	новая_морфология: МорфологияКлетки,
	показывать_внутренние_модули: bool,
	показывать_точки_сцепки: bool
) -> bool:
	if новая_морфология == null or новая_морфология.меш == null:
		push_error("Невозможно построить представление без морфологии клетки.")
		return false

	подготовить_общие_ресурсы()
	очистить()
	морфология = новая_морфология

	оболочка.mesh = морфология.меш
	scale = Vector3.ONE * морфология.визуальный_масштаб

	if показывать_внутренние_модули:
		оболочка.material_override = материал_прозрачной_клетки
		диагностика.add_child(создать_визуализацию_модулей())
	else:
		оболочка.material_override = материал_клетки

	if показывать_точки_сцепки:
		диагностика.add_child(создать_визуализацию_точек_сцепки())

	return true


func показать_гибель() -> void:
	подготовить_общие_ресурсы()
	оболочка.material_override = материал_гибели


func получить_локальные_точки_сцепки() -> PackedVector3Array:
	if морфология == null:
		return PackedVector3Array()

	return морфология.точки_сцепки


func получить_мировые_точки_сцепки() -> PackedVector3Array:
	var мировые_точки := PackedVector3Array()

	for точка: Vector3 in получить_локальные_точки_сцепки():
		мировые_точки.append(to_global(точка))

	return мировые_точки


func очистить() -> void:
	морфология = null
	оболочка.mesh = null
	оболочка.material_override = null

	for ребенок: Node in диагностика.get_children():
		диагностика.remove_child(ребенок)
		ребенок.queue_free()


func создать_визуализацию_модулей() -> Node3D:
	var контейнер := Node3D.new()
	контейнер.name = "ВнутренниеМодули"

	for номер: int in range(морфология.типы_модулей.size()):
		var визуальный_модуль := MeshInstance3D.new()
		визуальный_модуль.name = "Модуль_%02d" % номер
		визуальный_модуль.mesh = сфера_модуля
		визуальный_модуль.material_override = получить_материал_модуля(
			морфология.типы_модулей[номер],
			морфология.цвета_модулей[номер]
		)
		визуальный_модуль.position = морфология.центры_модулей[номер]
		визуальный_модуль.basis = морфология.ориентации_модулей[номер]
		визуальный_модуль.scale = морфология.размеры_модулей[номер]
		контейнер.add_child(визуальный_модуль)

	return контейнер


func создать_визуализацию_точек_сцепки() -> Node3D:
	var контейнер := Node3D.new()
	контейнер.name = "ТочкиСцепки"

	for номер: int in range(морфология.точки_сцепки.size()):
		var маркер := MeshInstance3D.new()
		маркер.name = "ТочкаСцепки_%02d" % номер
		маркер.mesh = сфера_точки_сцепки
		маркер.material_override = материал_точки_сцепки
		маркер.position = морфология.точки_сцепки[номер]
		контейнер.add_child(маркер)

	return контейнер


static func подготовить_общие_ресурсы() -> void:
	if сфера_модуля != null:
		return

	сфера_модуля = SphereMesh.new()
	сфера_модуля.radius = 1.0
	сфера_модуля.height = 2.0
	сфера_модуля.radial_segments = 24
	сфера_модуля.rings = 12

	сфера_точки_сцепки = SphereMesh.new()
	сфера_точки_сцепки.radius = 0.12
	сфера_точки_сцепки.height = 0.24
	сфера_точки_сцепки.radial_segments = 16
	сфера_точки_сцепки.rings = 8

	материал_клетки = StandardMaterial3D.new()
	материал_клетки.vertex_color_use_as_albedo = true
	материал_клетки.roughness = 0.7

	материал_прозрачной_клетки = StandardMaterial3D.new()
	материал_прозрачной_клетки.vertex_color_use_as_albedo = true
	материал_прозрачной_клетки.roughness = 0.7
	материал_прозрачной_клетки.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	материал_прозрачной_клетки.albedo_color.a = 0.22
	материал_прозрачной_клетки.cull_mode = BaseMaterial3D.CULL_DISABLED

	материал_гибели = StandardMaterial3D.new()
	материал_гибели.albedo_color = Color(0.03, 0.03, 0.03)
	материал_гибели.roughness = 0.7

	материал_точки_сцепки = StandardMaterial3D.new()
	материал_точки_сцепки.albedo_color = Color(1.0, 0.9, 0.1)
	материал_точки_сцепки.roughness = 0.35


static func получить_материал_модуля(тип: int, исходный_цвет: Color) -> StandardMaterial3D:
	if материалы_модулей.has(тип):
		return материалы_модулей[тип]

	var цвет: Color = исходный_цвет
	цвет.a = 0.55

	var материал := StandardMaterial3D.new()
	материал.albedo_color = цвет
	материал.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	материал.roughness = 0.45
	материалы_модулей[тип] = материал
	return материал
