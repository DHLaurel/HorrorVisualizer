class_name JournalEntry extends Interactable

@export var highlighted_games:Array[String]
@export var text:String
@export var journal_text:String


func interact():
	get_tree().call_group("Node", "try_highlight", highlighted_games)


func _on_area_3d_body_entered(body: Node3D) -> void:
	Interactor.text = text
	Interactor.interactable = self
