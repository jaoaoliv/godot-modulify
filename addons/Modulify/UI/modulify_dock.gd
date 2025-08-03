@tool
extends Control

var plugin : EditorPlugin

# --- ABA 1 ---
@onready var lineedit_nome = $"TabContainer/Criar Personagem/LineEdit"
@onready var option_tipo = $"TabContainer/Criar Personagem/OptionButton"
@onready var btn_criar = $"TabContainer/Criar Personagem/Button"
@onready var lbl_erro: Label = $"TabContainer/Criar Personagem/lbl_erro"

# --- ABA 2 ---
@onready var lbl_cena_aberta: Label = $"TabContainer/States e Modules/LabelCenaAberta"
@onready var label_info: Label = $"TabContainer/States e Modules/LabelInfo"
@onready var lbl_erro_aba2: Label = $"TabContainer/States e Modules/LabelErro"
@onready var lineedit_state: LineEdit = $"TabContainer/States e Modules/LineEditState"
@onready var btn_criar_state: Button = $"TabContainer/States e Modules/ButtonCriarState"
@onready var lineedit_module: LineEdit = $"TabContainer/States e Modules/LineEditModule"
@onready var btn_criar_module: Button = $"TabContainer/States e Modules/ButtonCriarModule"

func _ready():
	# ABA 1
	option_tipo.clear()
	option_tipo.add_item("Sidescroller")
	option_tipo.add_item("Top-down")
	btn_criar.pressed.connect(_on_criar_personagem)
	# ABA 2
	btn_criar_state.pressed.connect(_on_criar_state)
	btn_criar_module.pressed.connect(_on_criar_module)
	# Atualiza status inicial da cena aberta
	_atualizar_status_cena_aberta()

func _process(delta):
	_atualizar_status_cena_aberta()

# ---------------- ABA 1 -----------------
func _on_criar_personagem():
	lbl_erro.text = ""
	var nome : String = lineedit_nome.text.strip_edges()
	var tipo : int = option_tipo.selected

	# Validação completa do nome antes de prosseguir
	var erro : String = _validar_nome_personagem(nome)
	if erro != "":
		lbl_erro.text = erro
		return

	if not plugin:
		lbl_erro.text = "Plugin não está carregado!"
		return

	var resultado : String = plugin.criar_personagem(nome, tipo)
	if resultado == "":
		lbl_erro.text = "Personagem criado com sucesso!\nCaso a pasta não apareça no FileSystem minimize e maximize o editor para atualizar ;)"
		lineedit_nome.text = ""
	else:
		lbl_erro.text = resultado

func _validar_nome_personagem(nome: String) -> String:
	if nome == "":
		return "Digite o nome do personagem."
	if not nome.is_valid_identifier():
		return "Nome só pode conter letras, números e underline (_), sem espaços, acentos e não pode começar com número."
	var reservados := [
		"Node", "Node2D", "Control", "Sprite", "Scene", "Script", "Object",
		"CharacterBody2D", "Timer", "Label", "Camera2D", "Viewport", "Input", "Resource", "Signal"
	]
	if nome in reservados:
		return "Esse nome é reservado pela Godot. Escolha outro nome."
	if nome.is_valid_int():
		return "Nome não pode ser apenas números."
	if nome.length() < 3:
		return "Nome muito curto. Use pelo menos 3 caracteres."
	return ""  # Sem erros

# ---------------- ABA 2 -----------------

func _atualizar_status_cena_aberta():
	var scene = plugin.get_open_scene_root()
	if scene:
		lbl_cena_aberta.text = "Editando cena: %s" % scene.name
		var ok = scene.has_node("States") and scene.has_node("Modules")
		if ok:
			btn_criar_state.disabled = false
			btn_criar_module.disabled = false
			lbl_erro_aba2.text = ""
		else:
			btn_criar_state.disabled = true
			btn_criar_module.disabled = true
			lbl_erro_aba2.text = "A cena aberta não está estruturada! (Faltam States ou Modules)"
	else:
		lbl_cena_aberta.text = "Nenhuma cena de personagem aberta."
		btn_criar_state.disabled = true
		btn_criar_module.disabled = true
		lbl_erro_aba2.text = ""

func _on_criar_state():
	lbl_erro_aba2.text = ""
	var state_name = lineedit_state.text.strip_edges()
	if state_name == "":
		lbl_erro_aba2.text = "Digite o nome do State."
		return
	var erro = plugin.criar_state_na_cena_aberta(state_name)
	if erro == "":
		lbl_erro_aba2.text = "State criado com sucesso!"
		lineedit_state.text = ""
	else:
		lbl_erro_aba2.text = erro

func _on_criar_module():
	lbl_erro_aba2.text = ""
	var module_name = lineedit_module.text.strip_edges()
	if module_name == "":
		lbl_erro_aba2.text = "Digite o nome do Module."
		return
	var erro = plugin.criar_module_na_cena_aberta(module_name)
	if erro == "":
		lbl_erro_aba2.text = "Module criado com sucesso!"
		lineedit_module.text = ""
	else:
		lbl_erro_aba2.text = erro
