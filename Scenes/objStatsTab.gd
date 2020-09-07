extends Tabs

var last = false
var oneShotElapsed = false

func resizeMyself():
	if oneShotElapsed == true:
		return
	oneShotElapsed = true
	print(str(get_node("objProcessStats").rect_size) + name)
	rect_min_size = get_node("objProcessStats").rect_size
	var max_tab_size = get_parent().get_parent().get_parent().maxTabSize
	if max_tab_size < rect_min_size:
		max_tab_size = rect_min_size
	get_parent().get_parent().get_parent().maxTabSize = max_tab_size
	if last == true:
		remove_from_group("grpCtnSort")
		get_parent().rect_min_size = max_tab_size
		get_parent().get_parent().rect_min_size = max_tab_size
		get_parent().get_parent().popup_centered()
