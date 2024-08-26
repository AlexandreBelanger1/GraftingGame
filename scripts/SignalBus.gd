extends Node2D

signal addGold(amount:int)
signal removeGold(amount:int)
signal saveGame()
signal loadGame()
signal newSaveGame()
signal setState(state:int)
signal setTooltip(name:String, growth:float)
signal confirmRemove(decide:bool)
signal confirmUI()
signal mouseTooltip(value:String)
