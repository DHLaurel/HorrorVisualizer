class_name HUD extends Control

@onready var interaction_label:Label = $InteractionLabel


func _ready():
	interaction_label.hide()


func show_interaction_hint(hint_text:String):
	interaction_label.text = hint_text
	interaction_label.show()


func hide_interaction_hint():
	interaction_label.hide()
