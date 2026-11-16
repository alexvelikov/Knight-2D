extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor.patrol()
	return SUCCESS
