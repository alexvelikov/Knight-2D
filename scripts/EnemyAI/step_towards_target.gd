extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor.step_towards_target()
	return SUCCESS
