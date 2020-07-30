tool
extends Node

var teller : Happy_Story_Teller
var last_teller : Happy_Story_Teller

export(Dictionary) var local_values : Dictionary # name : value
export(Dictionary) var global_values : Dictionary
export(Dictionary) var all_local_values : Dictionary

func get_global_values(var name : String) -> int:
	if not local_values.has(name):
		print("Happy Story Designer Log:")
		print("ERROR: Can't Find Local Value Named '\"'" + name +" '\"' in director !")
		return 0
	return local_values[name]
	
func set_global_values(var name : String, var value : int):
	local_values[name] = value
	
#计算方法
func math_add_value(var is_global_0 : bool, var name_0 : String, var temp_value_0 : int, var is_global_1 : bool, var name_1 : String, var temp_value_1 : int) -> int:
	var new_value
	if name_0:
		temp_value_0 = global_values[name_0] if is_global_0 else local_values[name_0]
	if name_1:
		temp_value_1 = global_values[name_1] if is_global_1 else local_values[name_1]
	new_value = temp_value_0 + temp_value_1
	return new_value
	
func math_minus_value(var is_global_0 : bool, var name_0 : String, var temp_value_0 : int, var is_global_1 : bool, var name_1 : String, var temp_value_1 : int) -> int:
	var new_value
	if name_0:
		temp_value_0 = global_values[name_0] if is_global_0 else local_values[name_0]
	if name_1:
		temp_value_1 = global_values[name_1] if is_global_1 else local_values[name_1]
	new_value = temp_value_0 - temp_value_1
	return new_value
	
func math_multiply_value(var is_global_0 : bool, var name_0 : String, var temp_value_0 : int, var is_global_1 : bool, var name_1 : String, var temp_value_1 : int) -> int:
	var new_value
	if name_0:
		temp_value_0 = global_values[name_0] if is_global_0 else local_values[name_0]
	if name_1:
		temp_value_1 = global_values[name_1] if is_global_1 else local_values[name_1]
	new_value = temp_value_0 * temp_value_1
	return new_value
	
func math_divide_value(var is_global_0 : bool, var name_0 : String, var temp_value_0 : int, var is_global_1 : bool, var name_1 : String, var temp_value_1 : int) -> int:
	var new_value
	if name_0:
		temp_value_0 = global_values[name_0] if is_global_0 else local_values[name_0]
	if name_1:
		temp_value_1 = global_values[name_1] if is_global_1 else local_values[name_1]
	if temp_value_1 == 0:
		print("Happy Story Designer Log:")
		print("ERROR: The divisor can't be ZERO !")
		return 0
	new_value = temp_value_0 / temp_value_1
	return new_value
	
func math_switch_value(var is_global : bool, var name : String, var temp_value : int) -> int:
	var new_value
	if name:
		temp_value = global_values[name] if is_global else local_values[name]
	new_value = 0 if temp_value != 0 else 1
	return new_value

#判断方法
enum CONDITION{
	LESS
	EQUAL
	GREATER	
}

func condition_math(var condition : int, var is_global_0 : bool, var name_0 : String, var temp_value_0 : int, var is_global_1 : bool, var name_1 : String, var temp_value_1 : int) -> bool:
	if name_0:
		temp_value_0 = global_values[name_0] if is_global_0 else local_values[name_0]
	if name_1:
		temp_value_1 = global_values[name_1] if is_global_1 else local_values[name_1]
	
	match condition:
		CONDITION.LESS:
			return true if temp_value_0 < temp_value_1 else false
		CONDITION.GREATER:
			return true if temp_value_0 > temp_value_1 else false
		CONDITION.EQUAL:
			return true if temp_value_0 == temp_value_1 else false
		_:
			print("Happy Story Designer Log:")
			print("ERROR: How do you turn this on ?")
			return false
	
func condition_bool(var is_global : bool, var name : String) -> bool:
	var temp_value = global_values[name] if is_global else local_values[name]
	return true if temp_value >0 else false
