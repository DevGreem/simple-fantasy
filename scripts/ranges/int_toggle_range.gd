extends IntRange

class_name IntToggleRange

func put_in_range(value: int) -> int:
	
	if value < min_value:
		return max_value
	
	if value > max_value:
		return min_value
	
	return value
