extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	var target = actor.target_in_range
	if target == null:
		return FAILURE
	else:
		return SUCCESS
