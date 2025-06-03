extends Node

var is_ready = false
var listeners : Array[Node] = []


func register_listener(node : Node) -> void:
	if is_ready:
		node._on_system_ready()
	else:
		listeners.append(node)


func mark_ready():
	is_ready = true
	for node in listeners:
		node._on_system_ready()
	listeners.clear()
