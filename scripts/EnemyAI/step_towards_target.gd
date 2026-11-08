extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor._step_towards_target()
	return SUCCESS
