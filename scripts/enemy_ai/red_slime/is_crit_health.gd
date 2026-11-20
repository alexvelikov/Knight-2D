extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if actor.below_crit_health():
		print("crit health")
		return SUCCESS
	return FAILURE
