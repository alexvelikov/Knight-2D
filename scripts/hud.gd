extends CanvasLayer

@onready var score_label: Label = $ScoreLabel


func update_score(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score
