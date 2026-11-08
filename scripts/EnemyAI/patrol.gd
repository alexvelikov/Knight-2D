extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor._patrol()
	return SUCCESS
