@tool

extends EditorPlugin

var modulify_button : Button
var dock : Control

const ScriptTemplates = preload("res://addons/Modulify/Templates/scripts_templates.gd")

func _enter_tree():
	# Cria botão na barra do editor
	modulify_button = Button.new()
	modulify_button.icon = load("res://addons/modulify/icons/modulify_icon.svg")
	modulify_button.text = "Modulify"
	modulify_button.tooltip_text = "Abrir Modulify"
	modulify_button.pressed.connect(_on_button_pressed)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, modulify_button)

	# Dock inicial vazio (iremos popular nas próximas etapas)
	dock = preload("res://addons/modulify/UI/modulify_dock.tscn").instantiate()
	dock.plugin = self
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	dock.hide()

func _on_button_pressed():
	if dock.visible:
		dock.hide()
	else:
		dock.show()

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, modulify_button)
	modulify_button.queue_free()
	remove_control_from_docks(dock)
	dock.queue_free()


func criar_personagem(nome: String, tipo: int) -> String:
	var base_path = "res://Characters/%s/" % nome
	if DirAccess.dir_exists_absolute(base_path):
		return "A character with this name already exists!"

	DirAccess.make_dir_recursive_absolute(base_path + "States")
	DirAccess.make_dir_recursive_absolute(base_path + "Modules")

	# 1. Cria scripts base usando seus templates
	var fsm_path = "%sfsm.gd" % base_path
	var brain_path = "%smodules_brain.gd" % base_path
	var base_state_path = "%sStates/base_state.gd" % base_path

	if not FileAccess.file_exists(fsm_path):
		var fsm_file = FileAccess.open(fsm_path, FileAccess.WRITE)
		fsm_file.store_string(ScriptTemplates.get_fsm_template())
		fsm_file.close()
	if not FileAccess.file_exists(brain_path):
		var brain_file = FileAccess.open(brain_path, FileAccess.WRITE)
		brain_file.store_string(ScriptTemplates.get_modules_brain_template())
		brain_file.close()
	if not FileAccess.file_exists(base_state_path):
		var base_state_file = FileAccess.open(base_state_path, FileAccess.WRITE)
		base_state_file.store_string(ScriptTemplates.get_base_state_template())
		base_state_file.close()

	# 2. Cria a cena com os nodes já estruturados
	var root_node = CharacterBody2D.new()
	root_node.name = nome

	var states_node = Node.new()
	states_node.name = "States"
	var modules_node = Node.new()
	modules_node.name = "Modules"

	# Scripts
	if ResourceLoader.exists(fsm_path):
		var fsm_script = load(fsm_path)
		states_node.set_script(fsm_script)
	if ResourceLoader.exists(brain_path):
		var brain_script = load(brain_path)
		root_node.set_script(brain_script)

	# Monta a árvore e define owners
	root_node.add_child(states_node)
	root_node.add_child(modules_node)
	states_node.owner = root_node
	modules_node.owner = root_node

	# --- AQUI ESTAVA FALTANDO! ---
	# Empacota e salva a cena
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(root_node)
	if result != OK:
		return "Failed to create the scene! (Packing error)"

	var scene_path = "%s%s.tscn" % [base_path, nome]
	var save_result = ResourceSaver.save(packed_scene, scene_path)
	if save_result != OK:
		return "Failed to save the character scene!"

	call_deferred("atualizar_filesystem")
	return ""

func atualizar_filesystem():
	print("Forçando atualização do FileSystem do editor...")
	var fs_dock = get_editor_interface().get_resource_filesystem()
	if fs_dock:
		fs_dock.scan()
	
func get_open_scene_root():
	return get_editor_interface().get_edited_scene_root()


func criar_state_na_cena_aberta(state_name: String) -> String:
	var scene = get_open_scene_root()
	if not scene:
		return "Nenhuma cena aberta!"
	var states_node = scene.get_node("States")
	if not states_node:
		return "A cena não possui o node 'States'!"
	if states_node.has_node(state_name):
		return "Já existe um State com esse nome!"

	# Caminho para o script novo
	var char_dir = scene.name  # Assumindo que o nome da cena = nome do personagem
	var state_script_path = "res://Characters/%s/States/%s.gd" % [char_dir, state_name]

	# Se não existir, crie o script na pasta correta
	if not FileAccess.file_exists(state_script_path):
		var file = FileAccess.open(state_script_path, FileAccess.WRITE)
		file.store_string(ScriptTemplates.get_state_template(state_name))
		file.close()

	# Cria node e anexa o script
	var node = Node.new()
	node.name = state_name
	if ResourceLoader.exists(state_script_path):
		node.set_script(load(state_script_path))
	states_node.add_child(node)
	node.owner = scene
	return ""

func criar_module_na_cena_aberta(module_name: String) -> String:
	var scene = get_open_scene_root()
	if not scene:
		return "Nenhuma cena aberta!"
	var modules_node = scene.get_node("Modules")
	if not modules_node:
		return "A cena não possui o node 'Modules'!"
	if modules_node.has_node(module_name):
		return "Já existe um Module com esse nome!"

	# Caminho para o script novo
	var char_dir = scene.name  # Assumindo que o nome da cena = nome do personagem
	var module_script_path = "res://Characters/%s/Modules/%s.gd" % [char_dir, module_name]

	# Se não existir, crie o script na pasta correta
	if not FileAccess.file_exists(module_script_path):
		var file = FileAccess.open(module_script_path, FileAccess.WRITE)
		file.store_string(ScriptTemplates.get_module_template(module_name))
		file.close()

	# Cria node e anexa o script
	var node = Node.new()
	node.name = module_name
	if ResourceLoader.exists(module_script_path):
		node.set_script(load(module_script_path))
	modules_node.add_child(node)
	node.owner = scene
	return ""
