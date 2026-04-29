extends Resource

class_name IntRange

@export var min_value: int:
	get:
		return min_value
	set(value):
		min_value = value
		_verify_range(self)

@export var max_value: int:
	get:
		return max_value
	set(value):
		max_value = value
		_verify_range(self)

static func _verify_range(obj: IntRange) -> void:
	
	if obj.min_value > obj.max_value:
		obj.max_value = obj.min_value

static func create(_min_value: int, _max_value: int) -> IntRange:
	var int_range := IntRange.new()
	int_range.max_value = _max_value
	int_range.min_value = _min_value
	
	return int_range

func put_in_range(value: int) -> int:
	return clamp(value, min_value, max_value)

## Generate a random number
func gen_num() -> int:
	return randi_range(min_value, max_value)
