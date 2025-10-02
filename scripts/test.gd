extends SceneTree

class_name Test

func _init():
	Donut.test_all_donuts_are_stopped()
	Donut.test_get_colliding_donut()
	Donut.test_move()
	
	DonutsPair.test_donuts_pair()
	DonutsPair.test_sync_position()
	DonutsPair.test_rotation()
	DonutsPair.test_move()

	Cleaner.test_find_clearable_donuts()
	Cleaner.test_mapping_donuts_to_2d_array()
	Cleaner.test_donut_out_of_area()
	Cleaner.test_donut_grid_position()
	Cleaner.test_find_large_groups()
	Cleaner.test_create_2d_array()
	Cleaner.test_out_of_bounds()


	quit()
