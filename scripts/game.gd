extends "res://scripts/game_views.gd"

func _ready() -> void:
	rng.randomize()
	football_logo_manifest = _load_football_logo_manifest()
	LEAGUES = _load_league_catalog()
	var brand_image := Image.new()
	var brand_bytes := FileAccess.get_file_as_bytes("res://assets/club-legacy-logo.png")
	if not brand_bytes.is_empty() and brand_image.load_png_from_buffer(brand_bytes) == OK:
		brand_mark_texture = ImageTexture.create_from_image(brand_image)
	asset_http = HTTPRequest.new()
	asset_http.timeout = 15.0
	asset_http.request_completed.connect(_on_asset_download_completed)
	add_child(asset_http)
	_migrate_legacy_save()
	_refresh_save_slot_summaries()
	queue_redraw()

func _process(delta: float) -> void:
	if screen == "match" and not match_over and not match_paused:
		_update_match(delta)
	if screen == "match" and not match_paused:
		match_visual_time += delta
	if banner_time > 0:
		banner_time = maxf(0, banner_time - delta)
	if screen == "assets": asset_animation_time += delta
	if asset_notice_time > 0: asset_notice_time = maxf(0.0, asset_notice_time - delta)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if screen == "assets" and event.keycode == KEY_ESCAPE:
			_request_assets_back()
		elif screen == "match":
			_handle_match_key(event.keycode)
		elif screen == "squad":
			if event.keycode == KEY_LEFT: _cycle_formation(-1)
			elif event.keycode == KEY_RIGHT: _cycle_formation(1)
		elif screen == "calendar" and event.keycode == KEY_ENTER:
			match_setup_open = true
		elif screen == "career" and event.keycode == KEY_ENTER:
			match_setup_open = true
		elif screen == "select":
			if event.keycode == KEY_LEFT: _cycle_league_selection(-1)
			elif event.keycode == KEY_RIGHT: _cycle_league_selection(1)
			elif event.keycode == KEY_PAGEUP:
				league_list_offset = maxi(0, league_list_offset - LEAGUE_ROWS_PER_PAGE)
				league_index = country_display_order[league_list_offset]
				club_index = 0
			elif event.keycode == KEY_PAGEDOWN:
				league_list_offset = mini(_last_league_page_offset(), league_list_offset + LEAGUE_ROWS_PER_PAGE)
				league_index = country_display_order[league_list_offset]
				club_index = 0
			elif event.keycode == KEY_A: club_index = posmod(club_index - 1, LEAGUES[league_index]["teams"].size())
			elif event.keycode == KEY_D: club_index = posmod(club_index + 1, LEAGUES[league_index]["teams"].size())
			elif event.keycode == KEY_ENTER: _begin_new_career()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pointer_down = true
			pointer_start = event.position
		else:
			if screen == "match" and pointer_down:
				var swipe: Vector2 = event.position - pointer_start
				if swipe.length() > 18:
					if match_owner == 0: _match_kick(swipe)
					else: _match_tackle()
				else:
					_handle_click(event.position)
				pointer_down = false
			else:
				pointer_down = false
				_handle_click(event.position)
	elif event is InputEventScreenTouch:
		if event.pressed:
			touch_action_index = event.index
			pointer_start = event.position
		else:
			if event.index == touch_move_index:
				touch_move_index = -1
				touch_move_vector = Vector2.ZERO
			elif event.index == touch_action_index:
				var swipe: Vector2 = event.position - pointer_start
				if swipe.length() > 18:
					if match_owner == 0: _match_kick(swipe)
					else: _match_tackle()
				elif screen == "match": _handle_click(event.position)
				else: _handle_click(event.position)
				touch_action_index = -1
	elif event is InputEventScreenDrag:
		if event.index == touch_move_index:
			touch_move_vector = ((event.position - touch_move_origin) / 62.0).limit_length(1.0)
