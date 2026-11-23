extends "res://scripts/game_state.gd"

func _load_football_logo_manifest() -> Dictionary:
	var file := FileAccess.open("res://assets/football_logo_manifest.json", FileAccess.READ)
	if file == null: return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

func _load_league_catalog() -> Array:
	var leagues: Array = BASE_LEAGUES.duplicate(true)
	for league in leagues:
		league["team_logos"] = league["teams"].duplicate()
		league["competition_logo_available"] = true
	for catalog_path in ["res://assets/openfootball_major_catalog.json", "res://assets/openfootball_world_catalog.json"]:
		var file := FileAccess.open(catalog_path, FileAccess.READ)
		if file == null: continue
		var parsed: Variant = JSON.parse_string(file.get_as_text())
		if not parsed is Array: continue
		for entry in parsed:
			if not entry is Dictionary or not entry.get("teams", []) is Array: continue
			var league: Dictionary = entry.duplicate(true)
			league["team_logos"] = league.get("teams", []).duplicate()
			league["competition_logo_available"] = not _league_badge_file(league).is_empty() or (str(league.get("country", "")) == "Alemanha" and str(league.get("name", "")) == "Bundesliga") or (str(league.get("country", "")) == "França" and str(league.get("name", "")) == "Ligue 1")
			# Preserve original league indices so old saves still point to the same competition.
			var legacy_index := int(league.get("legacy_index", -1))
			if legacy_index >= 0 and legacy_index < leagues.size():
				var base: Dictionary = leagues[legacy_index].duplicate(true)
				base["teams"] = league["teams"]
				base["team_logos"] = league["teams"].duplicate()
				leagues[legacy_index] = base
			elif str(league.get("source_code", "")) == "mx1":
				var mexico: Dictionary = leagues[9].duplicate(true)
				mexico["teams"] = league["teams"]
				mexico["team_logos"] = league["teams"].duplicate()
				leagues[9] = mexico
			else:
				leagues.append(league)
	_build_league_display_order(leagues)
	return leagues

func _build_league_display_order(leagues: Array) -> void:
	league_display_order.clear()
	country_display_order.clear()
	var countries := ["Brasil", "Inglaterra", "Espanha", "Itália", "Portugal", "Países Baixos", "Argentina", "Estados Unidos", "Japão", "México", "Alemanha", "França", "Arábia Saudita", "China"]
	for country in countries:
		var country_indices: Array[int] = []
		for index in range(leagues.size()):
			if str(leagues[index].get("country", "")) == country:
				country_indices.append(index)
		country_indices.sort_custom(func(a: int, b: int) -> bool:
			var rank_a := _league_division_rank(str(leagues[a].get("name", "")))
			var rank_b := _league_division_rank(str(leagues[b].get("name", "")))
			return rank_a < rank_b if rank_a != rank_b else str(leagues[a].get("name", "")) < str(leagues[b].get("name", ""))
		)
		league_display_order.append_array(country_indices)
		if not country_indices.is_empty(): country_display_order.append(country_indices[0])
	for index in range(leagues.size()):
		if not league_display_order.has(index):
			league_display_order.append(index)
			if not country_display_order.has(index): country_display_order.append(index)

func _league_division_rank(name: String) -> int:
	var ranks := {
		"Série A": 1, "Série B": 2, "Série C": 3, "Série D": 4,
		"Premier League": 1, "Championship": 2, "League One": 3, "League Two": 4,
		"La Liga": 1, "Segunda División": 2,
		"Bundesliga": 1, "2. Bundesliga": 2, "3. Liga": 3,
		"Serie A": 1, "Serie B": 2, "Serie C - Grupo A": 3, "Serie C - Grupo B": 4, "Serie C - Grupo C": 5,
		"Primeira Liga": 1, "Liga Portugal 2": 2,
		"Eredivisie": 1, "Eerste Divisie": 2,
		"Liga Profesional": 1, "MLS": 1, "J1 League": 1, "J3 League": 3,
		"Liga MX": 1, "Liga de Expansión MX": 2,
		"Ligue 1": 1, "Ligue 2": 2,
		"Saudi Professional League": 1, "Super League": 1
	}
	return int(ranks.get(name, 10))

func _division_picker_indices(country: String) -> Array[int]:
	var result: Array[int] = []
	for index in league_display_order:
		if str(LEAGUES[index].get("country", "")) == country:
			result.append(index)
	return result

func _keep_selected_league_visible() -> void:
	var country := str(LEAGUES[league_index].get("country", ""))
	var selected_position := -1
	for row_index in range(country_display_order.size()):
		if str(LEAGUES[country_display_order[row_index]].get("country", "")) == country:
			selected_position = row_index
			break
	if selected_position < 0: return
	if selected_position < league_list_offset:
		league_list_offset = selected_position
	elif selected_position >= league_list_offset + LEAGUE_ROWS_PER_PAGE:
		league_list_offset = selected_position - LEAGUE_ROWS_PER_PAGE + 1
	league_list_offset = clampi(league_list_offset, 0, _last_league_page_offset())

func _cycle_league_selection(direction: int) -> void:
	if country_display_order.is_empty(): return
	var country := str(LEAGUES[league_index].get("country", ""))
	var position := 0
	for row_index in range(country_display_order.size()):
		if str(LEAGUES[country_display_order[row_index]].get("country", "")) == country:
			position = row_index
			break
	position = posmod(position + direction, country_display_order.size())
	league_index = country_display_order[position]
	club_index = 0
	_keep_selected_league_visible()

func _last_league_page_offset() -> int:
	return maxi(0, int(floor(float(maxi(0, country_display_order.size() - 1)) / LEAGUE_ROWS_PER_PAGE)) * LEAGUE_ROWS_PER_PAGE)

func _country_league_name(country: String) -> String:
	var names := {
		"Brasil":"Brasileirão", "Inglaterra":"Premier League", "Espanha":"La Liga", "Itália":"Serie A",
		"Portugal":"Primeira Liga", "Países Baixos":"Eredivisie", "Argentina":"Liga Profesional",
		"Estados Unidos":"MLS", "Japão":"J.League", "México":"Liga MX", "Alemanha":"Bundesliga",
		"França":"Ligue 1", "Arábia Saudita":"Saudi Pro League", "China":"Super League"
	}
	return str(names.get(country, "Liga nacional"))

func _country_competitions(country: String) -> Array[String]:
	var competitions := {
		"Brasil":["Copa do Brasil", "Libertadores", "Sul-Americana", "Supercopa Rei", "Recopa Sul-Americana", "Mundial de Clubes"],
		"Inglaterra":["FA Cup", "EFL Cup", "Champions League", "Europa League", "Conference League", "Community Shield", "Mundial de Clubes"],
		"Espanha":["Copa do Rei", "Supercopa da Espanha", "Champions League", "Europa League", "Conference League", "Mundial de Clubes"],
		"Itália":["Coppa Italia", "Supercoppa Italiana", "Champions League", "Europa League", "Conference League", "Mundial de Clubes"],
		"Portugal":["Taça de Portugal", "Taça da Liga", "Supertaça", "Champions League", "Europa League", "Conference League"],
		"Países Baixos":["KNVB Beker", "Johan Cruyff Shield", "Champions League", "Europa League", "Conference League"],
		"Argentina":["Copa Argentina", "Supercopa Argentina", "Libertadores", "Sul-Americana", "Recopa Sul-Americana", "Mundial de Clubes"],
		"Estados Unidos":["MLS Cup", "U.S. Open Cup", "Leagues Cup", "Copa dos Campeões da Concacaf", "Mundial de Clubes"],
		"Japão":["Copa do Imperador", "Copa da J.League", "Supercopa do Japão", "Champions da Ásia", "Mundial de Clubes"],
		"México":["Campeón de Campeones", "Leagues Cup", "Copa dos Campeões da Concacaf", "Mundial de Clubes"],
		"Alemanha":["DFB-Pokal", "Supercopa da Alemanha", "Champions League", "Europa League", "Conference League", "Mundial de Clubes"],
		"França":["Coupe de France", "Trophée des Champions", "Champions League", "Europa League", "Conference League", "Mundial de Clubes"],
		"Arábia Saudita":["Copa do Rei", "Supercopa Saudita", "Champions da Ásia", "Mundial de Clubes"],
		"China":["Copa da China", "Supercopa da China", "Champions da Ásia", "Mundial de Clubes"]
	}
	var result: Array[String] = []
	for competition in competitions.get(country, ["Liga nacional"]):
		result.append(str(competition))
	return result

func _competition_short_name(competition: String) -> String:
	return competition if competition.length() <= 23 else competition.substr(0, 21) + "…"

func _handle_click(pos: Vector2) -> void:
	if save_overwrite_confirm:
		if Rect2(402, 382, 210, 54).has_point(pos):
			save_overwrite_confirm = false
			active_save_slot = overwrite_confirm_slot
			league_index = pending_new_league
			club_index = pending_new_club
			_new_career()
		elif Rect2(632, 382, 210, 54).has_point(pos):
			save_overwrite_confirm = false
		return
	if match_setup_open:
		if Rect2(460, 374, 170, 58).has_point(pos):
			match_setup_open = false
			_play_next()
		elif Rect2(650, 374, 170, 58).has_point(pos):
			match_setup_open = false
			_simulate_next_match()
		elif Rect2(540, 450, 200, 44).has_point(pos):
			match_setup_open = false
		return
	if sim_result_open:
		if Rect2(500, 442, 280, 54).has_point(pos): sim_result_open = false
		return
	match screen:
		"home":
			if Rect2(484, 392, 312, 58).has_point(pos): preferred_save_slot = 0; screen = "select"
			elif Rect2(484, 465, 312, 50).has_point(pos): save_screen_mode = "load"; _refresh_save_slot_summaries(); screen = "saves"
			elif Rect2(484, 538, 312, 50).has_point(pos): screen = "assets"
		"assets":
			if Rect2(1124, 13, 136, 44).has_point(pos): _request_assets_back()
			elif Rect2(384, 340, 512, 58).has_point(pos): _download_all_assets()
			elif Rect2(384, 416, 512, 58).has_point(pos): _remove_cached_crests()
		"saves":
			if Rect2(1124, 13, 136, 44).has_point(pos): screen = "home"
			else: _handle_save_slot_click(pos)
		"select":
			if division_picker_open:
				var country_divisions := _division_picker_indices(str(LEAGUES[league_index].get("country", "")))
				var picker_rect := Rect2(798, 233, 330, country_divisions.size() * 36.0)
				if picker_rect.has_point(pos):
					var picked_row := clampi(int((pos.y - picker_rect.position.y) / 36.0), 0, country_divisions.size() - 1)
					league_index = country_divisions[picked_row]
					club_index = 0
					division_picker_open = false
					_keep_selected_league_visible()
					return
				if Rect2(798, 190, 330, 38).has_point(pos):
					division_picker_open = false
					return
				division_picker_open = false
			if Rect2(798, 190, 330, 38).has_point(pos): division_picker_open = true
			elif Rect2(1120, 12, 132, 44).has_point(pos): _begin_new_career()
			elif Rect2(0, 0, 70, 68).has_point(pos): preferred_save_slot = 0; screen = "home"
			elif Rect2(52, 181, 546, 400).has_point(pos):
				var visible_row := clampi(int((pos.y - 181) / 40), 0, LEAGUE_ROWS_PER_PAGE - 1)
				league_index = country_display_order[mini(league_list_offset + visible_row, country_display_order.size() - 1)]
				club_index = 0
			elif Rect2(448, 592, 52, 26).has_point(pos):
				league_list_offset = maxi(0, league_list_offset - LEAGUE_ROWS_PER_PAGE)
				league_index = country_display_order[league_list_offset]
				club_index = 0
			elif Rect2(542, 592, 52, 26).has_point(pos):
				league_list_offset = mini(_last_league_page_offset(), league_list_offset + LEAGUE_ROWS_PER_PAGE)
				league_index = country_display_order[league_list_offset]
				club_index = 0
			elif Rect2(645, 285, 48, 48).has_point(pos): club_index = posmod(club_index - 1, LEAGUES[league_index]["teams"].size())
			elif Rect2(1175, 285, 48, 48).has_point(pos): club_index = posmod(club_index + 1, LEAGUES[league_index]["teams"].size())
			elif Rect2(855, 560, 336, 54).has_point(pos): _begin_new_career()
			elif Rect2(1130, 18, 118, 42).has_point(pos): preferred_save_slot = 0; screen = "home"
		"squad":
			if Rect2(1130, 12, 118, 48).has_point(pos): screen = "career"
			elif Rect2(980, 650, 270, 52).has_point(pos): _cycle_formation(1)
			elif Rect2(700, 650, 260, 52).has_point(pos): mentality = posmod(mentality + 1, 3); _save_game()
			elif Rect2(18, 75, 120, 40).has_point(pos): screen = "squad"
			elif Rect2(142, 75, 120, 40).has_point(pos): screen = "squad"
			else: _select_lineup_player(pos)
		"career":
			if Rect2(1080, 10, 180, 52).has_point(pos): match_setup_open = true
			elif Rect2(0, 0, 80, 68).has_point(pos): screen = "home"
			elif Rect2(18, 130, 300, 170).has_point(pos): match_setup_open = true
			elif Rect2(324, 130, 300, 170).has_point(pos) or Rect2(630, 130, 300, 170).has_point(pos): screen = "squad"
			elif Rect2(936, 130, 300, 170).has_point(pos): screen = "squad"
			elif Rect2(18, 305, 300, 172).has_point(pos): screen = "calendar"
			elif Rect2(324, 305, 300, 172).has_point(pos) or Rect2(630, 305, 300, 172).has_point(pos): screen = "market"
			elif Rect2(936, 305, 300, 347).has_point(pos): screen = "squad"
			elif Rect2(18, 480, 300, 172).has_point(pos): screen = "standings"
			elif Rect2(324, 480, 300, 172).has_point(pos) or Rect2(630, 480, 300, 172).has_point(pos): screen = "market"
			elif Rect2(936, 480, 300, 172).has_point(pos): screen = "squad"
		"calendar":
			if Rect2(1124, 13, 136, 44).has_point(pos): screen = "career"
			elif Rect2(700, 650, 260, 50).has_point(pos): match_setup_open = true
			elif Rect2(970, 650, 270, 50).has_point(pos): _simulate_next_match()
			elif Rect2(330, 96, 170, 48).has_point(pos): screen = "career"
			elif Rect2(510, 96, 170, 48).has_point(pos): screen = "squad"
			elif Rect2(690, 96, 170, 48).has_point(pos): screen = "market"
		"standings":
			if Rect2(1124, 13, 136, 44).has_point(pos) or Rect2(1000, 650, 250, 50).has_point(pos): screen = "career"
		"market":
			if Rect2(1100, 12, 158, 44).has_point(pos): screen = "career"
			elif Rect2(1000, 650, 250, 50).has_point(pos): screen = "career"
			else: _market_action(pos)
		"match":
			if match_over:
				if Rect2(461, 420, 358, 60).has_point(pos): _finish_match()
			elif Rect2(1016, 662, 96, 44).has_point(pos): match_paused = not match_paused
			elif Rect2(1124, 662, 132, 44).has_point(pos): _fast_forward_match()
			elif pos.y > 70 and pos.y < 642: _match_tap(pos)

func _begin_new_career() -> void:
	pending_new_league = league_index
	pending_new_club = club_index
	if preferred_save_slot > 0:
		active_save_slot = preferred_save_slot
		preferred_save_slot = 0
		_new_career()
	else:
		save_screen_mode = "new"
		_refresh_save_slot_summaries()
		screen = "saves"

func _new_career() -> void:
	if active_save_slot < 1 or active_save_slot > SAVE_SLOT_COUNT: return
	club_name = LEAGUES[league_index]["teams"][club_index]
	_generate_roster()
	_generate_league()
	formation_index = 0
	mentality = 1
	season = 1
	round_number = 1
	budget = 1800000
	points = 0; wins = 0; draws = 0; losses = 0; goals_for = 0; goals_against = 0
	last_match_result = ""
	_refresh_transfer_market()
	screen = "career"
	_save_game()

func _simulate_next_match() -> void:
	_play_next()
	if screen != "match": return
	_simulate_match()
	var fixture := _next_fixture()
	sim_result_home = str(fixture.get("home", club_name))
	sim_result_away = str(fixture.get("away", "Adversário"))
	var user_is_home: bool = sim_result_home == club_name
	sim_result_home_score = match_score[0] if user_is_home else match_score[1]
	sim_result_away_score = match_score[1] if user_is_home else match_score[0]
	_finish_match()
	sim_result_open = true

func _generate_roster() -> void:
	roster.clear()
	bench.clear()
	if REAL_SQUADS.has(club_name):
		var raw_squad: Array = REAL_SQUADS[club_name].duplicate(true)
		var sorted_squad: Array = []
		var position_count := {"GK":0, "DEF":0, "MID":0, "ATT":0}
		var starter_target := {"GK":1, "DEF":4, "MID":4, "ATT":2}
		for desired_pos in ["GK", "DEF", "MID", "ATT"]:
			for record in raw_squad:
				if record[1] == desired_pos and int(position_count[desired_pos]) < int(starter_target[desired_pos]):
					sorted_squad.append(record)
					position_count[desired_pos] = int(position_count[desired_pos]) + 1
		for record in raw_squad:
			if not sorted_squad.has(record): sorted_squad.append(record)
		for i in range(sorted_squad.size()):
			var real_player: Array = sorted_squad[i]
			var rating := rng.randi_range(61, 86) if i >= 11 else rng.randi_range(68, 88)
			roster.append({"name":real_player[0], "pos":real_player[1], "rating":rating, "age":rng.randi_range(18, 34), "spd":rng.randi_range(50, 92), "pas":rng.randi_range(50, 92), "sho":rng.randi_range(45, 90), "tck":rng.randi_range(45, 92), "gk":rng.randi_range(45, 88), "fitness":100, "number":real_player[2]})
		for i in range(11, roster.size()): bench.append(i)
		return
	var used := {}
	for i in range(18):
		var first: String = FIRST_NAMES[rng.randi_range(0, FIRST_NAMES.size() - 1)]
		var last: String = LAST_NAMES[rng.randi_range(0, LAST_NAMES.size() - 1)]
		var full_name: String = first + " " + last
		var tries := 0
		while used.has(full_name) and tries < 8:
			last = LAST_NAMES[rng.randi_range(0, LAST_NAMES.size() - 1)]
			full_name = first + " " + last
			tries += 1
		used[full_name] = true
		var base: int = rng.randi_range(54, 82)
		if i < 11: base += 3
		var pos: String = POSITIONS[i]
		var player := {"name":full_name, "pos":pos, "rating":mini(92, base), "age":rng.randi_range(18, 34), "spd":rng.randi_range(45, 94), "pas":rng.randi_range(45, 94), "sho":rng.randi_range(45, 94), "tck":rng.randi_range(40, 94), "gk":rng.randi_range(35, 88), "fitness":100, "number":i + 1}
		roster.append(player)
		if i >= 11: bench.append(i)

func _generate_league() -> void:
	league_table.clear()
	fixtures.clear()
	for team in LEAGUES[league_index]["teams"]:
		league_table.append({"name":team, "pts":0, "p":0, "w":0, "d":0, "l":0, "gf":0, "ga":0, "user":team == club_name})
	var rotation: Array = LEAGUES[league_index]["teams"].duplicate()
	for round_index in range(rotation.size() - 1):
		for i in range(int(rotation.size() / 2)):
			var home_team: String = rotation[i]
			var away_team: String = rotation[rotation.size() - 1 - i]
			if (round_index + i) % 2 == 1:
				var swap := home_team; home_team = away_team; away_team = swap
			fixtures.append({"round":round_index + 1, "home":home_team, "away":away_team, "played":false, "hs":0, "as":0})
		var last_team: Variant = rotation.pop_back()
		rotation.insert(1, last_team)

func _migrate_legacy_save() -> void:
	var first_slot_path := _save_slot_path(1)
	if FileAccess.file_exists(first_slot_path) or not FileAccess.file_exists("user://career.cfg"): return
	var legacy_absolute := ProjectSettings.globalize_path("user://career.cfg")
	var slot_absolute := ProjectSettings.globalize_path(first_slot_path)
	DirAccess.copy_absolute(legacy_absolute, slot_absolute)

func _save_slot_path(slot: int) -> String:
	return "user://career_slot_%d.cfg" % slot

func _save_slot_summary(slot: int) -> Dictionary:
	if slot < 1 or slot > SAVE_SLOT_COUNT: return {"exists":false}
	var cfg := ConfigFile.new()
	if cfg.load(_save_slot_path(slot)) != OK: return {"exists":false}
	var saved_club: String = str(cfg.get_value("career", "club", ""))
	if saved_club.is_empty(): return {"exists":false}
	return {"exists":true, "club":saved_club, "season":int(cfg.get_value("career", "season", 1)), "budget":int(cfg.get_value("career", "budget", 1800000))}

func _refresh_save_slot_summaries() -> void:
	save_slot_summaries.clear()
	for slot in range(1, SAVE_SLOT_COUNT + 1): save_slot_summaries.append(_save_slot_summary(slot))

func _handle_save_slot_click(pos: Vector2) -> void:
	for i in range(SAVE_SLOT_COUNT):
		var rect := Rect2(180, 142 + i * 112, 920, 92)
		if not rect.has_point(pos): continue
		var slot := i + 1
		var summary := _save_slot_summary(slot)
		if save_screen_mode == "load":
			if bool(summary.get("exists", false)):
				active_save_slot = slot
				_load_save(slot)
			else:
				preferred_save_slot = slot
				screen = "select"
		else:
			pending_new_league = league_index
			pending_new_club = club_index
			if bool(summary.get("exists", false)):
				overwrite_confirm_slot = slot
				save_overwrite_confirm = true
			else:
				active_save_slot = slot
				_new_career()
		return

func _load_save(slot: int) -> void:
	var cfg := ConfigFile.new()
	if cfg.load(_save_slot_path(slot)) != OK: return
	active_save_slot = slot
	club_name = cfg.get_value("career", "club", "")
	if club_name == "": return
	league_index = clampi(int(cfg.get_value("career", "league", 0)), 0, LEAGUES.size() - 1)
	club_index = int(cfg.get_value("career", "club_index", 0))
	var saved_league_teams: Array = LEAGUES[league_index]["teams"]
	if not saved_league_teams.has(club_name):
		# Preserve a club name stored by an older save even if it left the refreshed season list.
		saved_league_teams.append(club_name)
		LEAGUES[league_index]["teams"] = saved_league_teams
	club_index = saved_league_teams.find(club_name)
	season = int(cfg.get_value("career", "season", 1))
	round_number = int(cfg.get_value("career", "round", 1))
	formation_index = int(cfg.get_value("career", "formation", 0))
	mentality = int(cfg.get_value("career", "mentality", 1))
	budget = int(cfg.get_value("career", "budget", 1800000))
	_generate_roster()
	_generate_league()
	points = int(cfg.get_value("career", "points", 0))
	wins = int(cfg.get_value("career", "wins", 0))
	draws = int(cfg.get_value("career", "draws", 0))
	losses = int(cfg.get_value("career", "losses", 0))
	goals_for = int(cfg.get_value("career", "gf", 0))
	goals_against = int(cfg.get_value("career", "ga", 0))
	var saved_roster: Variant = str_to_var(str(cfg.get_value("career", "roster", "")))
	var saved_fixtures: Variant = str_to_var(str(cfg.get_value("career", "fixtures", "")))
	var saved_table: Variant = str_to_var(str(cfg.get_value("career", "table", "")))
	var saved_market: Variant = str_to_var(str(cfg.get_value("career", "market", "")))
	var saved_offer: Variant = str_to_var(str(cfg.get_value("career", "offer", "")))
	var roster_data_version := int(cfg.get_value("career", "roster_version", 0))
	if saved_roster is Array and not saved_roster.is_empty() and (not REAL_SQUADS.has(club_name) or roster_data_version >= 2): roster.assign(saved_roster)
	var saved_table_compatible: bool = saved_table is Array and not saved_table.is_empty()
	if saved_table_compatible:
		for team in LEAGUES[league_index]["teams"]:
			var found_team := false
			for row in saved_table:
				if row.get("name", "") == team: found_team = true; break
			if not found_team: saved_table_compatible = false; break
	if saved_fixtures is Array and not saved_fixtures.is_empty() and saved_table_compatible: fixtures.assign(saved_fixtures)
	if saved_table_compatible: league_table.assign(saved_table)
	if saved_market is Array and not saved_market.is_empty(): market_candidates.assign(saved_market)
	else: _refresh_transfer_market()
	if saved_offer is Dictionary: transfer_offer = saved_offer
	elif transfer_offer.is_empty(): _refresh_transfer_market()
	screen = "career"

func _save_game() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("career", "club", club_name)
	cfg.set_value("career", "league", league_index)
	cfg.set_value("career", "club_index", club_index)
	cfg.set_value("career", "season", season)
	cfg.set_value("career", "round", round_number)
	cfg.set_value("career", "formation", formation_index)
	cfg.set_value("career", "mentality", mentality)
	cfg.set_value("career", "budget", budget)
	cfg.set_value("career", "points", points)
	cfg.set_value("career", "wins", wins)
	cfg.set_value("career", "draws", draws)
	cfg.set_value("career", "losses", losses)
	cfg.set_value("career", "gf", goals_for)
	cfg.set_value("career", "ga", goals_against)
	cfg.set_value("career", "roster", var_to_str(roster))
	cfg.set_value("career", "roster_version", 2)
	cfg.set_value("career", "fixtures", var_to_str(fixtures))
	cfg.set_value("career", "table", var_to_str(league_table))
	cfg.set_value("career", "market", var_to_str(market_candidates))
	cfg.set_value("career", "offer", var_to_str(transfer_offer))
	if active_save_slot > 0 and active_save_slot <= SAVE_SLOT_COUNT:
		cfg.save(_save_slot_path(active_save_slot))
		_refresh_save_slot_summaries()

func _next_fixture() -> Dictionary:
	if fixtures.is_empty(): return {}
	for fixture in fixtures:
		if int(fixture["round"]) == round_number and (fixture["home"] == club_name or fixture["away"] == club_name): return fixture
	return {}

func _play_next() -> void:
	var fixture := _next_fixture()
	if fixture.is_empty():
		banner = "NAO FOI POSSIVEL ENCONTRAR A PROXIMA PARTIDA"
		banner_time = 2.5
		return
	last_match_result = ""
	match_score = [0, 0]
	match_clock = 0.0
	match_time_limit = 120.0
	fast_sim_timer = 0.0
	key_play_active = true
	pending_ball_action = ""
	match_visual_time = 0.0
	match_over = false
	match_paused = false
	match_state = "KICKOFF"
	match_event_text = "SAÍDA DE BOLA"
	match_event_timer = 1.8
	match_ball = Vector2(640, 360)
	match_ball_vel = Vector2.ZERO
	match_ball_height = 0.0
	match_ball_vertical_speed = 0.0
	match_owner = 0
	selected_match_player = 9
	match_last_touch_team = 0
	match_restart_timer = 1.0
	match_half_time_shown = false
	match_camera_offset = Vector2.ZERO
	match_players.clear()
	var home_positions: Array[Vector2] = [Vector2(105,360),Vector2(230,220),Vector2(230,315),Vector2(230,405),Vector2(230,500),Vector2(390,210),Vector2(390,310),Vector2(390,410),Vector2(390,510),Vector2(520,300),Vector2(520,420)]
	var away_positions: Array[Vector2] = [Vector2(1175,360),Vector2(1050,220),Vector2(1050,315),Vector2(1050,405),Vector2(1050,500),Vector2(890,210),Vector2(890,310),Vector2(890,410),Vector2(890,510),Vector2(760,300),Vector2(760,420)]
	for team in range(2):
		for i in range(11):
			var spawn: Vector2 = home_positions[i] if team == 0 else away_positions[i]
			var player_data: Dictionary = {}
			var roster_index: int = i if team == 0 else -1
			var source: Dictionary = roster[i] if team == 0 and i < roster.size() else {}
			player_data = {"team":team,"pos":spawn,"home":spawn,"vel":Vector2.ZERO,"dir":Vector2.RIGHT if team == 0 else Vector2.LEFT,"num":i+1,"role":str(source.get("pos", "MID" if i > 0 else "GK")),"spd":float(source.get("spd", 65 if i > 0 else 45)),"pas":float(source.get("pas", 60)),"sho":float(source.get("sho", 60)),"ctl":float(source.get("ctl", source.get("rating", 65))),"tck":float(source.get("tck", 60)),"agi":float(source.get("agi", 60)),"sta":float(source.get("sta", 85)),"gk":float(source.get("gk", source.get("rating", 60) if i == 0 else 20)),"anim":"idle","anim_t":0.0,"cooldown":0.0,"roster_index":roster_index,"has_ball":false}
			match_players.append(player_data)
	match_players[9]["pos"] = Vector2(620, 360)
	match_players[9]["home"] = Vector2(620, 360)
	match_ball = Vector2(635, 360)
	player_run_target = Vector2.ZERO
	screen = "match"

func _update_match(delta: float) -> void:
	if match_over or match_paused: return
	if match_event_timer > 0.0: match_event_timer = maxf(0.0, match_event_timer - delta)
	if match_restart_timer > 0.0:
		match_restart_timer = maxf(0.0, match_restart_timer - delta)
		return
	match_clock = minf(match_time_limit, match_clock + delta)
	if match_clock >= match_time_limit:
		match_clock = match_time_limit
		match_over = true
		match_state = "FULL_TIME"
		match_event_text = "FIM DE JOGO"
		return
	if not match_half_time_shown and match_clock >= match_time_limit * 0.5:
		match_half_time_shown = true
		match_event_text = "INTERVALO — SEGUNDO TEMPO"
		match_event_timer = 2.0
		match_restart_timer = 1.0
		for p in match_players:
			p["vel"] = Vector2.ZERO
			p["home"] = Vector2(1280.0 - float(p["home"].x), float(p["home"].y))
			p["pos"] = p["home"]
		return
	var move := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): move.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): move.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): move.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): move.y += 1
	if touch_move_vector.length() > 0.1: move = touch_move_vector
	if player_run_target != Vector2.ZERO and move.length() < 0.05:
		var controlled_pos: Vector2 = match_players[selected_match_player]["pos"]
		if controlled_pos.distance_to(player_run_target) < 12.0: player_run_target = Vector2.ZERO
		else: move = controlled_pos.direction_to(player_run_target)
	var controlled: Dictionary = match_players[selected_match_player]
	var controlled_team: int = int(controlled["team"])
	if controlled_team != match_owner and match_owner >= 0:
		# When defending, keep manual control but do not allow a tackle from across the field.
		pass
	var max_speed: float = 170.0 + float(controlled.get("spd", 60.0)) * 0.72
	if move.length() > 0.05:
		controlled["vel"] = Vector2(controlled["vel"]).move_toward(move.normalized() * max_speed, match_player_accel * delta)
		controlled["dir"] = move.normalized()
		controlled["anim"] = "run"
		player_run_target = Vector2.ZERO
	else:
		controlled["vel"] = Vector2(controlled["vel"]).move_toward(Vector2.ZERO, match_player_decel * delta)
		controlled["anim"] = "idle" if Vector2(controlled["vel"]).length() < 12.0 else "run"
	match_players[selected_match_player] = controlled
	# Tactical AI: only a few nearest defenders press; teammates keep shape and create passing lanes.
	for i in range(match_players.size()):
		var pl: Dictionary = match_players[i]
		var pos: Vector2 = pl["pos"]
		var team: int = int(pl["team"])
		var vel: Vector2 = pl["vel"]
		if i == selected_match_player:
			pos += vel * delta
		else:
			var target: Vector2 = pl["home"]
			var attack_sign: float = 1.0 if team == 0 else -1.0
			var dist_to_ball: float = pos.distance_to(match_ball)
			if match_owner == team:
				if i == (9 if team == 0 else 20): target = match_ball + Vector2(attack_sign * 90.0, -25.0)
				elif str(pl["role"]) == "ATT": target += Vector2(attack_sign * 100.0, 0)
				elif str(pl["role"]) == "MID": target += Vector2(attack_sign * 45.0, 0)
				target.y += sin(match_visual_time * 0.7 + float(i)) * 18.0
			else:
				var nearest_defender := _nearest_team_player(match_ball, team)
				if i == nearest_defender: target = match_ball + (pos - match_ball).normalized() * 12.0
				else:
					target = pl["home"].lerp(match_ball, 0.12)
					if team == 0: target.x = maxf(target.x, 105.0)
					else: target.x = minf(target.x, 1175.0)
			var ai_speed: float = 95.0 + float(pl.get("spd", 60.0)) * 0.6
			if pos.distance_to(target) > 5.0:
				var desired: Vector2 = pos.direction_to(target) * ai_speed
				vel = vel.move_toward(desired, 320.0 * delta)
				pos += vel * delta
			else:
				vel = vel.move_toward(Vector2.ZERO, 400.0 * delta)
			pl["anim"] = "run" if vel.length() > 24.0 else "idle"
			if vel.length() > 5.0: pl["dir"] = vel.normalized()
		pl["vel"] = vel
		pl["pos"] = Vector2(clampf(pos.x, 65.0, 1215.0), clampf(pos.y, 145.0, 575.0))
		pl["anim_t"] = float(pl.get("anim_t", 0.0)) + delta
		pl["cooldown"] = maxf(0.0, float(pl.get("cooldown", 0.0)) - delta)
		match_players[i] = pl
	# Ball flight and ground friction. Height is independent from the ground shadow.
	if match_owner < 0:
		match_ball += match_ball_vel * delta
		match_ball_height = maxf(0.0, match_ball_height + match_ball_vertical_speed * delta)
		match_ball_vertical_speed -= 560.0 * delta
		if match_ball_height <= 0.0:
			match_ball_height = 0.0
			match_ball_vertical_speed = 0.0
			match_ball_vel = match_ball_vel.move_toward(Vector2.ZERO, 180.0 * delta)
		# Post and player collisions while the ball is moving.
		if match_ball.x < 84.0 or match_ball.x > 1196.0:
			var in_goal: bool = match_ball.y > 318.0 and match_ball.y < 402.0
			if in_goal and match_ball_height < 38.0:
				var scorer_team: int = 0 if match_ball.x > 1196.0 else 1
				match_score[scorer_team] += 1
				match_event_text = "GOL!"
				match_event_timer = 2.5
				match_state = "GOAL"
				match_last_touch_team = scorer_team
				_reset_after_goal()
			else:
				match_ball.x = clampf(match_ball.x, 84.0, 1196.0)
				match_ball_vel.x *= -0.55
				if absf(match_ball_vel.x) < 120.0:
					match_event_text = "TIRO DE META / ESCANTEIO"
					match_event_timer = 1.4
					match_owner = 1 - match_last_touch_team
					match_state = "RESTART"
					match_restart_timer = 0.8
		if match_ball.y < 148.0 or match_ball.y > 572.0:
			match_ball.y = clampf(match_ball.y, 148.0, 572.0)
			match_ball_vel.y *= -0.62
			if match_ball_vel.length() < 100.0:
				match_event_text = "LATERAL"
				match_event_timer = 1.0
				match_owner = 1 - match_last_touch_team
				match_state = "RESTART"
				match_restart_timer = 0.65
		# Interception and keeper reaction are distance/skill based, not random possession teleporting.
		if match_ball_height < 18.0 and match_ball_vel.length() < 520.0:
			for i in range(match_players.size()):
				var pl: Dictionary = match_players[i]
				var reach: float = 17.0 if i % 11 != 0 else 22.0
				if Vector2(pl["pos"]).distance_to(match_ball) < reach:
					var control_skill: float = float(pl.get("ctl", 60.0))
					var catch_chance: float = clampf(0.58 + (control_skill - 60.0) * 0.006, 0.25, 0.9)
					if i % 11 == 0 and int(pl["team"]) != match_last_touch_team:
						catch_chance = clampf( 0.45 + float(pl.get("gk", 60.0)) * 0.004, 0.4, 0.88)
						if rng.randf() < catch_chance:
							_resolve_ball_possession(int(pl["team"]))
							if int(pl["team"]) == 0:
								selected_match_player = _nearest_team_player(match_ball, 0)
								match_ball_vel = Vector2.ZERO
								match_ball_height = 0.0
								match_ball = pl["pos"] + Vector2(pl["dir"]) * 13.0
								match_last_touch_team = int(pl["team"])
	else:
		# Loose ball slowly follows the carrier with a small touch offset, never rigidly attached.
		var carrier_index: int = _carrier_index(match_owner)
		if carrier_index >= 0:
			var carrier: Dictionary = match_players[carrier_index]
			var carrier_pos: Vector2 = carrier["pos"]
			var carrier_dir: Vector2 = carrier["dir"]
			match_ball = match_ball.lerp(carrier_pos + carrier_dir * 13.0 + Vector2(0, 3.0), minf(1.0, delta * 12.0))
			if carrier_index == selected_match_player and move.length() > 0.1 and rng.randf() < 0.08:
				match_ball += carrier_dir * 4.0
		# Opponent AI makes decisions from pressure, distance and passing options.
		if match_owner == 1 and carrier_index >= 0:
			var carrier: Dictionary = match_players[carrier_index]
			var goal_distance: float = absf(float(carrier["pos"].x) - 84.0)
			var pressure: int = _nearby_opponents(carrier["pos"], 1, 95.0)
			if goal_distance < 300.0 and rng.randf() < 0.012:
				_match_ai_shot(carrier_index)
			elif (pressure >= 2 or rng.randf() < 0.003) and rng.randf() < 0.55:
				_match_ai_pass(carrier_index)
	# Camera follows ball smoothly; field drawing applies the offset to the match objects.
	var target_offset := Vector2(clampf(match_ball.x - 640.0, -100.0, 100.0), clampf(match_ball.y - 360.0, -25.0, 25.0))
	match_camera_offset = match_camera_offset.lerp(target_offset, minf(1.0, delta * 2.5))

func _carrier_index(team: int) -> int:
	for i in range(match_players.size()):
		if int(match_players[i]["team"]) == team and bool(match_players[i].get("has_ball", false)): return i
	# Legacy-safe fallback: possession is assigned to the closest player to the ball.
	var best := -1
	var distance := INF
	for i in range(match_players.size()):
		if int(match_players[i]["team"]) != team: continue
		var d: float = Vector2(match_players[i]["pos"]).distance_to(match_ball)
		if d < distance: distance = d; best = i
	return best if distance < 95.0 else -1

func _nearest_team_player(point: Vector2, team: int) -> int:
	var best := -1
	var best_distance := INF
	for i in range(match_players.size()):
		if int(match_players[i]["team"]) != team: continue
		var d: float = Vector2(match_players[i]["pos"]).distance_to(point)
		if d < best_distance: best_distance = d; best = i
	return best

func _nearby_opponents(point: Vector2, team: int, radius: float) -> int:
	var count := 0
	for p in match_players:
		if int(p["team"]) != team and Vector2(p["pos"]).distance_to(point) < radius: count += 1
	return count

func _resolve_ball_possession(team: int) -> void:
	match_owner = team
	match_last_touch_team = team
	for i in range(match_players.size()):
		match_players[i]["has_ball"] = false
	var carrier := _nearest_team_player(match_ball, team)
	if carrier >= 0:
		match_players[carrier]["has_ball"] = true
		if team == 0: selected_match_player = carrier
	match_state = "POSSESSION"
	pending_ball_action = ""

func _match_tap(position: Vector2) -> void:
	if not key_play_active or match_over or match_paused: return
	var tapped_player: int = _player_at(position + match_camera_offset)
	if match_owner == 0:
		if tapped_player >= 0 and tapped_player < 11 and tapped_player != selected_match_player:
			_match_pass_to(tapped_player)
		else:
			player_run_target = position + match_camera_offset
	else:
		if tapped_player >= 0 and tapped_player < 11:
			selected_match_player = tapped_player
		else:
			player_run_target = position + match_camera_offset

func _player_at(position: Vector2) -> int:
	for i in range(match_players.size()):
		if Vector2(match_players[i]["pos"]).distance_to(position) <= 25.0: return i
	return -1

func _nearest_match_player(point: Vector2) -> int:
	var nearest := -1
	var best := INF
	for i in range(match_players.size()):
		var d: float = Vector2(match_players[i]["pos"]).distance_to(point)
		if d < best: best = d; nearest = i
	return nearest

func _match_kick(direction: Vector2, is_pass: bool = false) -> void:
	if match_over or match_paused or not key_play_active or match_owner != 0: return
	var p: Dictionary = match_players[selected_match_player]
	var ppos: Vector2 = p["pos"]
	if ppos.distance_to(match_ball) > 65.0: return
	var v: Vector2 = direction.normalized() if direction.length() > 0.01 else Vector2.RIGHT
	match_owner = -1
	match_last_touch_team = 0
	match_ball = ppos + v * 18.0
	match_ball_vel = v * (390.0 + float(p.get("pas", 60.0)) * 1.8 if is_pass else 450.0 + float(p.get("sho", 60.0)) * 2.4)
	match_ball_height = 0.0 if is_pass else 2.0
	match_ball_vertical_speed = 0.0 if is_pass else 70.0
	pending_ball_action = "pass" if is_pass else "shot"
	match_state = "PASS" if is_pass else "SHOT"
	p["anim"] = "kick"
	p["cooldown"] = 0.25
	match_players[selected_match_player] = p
	for i in range(match_players.size()): match_players[i]["has_ball"] = false
	player_run_target = Vector2.ZERO

func _match_pass() -> void:
	if not key_play_active or match_owner != 0: return
	var carrier := _carrier_index(0)
	if carrier < 0: carrier = selected_match_player
	var ppos: Vector2 = match_players[carrier]["pos"]
	var best := -INF
	var target := -1
	for i in range(11):
		if i == carrier: continue
		var candidate: Vector2 = match_players[i]["pos"]
		var forward: float = candidate.x - ppos.x
		var distance: float = ppos.distance_to(candidate)
		var lane_pressure := 0.0
		for j in range(11, 22):
			var enemy: Vector2 = match_players[j]["pos"]
			if enemy.distance_to(ppos.lerp(candidate, 0.5)) < 55.0: lane_pressure += 35.0
		var score: float = forward * 0.8 - distance * 0.25 - lane_pressure
		if distance < 340.0 and score > best: best = score; target = i
	if target >= 0: _match_pass_to(target)

func _match_pass_to(target: int) -> void:
	if match_owner != 0 or target < 0 or target >= 11: return
	var carrier := _carrier_index(0)
	if carrier < 0: carrier = selected_match_player
	var start: Vector2 = match_players[carrier]["pos"]
	var target_pos: Vector2 = match_players[target]["pos"]
	var distance: float = start.distance_to(target_pos)
	var pass_skill: float = float(match_players[carrier].get("pas", 60.0))
	var lead: Vector2 = target_pos + Vector2(match_players[target]["vel"]) * clampf(distance / 450.0, 0.15, 0.65)
	var direction: Vector2 = (lead - start).normalized()
	var accuracy_error: float = (100.0 - pass_skill) * 0.0018
	direction = direction.rotated(rng.randf_range(-accuracy_error, accuracy_error))
	selected_match_player = carrier
	_match_kick(direction, true)
	# Pass remains interceptable; selected player switches once the ball is clearly traveling.
	selected_match_player = target

func _match_tackle() -> void:
	if not key_play_active or match_owner != 1 or match_paused: return
	var defender: Dictionary = match_players[selected_match_player]
	var defender_pos: Vector2 = defender["pos"]
	var carrier := _carrier_index(1)
	if carrier < 0: return
	var attacker_pos: Vector2 = match_players[carrier]["pos"]
	var distance: float = defender_pos.distance_to(attacker_pos)
	if distance > 48.0:
		match_event_text = "APROXIME-SE PARA DESARMAR"
		match_event_timer = 1.0
		return
	var facing: Vector2 = defender["dir"]
	var toward_ball: Vector2 = defender_pos.direction_to(attacker_pos)
	var facing_bonus: float = 0.12 if facing.dot(toward_ball) > 0.25 else -0.08
	var tackle_chance: float = clampf(0.24 + float(defender.get("tck", 60.0)) * 0.004 + facing_bonus - float(match_players[carrier].get("ctl", 60.0)) * 0.0015, 0.12, 0.72)
	if rng.randf() < tackle_chance:
		_resolve_ball_possession(0)
		match_ball = defender_pos + toward_ball * 10.0
		match_ball_vel = Vector2.ZERO
		match_event_text = "DESARME LIMPO!"
		match_event_timer = 1.1
		match_state = "TACKLE"
	else:
		defender["anim"] = "tackle"
		defender["cooldown"] = 0.7
		match_players[selected_match_player] = defender
		match_event_text = "DESARME FALHOU"
		match_event_timer = 0.8

func _match_ai_pass(carrier_index: int) -> void:
	if carrier_index < 0 or carrier_index >= match_players.size(): return
	var team: int = int(match_players[carrier_index]["team"])
	var start: Vector2 = match_players[carrier_index]["pos"]
	var best := -INF
	var target := -1
	for i in range(team * 11, team * 11 + 11):
		if i == carrier_index: continue
		var candidate: Vector2 = match_players[i]["pos"]
		var forward: float = (start.x - candidate.x) if team == 1 else (candidate.x - start.x)
		var distance: float = start.distance_to(candidate)
		if distance > 350.0: continue
		var score: float = forward * 0.7 - distance * 0.22 + rng.randf_range(-12.0, 12.0)
		if score > best: best = score; target = i
	if target >= 0:
		var target_pos: Vector2 = match_players[target]["pos"] + Vector2(match_players[target]["vel"]) * 0.25
		match_ball_vel = (target_pos - start).normalized() * (390.0 + float(match_players[carrier_index].get("pas", 60.0)) * 1.6)
		match_ball = start
		match_owner = -1
		match_last_touch_team = team
		match_state = "PASS"
		for i in range(match_players.size()): match_players[i]["has_ball"] = false

func _match_ai_shot(carrier_index: int) -> void:
	var p: Dictionary = match_players[carrier_index]
	var pos: Vector2 = p["pos"]
	var target_goal := Vector2(84.0, rng.randf_range(326.0, 394.0)) if int(p["team"]) == 1 else Vector2(1196.0, rng.randf_range(326.0, 394.0))
	var direction: Vector2 = (target_goal - pos).normalized()
	var shot_skill: float = float(p.get("sho", 60.0))
	direction = direction.rotated(rng.randf_range(-0.16, 0.16) * (1.2 - shot_skill / 150.0))
	match_ball = pos + direction * 18.0
	match_ball_vel = direction * (440.0 + shot_skill * 2.0)
	match_ball_height = 0.0
	match_ball_vertical_speed = rng.randf_range(20.0, 90.0)
	match_owner = -1
	match_last_touch_team = int(p["team"])
	match_state = "SHOT"
	pending_ball_action = "opponent_shot"
	for i in range(match_players.size()): match_players[i]["has_ball"] = false

func _handle_match_key(key: int) -> void:
	if key == KEY_P: match_paused = not match_paused; return
	if match_over: return
	if key == KEY_F: _fast_forward_match()
	elif key == KEY_SPACE:
		var direction := Vector2.RIGHT if selected_match_player < 11 else Vector2.LEFT
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W): direction.y = -0.35
		if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S): direction.y = 0.35
		_match_kick(direction)
	elif key == KEY_J: _match_pass()
	elif key == KEY_K: _match_pass_to(_best_through_pass_target())
	elif key == KEY_TAB:
		selected_match_player = _next_controlled_player()
	elif key == KEY_Q: _match_tackle()
	elif key == KEY_ESCAPE: match_paused = true

func _best_through_pass_target() -> int:
	var carrier := _carrier_index(0)
	if carrier < 0: carrier = selected_match_player
	var best := -INF
	var target := -1
	for i in range(11):
		if i == carrier: continue
		var pos: Vector2 = match_players[i]["pos"]
		var score: float = (pos.x - match_ball.x) - match_ball.distance_to(pos) * 0.25
		if pos.x > match_ball.x and score > best: best = score; target = i
	if target >= 0:
		var lead: Vector2 = match_players[target]["pos"] + Vector2(75.0, 0.0) + Vector2(match_players[target]["vel"]) * 0.35
		_match_kick(lead - match_ball, true)
	return target

func _next_controlled_player() -> int:
	if match_owner == 0: return posmod(selected_match_player + 1, 11)
	var best := _nearest_team_player(match_ball, 0)
	return best if best >= 0 else posmod(selected_match_player + 1, 11)

func _fast_forward_match() -> void:
	if match_over or match_paused: return
	# A short forward step, while retaining live physics and collision checks.
	for i in range(15): _update_match(0.08)

func _simulate_match() -> void:
	if match_over: return
	var fixture := _next_fixture()
	var opponent: String = str(fixture.get("away", "")) if fixture.get("home", "") == club_name else str(fixture.get("home", ""))
	var own_total := 0.0
	for player in roster: own_total += float(player.get("rating", 65))
	var own_power: float = own_total / maxf(1.0, float(roster.size()))
	var power_gap: float = own_power - _club_power(opponent)
	var user_expected_goals: float = clampf(1.35 + power_gap / 18.0, 0.3, 3.4)
	var opponent_expected_goals: float = clampf(1.25 - power_gap / 20.0, 0.3, 3.2)
	match_score = [_sample_goals(user_expected_goals), _sample_goals(opponent_expected_goals)]
	match_clock = match_time_limit
	match_over = true

func _sample_goals(expected: float) -> int:
	var product := 1.0
	var threshold := exp(-expected)
	var goals := 0
	while product > threshold and goals < 7:
		product *= rng.randf()
		goals += 1
	return goals - 1

func _club_power(team: String) -> float:
	var powers := {
		"Flamengo":78.0, "Palmeiras":78.0, "Arsenal":78.0, "Chelsea":76.0, "Liverpool":79.0,
		"Manchester City":81.0, "Manchester United":75.0, "Barcelona":80.0, "Real Madrid":82.0,
		"Inter":79.0, "Milan":76.0, "Juventus":76.0, "Benfica":77.0, "Porto":76.0,
		"Ajax":75.0, "Boca Juniors":75.0, "River Plate":76.0, "Inter Miami":74.0,
		"Roasso Kumamoto":66.0, "Nara Club":64.0, "Fukushima United FC":64.0
	}
	return float(powers.get(team, 68.0))

func _finish_match() -> void:
	var fixture := _next_fixture()
	if fixture.is_empty(): screen = "career"; return
	var user_home: bool = fixture["home"] == club_name
	var user_goals: int = match_score[0]
	var opponent_goals: int = match_score[1]
	goals_for += user_goals; goals_against += opponent_goals
	var home_row: Dictionary = _team_row(fixture["home"])
	var away_row: Dictionary = _team_row(fixture["away"])
	fixture["played"] = true
	fixture["hs"] = match_score[0] if user_home else match_score[1]
	fixture["as"] = match_score[1] if user_home else match_score[0]
	_apply_result(home_row, away_row, int(fixture["hs"]), int(fixture["as"]))
	if user_goals > opponent_goals: points += 3; wins += 1
	elif user_goals == opponent_goals: points += 1; draws += 1
	else: losses += 1
	last_match_result = "%s  %d–%d  %s" % [fixture["home"], fixture["hs"], fixture["as"], fixture["away"]]
	round_number += 1
	if round_number > LEAGUES[league_index]["teams"].size() - 1:
		var user_row: Dictionary = _team_row(club_name)
		var user_rank := 1
		for row in league_table:
			if str(row.get("name", "")) == club_name: continue
			var row_difference: int = int(row.get("gf", 0)) - int(row.get("ga", 0))
			var user_difference: int = int(user_row.get("gf", 0)) - int(user_row.get("ga", 0))
			if int(row.get("pts", 0)) > int(user_row.get("pts", 0)) or (int(row.get("pts", 0)) == int(user_row.get("pts", 0)) and row_difference > user_difference):
				user_rank += 1
		budget += maxi(300000, (9 - user_rank) * 550000)
		_develop_roster()
		if roster.size() < 25:
			var youth_pos: String = ["GK", "DEF", "MID", "ATT"][rng.randi_range(0, 3)]
			var youth_rating: int = rng.randi_range(51, 62)
			var youth: Dictionary = {"name":FIRST_NAMES[rng.randi_range(0, FIRST_NAMES.size() - 1)] + " " + LAST_NAMES[rng.randi_range(0, LAST_NAMES.size() - 1)], "pos":youth_pos, "rating":youth_rating, "age":rng.randi_range(17, 19), "spd":rng.randi_range(50, 78), "pas":rng.randi_range(50, 78), "sho":rng.randi_range(45, 74), "tck":rng.randi_range(45, 78), "gk":rng.randi_range(45, 78), "fitness":100, "number":roster.size() + 1}
			roster.append(youth)
			bench.append(roster.size() - 1)
		banner = "TEMPORADA %d • %dº LUGAR • BASE + JOVEM PROMOVIDO" % [season, user_rank]
		banner_time = 4.0
		season += 1
		round_number = 1
		points = 0; wins = 0; draws = 0; losses = 0; goals_for = 0; goals_against = 0
		_generate_league()
		_refresh_transfer_market()
	_save_game()
	screen = "career"

func _team_row(name: String) -> Dictionary:
	for row in league_table:
		if row["name"] == name: return row
	return {}

func _simulate_ai_round() -> void:
	for fixture in fixtures:
		if int(fixture["round"]) != round_number or fixture["played"]: continue
		if fixture["home"] == club_name or fixture["away"] == club_name: continue
		fixture["played"] = true
		fixture["hs"] = rng.randi_range(0, 3)
		fixture["as"] = rng.randi_range(0, 3)
		var home := _team_row(fixture["home"]); var away := _team_row(fixture["away"])
		_apply_result(home, away, int(fixture["hs"]), int(fixture["as"]))

func _apply_result(home: Dictionary, away: Dictionary, home_goals: int, away_goals: int) -> void:
	home["p"] += 1; away["p"] += 1
	home["gf"] += home_goals; home["ga"] += away_goals
	away["gf"] += away_goals; away["ga"] += home_goals
	if home_goals > away_goals: home["w"] += 1; home["pts"] += 3; away["l"] += 1
	elif home_goals < away_goals: away["w"] += 1; away["pts"] += 3; home["l"] += 1
	else: home["d"] += 1; away["d"] += 1; home["pts"] += 1; away["pts"] += 1

func _cycle_formation(step: int) -> void:
	formation_index = posmod(formation_index + step, FORMATIONS.size())
	selected_player = -1
	_save_game()

func _select_lineup_player(pos: Vector2) -> void:
	var coords := _formation_positions()
	for i in range(coords.size()):
		if pos.distance_to(coords[i]) < 36:
			if selected_player < 0:
				selected_player = i
			else:
				var swap := i
				var temp: Dictionary = roster[selected_player]
				roster[selected_player] = roster[swap]
				roster[swap] = temp
				selected_player = -1
				_save_game()
				return
	for i in range(11, roster.size()):
		var bench_index: int = i - 11
		var bench_rect := Rect2(790 + float(bench_index % 3) * 151, 180 + float(bench_index / 3) * 56, 145, 54)
		if bench_rect.has_point(pos):
			var starter_index: int = mini(bench_index, 10)
			var starter: Dictionary = roster[starter_index]
			roster[starter_index] = roster[i]
			roster[i] = starter
			_save_game()
			return

func _formation_positions() -> Array[Vector2]:
	var shape: Array = FORMATIONS[formation_index]
	var result: Array[Vector2] = [Vector2(394, 575)]
	var rows: Array[int] = [shape[0], shape[1], shape[2]]
	for row in range(rows.size()):
		for j in range(rows[row]):
			var x: float = 46.0 + (float(j + 1) / float(rows[row] + 1)) * 700.0
			var y: float = 472.0 - float(row) * 116.0
			result.append(Vector2(x, y))
	while result.size() < 11: result.append(Vector2(394, 535))
	return result

func _market_action(pos: Vector2) -> void:
	if Rect2(850, 210, 100, 38).has_point(pos):
		if transfer_offer.is_empty(): return
		var player_index: int = int(transfer_offer.get("player_index", -1))
		if player_index < 11 or player_index >= roster.size():
			banner = "NAO HA SUBSTITUTO PARA NEGOCIAR"
			banner_time = 1.8
			return
		var sold_name: String = str(roster[player_index].get("name", "Jogador"))
		var fee: int = int(transfer_offer.get("fee", 0))
		budget += fee
		roster.remove_at(player_index)
		bench.clear()
		for roster_index in range(11, roster.size()): bench.append(roster_index)
		banner = sold_name + " VENDIDO • $" + _money(fee)
		banner_time = 2.0
		_refresh_transfer_market()
		_save_game()
		return
	if Rect2(958, 210, 82, 38).has_point(pos):
		if transfer_offer.is_empty(): return
		if rng.randf() < 0.65:
			transfer_offer["fee"] = int(float(transfer_offer.get("fee", 0)) * 1.12)
			banner = "CONTRAOFERTA ENVIADA • $" + _money(int(transfer_offer["fee"]))
		else:
			transfer_offer = {}
			banner = "O CLUBE RETIROU A OFERTA"
		banner_time = 2.0
		_save_game()
		return
	for i in range(market_candidates.size()):
		if Rect2(1080, 414 + i * 34, 104, 29).has_point(pos):
			var candidate: Dictionary = market_candidates[i]
			var fee: int = int(candidate.get("fee", 0))
			if roster.size() >= 25:
				banner = "ELENCO CHEIO • VENDA UM JOGADOR PRIMEIRO"
				banner_time = 2.0
				return
			if budget < fee:
				banner = "VERBA INSUFICIENTE PARA CONTRATAR"
				banner_time = 1.8
				return
			budget -= fee
			var signing: Dictionary = candidate.duplicate(true)
			signing.erase("fee")
			signing.erase("club")
			signing["number"] = roster.size() + 1
			signing["fitness"] = 100
			roster.append(signing)
			bench.append(roster.size() - 1)
			banner = str(signing.get("name", "Jogador")) + " CONTRATADO • $" + _money(fee)
			banner_time = 2.0
			market_candidates.remove_at(i)
			_save_game()
			return

func _refresh_transfer_market() -> void:
	market_candidates.clear()
	var positions: Array[String] = ["GK", "DEF", "MID", "ATT"]
	for i in range(6):
		var pos: String = positions[i % positions.size()]
		var age: int = rng.randi_range(17, 29)
		var rating: int = rng.randi_range(55, 72) if i < 4 else rng.randi_range(62, 79)
		var first: String = FIRST_NAMES[rng.randi_range(0, FIRST_NAMES.size() - 1)]
		var last: String = LAST_NAMES[rng.randi_range(0, LAST_NAMES.size() - 1)]
		var player: Dictionary = {"name":first + " " + last, "pos":pos, "rating":rating, "age":age,
			"spd":rng.randi_range(48, 88), "pas":rng.randi_range(48, 88), "sho":rng.randi_range(45, 88),
			"tck":rng.randi_range(45, 88), "gk":rng.randi_range(40, 88), "number":0,
			"fitness":100, "fee":_player_value(rating, age), "club":"Mercado livre"}
		market_candidates.append(player)
	transfer_offer = {}
	if roster.size() > 11:
		var offered_index: int = rng.randi_range(11, roster.size() - 1)
		var offered_player: Dictionary = roster[offered_index]
		var value: int = _player_value(int(offered_player.get("rating", 60)), int(offered_player.get("age", 25)))
		transfer_offer = {"player_index":offered_index, "fee":int(float(value) * rng.randf_range(0.82, 1.24))}

func _player_value(rating: int, age: int) -> int:
	var potential_bonus: float = 1.0 + clampf(float(23 - age) * 0.025, 0.0, 0.35)
	var experience_factor: float = 1.0 - clampf(float(age - 29) * 0.045, 0.0, 0.35)
	return maxi(150000, int((200000.0 + float(rating * rating) * 250.0) * potential_bonus * experience_factor))

func _develop_roster() -> void:
	for i in range(roster.size()):
		var player: Dictionary = roster[i]
		var age: int = int(player.get("age", 24)) + 1
		var rating: int = int(player.get("rating", 60))
		if age <= 22 and rating < 92 and rng.randf() < 0.72:
			rating += 1
		elif age >= 31 and rating > 40 and rng.randf() < 0.45:
			rating -= 1
		player["age"] = age
		player["rating"] = rating
		roster[i] = player

func _cached_asset_texture(cache_key: String) -> Texture2D:
	if asset_textures.has(cache_key): return asset_textures[cache_key] as Texture2D
	for extension in ["svg", "png"]:
		var cache_path := "user://asset-cache/%s.%s" % [cache_key, extension]
		if not FileAccess.file_exists(cache_path): continue
		var cached_bytes := FileAccess.get_file_as_bytes(cache_path)
		var cached_image := Image.new()
		var image_error: Error = cached_image.load_svg_from_string(cached_bytes.get_string_from_utf8()) if extension == "svg" else cached_image.load_png_from_buffer(cached_bytes)
		if image_error == OK and cached_image.get_width() > 0 and cached_image.get_height() > 0:
			var cached_texture := ImageTexture.create_from_image(cached_image)
			asset_textures[cache_key] = cached_texture
			return cached_texture
	return null

func _download_all_assets() -> void:
	if not active_asset_request.is_empty() or not asset_queue.is_empty(): return
	asset_requests_started.clear()
	asset_download_success = 0
	asset_download_failures = 0
	asset_notice = ""
	asset_notice_time = 0.0
	asset_failure_hint = ""
	asset_queue.clear()
	var download_order: Array = []
	if league_index >= 0 and league_index < LEAGUES.size(): download_order.append(LEAGUES[league_index])
	for index in range(LEAGUES.size()):
		if index != league_index: download_order.append(LEAGUES[index])
	for league in download_order:
		var flag_code: String = str(league["flag"])
		_queue_asset_download("flags/4x3/%s" % flag_code, "https://raw.githubusercontent.com/lipis/flag-icons/refs/heads/main/flags/4x3/%s.svg" % flag_code)
		var competition_asset := _league_badge_download(league)
		if not competition_asset.is_empty():
			_queue_asset_download(str(competition_asset["key"]), str(competition_asset["url"]))
		for team in league.get("team_logos", []):
			var file_name := _logo_file_name(str(team), league)
			if file_name.is_empty(): continue
			var club_asset := _logo_asset(_asset_folder(league).path_join(file_name))
			_queue_asset_download(str(club_asset["key"]), str(club_asset["url"]))
	var cup_paths: Dictionary = football_logo_manifest.get("cups", {})
	for relative_path in cup_paths.values():
		var cup_asset := _logo_asset(str(relative_path))
		_queue_asset_download(str(cup_asset["key"]), str(cup_asset["url"]))
	asset_download_total = asset_queue.size() + (1 if not active_asset_request.is_empty() else 0)
	if asset_download_total == 0: asset_download_total = asset_download_success + asset_download_failures
	if active_asset_request.is_empty() and asset_queue.is_empty(): _set_asset_completion_notice()

func _remove_cached_crests() -> void:
	var flags_left: Array[Dictionary] = []
	for item in asset_queue:
		if not str(item.get("key", "")).begins_with("logos/"): flags_left.append(item)
	asset_queue = flags_left
	if not active_asset_request.is_empty() and str(active_asset_request.get("key", "")).begins_with("logos/"):
		active_asset_request["discard"] = true
	for key in asset_textures.keys():
		if str(key).begins_with("logos/"): asset_textures.erase(key)
	for key in asset_requests_started.keys():
		if str(key).begins_with("logos/"): asset_requests_started.erase(key)
	var logo_cache_path := "user://asset-cache/logos"
	_remove_cached_directory(logo_cache_path)
	asset_download_total = asset_queue.size() + (1 if not active_asset_request.is_empty() and not bool(active_asset_request.get("discard", false)) else 0)
	asset_download_success = 0
	asset_download_failures = 0
	asset_notice = "Escudos removidos deste aparelho."
	asset_notice_time = 4.0
	queue_redraw()

func _request_assets_back() -> void:
	# Downloads stay in the background; a large world catalog must not trap the player here.
	screen = "home"

func _set_asset_completion_notice() -> void:
	if asset_download_failures == 0:
		asset_notice = "Download concluído com sucesso!"
	else:
		asset_notice = "Download concluído: %d imagem(ns) não disponível(is). %s" % [asset_download_failures, asset_failure_hint]
	asset_notice_time = 5.0

func _asset_request_error(result: int, response_code: int) -> String:
	if response_code == 404: return "Arquivo não encontrado na fonte."
	if result == HTTPRequest.RESULT_CANT_CONNECT or result == HTTPRequest.RESULT_CANT_RESOLVE:
		return "Sem conexão. No Android, ative INTERNET na exportação e gere um novo APK."
	if result == HTTPRequest.RESULT_TLS_HANDSHAKE_ERROR: return "Falha segura de conexão com a fonte."
	if result == HTTPRequest.RESULT_TIMEOUT: return "A conexão expirou. Verifique a internet e tente novamente."
	if response_code > 0: return "A fonte respondeu com erro HTTP %d." % response_code
	return "Falha de rede (código %d)." % result

func _asset_connection_failed(result: int) -> bool:
	return result == HTTPRequest.RESULT_CANT_CONNECT or result == HTTPRequest.RESULT_CANT_RESOLVE or result == HTTPRequest.RESULT_TLS_HANDSHAKE_ERROR or result == HTTPRequest.RESULT_TIMEOUT

func _remove_cached_directory(path: String) -> void:
	var directory := DirAccess.open(path)
	if directory == null: return
	directory.list_dir_begin()
	var entry := directory.get_next()
	while entry != "":
		if entry != "." and entry != "..":
			var child_path := path.path_join(entry)
			if directory.current_is_dir(): _remove_cached_directory(child_path)
			else: directory.remove(entry)
		entry = directory.get_next()
	directory.list_dir_end()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func _logo_file_name(team: String, league: Dictionary = {}) -> String:
	var clubs: Dictionary = football_logo_manifest.get("clubs", {}).get(str(league.get("country", "")), {})
	return str(clubs.get(team, ""))

func _league_badge_file(league: Dictionary) -> String:
	var key := "%s|%s" % [str(league.get("country", "")), str(league.get("name", ""))]
	var relative_path := str(football_logo_manifest.get("leagues", {}).get(key, ""))
	return relative_path.get_file() if relative_path != "" else ""

func _league_badge_download(league: Dictionary) -> Dictionary:
	var key := "%s|%s" % [str(league.get("country", "")), str(league.get("name", ""))]
	var relative_path := str(football_logo_manifest.get("leagues", {}).get(key, ""))
	return _logo_asset(relative_path) if relative_path != "" else {}

func _cup_logo_asset(cup_name: String) -> Dictionary:
	var relative_path := str(football_logo_manifest.get("cups", {}).get(cup_name, ""))
	return _logo_asset(relative_path) if relative_path != "" else {}

func _logo_asset(relative_path: String) -> Dictionary:
	if relative_path == "": return {}
	var encoded_parts: PackedStringArray = []
	for part in relative_path.split("/", false):
		encoded_parts.append(str(part).uri_encode())
	var key := "logos/%s" % relative_path.trim_suffix(".svg")
	return {
		"key":key,
		"path":"logos/%s" % relative_path,
		"name":relative_path.get_file().trim_suffix(".svg"),
		"url":"https://raw.githubusercontent.com/JoseArroyave/football-logos/refs/heads/main/logos/%s" % "/".join(encoded_parts),
		"extension":"svg"
	}

func _asset_folder(league: Dictionary) -> String:
	var explicit_folder := str(league.get("asset_folder", ""))
	if explicit_folder != "": return explicit_folder
	var country_folders := {
		"Brasil":"brazil", "Inglaterra":"england", "Espanha":"spain", "Itália":"italy", "Portugal":"portugal",
		"Países Baixos":"netherlands", "Argentina":"argentina", "Estados Unidos":"usa", "Japão":"japan", "México":"mexico",
		"Alemanha":"germany", "França":"france", "Arábia Saudita":"saudi-arabia", "China":"china"
	}
	return str(country_folders.get(str(league.get("country", "")), league.get("folder", "")))

func _queue_asset_download(cache_key: String, url: String) -> void:
	if asset_requests_started.has(cache_key): return
	for extension in ["svg", "png"]:
		if FileAccess.file_exists("user://asset-cache/%s.%s" % [cache_key, extension]): return
	asset_requests_started[cache_key] = true
	var extension := "png" if url.get_extension().to_lower() == "png" else "svg"
	if not active_asset_request.is_empty() or not asset_queue.is_empty():
		asset_queue.append({"key":cache_key, "url":url, "extension":extension})
		return
	asset_queue.append({"key":cache_key, "url":url, "extension":extension})
	_start_next_asset_download()

func _start_next_asset_download() -> void:
	if not active_asset_request.is_empty() or asset_queue.is_empty(): return
	active_asset_request = asset_queue.pop_front()
	var error: Error = asset_http.request(str(active_asset_request["url"]))
	if error != OK:
		if _retry_active_asset_download(): return
		asset_download_failures += 1
		asset_failure_hint = "Falha ao iniciar download: %s" % error_string(error)
		active_asset_request = {}
		_start_next_asset_download()

func _retry_active_asset_download() -> bool:
	if active_asset_request.is_empty(): return false
	var attempts := int(active_asset_request.get("attempts", 0))
	if attempts >= 2: return false
	active_asset_request["attempts"] = attempts + 1
	return asset_http.request(str(active_asset_request.get("url", ""))) == OK

func _on_asset_download_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if not active_asset_request.is_empty() and not bool(active_asset_request.get("discard", false)):
		if response_code == 200:
			var image := Image.new()
			var extension := str(active_asset_request.get("extension", "svg"))
			var image_error: Error = image.load_png_from_buffer(body) if extension == "png" else image.load_svg_from_string(body.get_string_from_utf8())
			if image_error == OK and image.get_width() > 0 and image.get_height() > 0:
				var key: String = str(active_asset_request["key"])
				asset_textures[key] = ImageTexture.create_from_image(image)
				var cache_path := "user://asset-cache/%s.%s" % [key, extension]
				var absolute_dir := ProjectSettings.globalize_path(cache_path.get_base_dir())
				DirAccess.make_dir_recursive_absolute(absolute_dir)
				var cache_file := FileAccess.open(cache_path, FileAccess.WRITE)
				if cache_file != null:
					cache_file.store_buffer(body)
					asset_download_success += 1
				else:
					asset_download_failures += 1
					asset_failure_hint = "Não foi possível salvar no aparelho."
			else:
				asset_download_failures += 1
				asset_failure_hint = "A fonte enviou um arquivo de imagem inválido."
		else:
			var can_retry := _asset_connection_failed(result) or response_code >= 500
			if can_retry and _retry_active_asset_download(): return
			asset_download_failures += 1
			asset_failure_hint = _asset_request_error(result, response_code)
	active_asset_request = {}
	queue_redraw()
	_start_next_asset_download()
	if active_asset_request.is_empty() and asset_queue.is_empty() and asset_download_total > 0: _set_asset_completion_notice()

func _load_image_texture(path: String) -> Texture2D:
	var texture_cache_key := "local:" + path
	if asset_textures.has(texture_cache_key): return asset_textures[texture_cache_key] as Texture2D
	# SVG imports can resolve to Godot's white placeholder texture (notably on
	# first launch or after adding the logo folders). Decode the source file so
	# badges and flags do not depend on the editor import cache.
	if path.get_extension().to_lower() == "svg":
		if not FileAccess.file_exists(path):
			asset_textures[texture_cache_key] = null
			return null
		var svg_image := Image.new()
		var svg_error: Error = svg_image.load_svg_from_string(FileAccess.get_file_as_string(path))
		if svg_error == OK and svg_image.get_width() > 0 and svg_image.get_height() > 0:
			var svg_texture := ImageTexture.create_from_image(svg_image)
			asset_textures[texture_cache_key] = svg_texture
			return svg_texture
		asset_textures[texture_cache_key] = null
		return null
	if not ResourceLoader.exists(path):
		asset_textures[texture_cache_key] = null
		return null
	var loaded_resource: Resource = load(path)
	if loaded_resource is Texture2D and loaded_resource.get_class() != "PlaceholderTexture2D":
		asset_textures[texture_cache_key] = loaded_resource as Texture2D
		return loaded_resource as Texture2D
	asset_textures[texture_cache_key] = null
	return null

func _reset_after_goal() -> void:
	match_ball_vel = Vector2.ZERO
	match_ball_height = 0.0

func _money(value: int) -> String:
	if value >= 1000000: return "%.1f mi" % (float(value) / 1000000.0)
	return "%d mil" % int(value / 1000)
