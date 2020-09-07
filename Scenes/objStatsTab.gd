extends Tabs

var last = false

func resizeMyself():
	print(str(get_node("objProcessStats").rect_size) + name)
	rect_min_size = get_node("objProcessStats").rect_size
	if get_parent().rect_min_size < rect_min_size:
		get_parent().rect_min_size = rect_min_size
		get_parent().get_parent().rect_min_size = rect_min_size
		#print("popuped")
		get_parent().get_parent().popup_centered()
