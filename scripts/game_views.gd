extends "res://scripts/game_logic.gd"

func _draw() -> void:
	if screen != "match":
		draw_rect(Rect2(0, 0, W, H), BG, true)
	match screen:
		"home": _draw_home()
		"assets": _draw_assets()
		"saves": _draw_save_slots()
		"select": _draw_select()
		"squad": _draw_squad()
		"career": _draw_career()
		"calendar": _draw_calendar()
		"standings": _draw_standings()
		"market": _draw_market()
		"match": _draw_match()
	if banner_time > 0: _draw_banner()
	if match_setup_open: _draw_match_setup()
	if sim_result_open: _draw_sim_result()
	if save_overwrite_confirm: _draw_overwrite_confirmation()

func _label(text: String, x: float, y: float, size: int, color: Color = TEXT, width: float = -1, align: int = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	draw_string(ThemeDB.fallback_font, Vector2(x, y), text, align, width, size, color)

func _panel(rect: Rect2, color: Color = PANEL) -> void:
	draw_rect(rect, color, true)
	draw_rect(rect, LINE, false, 1.0)

func _draw_brand_mark(rect: Rect2) -> void:
	if brand_mark_texture != null:
		_draw_texture_fit(brand_mark_texture, rect)
		return
	draw_circle(rect.get_center(), rect.size.y * 0.46, Color("f2f2e7"))
	draw_circle(rect.get_center(), rect.size.y * 0.35, Color("226c46"))
	_label("⚽", rect.position.x + rect.size.x * 0.2, rect.position.y + rect.size.y * 0.72, int(rect.size.y * 0.48), TEXT)

func _button(rect: Rect2, text: String, active: bool = false) -> void:
	draw_rect(rect, WSC_GREEN if active else Color("303655"), true)
	draw_rect(rect, Color("4fa26b") if active else Color("515a7a"), false, 1.0)
	_label(text, rect.position.x + 10, rect.position.y + rect.size.y * 0.62, 15, TEXT, rect.size.x - 20, HORIZONTAL_ALIGNMENT_CENTER)

func _topbar(title: String, sub: String = "") -> void:
	draw_rect(Rect2(0, 0, W, 70), WSC_GREEN, true)
	_draw_brand_mark(Rect2(18, 8, 54, 54))
	_label(title, 88, 34, 20, TEXT)
	_label(sub, 88, 56, 12, Color("d4e6d7"))
	_button(Rect2(1124, 13, 136, 44), "VOLTAR")

func _wsc_team_header(right_text: String = "VOLTAR") -> void:
	var league: Dictionary = LEAGUES[league_index]
	var club_color: Color = _club_color(club_name)
	draw_rect(Rect2(0, 0, W, 68), club_color, true)
	_label("☰", 20, 43, 24, TEXT)
	_draw_crest(club_name, league, Rect2(47, 10, 46, 46))
	_label(club_name, 108, 43, 23, TEXT)
	_button(Rect2(1100, 12, 158, 44), right_text, right_text == "CONTINUAR")

func _club_color(team: String) -> Color:
	var colors := {
		"Flamengo": Color("b51d32"), "Palmeiras": Color("087446"), "Corinthians": Color("171717"),
		"Arsenal": Color("c72c35"), "Chelsea": Color("174d9b"), "Liverpool": Color("bd2735"),
		"Barcelona": Color("9e2639"), "Real Madrid": Color("f3f0e4"), "Inter": Color("153970"),
		"Juventus": Color("24272b"), "Benfica": Color("c62532"), "Porto": Color("1e4a8d"),
		"Ajax": Color("c72b36"), "Boca Juniors": Color("e9c52d"), "River Plate": Color("eeeeea"),
		"Inter Miami": Color("e477a0"), "Kashima Antlers": Color("b92b38"), "Urawa Reds": Color("bb2333"),
		"Roasso Kumamoto": Color("c52036"), "América": Color("bd2838"), "Guadalajara": Color("c52c3b")
	}
	return colors.get(team, WSC_GREEN)

func _dashboard_card(rect: Rect2, title: String, detail: String, accent: Color = WSC_GOLD) -> void:
	draw_rect(rect, WSC_CARD, true)
	draw_rect(Rect2(rect.position.x, rect.position.y, rect.size.x, 5), accent, true)
	draw_rect(rect, Color("414765"), false, 1.0)
	_label(title.to_upper(), rect.position.x + 17, rect.position.y + 31, 14, Color("e5e7ef"), rect.size.x - 32)
	var detail_lines: PackedStringArray = detail.split("\n")
	for i in range(detail_lines.size()):
		var safe_line: String = detail_lines[i]
		if safe_line.length() > 29: safe_line = safe_line.substr(0, 28) + "…"
		_label(safe_line, rect.position.x + 17, rect.position.y + 67 + i * 22, 14, TEXT, rect.size.x - 32)

func _draw_match_setup() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0.02, 0.03, 0.08, 0.78), true)
	_panel(Rect2(350, 220, 580, 310), Color("20243f"))
	var fixture := _next_fixture()
	var opponent := str(fixture.get("away", "—")) if fixture.get("home", "") == club_name else str(fixture.get("home", "—"))
	_label("PRÓXIMA PARTIDA", 0, 272, 14, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
	var club_display: String = club_name if club_name.length() <= 17 else club_name.substr(0, 16) + "…"
	var opponent_display: String = opponent if opponent.length() <= 17 else opponent.substr(0, 16) + "…"
	_label(club_display + "   x   " + opponent_display, 385, 322, 20, TEXT, 510, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Semana %d  •  %s" % [round_number, LEAGUES[league_index]["name"]], 0, 350, 14, MUTED, W, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(460, 374, 170, 58), "JOGAR", true)
	_button(Rect2(650, 374, 170, 58), "SIMULAR")
	_button(Rect2(540, 450, 200, 44), "VOLTAR")

func _draw_sim_result() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0.02, 0.03, 0.08, 0.82), true)
	_panel(Rect2(350, 225, 580, 300), Color("20243f"))
	_label("PARTIDA SIMULADA", 0, 274, 14, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
	var home_display: String = sim_result_home if sim_result_home.length() <= 17 else sim_result_home.substr(0, 16) + "…"
	var away_display: String = sim_result_away if sim_result_away.length() <= 17 else sim_result_away.substr(0, 16) + "…"
	_label(home_display, 390, 344, 17, TEXT, 195, HORIZONTAL_ALIGNMENT_CENTER)
	_label("%d  -  %d" % [sim_result_home_score, sim_result_away_score], 550, 348, 28, TEXT, 180, HORIZONTAL_ALIGNMENT_CENTER)
	_label(away_display, 735, 344, 17, TEXT, 195, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(500, 442, 280, 54), "CONTINUAR", true)

func _mini_player_card(index: int, rect: Rect2, reserve: bool = false) -> void:
	if index < 0 or index >= roster.size(): return
	var p: Dictionary = roster[index]
	var tile := Color("d9e1dc") if not reserve else Color("cfd5dd")
	draw_rect(rect, tile, true)
	draw_rect(rect, Color("aab6bd"), false, 1.0)
	var badge_color := Color("3d8058") if int(p["rating"]) >= 64 else Color("9a8734")
	draw_circle(Vector2(rect.position.x + 20, rect.position.y + 21), 15, badge_color)
	_label(str(p["rating"]), rect.position.x + 7, rect.position.y + 26, 12, TEXT, 26, HORIZONTAL_ALIGNMENT_CENTER)
	_label(str(p["pos"]), rect.position.x + 42, rect.position.y + 20, 10, Color("3e4654"))
	var player_name: String = str(p["name"])
	if player_name.length() > 17: player_name = player_name.substr(0, 16) + "…"
	_label(player_name, rect.position.x + 7, rect.position.y + 51, 11, Color("282f3d"), rect.size.x - 12)

func _draw_home() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	draw_rect(Rect2(0, 0, W, 70), WSC_GREEN, true)
	_draw_brand_mark(Rect2(18, 8, 54, 54))
	_label("CLUB LEGACY", 88, 43, 20, TEXT)
	draw_rect(Rect2(64, 112, 1152, 530), Color("202543"), true)
	_label("CLUB LEGACY", 0, 220, 22, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("CARREIRA", 0, 303, 54, TEXT, W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Escolha um clube para começar sua temporada", 0, 344, 17, Color("bac1d0"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(484, 392, 312, 58), "NOVA CARREIRA", true)
	_button(Rect2(484, 465, 312, 50), "CARREIRAS SALVAS")
	_button(Rect2(484, 538, 312, 50), "IMAGENS E ARMAZENAMENTO")

func _draw_save_slots() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	_topbar("CARREIRAS SALVAS", "ESCOLHA UM DOS QUATRO SLOTS")
	_panel(Rect2(140, 92, 1000, 550), Color("202543"))
	_label("Quatro espaços para suas carreiras", 0, 124, 20, TEXT, W, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(SAVE_SLOT_COUNT):
		var slot := i + 1
		var y: float = 142 + i * 112
		var card := Rect2(180, y, 920, 92)
		var summary: Dictionary = save_slot_summaries[i] if i < save_slot_summaries.size() else {"exists":false}
		draw_rect(card, Color("2a2e4c"), true)
		draw_rect(card, Color("414765"), false, 1.0)
		_label("SLOT %d" % slot, 198, y + 25, 12, WSC_GOLD)
		if bool(summary.get("exists", false)):
			var team: String = str(summary.get("club", "Clube"))
			_draw_team_badge(team, Rect2(270, y + 14, 62, 62))
			_label(team, 350, y + 40, 19, TEXT, 420)
			_label("Temporada %d    •    Dinheiro: $%s" % [int(summary.get("season", 1)), _money(int(summary.get("budget", 0)))], 350, y + 67, 14, MUTED, 450)
			_button(Rect2(850, y + 18, 220, 56), "CARREGAR" if save_screen_mode == "load" else "ESCOLHER SLOT", save_screen_mode == "load")
		else:
			_label("Vazio  •  escolha um clube para começar", 270, y + 53, 16, MUTED, 520)
			_button(Rect2(850, y + 18, 220, 56), "NOVO SAVE")
	_label("A carreira é salva automaticamente no slot escolhido.", 0, 610, 13, MUTED, W, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_overwrite_confirmation() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0.02, 0.03, 0.08, 0.82), true)
	_panel(Rect2(350, 230, 580, 260), Color("20243f"))
	_label("SUBSTITUIR CARREIRA?", 0, 292, 24, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("O Slot %d será substituído pelo save de %s." % [overwrite_confirm_slot, LEAGUES[pending_new_league]["teams"][pending_new_club]], 385, 342, 16, TEXT, 510, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Essa ação apaga a carreira que está nesse slot.", 0, 372, 14, MUTED, W, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(402, 382, 210, 54), "SUBSTITUIR SLOT", true)
	_button(Rect2(632, 382, 210, 54), "CANCELAR")

func _draw_assets() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	_topbar("IMAGENS E ARMAZENAMENTO", "BAIXE OU REMOVA ARQUIVOS DO JOGO")
	_panel(Rect2(220, 130, 840, 500), Color("202543"))
	var glow_alpha := 0.16 + 0.08 * sin(asset_animation_time * 2.4)
	draw_rect(Rect2(220, 130, 840, 500), Color(0.35, 0.72, 0.58, glow_alpha), false, 2.0)
	_label("Bandeiras, escudos e competições", 0, 205, 30, TEXT, W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Baixe as imagens quando quiser. Elas ficam salvas neste aparelho.", 0, 246, 17, Color("bac1d0"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Sem download, o jogo mostra versões simples que ocupam menos espaço.", 0, 274, 15, Color("bac1d0"), W, HORIZONTAL_ALIGNMENT_CENTER)
	var preview_league: Dictionary = LEAGUES[league_index]
	var preview_flag_code: String = str(preview_league.get("flag", ""))
	var preview_flag_rect := Rect2(348, 284, 48, 34)
	var preview_flag_texture := _load_image_texture("res://assets/flag-icons/flags/4x3/%s.svg" % preview_flag_code)
	if not _draw_texture_fit(preview_flag_texture, preview_flag_rect):
		var cached_flag := _cached_asset_texture("flags/4x3/%s" % preview_flag_code)
		if not _draw_texture_fit(cached_flag, preview_flag_rect): _draw_flag(preview_flag_code, preview_flag_rect)
	_draw_league_badge(preview_league, Rect2(616, 281, 40, 40))
	var preview_teams: Array = preview_league.get("teams", [])
	if preview_teams.is_empty():
		_draw_fallback_crest("Clube", Rect2(884, 281, 40, 40))
	else:
		var preview_club_index: int = clampi(club_index, 0, preview_teams.size() - 1)
		_draw_crest(str(preview_teams[preview_club_index]), preview_league, Rect2(884, 281, 40, 40))
	_label("PAÍS", 320, 328, 10, MUTED, 104, HORIZONTAL_ALIGNMENT_CENTER)
	_label("COMPETIÇÃO", 574, 328, 10, MUTED, 124, HORIZONTAL_ALIGNMENT_CENTER)
	_label("CLUBE", 852, 328, 10, MUTED, 104, HORIZONTAL_ALIGNMENT_CENTER)
	var is_downloading := not active_asset_request.is_empty() or not asset_queue.is_empty()
	_button(Rect2(384, 340, 512, 58), "BAIXAR / ATUALIZAR IMAGENS DO JOGO", not is_downloading)
	_button(Rect2(384, 416, 512, 58), "REMOVER ESCUDOS BAIXADOS")
	if is_downloading:
		var completed := asset_download_success + asset_download_failures
		var percent := int(round(100.0 * float(completed) / float(maxi(1, asset_download_total))))
		var progress_bar := Rect2(280, 484, 720, 18)
		draw_rect(progress_bar, Color("11182c"), true)
		draw_rect(Rect2(progress_bar.position.x, progress_bar.position.y, progress_bar.size.x * float(percent) / 100.0, progress_bar.size.y), WSC_GREEN, true)
		var shine_x := progress_bar.position.x + fposmod(asset_animation_time * 260.0, progress_bar.size.x)
		if percent < 100: draw_rect(Rect2(shine_x - 18, progress_bar.position.y + 2, 36, progress_bar.size.y - 4), Color(1, 1, 1, 0.28), true)
		draw_rect(progress_bar, Color("64708e"), false, 1.0)
		_label("%d%%" % percent, 0, 533, 20, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
		_label("Baixando: %d de %d  •  %d falhas" % [completed, asset_download_total, asset_download_failures], 0, 562, 13, MUTED, W, HORIZONTAL_ALIGNMENT_CENTER)
	elif asset_download_total > 0:
		var finished_bar := Rect2(280, 484, 720, 18)
		draw_rect(finished_bar, WSC_GREEN if asset_download_failures == 0 else Color("bf8f28"), true)
		draw_rect(finished_bar, Color("64708e"), false, 1.0)
		_label("100%", 0, 533, 20, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
		var finished_notice_alpha := 0.72 + 0.28 * absf(sin(asset_animation_time * 4.0)) if asset_notice_time > 0 else 1.0
		var finished_notice_color := Color("8af0bd", finished_notice_alpha) if asset_download_failures == 0 else Color("ffd27a", finished_notice_alpha)
		_label("Download concluído com sucesso!" if asset_download_failures == 0 else "Download concluído com falhas.", 0, 562, 14, finished_notice_color, W, HORIZONTAL_ALIGNMENT_CENTER)
		if asset_download_failures > 0: _label(asset_failure_hint, 250, 590, 12, Color("ffd27a"), 780, HORIZONTAL_ALIGNMENT_CENTER)
	else:
		var idle_notice_alpha := 0.72 + 0.28 * absf(sin(asset_animation_time * 4.0)) if asset_notice_time > 0 else 1.0
		var idle_notice_color := Color("8af0bd", idle_notice_alpha) if asset_notice_time > 0 else MUTED
		_label(asset_notice if asset_notice != "" else "Remover escudos preserva as bandeiras baixadas.", 0, 526, 15, idle_notice_color, W, HORIZONTAL_ALIGNMENT_CENTER)
	if is_downloading and asset_notice_time > 0: _label(asset_notice, 0, 590, 14, Color("ffd27a"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Escudos, competições e bandeiras são salvos neste aparelho.", 0, 610, 13, MUTED, W, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_select() -> void:
	draw_rect(Rect2(0, 0, W, H), Color("e8e9ec"), true)
	draw_rect(Rect2(0, 0, W, 68), Color("5bc5ae"), true)
	_label("‹", 22, 48, 38, TEXT)
	_draw_brand_mark(Rect2(64, 10, 48, 48))
	_label("CLUB LEGACY", 120, 43, 22, Color("153d48"))
	_button(Rect2(1120, 12, 132, 44), "ESCOLHER SLOT", true)
	_label("Nova Carreira  /  Escolher Liga", 0, 100, 21, Color("263849"), W, HORIZONTAL_ALIGNMENT_CENTER)
	var league: Dictionary = LEAGUES[league_index]
	_panel(Rect2(40, 126, 570, 495), Color("17233a"))
	draw_rect(Rect2(52, 143, 546, 36), Color("263650"), true)
	_label("PAÍS", 70, 167, 13, Color("d5dbe4"))
	_label("LIGA", 305, 167, 13, Color("d5dbe4"))
	_label("TOP 7 TIMES", 484, 167, 13, Color("d5dbe4"))
	for visible_row in range(LEAGUE_ROWS_PER_PAGE):
		var display_index := league_list_offset + visible_row
		if display_index >= country_display_order.size(): break
		var i := country_display_order[display_index]
		var row_y: float = 181 + visible_row * 40
		var selected_country := str(LEAGUES[league_index].get("country", "")) == str(LEAGUES[i].get("country", ""))
		if selected_country: draw_rect(Rect2(52, row_y, 546, 39), Color("3c5367"), true)
		var flag_path := "res://assets/flag-icons/flags/4x3/%s.svg" % LEAGUES[i]["flag"]
		var flag_rect := Rect2(68, row_y + 8, 28, 20)
		var local_flag_texture := _load_image_texture(flag_path)
		if not _draw_texture_fit(local_flag_texture, flag_rect):
			var flag_code: String = str(LEAGUES[i]["flag"])
			var flag_texture := _cached_asset_texture("flags/4x3/%s" % flag_code)
			if not _draw_texture_fit(flag_texture, flag_rect): _draw_flag(flag_code, flag_rect)
		_label(str(LEAGUES[i]["country"]), 108, row_y + 26, 14, Color("f1f2f4"), 172)
		_label(_country_league_name(str(LEAGUES[i]["country"])), 286, row_y + 26, 12, Color("c1c9d4"), 156)
		_label("★★★", 480, row_y + 26, 14, WSC_GOLD)
	var page_count := ceili(float(country_display_order.size()) / LEAGUE_ROWS_PER_PAGE)
	var current_page := int(league_list_offset / LEAGUE_ROWS_PER_PAGE) + 1
	_button(Rect2(448, 592, 52, 24), "◀")
	_label("%d / %d" % [current_page, page_count], 500, 610, 12, Color("c1c9d4"), 42, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(542, 592, 52, 24), "▶")
	draw_rect(Rect2(630, 126, 610, 495), Color("17233a"), true)
	_label("CLUBES MAIS FORTES", 630, 166, 13, Color("c6ced9"), 610, HORIZONTAL_ALIGNMENT_CENTER)
	var competition_title := str(league["country"]).to_upper() + "  •  " + str(league["name"])
	_draw_league_badge(league, Rect2(758, 190, 38, 38))
	_button(Rect2(798, 190, 330, 38), competition_title + "  ▾")
	var teams: Array = league["teams"]
	_button(Rect2(645, 285, 48, 48), "◀")
	_button(Rect2(1175, 285, 48, 48), "▶")
	var selected_team: String = str(teams[club_index])
	_draw_crest(selected_team, league, Rect2(865, 244, 120, 120))
	_label(selected_team.to_upper(), 690, 402, 22, Color("f3f4f6"), 520, HORIZONTAL_ALIGNMENT_CENTER)
	_label("COPAS E TORNEIOS POSSÍVEIS", 640, 436, 13, Color("c6ced9"), 590, HORIZONTAL_ALIGNMENT_CENTER)
	var competitions := _country_competitions(str(league.get("country", "")))
	for competition_index in range(competitions.size()):
		var column := competition_index % 3
		var row := int(competition_index / 3)
		var chip_rect := Rect2(650 + column * 194, 445 + row * 32, 184, 28)
		draw_rect(chip_rect, Color("263650"), true)
		draw_rect(chip_rect, Color("40546c"), false, 1.0)
		var cup_asset := _cup_logo_asset(competitions[competition_index])
		var label_x := chip_rect.position.x + 7
		var label_width := chip_rect.size.x - 14
		if not cup_asset.is_empty():
			var cup_texture := _cached_asset_texture(str(cup_asset["key"]))
			if cup_texture != null:
				_draw_texture_fit(cup_texture, Rect2(chip_rect.position.x + 5, chip_rect.position.y + 3, 22, 22))
				label_x += 22
				label_width -= 22
		_label(_competition_short_name(competitions[competition_index]), label_x, chip_rect.position.y + 19, 11, TEXT, label_width, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Vagas continentais dependem da classificação.", 650, 548, 11, Color("9eacbd"), 580, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(855, 560, 336, 54), "COMEÇAR CARREIRA", true)
	_label("←/→ muda o país  •  A/D muda o clube", 34, 690, 12, MUTED)
	if division_picker_open:
		var divisions := _division_picker_indices(str(league.get("country", "")))
		var menu_rect := Rect2(798, 233, 330, divisions.size() * 36.0)
		draw_rect(menu_rect, Color("263650"), true)
		draw_rect(menu_rect, Color("536b83"), false, 1.0)
		for row in range(divisions.size()):
			var division_index: int = divisions[row]
			var row_rect := Rect2(menu_rect.position.x + 1, menu_rect.position.y + row * 36.0, menu_rect.size.x - 2, 35)
			if division_index == league_index: draw_rect(row_rect, Color("3c5367"), true)
			_label(str(LEAGUES[division_index].get("name", "")), row_rect.position.x + 14, row_rect.position.y + 24, 15, TEXT, row_rect.size.x - 28)

func _draw_crest(team: String, league: Dictionary, rect: Rect2) -> void:
	if not league.get("team_logos", []).has(team):
		_draw_fallback_crest(team, rect)
		return
	var file_name := _logo_file_name(team, league)
	if file_name.is_empty():
		_draw_fallback_crest(team, rect)
		return
	var asset := _logo_asset(_asset_folder(league).path_join(file_name))
	var path := "res://assets/football-logos-source/%s" % str(asset["path"])
	if _draw_texture_fit(_load_image_texture(path), rect): return
	if _draw_texture_fit(_cached_asset_texture(str(asset["key"])), rect): return
	_draw_fallback_crest(team, rect)

func _draw_fallback_crest(team: String, rect: Rect2) -> void:
	var side: float = minf(rect.size.x, rect.size.y)
	var center := rect.get_center()
	var badge_rect := Rect2(center.x - side * 0.38, center.y - side * 0.45, side * 0.76, side * 0.9)
	var badge_color: Color = _club_color(team)
	var points := PackedVector2Array([
		Vector2(badge_rect.position.x, badge_rect.position.y),
		Vector2(badge_rect.end.x, badge_rect.position.y),
		Vector2(badge_rect.end.x, badge_rect.position.y + badge_rect.size.y * 0.68),
		Vector2(center.x, badge_rect.end.y),
		Vector2(badge_rect.position.x, badge_rect.position.y + badge_rect.size.y * 0.68)
	])
	draw_colored_polygon(points, badge_color)
	draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[4], points[0]]), Color("f4f0dd"), maxf(1.0, side * 0.035), true)
	draw_rect(Rect2(badge_rect.position.x + side * 0.12, badge_rect.position.y + side * 0.12, side * 0.52, side * 0.12), Color("f4f0dd"), true)
	var initials := ""
	for word in team.split(" ", false):
		if not word.is_empty(): initials += word.substr(0, 1)
	if initials.length() > 3: initials = initials.substr(0, 3)
	var letter_size: int = clampi(int(side * 0.27), 9, 34)
	_label(initials, badge_rect.position.x, center.y + side * 0.16, letter_size, Color("f4f0dd"), badge_rect.size.x, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_flag(code: String, rect: Rect2) -> void:
	var colors: Array[Color] = []
	match code:
		"br": colors = [Color("168447"), Color("f4d12e"), Color("2456a6")]
		"gb-eng": colors = [Color("ffffff"), Color("d51e36"), Color("ffffff")]
		"es": colors = [Color("aa151b"), Color("f1bf00"), Color("aa151b")]
		"it": colors = [Color("009246"), Color("ffffff"), Color("ce2b37")]
		"pt": colors = [Color("006600"), Color("ff0000")]
		"nl": colors = [Color("ae1c28"), Color("ffffff"), Color("21468b")]
		"ar": colors = [Color("74acdf"), Color("ffffff"), Color("74acdf")]
		"us": colors = [Color("b22234"), Color("ffffff"), Color("b22234"), Color("ffffff"), Color("b22234"), Color("ffffff"), Color("b22234")]
		"jp": colors = [Color("ffffff")]
		"mx": colors = [Color("006847"), Color("ffffff"), Color("ce1126")]
		_: colors = [Color("ffffff"), Color("68758a"), Color("ffffff")]
	draw_rect(rect, Color("ffffff"), true)
	if code == "it" or code == "mx" or code == "pt":
		var stripe_width: float = rect.size.x / float(colors.size())
		for i in range(colors.size()):
			draw_rect(Rect2(rect.position.x + stripe_width * i, rect.position.y, stripe_width + 0.5, rect.size.y), colors[i], true)
	else:
		var stripe_height: float = rect.size.y / float(colors.size())
		for i in range(colors.size()):
			draw_rect(Rect2(rect.position.x, rect.position.y + stripe_height * i, rect.size.x, stripe_height + 0.5), colors[i], true)
	if code == "gb-eng":
		draw_rect(Rect2(rect.position.x + rect.size.x * 0.42, rect.position.y, rect.size.x * 0.16, rect.size.y), Color("d51e36"), true)
		draw_rect(Rect2(rect.position.x, rect.position.y + rect.size.y * 0.38, rect.size.x, rect.size.y * 0.24), Color("d51e36"), true)
	elif code == "jp": draw_circle(rect.get_center(), rect.size.y * 0.27, Color("bc002d"))
	elif code == "br":
		var diamond := PackedVector2Array([rect.get_center() + Vector2(0, -rect.size.y * 0.32), rect.get_center() + Vector2(rect.size.x * 0.38, 0), rect.get_center() + Vector2(0, rect.size.y * 0.32), rect.get_center() + Vector2(-rect.size.x * 0.38, 0)])
		draw_colored_polygon(diamond, Color("f4d12e"))
		draw_circle(rect.get_center(), rect.size.y * 0.16, Color("2456a6"))
	draw_rect(rect, Color("d7dce2"), false, 1.0)

func _draw_team_badge(team: String, rect: Rect2) -> void:
	for league in LEAGUES:
		if league["teams"].has(team):
			_draw_crest(team, league, rect)
			return

func _draw_league_badge(league: Dictionary, rect: Rect2) -> void:
	var badge_asset := _league_badge_download(league)
	if not badge_asset.is_empty():
		var cache_key := str(badge_asset["key"])
		var local_path := "res://assets/football-logos-source/%s" % str(badge_asset["path"])
		if _draw_texture_fit(_load_image_texture(local_path), rect): return
		if _draw_texture_fit(_cached_asset_texture(cache_key), rect): return
	var country: String = str(league["country"])
	var initials := {"Brasil":"BRA", "Inglaterra":"PL", "Espanha":"LALIGA", "Itália":"SA", "Portugal":"PT", "Países Baixos":"ERE", "Argentina":"ARG", "Estados Unidos":"MLS", "Japão":"J3", "México":"MX"}
	var colors := {"Brasil":Color("168447"), "Inglaterra":Color("5c2d91"), "Espanha":Color("e6533e"), "Itália":Color("1769aa"), "Portugal":Color("006600"), "Países Baixos":Color("e87525"), "Argentina":Color("74acdf"), "Estados Unidos":Color("26376f"), "Japão":Color("bc002d"), "México":Color("006847")}
	var side: float = minf(rect.size.x, rect.size.y)
	var center := rect.get_center()
	var badge := Rect2(center.x - side * 0.4, center.y - side * 0.45, side * 0.8, side * 0.9)
	draw_rect(badge, colors.get(country, Color("35465e")), true)
	draw_rect(badge, Color("f2f2e7"), false, 1.0)
	draw_rect(Rect2(badge.position.x, badge.position.y + side * 0.12, badge.size.x, side * 0.1), Color("f1c82f"), true)
	_label(str(initials.get(country, "LIGA")), badge.position.x, center.y + side * 0.2, 10, Color("ffffff"), badge.size.x, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_texture_fit(texture: Texture2D, rect: Rect2) -> bool:
	if texture == null: return false
	var source_size := texture.get_size()
	if source_size.x <= 0 or source_size.y <= 0: return false
	var fit_scale := minf(rect.size.x / source_size.x, rect.size.y / source_size.y)
	var fitted_size := source_size * fit_scale
	draw_texture_rect(texture, Rect2(rect.position + (rect.size - fitted_size) * 0.5, fitted_size), false)
	return true

func _draw_squad() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	_wsc_team_header()
	draw_rect(Rect2(0, 68, W, 54), Color("222744"), true)
	_button(Rect2(18, 76, 120, 38), "MEU TIME", true)
	_button(Rect2(144, 76, 120, 38), "FUNÇÕES")
	_label("Gestão do Time", 0, 106, 17, Color("e1e3ed"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("2  ◈     1  ◇     $%s      %d" % [_money(budget), 105], 890, 105, 12, WSC_GOLD, 360, HORIZONTAL_ALIGNMENT_RIGHT)
	_draw_pitch_art(Rect2(20, 136, 744, 500), false)
	var coords := _formation_positions()
	for i in range(mini(11, coords.size())):
		var p: Dictionary = roster[i]
		var pos: Vector2 = coords[i]
		var selected: bool = selected_player == i
		draw_circle(pos + Vector2(0, 4), 19, Color(0.04, 0.06, 0.05, 0.35))
		draw_circle(pos, 20, WSC_GOLD if selected else Color("f5f5ef"))
		draw_circle(pos, 16, Color("376f51"))
		_label(str(p["rating"]), pos.x - 15, pos.y + 4, 12, TEXT, 30, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(p["pos"]), pos.x - 18, pos.y - 23, 9, Color("f4d557"), 36, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(p["name"]).split(" ")[0], pos.x - 49, pos.y + 37, 11, TEXT, 98, HORIZONTAL_ALIGNMENT_CENTER)
	draw_rect(Rect2(782, 136, 478, 500), Color("252a46"), true)
	draw_rect(Rect2(782, 136, 478, 40), Color("e4e6ea"), true)
	_label("SUPLENTES  /  RESERVAS", 792, 162, 14, Color("303647"), 458, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(11, roster.size()):
		var bench_index: int = i - 11
		var bench_x: float = 790 + float(bench_index % 3) * 151
		var bench_y: float = 180 + float(bench_index / 3) * 56
		if bench_y + 54 <= 634: _mini_player_card(i, Rect2(bench_x, bench_y, 145, 54), true)
	_label("FORMAÇÃO  " + _formation_text(), 24, 680, 14, TEXT)
	_label("Clique para selecionar  •  toque num reserva para substituir", 268, 680, 13, Color("bbc2d1"), 410, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(700, 650, 260, 52), "MENTALIDADE: " + ["DEFENSIVA", "EQUILIBRADA", "OFENSIVA"][mentality])
	_button(Rect2(980, 650, 270, 52), "FORMAÇÃO  ↻", true)

func _draw_stat(name: String, value: int, x: float, y: float) -> void:
	_label(name, x, y, 11, MUTED)
	var r := Rect2(x + 58, y - 10, 198, 7)
	draw_rect(r, Color("26384b"), true)
	draw_rect(Rect2(r.position, Vector2(r.size.x * float(value) / 100.0, r.size.y)), MINT if value >= 70 else Color("e3b85d"), true)
	_label(str(value), x + 277, y, 11, TEXT)

func _draw_career() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	_wsc_team_header("CONTINUAR")
	draw_rect(Rect2(0, 68, W, 48), Color("202543"), true)
	var start_year: int = 2026 + season - 1
	_label("Ano %d (%d/%d) - Semana %d" % [season, start_year, start_year + 1, round_number], 24, 99, 16, Color("e5e6eb"))
	_label("2  ◈      1  ◇      $%s      %d" % [_money(budget), 105], 850, 99, 14, WSC_GOLD, 390, HORIZONTAL_ALIGNMENT_RIGHT)
	var f := _next_fixture()
	var opponent: String = str(f.get("away", "—")) if f.get("home", "") == club_name else str(f.get("home", "—"))
	var card_w: float = 294
	var card_h: float = 158
	_dashboard_card(Rect2(18, 130, card_w, card_h), "PRÓXIMO JOGO", "Amistoso\n" + opponent, Color("f0c92e"))
	_dashboard_card(Rect2(324, 130, card_w, card_h), "GESTÃO DO TIME", _formation_text() + "  •  Energia 100%", Color("54bd5e"))
	_dashboard_card(Rect2(630, 130, card_w, card_h), "TREINAMENTO", "Nível de treinamento\n5/20", Color("d7c43d"))
	_dashboard_card(Rect2(936, 130, card_w, card_h), "ACADEMIA", "★ ★ ★ ★ ☆   5/20", Color("e2c345"))
	_dashboard_card(Rect2(18, 305, card_w, card_h), "CALENDÁRIO", "Próximos jogos\nRodada " + str(round_number), Color("6c9ad1"))
	_dashboard_card(Rect2(324, 305, card_w, card_h), "TRANSFERÊNCIAS", "Saídas   " + str(roster.size()), Color("d87055"))
	_dashboard_card(Rect2(630, 305, card_w, card_h), "OLHEIROS", "Rede de observação", Color("b4b8ce"))
	_dashboard_card(Rect2(936, 305, card_w, card_h), "FUNÇÕES", "Organize sua equipe", Color("67b9ad"))
	_dashboard_card(Rect2(18, 480, card_w, card_h), str(LEAGUES[league_index]["name"]), "Classificação\n" + ("Sem partidas disputadas" if round_number == 1 else "%d pontos" % points), Color("9a73cd"))
	_dashboard_card(Rect2(324, 480, card_w, card_h), "ESTAT. JOGADOR", "Melhor média\n" + str(roster[0].get("name", "—")), Color("6ba3d1"))
	_dashboard_card(Rect2(630, 480, card_w, card_h), "SALA TROFÉUS", "%d troféus" % (season - 1), Color("dfb44f"))
	_dashboard_card(Rect2(936, 480, card_w, card_h), "JOGADORES", "%d no elenco" % roster.size(), Color("bc6685"))

func _draw_tabs(current: String) -> void:
	_button(Rect2(330, 96, 170, 48), "CLASSIFICAÇÃO", current == "career")
	_button(Rect2(510, 96, 170, 48), "ELENCO")
	_button(Rect2(690, 96, 170, 48), "MERCADO")

func _draw_table(x: float, y: float, width: float) -> void:
	_label("#   CLUBE                                   PJ    V    E    D   PTS", x, y, 11, MUTED)
	var sorted := league_table.duplicate()
	sorted.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["pts"]) > int(b["pts"]))
	for i in range(sorted.size()):
		var row: Dictionary = sorted[i]
		var yy: float = y + 37 + i * 38
		if row["user"]: draw_rect(Rect2(x - 12, yy - 20, width, 30), Color(0.19, 0.48, 0.38, 0.45), true)
		_label("%02d" % (i + 1), x, yy, 12, MUTED)
		_draw_team_badge(str(row["name"]), Rect2(x + 32, yy - 12, 24, 24))
		_label(str(row["name"]), x + 63, yy, 12, TEXT, 280)
		_label(str(row["p"]), x + 455, yy, 12, TEXT, 32, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["w"]), x + 505, yy, 12, TEXT, 32, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["d"]), x + 550, yy, 12, TEXT, 32, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["l"]), x + 595, yy, 12, TEXT, 32, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["pts"]), x + 645, yy, 12, MINT, 38, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_calendar() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	_topbar("CALENDÁRIO", "%s  •  TEMPORADA %d" % [LEAGUES[league_index]["name"], season])
	draw_rect(Rect2(0, 70, W, 47), Color("202543"), true)
	_label("JOGOS DA TEMPORADA", 28, 100, 15, Color("e5e7ef"))
	_panel(Rect2(36, 132, 1208, 510), Color("20243f"))
	draw_rect(Rect2(54, 150, 1172, 42), Color("343a5d"), true)
	_label("SEMANA", 72, 177, 12, Color("d5d9e5"))
	_label("MANDANTE", 236, 177, 12, Color("d5d9e5"))
	_label("PLACAR", 658, 177, 12, Color("d5d9e5"), 100, HORIZONTAL_ALIGNMENT_CENTER)
	_label("VISITANTE", 820, 177, 12, Color("d5d9e5"))
	for i in range(fixtures.size()):
		var f: Dictionary = fixtures[i]
		var y: float = 218 + i * 47
		if y > 574: break
		if i % 2 == 0: draw_rect(Rect2(54, y - 27, 1172, 42), Color("292e4b"), true)
		var result: String = "%d  -  %d" % [f["hs"], f["as"]] if f["played"] else "VS"
		var active: bool = int(f["round"]) == round_number
		if active: draw_rect(Rect2(54, y - 27, 1172, 42), Color("345a4c"), true)
		_label("SEMANA %02d" % f["round"], 72, y, 12, Color("c4c9d7"))
		_draw_team_badge(str(f["home"]), Rect2(202, y - 14, 25, 25))
		_label(str(f["home"]), 236, y, 14, TEXT)
		_label(result, 658, y, 14, WSC_GOLD, 100, HORIZONTAL_ALIGNMENT_CENTER)
		_draw_team_badge(str(f["away"]), Rect2(786, y - 14, 25, 25))
		_label(str(f["away"]), 820, y, 14, TEXT)
	_button(Rect2(700, 650, 260, 50), "JOGAR PRÓXIMO", true)
	_button(Rect2(970, 650, 270, 50), "SIMULAR PRÓXIMO")

func _draw_standings() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	draw_rect(Rect2(0, 0, W, 72), Color("741d73"), true)
	_label("3   " + str(LEAGUES[league_index]["name"]), 28, 32, 22, TEXT)
	_label("Grupo  •  Classificação", 104, 57, 12, Color("e4cfe4"))
	_button(Rect2(1092, 13, 166, 44), "CONTINUAR", true)
	_button(Rect2(24, 84, 176, 36), "ARTILHEIROS")
	_button(Rect2(208, 84, 176, 36), "ASSISTÊNCIAS")
	_panel(Rect2(56, 134, 1168, 506), Color("20243f"))
	draw_rect(Rect2(74, 150, 1132, 42), Color("343a5d"), true)
	_label("#", 88, 177, 12, Color("d5d9e5"))
	_label("TIME", 138, 177, 12, Color("d5d9e5"))
	_label("J", 650, 177, 12, Color("d5d9e5"), 34, HORIZONTAL_ALIGNMENT_CENTER)
	_label("V", 704, 177, 12, Color("d5d9e5"), 34, HORIZONTAL_ALIGNMENT_CENTER)
	_label("E", 758, 177, 12, Color("d5d9e5"), 34, HORIZONTAL_ALIGNMENT_CENTER)
	_label("D", 812, 177, 12, Color("d5d9e5"), 34, HORIZONTAL_ALIGNMENT_CENTER)
	_label("GF", 866, 177, 12, Color("d5d9e5"), 42, HORIZONTAL_ALIGNMENT_CENTER)
	_label("GS", 922, 177, 12, Color("d5d9e5"), 42, HORIZONTAL_ALIGNMENT_CENTER)
	_label("+/-", 986, 177, 12, Color("d5d9e5"), 54, HORIZONTAL_ALIGNMENT_CENTER)
	_label("PTS", 1080, 177, 12, Color("d5d9e5"), 70, HORIZONTAL_ALIGNMENT_CENTER)
	var sorted := league_table.duplicate()
	sorted.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["pts"]) > int(b["pts"]))
	for i in range(sorted.size()):
		var row: Dictionary = sorted[i]
		var y: float = 218 + float(i) * 48
		if i % 2 == 0: draw_rect(Rect2(74, y - 25, 1132, 42), Color("2a2e4a"), true)
		if bool(row["user"]): draw_rect(Rect2(74, y - 25, 1132, 42), Color(0.1, 0.42, 0.29, 0.62), true)
		_label(str(i + 1), 88, y, 13, Color("d5d9e5"))
		_draw_team_badge(str(row["name"]), Rect2(112, y - 12, 24, 24))
		_label(str(row["name"]), 146, y, 14, TEXT, 490)
		_label(str(row["p"]), 650, y, 13, TEXT, 34, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["w"]), 704, y, 13, TEXT, 34, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["d"]), 758, y, 13, TEXT, 34, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["l"]), 812, y, 13, TEXT, 34, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["gf"]), 866, y, 13, TEXT, 42, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["ga"]), 922, y, 13, TEXT, 42, HORIZONTAL_ALIGNMENT_CENTER)
		_label("%+d" % (int(row["gf"]) - int(row["ga"])), 986, y, 13, TEXT, 54, HORIZONTAL_ALIGNMENT_CENTER)
		_label(str(row["pts"]), 1080, y, 13, WSC_GOLD, 70, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(1000, 650, 250, 50), "CONTINUAR", true)

func _draw_market() -> void:
	draw_rect(Rect2(0, 0, W, H), WSC_NAVY, true)
	_wsc_team_header()
	draw_rect(Rect2(0, 68, W, 52), Color("202543"), true)
	_label("MERCADO DE TRANSFERÊNCIAS", 0, 102, 18, Color("e5e7ef"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("$%s     %d" % [_money(budget), 105], 1000, 102, 13, WSC_GOLD, 230, HORIZONTAL_ALIGNMENT_RIGHT)
	_panel(Rect2(210, 132, 860, 132), Color("20243f"))
	_label("OFERTA POR UM JOGADOR DO ELENCO", 238, 162, 14, Color("e1e3ed"))
	draw_rect(Rect2(236, 176, 808, 34), Color("343a5d"), true)
	_label("JOGADOR", 254, 199, 11, Color("d5d9e5"))
	_label("IDADE", 588, 199, 11, Color("d5d9e5"))
	_label("OFERTA", 680, 199, 11, Color("d5d9e5"))
	if not transfer_offer.is_empty() and int(transfer_offer.get("player_index", -1)) < roster.size():
		var offer_player: Dictionary = roster[int(transfer_offer.get("player_index", 0))]
		_label(str(offer_player.get("pos", "")) + "   " + str(offer_player.get("name", "")), 254, 240, 14, TEXT, 330)
		_label(str(offer_player.get("age", "—")), 588, 240, 13, Color("d9e0e9"))
		_label("$%s" % _money(int(transfer_offer.get("fee", 0))), 680, 240, 13, WSC_GOLD)
		_button(Rect2(850, 210, 100, 38), "ACEITAR", true)
		_button(Rect2(958, 210, 82, 38), "NEGOCIAR")
	else:
		_label("Nenhuma oferta no momento", 254, 240, 14, MUTED)
	_panel(Rect2(54, 282, 1172, 362), Color("20243f"))
	_label("OBSERVAÇÃO DE JOGADORES", 78, 314, 14, Color("e1e3ed"))
	_label("Jovens promessas e atletas disponíveis • contrate dentro da verba", 78, 336, 12, Color("aab1c3"))
	draw_rect(Rect2(78, 350, 1124, 38), Color("343a5d"), true)
	_label("JOGADOR", 96, 375, 11, Color("d5d9e5"))
	_label("PONTOS", 620, 375, 11, Color("d5d9e5"))
	_label("IDADE", 786, 375, 11, Color("d5d9e5"))
	_label("VALOR", 940, 375, 11, Color("d5d9e5"))
	for i in range(market_candidates.size()):
		var y: float = 435 + i * 34
		var player: Dictionary = market_candidates[i]
		if i % 2 == 0: draw_rect(Rect2(78, y - 23, 1124, 30), Color("292e4b"), true)
		_label(str(player.get("pos", "")) + "   " + str(player.get("name", "")), 96, y, 13, TEXT)
		_label(str(player.get("rating", 0)), 620, y, 13, WSC_GOLD)
		_label(str(player.get("age", 0)), 786, y, 13, Color("d2d7e0"))
		_label("$" + _money(int(player.get("fee", 0))), 940, y, 13, Color("f2c86d"))
		_button(Rect2(1080, y - 21, 104, 29), "CONTRATAR")
	_button(Rect2(1000, 650, 250, 50), "VOLTAR", true)

func _draw_match() -> void:
	draw_rect(Rect2(0, 68, W, 588), Color("124a2d"), true)
	# A subtle trapezoid gives the pitch a diagonal/2.5D read without changing gameplay coordinates.
	var field := Rect2(32, 82, W - 64, 548)
	var pitch_poly := PackedVector2Array([Vector2(72, 82), Vector2(1208, 82), Vector2(1260, 630), Vector2(20, 630)])
	draw_colored_polygon(pitch_poly, Color("1c7542"))
	for stripe in range(10):
		if stripe % 2 == 0:
			var stripe_rect := Rect2(field.position.x + field.size.x * float(stripe) / 10.0, field.position.y, field.size.x / 10.0, field.size.y)
			draw_rect(stripe_rect, Color("25894d"), true)
	var line_color := Color("edf5e8", 0.92)
	draw_rect(field, line_color, false, 2)
	draw_line(Vector2(field.get_center().x, field.position.y), Vector2(field.get_center().x, field.end.y), line_color, 2)
	draw_arc(field.get_center(), 76, 0, TAU, 48, line_color, 2)
	draw_circle(field.get_center(), 3, line_color)
	var box_height: float = field.size.y * 0.56
	var box_y: float = field.get_center().y - box_height * 0.5
	draw_rect(Rect2(field.position.x, box_y, 150, box_height), line_color, false, 2)
	draw_rect(Rect2(field.end.x - 150, box_y, 150, box_height), line_color, false, 2)
	draw_rect(Rect2(field.position.x, field.get_center().y - 54, 56, 108), line_color, false, 2)
	draw_rect(Rect2(field.end.x - 56, field.get_center().y - 54, 56, 108), line_color, false, 2)
	draw_arc(Vector2(field.position.x + 116, field.get_center().y), 60, -PI * 0.37, PI * 0.37, 24, line_color, 2)
	draw_arc(Vector2(field.end.x - 116, field.get_center().y), 60, PI * 0.63, PI * 1.37, 24, line_color, 2)
	draw_rect(Rect2(18, field.get_center().y - 52, 14, 104), Color("cfdad2"), false, 2)
	draw_rect(Rect2(field.end.x, field.get_center().y - 52, 14, 104), Color("cfdad2"), false, 2)
	var fixture := _next_fixture()
	var left_name: String = club_name
	var right_name: String = str(fixture.get("away", "Adversário")) if fixture.get("home", "") == club_name else str(fixture.get("home", "Adversário"))
	draw_rect(Rect2(0, 0, 510, 68), _club_color(left_name), true)
	draw_rect(Rect2(510, 0, 260, 68), Color("10131f"), true)
	draw_rect(Rect2(770, 0, 510, 68), _club_color(right_name), true)
	_draw_team_badge(left_name, Rect2(16, 10, 48, 48))
	var display_left: String = left_name if left_name.length() < 27 else left_name.substr(0, 25) + "…"
	var display_right: String = right_name if right_name.length() < 27 else right_name.substr(0, 25) + "…"
	_label(display_left, 77, 42, 15, TEXT, 415)
	_label("%d   %02d   %d" % [match_score[0], mini(90, int(match_clock / match_time_limit * 90)), match_score[1]], 510, 44, 23, TEXT, 260, HORIZONTAL_ALIGNMENT_CENTER)
	_draw_team_badge(right_name, Rect2(1216, 10, 48, 48))
	_label(display_right, 792, 42, 15, TEXT, 410, HORIZONTAL_ALIGNMENT_RIGHT)
	for i in range(match_players.size()):
		var p: Dictionary = match_players[i]
		var own_team: bool = int(p["team"]) == 0
		var player_team_name: String = left_name if own_team else right_name
		var player_direction := Vector2.RIGHT if own_team else Vector2.LEFT
		if i == selected_match_player and player_run_target != Vector2.ZERO:
			player_direction = player_run_target - p["pos"]
		var is_running: bool = key_play_active and (i == selected_match_player or int(p["team"]) != match_owner)
		var draw_pos: Vector2 = Vector2(p["pos"]) - match_camera_offset
		_draw_match_player(draw_pos, int(p["num"]), player_team_name, own_team and i == selected_match_player, player_direction, is_running)
	_draw_match_ball(match_ball - match_camera_offset + Vector2(0, -match_ball_height))
	_draw_match_controls()
	if match_over:
		draw_rect(Rect2(0, 0, W, H), Color(0.02, 0.04, 0.06, 0.8), true)
		_panel(Rect2(356, 213, 568, 300), Color("142233"))
		_label("FIM DE JOGO", 0, 278, 24, MINT, W, HORIZONTAL_ALIGNMENT_CENTER)
		_label(left_name + "    %d  -  %d    " % [match_score[0], match_score[1]] + right_name, 0, 344, 24, TEXT, W, HORIZONTAL_ALIGNMENT_CENTER)
		_label("Toque para retornar ao calendário da temporada", 0, 387, 13, MUTED, W, HORIZONTAL_ALIGNMENT_CENTER)
		_button(Rect2(461, 420, 358, 60), "CONTINUAR", true)

func _draw_match_controls() -> void:
	draw_rect(Rect2(0, 656, W, 64), Color(0.04, 0.08, 0.12, 0.92), true)
	var status: String = match_state.replace("_", " ")
	if match_event_timer > 0.0: status = match_event_text
	_label(status, 24, 680, 12, WSC_GOLD, 250)
	_label("WASD MOVER  J PASSE  K ENFIADA  ESPAÇO CHUTE  Q DESARME  TAB TROCAR", 270, 695, 10, Color("d1dbea"), 690, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(1016, 662, 96, 44), "▶" if match_paused else "Ⅱ", true)
	_button(Rect2(1124, 662, 132, 44), "AVANÇAR  »", true)

func _draw_match_player(pos: Vector2, number: int, team_name: String, selected: bool, facing: Vector2, running: bool) -> void:
	if selected:
		draw_arc(pos, 24, 0, TAU, 32, WSC_GOLD, 2.5)
		draw_colored_polygon(PackedVector2Array([pos + Vector2(0, -30), pos + Vector2(-4, -37), pos + Vector2(4, -37)]), WSC_GOLD)
	draw_set_transform(pos + Vector2(2, 5), 0.0, Vector2(1.35, 0.55))
	draw_circle(Vector2.ZERO, 13, Color(0.02, 0.04, 0.03, 0.32))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var identity: int = posmod(number * 11 + abs(team_name.hash() % 2147483647), 8)
	var skin_palette: Array[Color] = [Color("efc69e"), Color("d9a47d"), Color("bd835f"), Color("8a5b43"), Color("f2d5b6"), Color("a36a4d"), Color("e6b78e"), Color("6c4939")]
	var hair_palette: Array[Color] = [Color("241d1a"), Color("493126"), Color("201b25"), Color("a88753"), Color("35271e"), Color("5a4031"), Color("c1a36f"), Color("1c2023")]
	var skin: Color = skin_palette[identity]
	var hair: Color = hair_palette[(identity * 3 + number) % hair_palette.size()]
	var kit: Color = Color("e8c344") if number == 1 else _club_color(team_name)
	var trim := Color("f7f3e8") if kit.get_luminance() < 0.55 else kit.darkened(0.4)
	var direction := facing.normalized() if facing.length() > 0.01 else Vector2.RIGHT
	var bob: float = absf(sin(match_visual_time * 12.0 + number)) * 1.4 if running else 0.0
	draw_set_transform(pos + Vector2(0, -bob), direction.angle() + PI * 0.5, Vector2.ONE)
	var stride: float = sin(match_visual_time * 14.0 + number) * 3.0 if running else 0.0
	var outline := Color("20251f")
	var left_hip := Vector2(-3, 7)
	var right_hip := Vector2(3, 7)
	var left_foot := Vector2(-4 + stride, 17)
	var right_foot := Vector2(4 - stride, 17)
	# Legs, socks and boots sit behind the shirt, with a small two-step run cycle.
	draw_line(left_hip, left_foot, outline, 7.0, true)
	draw_line(right_hip, right_foot, outline, 7.0, true)
	draw_line(left_hip, left_foot, Color("f0eee4"), 4.5, true)
	draw_line(right_hip, right_foot, Color("f0eee4"), 4.5, true)
	draw_line(left_foot + Vector2(0, 1), left_foot + Vector2(1, 3), Color("242526"), 4.5, true)
	draw_line(right_foot + Vector2(0, 1), right_foot + Vector2(1, 3), Color("242526"), 4.5, true)
	# Arms and hands make each player read as a person at the game's overhead scale.
	for side in [-1.0, 1.0]:
		var shoulder := Vector2(side * 6, -5)
		var elbow := Vector2(side * 10, 0 + stride * 0.45)
		var hand := Vector2(side * 10, 5 + stride * 0.45)
		draw_line(shoulder, elbow, outline, 7.0, true)
		draw_line(shoulder, elbow, kit.darkened(0.12), 5.0, true)
		draw_line(elbow, hand, outline, 5.0, true)
		draw_line(elbow, hand, skin, 3.2, true)
	# Rounded shirt silhouette, contrasting trim and visible jersey number.
	var shirt := PackedVector2Array([Vector2(-5, -9), Vector2(5, -9), Vector2(8, -5), Vector2(7, 5), Vector2(5, 8), Vector2(-5, 8), Vector2(-7, 5), Vector2(-8, -5), Vector2(-5, -9)])
	draw_colored_polygon(PackedVector2Array([Vector2(-6, -10), Vector2(6, -10), Vector2(9, -5), Vector2(8, 6), Vector2(5, 9), Vector2(-5, 9), Vector2(-8, 6), Vector2(-9, -5)]), outline)
	draw_colored_polygon(shirt, kit)
	draw_line(Vector2(-3, -6), Vector2(-3, 5), trim, 1.6, true)
	draw_line(Vector2(3, -6), Vector2(3, 5), trim, 1.6, true)
	draw_string(ThemeDB.fallback_font, Vector2(-3.5, 3), str(number), HORIZONTAL_ALIGNMENT_CENTER, 8, 7, Color("ffffff"))
	draw_colored_polygon(PackedVector2Array([Vector2(-5, 6), Vector2(5, 6), Vector2(4, 11), Vector2(-4, 11)]), outline)
	draw_colored_polygon(PackedVector2Array([Vector2(-4, 7), Vector2(4, 7), Vector2(3.5, 10), Vector2(-3.5, 10)]), Color("25313a"))
	# Neck, head, ears and hair are drawn last so the face stays readable.
	draw_rect(Rect2(-2.5, -12, 5, 5), skin.darkened(0.12), true)
	draw_circle(Vector2(-5.2, -12), 2.3, skin.darkened(0.08))
	draw_circle(Vector2(5.2, -12), 2.3, skin.darkened(0.08))
	draw_circle(Vector2(0, -15), 7.5, outline)
	draw_circle(Vector2(0, -15), 6.2, skin)
	var hair_cap := PackedVector2Array([Vector2(-6, -14), Vector2(-5, -20), Vector2(-2, -22), Vector2(3, -21), Vector2(6, -18), Vector2(6, -14), Vector2(3, -16), Vector2(0, -15), Vector2(-3, -14)])
	draw_colored_polygon(hair_cap, hair)
	draw_circle(Vector2(-2.3, -15), 0.8, outline)
	draw_circle(Vector2(2.3, -15), 0.8, outline)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_match_ball(pos: Vector2) -> void:
	# The shadow stays on the pitch while the ball sprite rises during aerial shots.
	draw_circle(pos + Vector2(2, match_ball_height + 4), 7.0 + match_ball_height * 0.025, Color(0.02, 0.03, 0.03, 0.32))
	draw_circle(pos, 6, Color("f8f7ee"))
	draw_circle(pos, 2.3, Color("242a2c"))
	draw_line(pos + Vector2(-4, -1), pos + Vector2(-1, -4), Color("242a2c"), 1.4)
	draw_line(pos + Vector2(4, 1), pos + Vector2(1, 4), Color("242a2c"), 1.4)

func _draw_pitch_art(rect: Rect2, decorative: bool) -> void:
	draw_rect(rect, Color("173629"), true)
	var inset := rect.size.x * 0.025
	var field := rect.grow(-inset)
	draw_rect(field, Color("267a50"), true)
	for i in range(8):
		if i % 2 == 0:
			var stripe := Rect2(field.position.x + field.size.x * float(i) / 8.0, field.position.y, field.size.x / 8.0, field.size.y)
			draw_rect(stripe, Color(0.78, 1, 0.84, 0.035), true)
	var white := Color(0.87, 0.97, 0.89, 0.77)
	draw_rect(field, white, false, 2)
	draw_line(Vector2(field.get_center().x, field.position.y), Vector2(field.get_center().x, field.end.y), white, 2)
	draw_arc(field.get_center(), field.size.y * 0.15, 0, TAU, 48, white, 2)
	draw_circle(field.get_center(), 3, white)
	draw_rect(Rect2(field.position.x, field.position.y + field.size.y * 0.23, field.size.x * 0.16, field.size.y * 0.54), white, false, 2)
	draw_rect(Rect2(field.end.x - field.size.x * 0.16, field.position.y + field.size.y * 0.23, field.size.x * 0.16, field.size.y * 0.54), white, false, 2)
	if decorative:
		draw_rect(Rect2(rect.position.x, rect.position.y, rect.size.x, rect.size.y * 0.23), Color("101e29"), true)
		draw_rect(Rect2(rect.position.x, rect.end.y - rect.size.y * 0.20, rect.size.x, rect.size.y * 0.20), Color("101e29"), true)

func _draw_banner() -> void:
	var width := maxf(220, float(banner.length() * 10))
	_panel(Rect2(W * 0.5 - width * 0.5, 82, width, 42), Color("1c553f"))
	_label(banner, W * 0.5 - width * 0.5, 109, 13, TEXT, width, HORIZONTAL_ALIGNMENT_CENTER)

func _formation_text() -> String:
	var f: Array = FORMATIONS[formation_index]
	return "4-%d-%d" % [f[1], f[2]] if f[0] == 4 else "%d-%d-%d" % f

func _bench_summary() -> String:
	var parts: Array[String] = []
	for i in range(11, mini(roster.size(), 18)):
		parts.append("%s  %s %d" % [str(roster[i]["pos"]), str(roster[i]["name"]).split(" ")[0], roster[i]["rating"]])
	return "     ".join(PackedStringArray(parts))

func _fitness_text(player: Dictionary) -> String:
	return "ENERGIA %d%%" % player["fitness"]

func _stars(value: int) -> String:
	var s := ""
	for i in range(5): s += "★" if i < value else "☆"
	return s
