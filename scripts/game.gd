extends Node2D
@onready var player_ui = $Camera2D/PlayerUI
func _ready():
	SignalBus.addGold.connect(addCurrency)
	SignalBus.removeGold.connect(removeCurrency)

func addCurrency(value: int):
	Global.gold += value
	player_ui.updateCurrency()

func removeCurrency(value: int):
	Global.gold -= value
	player_ui.updateCurrency()


func _on_plant_generate_gold():
	addCurrency(1)
