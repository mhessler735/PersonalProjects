extends Label

func set_score(points: int):
	var score = int(text)
	score += points
	text = str(score)
