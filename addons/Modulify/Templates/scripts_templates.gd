static func get_fsm_template() -> String:
	return '''
extends Node

# -------------------------------------------------------
# FSM (Finite State Machine) - Máquina de Estados do Personagem
# -------------------------------------------------------
# Este script deve ser anexado ao node "States" do personagem.
# Ele controla qual "state" está ativo e faz a transição automática entre eles.
#
# Os scripts de estado (ex: IdleState, WalkState) devem ser filhos do node "States".
# Exemplo de estrutura recomendada na cena:
#
# CharacterBody2D (root)       <- modules_brain.gd anexado aqui
# ├── States (Node)            <- fsm.gd anexado aqui
# │   ├── IdleState
# │   └── WalkState
# └── Modules (Node)
#     ├── MoveModule
#     └── DashModule
# -------------------------------------------------------

# Estado atual (node de state), pode ser qualquer script que implemente enter/exit/update
var current_state = null

func _ready():
	# Procura todos os filhos do node "States" que tenham métodos enter/exit/update
	for child in get_children():
		if child.has_method("enter") and child.has_method("exit") and child.has_method("update"):
			child.fsm = self
	# Define o estado inicial automaticamente, se existir um node chamado "IdleState"
	if has_node("IdleState"):
		change_state(get_node("IdleState"))

# Troca o estado atual para um novo (qualquer node com enter/exit/update)
func change_state(new_state):
	if current_state:
		current_state.exit()
	current_state = new_state
	if current_state:
		current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)

# DICA: Para criar novos estados, crie um script herdando do template BaseState (fornecido pelo plugin)
# e adicione como filho do node "States" na cena!
'''

static func get_modules_brain_template() -> String:
	return '''
extends Node

# -------------------------------------------------------
# Modules Brain - Gerenciador de Módulos do Personagem
# -------------------------------------------------------
# Este script deve ser anexado ao node root do personagem (ex: CharacterBody2D).
# Ele gerencia todos os módulos (Move, Dash, etc) que estão como filhos do node "Modules".
#
# Exemplo de estrutura recomendada na cena:
# CharacterBody2D (root)       <- modules_brain.gd anexado aqui
# ├── States (Node)            <- fsm.gd anexado aqui
# │   ├── IdleState
# │   └── WalkState
# └── Modules (Node)
#     ├── MoveModule
#     └── DashModule
# -------------------------------------------------------

# Dicionário para acessar rapidamente os módulos pelo nome
var modules: Dictionary = {}

@onready var modules_node = $Modules

func _ready():
	# Procura todos os módulos filhos do node "Modules" e adiciona ao dicionário
	for child in modules_node.get_children():
		modules[child.name] = child

# Ativa um módulo pelo nome (se o módulo implementar set_active)
func activate_module(module_name: String) -> void:
	if modules.has(module_name) and modules[module_name].has_method("set_active"):
		modules[module_name].set_active(true)

# Desativa um módulo pelo nome (se o módulo implementar set_active)
func deactivate_module(module_name: String) -> void:
	if modules.has(module_name) and modules[module_name].has_method("set_active"):
		modules[module_name].set_active(false)

# DICA: Para criar novos módulos, crie scripts herdando Node ou Node2D,
# e adicione como filhos do node "Modules"!
'''

static func get_base_state_template() -> String:
	return '''
extends Node

# -------------------------------------------------------
# BaseState - Classe base para todos os "states" (estados) da FSM
# -------------------------------------------------------
# Todos os estados devem herdar deste script!
# O FSM chamará automaticamente enter(), exit() e update().
# -------------------------------------------------------

# Referência ao controlador FSM, preenchida automaticamente pelo FSM.
var fsm: Node = null

# Chamado ao entrar no estado (transição)
func enter():
	pass

# Chamado ao sair do estado (transição)
func exit():
	pass

# Chamado todo frame enquanto o estado estiver ativo
func update(delta):
	pass

# Exemplo:
# func enter():
#     print("Entrou no estado Idle")
#
# func update(delta):
#     if Input.is_action_just_pressed("ui_right"):
#         fsm.change_state(fsm.get_node("WalkState"))
#
# func exit():
#     print("Saiu do estado Idle")
'''


static func get_state_template(state_name: String) -> String:
	return '''
extends Node

# -------------------------------------------------------
# State: %s
# Este é um estado padrão da FSM do personagem.
# 
# O FSM irá chamar automaticamente:
#   - enter() quando este estado for ativado
#   - exit() ao sair deste estado
#   - update(delta) a cada frame enquanto ativo
#
# A referência ao FSM fica disponível na variável "fsm"
# (setada automaticamente pelo FSM)
# -------------------------------------------------------

var fsm = null # Referência ao FSM

func enter():
	# Este método é chamado quando o personagem entra neste estado.
	# Adicione aqui inicializações específicas deste estado.
	pass

func exit():
	# Este método é chamado ao sair deste estado.
	# Coloque aqui ações de limpeza ou reset necessárias.
	pass

func update(delta):
	# Chamado a cada frame enquanto este estado está ativo.
	# Use para lógica contínua (ex: checar inputs, condições de transição)
	pass

# Exemplo de uso:
# func update(delta):
#     if Input.is_action_just_pressed("ui_right"):
#         fsm.change_state(fsm.get_node("OutroState"))
''' % state_name

static func get_module_template(module_name: String) -> String:
	return '''
extends Node

# -------------------------------------------------------
# Module: %s
# Este é um módulo padrão para personagem.
#
# Os módulos podem ser ativados/desativados pelo brain com set_active().
# Override (sobrescreva) métodos para implementar a mecânica desejada.
# -------------------------------------------------------

var active := true # Estado atual do módulo (ativado/desativado)

func set_active(value: bool) -> void:
	active = value

func _ready():
	# Inicialize o módulo aqui, se necessário
	pass

# Adicione métodos e lógica própria para cada tipo de módulo

# Exemplo:
# func perform_action():
#     if active:
#         # Executa ação do módulo
#         pass
''' % module_name
