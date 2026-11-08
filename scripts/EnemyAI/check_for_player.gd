extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	var player = actor.target_in_range
	if player == null:
		return FAILURE
	else:
		return SUCCESS
