extends Control

@onready var shop_item_sprite = $ShopItemSprite
@onready var name_label = $NameLabel
@onready var description_label = $DescriptionLabel
@onready var cost_label = $CostLabel

var itemSpriteDict = {"Small Pot": 0, "Medium Pot": 1, "Bonsai Pot": 2, "Mystery Seed Lv.1": 3}
var defaultSize = 32


func _ready():
	SignalBus.shopDescription.connect(setPanelInfo)
	SignalBus.hideShopDesciption.connect(hidePanel)

func setPanelInfo(name:String, description: String, cost: int):
	modulate.a = 1
	name_label.text = name
	resizeName()
	description_label.text = description
	cost_label.text = str(cost)
	shop_item_sprite.frame = itemSpriteDict[name]

func hidePanel():
	modulate.a = 0

func resizeName():
	name_label.set("theme_override_font_sizes/normal_font_size",defaultSize)
	while name_label.get_content_width() > name_label.size.x:
		name_label.set("theme_override_font_sizes/normal_font_size",name_label.get("theme_override_font_sizes/normal_font_size") -1)
