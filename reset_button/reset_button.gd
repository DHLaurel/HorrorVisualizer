class_name ResetButton extends Interactable

func interact():
	get_tree().call_group("Node", "reset")
