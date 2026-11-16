extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if actor.below_crit_health():
		return SUCCESS
	return FAILURE
