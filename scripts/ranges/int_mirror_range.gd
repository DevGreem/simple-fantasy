extends IntRange

class_name IntMirrorRange

func put_in_range(value: int) -> int:
	
	var length = max_value - min_value
	var x = posmod(value - min_value, 2 * length)
	return min_value + abs(x - length)
