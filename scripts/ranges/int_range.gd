extends Resource

class_name IntRange

@export var min_value: int:
	set(value):
		
		if value <= max_value:
			min_value = value

@export var max_value: int:
	set(value):
		
		if value >= min_value:
			max_value = value

static func create(_min_value: int, _max_value: int) -> IntRange:
	var int_range := IntRange.new()
	int_range.max_value = _max_value
	int_range.min_value = _min_value
	
	return int_range

func put_in_range(value: int) -> int:
	return clamp(value, min_value, max_value)
