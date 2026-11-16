extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor.flee_from_target()
	print("Fleeing")
	return SUCCESS
