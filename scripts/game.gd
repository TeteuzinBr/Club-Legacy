extends Node2D

const W := 1280.0
const H := 720.0
const FIRST_NAMES := ["Caio", "Rafael", "Davi", "Luca", "Bruno", "Enzo", "Mateus", "Arthur", "Theo", "Nicolas", "João", "Gabriel", "Samuel", "Leonardo", "André", "Marcos", "Daniel", "Ícaro", "Vitor", "Felipe", "Renan", "Alex", "Tomás", "Diego", "Heitor", "Miguel", "Erick", "Murilo", "David", "Lucas"]
const LAST_NAMES := ["Silva", "Costa", "Almeida", "Santos", "Ferreira", "Lima", "Pereira", "Rocha", "Mendes", "Barros", "Oliveira", "Carvalho", "Ramos", "Freitas", "Azevedo", "Martins", "Nunes", "Moraes", "Teixeira", "Dias", "Moreira", "Castro", "Lopes", "Vieira", "Cardoso", "Correia", "Farias", "Cunha", "Gomes", "Reis"]
const LEAGUES := [
	{"country":"Brasil", "flag":"br", "folder":"brazil", "name":"Série A", "teams":["Flamengo", "Palmeiras", "Corinthians", "São Paulo", "Santos", "Grêmio", "Internacional", "Atlético-MG"]},
	{"country":"Inglaterra", "flag":"gb-eng", "folder":"england", "name":"Premier League", "teams":["Arsenal", "Chelsea", "Liverpool", "Manchester City", "Manchester United", "Tottenham", "Newcastle", "Aston Villa"]},
	{"country":"Espanha", "flag":"es", "folder":"spain", "name":"La Liga", "teams":["Barcelona", "Real Madrid", "Atlético de Madrid", "Sevilla", "Valencia", "Villarreal", "Real Sociedad", "Athletic Club"]},
	{"country":"Itália", "flag":"it", "folder":"italy", "name":"Serie A", "teams":["Inter", "Milan", "Juventus", "Roma", "Napoli", "Lazio", "Atalanta", "Fiorentina"]},
	{"country":"Portugal", "flag":"pt", "folder":"portugal", "name":"Primeira Liga", "teams":["Benfica", "Porto", "Sporting CP", "Braga", "Vitória SC", "Boavista", "Famalicão", "Rio Ave"]},
	{"country":"Países Baixos", "flag":"nl", "folder":"netherlands", "name":"Eredivisie", "teams":["Ajax", "PSV", "Feyenoord", "AZ Alkmaar", "Twente", "Utrecht", "Heerenveen", "Sparta Rotterdam"]},
	{"country":"Argentina", "flag":"ar", "folder":"argentina", "name":"Liga Profesional", "teams":["Boca Juniors", "River Plate", "Racing Club", "Independiente", "San Lorenzo", "Estudiantes", "Lanús", "Rosario Central"]},
	{"country":"Estados Unidos", "flag":"us", "folder":"usa", "name":"MLS", "teams":["Inter Miami", "LA Galaxy", "LAFC", "Seattle Sounders", "Atlanta United", "New York City", "Austin FC", "Portland Timbers"]},
	{"country":"Japão", "flag":"jp", "folder":"japan", "name":"J3 League", "teams":["Roasso Kumamoto", "Nara Club", "Fukushima United FC", "Matsumoto Yamaga FC", "Kamatamare Sanuki", "Kochi United SC", "Gainare Tottori", "FC Osaka"]},
	{"country":"México", "flag":"mx", "folder":"mexico", "name":"Liga MX", "teams":["América", "Guadalajara", "Cruz Azul", "Tigres", "Monterrey", "Pumas", "Toluca", "Pachuca"]},
]
const REAL_SQUADS := {
	"Flamengo": [
		["Agustín Rossi", "GK", 1], ["Andrew", "GK", 42], ["Dyogo Alves", "GK", 49],
		["Léo Ortiz", "DEF", 3], ["Léo Pereira", "DEF", 4], ["Danilo", "DEF", 13], ["Vitão", "DEF", 44], ["João Victor", "DEF", 61],
		["Guillermo Varela", "DEF", 2], ["Emerson Royal", "DEF", 22], ["Ayrton Lucas", "DEF", 6], ["Alex Sandro", "DEF", 26],
		["Erick Pulgar", "MID", 5], ["Jorginho", "MID", 21], ["Evertton Araújo", "MID", 52], ["Saúl Ñíguez", "MID", 8], ["De Arrascaeta", "MID", 10], ["Jorge Carrascal", "MID", 15], ["De la Cruz", "MID", 18], ["Lucas Paquetá", "MID", 11],
		["Luiz Araújo", "ATT", 7], ["Pedro", "ATT", 9], ["Anthony Valencia", "ATT", 14], ["Samuel Lino", "ATT", 16], ["Gonzalo Plata", "ATT", 19], ["Bruno Henrique", "ATT", 27], ["Joaquín Freitas", "ATT", 30]
	],
	"Palmeiras": [
		["Bruno Bertinato", "GK", 21], ["Carlos Miguel", "GK", 1], ["Marcelo Lomba", "GK", 14],
		["Alexander Barboza", "DEF", 2], ["Benedetti", "DEF", 43], ["Bruno Fuchs", "DEF", 3], ["Gustavo Gómez", "DEF", 15], ["Murilo", "DEF", 26], ["Agustín Giay", "DEF", 4], ["Khellven", "DEF", 12], ["Arthur", "DEF", 56], ["Jefté", "DEF", 6], ["Joaquín Piquerez", "DEF", 22],
		["Andreas Pereira", "MID", 8], ["Emiliano Martínez", "MID", 32], ["Felipe Anderson", "MID", 7], ["Larson", "MID", 48], ["Lucas Evangelista", "MID", 30], ["Marlon Freitas", "MID", 17], ["Maurício", "MID", 18],
		["Jhon Arias", "ATT", 11], ["López", "ATT", 42], ["Paulinho", "ATT", 10], ["Ramón Sosa", "ATT", 19], ["Vitor Roque", "ATT", 9]
	],
	"Barcelona": [
		["Joan García", "GK", 1], ["Wojciech Szczęsny", "GK", 13], ["Dominik Livaković", "GK", 25],
		["João Cancelo", "DEF", 2], ["Alejandro Balde", "DEF", 3], ["Brian Fariñas", "DEF", 4], ["Pau Cubarsí", "DEF", 5], ["Xavi Espart", "DEF", 12], ["Andreas Christensen", "DEF", 15], ["Gerard Martín", "DEF", 18], ["Jules Koundé", "DEF", 23], ["Eric García", "DEF", 24], ["Jesse Bisiwu", "DEF", 27],
		["Gavi", "MID", 6], ["Fermín López", "MID", 7], ["Pedri", "MID", 8], ["Rodrigo", "MID", 16], ["Dani Olmo", "MID", 20], ["Frenkie de Jong", "MID", 21], ["Marc Bernal", "MID", 22],
		["Gabriel Jesus", "ATT", 9], ["Lamine Yamal", "ATT", 10], ["Raphinha", "ATT", 11], ["Karim Adeyemi", "ATT", 14], ["Anthony Gordon", "ATT", 17], ["Roony Bardghji", "ATT", 19], ["Hamza Abdelkarim", "ATT", 29]
	],
	"Roasso Kumamoto": [
		["佐藤 史騎", "GK", 1], ["武者 大夢", "GK", 16], ["西村 遥己", "GK", 21], ["佐藤 優也", "GK", 23], ["永野 春樹", "GK", 31],
		["黒木 晃平", "DEF", 2], ["大西 遼太郎", "DEF", 3], ["薬師田 澪", "DEF", 4], ["李 泰河", "DEF", 24], ["戸田 峻平", "DEF", 26], ["長嶋 志歩", "DEF", 30], ["木村 匠汰", "DEF", 33], ["伊藤 颯真", "DEF", 35],
		["小林 慶太", "MID", 5], ["藤井 皓也", "MID", 7], ["渡邉 怜歩", "MID", 11], ["飯星 明良", "MID", 13], ["三島 頌平", "MID", 15], ["永井 颯太", "MID", 17], ["松田 詠太郎", "MID", 22], ["那須 健一", "MID", 25], ["根岸 恵汰", "MID", 27], ["吉岡 優希", "MID", 28], ["三品 直哉", "MID", 29], ["中島 永弥", "MID", 34], ["小澤 秀充", "MID", 37], ["石田 凌太郎", "MID", 39], ["大本 祐槻", "MID", 41],
		["ベ ジョンミン", "ATT", 9], ["鹿取 勇斗", "ATT", 10], ["石原 央羅", "ATT", 14], ["宮田 和純", "ATT", 19], ["中山 大耀", "ATT", 32]
	]
}
const POSITIONS := ["GK", "DEF", "DEF", "DEF", "DEF", "MID", "MID", "MID", "MID", "ATT", "ATT", "GK", "DEF", "DEF", "MID", "MID", "ATT", "ATT"]
const FORMATIONS := [[4, 3, 3], [4, 4, 2], [4, 5, 1], [3, 5, 2]]
const BG := Color("0b1420")
const PANEL := Color("142233")
const PANEL_2 := Color("1b2d40")
const LINE := Color("30465b")
const MINT := Color("55d6a5")
const TEXT := Color("f2f6fb")
const MUTED := Color("9aabba")
const WSC_GREEN := Color("078744")
const WSC_BLUE := Color("26376f")
const WSC_NAVY := Color("14172d")
const WSC_CARD := Color("2a2e4c")
const WSC_GOLD := Color("f1c82f")

var rng := RandomNumberGenerator.new()
var screen := "home"
var league_index := 0
var club_index := 0
var club_name := "Flamengo"
var roster: Array[Dictionary] = []
var bench: Array[int] = []
var selected_player := -1
var formation_index := 0
var mentality := 1
var season := 1
var round_number := 1
var budget := 1500000
var points := 0
var wins := 0
var draws := 0
var losses := 0
var goals_for := 0
var goals_against := 0
var league_table: Array[Dictionary] = []
var fixtures: Array[Dictionary] = []
var match_score := [0, 0]
var match_clock := 0.0
var match_time_limit := 105.0
var key_play_timer := 0.0
var match_over := false
var selected_match_player := 9
var match_ball := Vector2(535, 350)
var match_ball_vel := Vector2.ZERO
var match_owner := 9
var match_players: Array[Dictionary] = []
var player_run_target := Vector2.ZERO
var banner := ""
var banner_time := 0.0
var pointer_down := false
var pointer_start := Vector2.ZERO
var touch_move_index := -1
var touch_action_index := -1
var touch_move_origin := Vector2.ZERO
var touch_move_vector := Vector2.ZERO
var last_match_result := ""
var match_setup_open := false
var sim_result_open := false
var sim_result_home := ""
var sim_result_away := ""
var sim_result_home_score := 0
var sim_result_away_score := 0
var market_candidates: Array[Dictionary] = []
var transfer_offer: Dictionary = {}
var asset_http: HTTPRequest
var asset_queue: Array[Dictionary] = []
var active_asset_request: Dictionary = {}
var asset_textures: Dictionary = {}
var asset_requests_started: Dictionary = {}

func _ready() -> void:
	rng.randomize()
	asset_http = HTTPRequest.new()
	asset_http.timeout = 15.0
	asset_http.request_completed.connect(_on_asset_download_completed)
	add_child(asset_http)
	_load_save()
	queue_redraw()

func _process(delta: float) -> void:
	if screen == "match" and not match_over:
		_update_match(delta)
	if banner_time > 0:
		banner_time = maxf(0, banner_time - delta)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if screen == "match":
			_handle_match_key(event.keycode)
		elif screen == "squad":
			if event.keycode == KEY_LEFT: _cycle_formation(-1)
			elif event.keycode == KEY_RIGHT: _cycle_formation(1)
		elif screen == "calendar" and event.keycode == KEY_ENTER:
			match_setup_open = true
		elif screen == "career" and event.keycode == KEY_ENTER:
			match_setup_open = true
		elif screen == "select":
			if event.keycode == KEY_LEFT: league_index = posmod(league_index - 1, LEAGUES.size()); club_index = 0
			elif event.keycode == KEY_RIGHT: league_index = posmod(league_index + 1, LEAGUES.size()); club_index = 0
			elif event.keycode == KEY_A: club_index = posmod(club_index - 1, LEAGUES[league_index]["teams"].size())
			elif event.keycode == KEY_D: club_index = posmod(club_index + 1, LEAGUES[league_index]["teams"].size())
			elif event.keycode == KEY_ENTER: _new_career()
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

func _handle_click(pos: Vector2) -> void:
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
			if Rect2(484, 370, 312, 58).has_point(pos): screen = "select"
			elif Rect2(484, 443, 312, 50).has_point(pos): _ensure_demo_career(); screen = "career"
			elif Rect2(484, 508, 312, 50).has_point(pos): _ensure_demo_career(); screen = "calendar"
		"select":
			if Rect2(1120, 12, 132, 44).has_point(pos): _new_career()
			elif Rect2(0, 0, 70, 68).has_point(pos): screen = "home"
			elif Rect2(40, 173, 570, 424).has_point(pos):
				var row := clampi(int((pos.y - 180) / 40), 0, LEAGUES.size() - 1)
				league_index = row
				club_index = 0
			elif Rect2(645, 365, 48, 48).has_point(pos): club_index = posmod(club_index - 1, LEAGUES[league_index]["teams"].size())
			elif Rect2(1175, 365, 48, 48).has_point(pos): club_index = posmod(club_index + 1, LEAGUES[league_index]["teams"].size())
			elif Rect2(855, 560, 336, 54).has_point(pos): _new_career()
			elif Rect2(1130, 18, 118, 42).has_point(pos): screen = "home"
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
			elif Rect2(1192, 12, 72, 42).has_point(pos): _simulate_match()
			elif pos.y > 70 and pos.y < 642: _match_tap(pos)

func _new_career() -> void:
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

func _ensure_demo_career() -> void:
	if roster.is_empty(): _new_career()

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

func _load_save() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://career.cfg") != OK: return
	club_name = cfg.get_value("career", "club", "")
	if club_name == "": return
	league_index = clampi(int(cfg.get_value("career", "league", 0)), 0, LEAGUES.size() - 1)
	club_index = int(cfg.get_value("career", "club_index", 0))
	if not LEAGUES[league_index]["teams"].has(club_name):
		club_index = 0
		club_name = str(LEAGUES[league_index]["teams"][0])
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
	cfg.save("user://career.cfg")

func _next_fixture() -> Dictionary:
	if fixtures.is_empty(): return {}
	for fixture in fixtures:
		if int(fixture["round"]) == round_number and (fixture["home"] == club_name or fixture["away"] == club_name): return fixture
	return {}

func _play_next() -> void:
	var fixture := _next_fixture()
	if fixture.is_empty(): return
	last_match_result = ""
	_simulate_ai_round()
	match_score = [0, 0]
	match_clock = 0
	key_play_timer = 0
	match_over = false
	match_ball = Vector2(640, 360)
	match_ball_vel = Vector2.ZERO
	match_owner = 0
	selected_match_player = 9
	match_players.clear()
	for i in range(11):
		var x: float = 320 + float(i % 4) * 72
		var y: float = 195 + float(i / 4) * 112
		match_players.append({"team":0, "pos":Vector2(x,y), "home":Vector2(x,y), "num":i + 1})
	for i in range(11):
		var x: float = 960 - float(i % 4) * 72
		var y: float = 195 + float(i / 4) * 112
		match_players.append({"team":1, "pos":Vector2(x,y), "home":Vector2(x,y), "num":i + 1})
	var kickoff: Dictionary = match_players[selected_match_player]
	kickoff["pos"] = Vector2(640, 360)
	kickoff["home"] = Vector2(640, 360)
	match_players[selected_match_player] = kickoff
	player_run_target = Vector2.ZERO
	screen = "match"

func _update_match(delta: float) -> void:
	match_clock += delta
	key_play_timer += delta
	if match_clock >= match_time_limit:
		match_over = true
		return
	if key_play_timer >= 6.5:
		_advance_key_play()
		key_play_timer = 0.0
	var move := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): move.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): move.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): move.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): move.y += 1
	if move.length() < 0.05 and player_run_target != Vector2.ZERO:
		var active_pos: Vector2 = match_players[selected_match_player]["pos"]
		if active_pos.distance_to(player_run_target) < 10:
			player_run_target = Vector2.ZERO
		else:
			move = active_pos.direction_to(player_run_target)
	if move.length() > 0 and match_owner == 0:
		var p: Dictionary = match_players[selected_match_player]
		var ppos: Vector2 = p["pos"]
		var move_speed: float = 130.0 + float(roster[selected_match_player]["spd"]) * 0.72
		p["pos"] = ppos + move.normalized() * move_speed * delta
		p["pos"] = Vector2(clampf(p["pos"].x, 75, 1195), clampf(p["pos"].y, 158, 565))
		match_players[selected_match_player] = p
		match_ball = p["pos"] + Vector2(22, 0)
	elif move.length() > 0 and match_owner == 1:
		var defender: Dictionary = match_players[selected_match_player]
		var defender_pos: Vector2 = defender["pos"]
		var move_speed: float = 130.0 + float(roster[selected_match_player]["spd"]) * 0.72
		defender["pos"] = defender_pos + move.normalized() * move_speed * delta
		defender["pos"] = Vector2(clampf(defender["pos"].x, 75, 1195), clampf(defender["pos"].y, 158, 565))
		match_players[selected_match_player] = defender
	for i in range(match_players.size()):
		var p: Dictionary = match_players[i]
		var pos: Vector2 = p["pos"]
		if i != selected_match_player:
			if int(p["team"]) == 1:
				pos = pos.move_toward(match_ball, 52 * delta)
			else:
				var home: Vector2 = p["home"]
				var forward_support: float = 30.0 + float(mentality - 1) * 40.0
				pos = pos.move_toward(home + Vector2(forward_support, 0), 26 * delta)
		p["pos"] = pos
		match_players[i] = p
	if match_owner < 0:
		match_ball += match_ball_vel * delta
		match_ball_vel = match_ball_vel.move_toward(Vector2.ZERO, 250 * delta)
		if match_ball.y < 155 or match_ball.y > 565: match_ball_vel.y *= -0.72
		match_ball.y = clampf(match_ball.y, 155, 565)
		if match_ball.x < 76 or match_ball.x > 1204:
			var scored: bool = match_ball.y > 300 and match_ball.y < 420
			if scored: match_score[0 if match_ball.x > 1204 else 1] += 1
			else: match_ball_vel.x *= -0.65
			match_ball.x = clampf(match_ball.x, 76, 1204)
			if scored: _reset_after_goal()
		elif match_ball_vel.length() < 125:
			var nearest := _nearest_match_player(match_ball)
			if nearest >= 0:
				var nearest_pos: Vector2 = match_players[nearest]["pos"]
				if nearest_pos.distance_to(match_ball) < 28:
					match_owner = int(match_players[nearest]["team"])
					selected_match_player = posmod(nearest, 11)
					match_ball_vel = Vector2.ZERO
					match_ball = match_players[nearest]["pos"]
	elif match_owner == 1 and rng.randf() < 0.006:
		var attack_dir := Vector2.LEFT
		if rng.randf() < 0.58: match_owner = -1; match_ball_vel = attack_dir * 430
		else: match_owner = -1; match_ball_vel = attack_dir * 290

func _advance_key_play() -> void:
	if match_owner == 0 and rng.randf() < 0.32:
		var user_pos: Vector2 = match_players[selected_match_player]["pos"]
		_match_kick(Vector2(1205 - user_pos.x, 360 - user_pos.y))
		return
	var attacking_team: int = rng.randi_range(0, 1)
	var attacks_right: bool = attacking_team == 0
	var focal_x: float = rng.randf_range(590, 940) if attacks_right else rng.randf_range(340, 690)
	var focal_y: float = rng.randf_range(245, 470)
	var attack_offsets: Array[Vector2] = [Vector2(-30, 0), Vector2(-130, -115), Vector2(-130, 115), Vector2(-75, -175), Vector2(-75, 175), Vector2(100, -85), Vector2(105, 85), Vector2(180, -155), Vector2(180, 155), Vector2(245, -35), Vector2(295, 10)]
	var defense_offsets: Array[Vector2] = [Vector2(-240, 0), Vector2(-165, -100), Vector2(-165, 100), Vector2(-75, -170), Vector2(-75, 170), Vector2(30, -95), Vector2(30, 95), Vector2(110, -145), Vector2(110, 145), Vector2(190, -45), Vector2(200, 40)]
	if not attacks_right:
		for i in range(attack_offsets.size()):
			var attack_offset: Vector2 = attack_offsets[i]
			attack_offset.x *= -1
			attack_offsets[i] = attack_offset
		for i in range(defense_offsets.size()):
			var defense_offset: Vector2 = defense_offsets[i]
			defense_offset.x *= -1
			defense_offsets[i] = defense_offset
	for i in range(match_players.size()):
		var player: Dictionary = match_players[i]
		var own_team: int = int(player["team"])
		var player_number: int = i if own_team == 0 else i - 11
		var offset: Vector2 = attack_offsets[player_number] if own_team == attacking_team else defense_offsets[player_number]
		var player_spawn := Vector2(clampf(focal_x + offset.x, 85, 1195), clampf(focal_y + offset.y, 160, 560))
		player["pos"] = player_spawn
		player["home"] = player_spawn
		match_players[i] = player
	var receiver: int = 9 if attacking_team == 0 else 20
	match_owner = attacking_team
	match_ball = match_players[receiver]["pos"]
	match_ball_vel = Vector2.ZERO
	selected_match_player = 9
	if attacking_team == 1:
		var nearest_distance := INF
		for i in range(11):
			var player_pos: Vector2 = match_players[i]["pos"]
			var distance: float = player_pos.distance_to(match_ball)
			if distance < nearest_distance:
				nearest_distance = distance
				selected_match_player = i
	player_run_target = Vector2.ZERO
	banner = "LANCE DE ATAQUE" if attacking_team == 0 else "DEFENDA A JOGADA"
	banner_time = 1.1

func _match_tap(position: Vector2) -> void:
	if match_owner == 0:
		var tapped_player: int = _player_at(position)
		if tapped_player >= 0 and tapped_player < 11 and tapped_player != selected_match_player:
			_match_pass_to(tapped_player)
		else:
			player_run_target = position
	else:
		player_run_target = position

func _player_at(position: Vector2) -> int:
	for i in range(match_players.size()):
		var player_position: Vector2 = match_players[i]["pos"]
		if player_position.distance_to(position) <= 23: return i
	return -1

func _nearest_match_player(point: Vector2) -> int:
	var nearest := -1
	var best := INF
	for i in range(match_players.size()):
		var player_pos: Vector2 = match_players[i]["pos"]
		var d: float = player_pos.distance_to(point)
		if d < best: best = d; nearest = i
	return nearest

func _match_kick(direction: Vector2, is_pass: bool = false) -> void:
	if match_over or match_owner != 0: return
	var p: Dictionary = match_players[selected_match_player]
	var ppos: Vector2 = p["pos"]
	if ppos.distance_to(match_ball) > 85: return
	var v: Vector2 = direction.normalized() if direction.length() > 0.01 else Vector2.RIGHT
	match_owner = -1
	match_ball = p["pos"] + v * 22
	var action_power: float
	if is_pass: action_power = 360.0 + float(roster[selected_match_player]["pas"]) * 1.7
	else: action_power = 420.0 + float(roster[selected_match_player]["sho"]) * 1.9
	match_ball_vel = v * action_power
	key_play_timer = 0.0
	player_run_target = Vector2.ZERO

func _match_pass() -> void:
	if match_owner != 0: return
	var p: Dictionary = match_players[selected_match_player]
	var target := -1
	var best := INF
	for i in range(11):
		if i == selected_match_player: continue
		var candidate: Vector2 = match_players[i]["pos"]
		var ppos: Vector2 = p["pos"]
		if candidate.x < ppos.x + 5: continue
		var d: float = candidate.distance_to(ppos)
		if d < best: best = d; target = i
	if target >= 0:
		_match_pass_to(target)

func _match_pass_to(target: int) -> void:
	if match_owner != 0 or target < 0 or target >= 11: return
	var target_pos: Vector2 = match_players[target]["pos"]
	_match_kick(target_pos - match_ball, true)
	selected_match_player = target

func _match_tackle() -> void:
	if match_owner != 1: return
	var nearest_distance := INF
	var defender_pos: Vector2 = match_players[selected_match_player]["pos"]
	for i in range(11, 22):
		var opponent_pos: Vector2 = match_players[i]["pos"]
		var distance: float = defender_pos.distance_to(opponent_pos)
		if distance < nearest_distance: nearest_distance = distance
	if nearest_distance > 58:
		banner = "APROXIME-SE PARA DESARMAR"
		banner_time = 1.0
		return
	var tackle_chance: float = clampf(0.28 + float(roster[selected_match_player]["tck"]) * 0.004, 0.35, 0.70)
	if rng.randf() < tackle_chance:
		match_owner = 0
		match_ball = match_players[selected_match_player]["pos"]
		key_play_timer = 0.0
		player_run_target = Vector2.ZERO
		banner = "BOLA RECUPERADA"
		banner_time = 1.2

func _handle_match_key(key: int) -> void:
	if match_over: return
	if key == KEY_SPACE: _match_kick(Vector2.RIGHT)
	elif key == KEY_J: _match_pass()
	elif key == KEY_TAB: selected_match_player = posmod(selected_match_player + 1, 11)
	elif key == KEY_Q: _match_tackle()
	elif key == KEY_ESCAPE: match_over = true

func _reset_after_goal() -> void:
	match_owner = 0
	match_ball = Vector2(640, 360)
	match_ball_vel = Vector2.ZERO
	var kickoff: Dictionary = match_players[selected_match_player]
	kickoff["pos"] = Vector2(640, 360)
	kickoff["home"] = Vector2(640, 360)
	match_players[selected_match_player] = kickoff
	banner = "GOLO!"
	banner_time = 1.4

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

func _draw() -> void:
	draw_rect(Rect2(0, 0, W, H), BG, true)
	match screen:
		"home": _draw_home()
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

func _label(text: String, x: float, y: float, size: int, color: Color = TEXT, width: float = -1, align: int = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	draw_string(ThemeDB.fallback_font, Vector2(x, y), text, align, width, size, color)

func _panel(rect: Rect2, color: Color = PANEL) -> void:
	draw_rect(rect, color, true)
	draw_rect(rect, LINE, false, 1.0)

func _button(rect: Rect2, text: String, active: bool = false) -> void:
	draw_rect(rect, WSC_GREEN if active else Color("303655"), true)
	draw_rect(rect, Color("4fa26b") if active else Color("515a7a"), false, 1.0)
	_label(text, rect.position.x + 10, rect.position.y + rect.size.y * 0.62, 15, TEXT, rect.size.x - 20, HORIZONTAL_ALIGNMENT_CENTER)

func _remote_asset_texture(cache_key: String, url: String) -> Texture2D:
	if asset_textures.has(cache_key): return asset_textures[cache_key] as Texture2D
	var cache_path := "user://asset-cache/%s.svg" % cache_key
	if FileAccess.file_exists(cache_path):
		var cached_bytes := FileAccess.get_file_as_bytes(cache_path)
		var cached_image := Image.new()
		if cached_image.load_svg_from_string(cached_bytes.get_string_from_utf8()) == OK:
			var cached_texture := ImageTexture.create_from_image(cached_image)
			asset_textures[cache_key] = cached_texture
			if not asset_requests_started.has(cache_key): _queue_asset_download(cache_key, url)
			return cached_texture
	if not asset_requests_started.has(cache_key): _queue_asset_download(cache_key, url)
	return null

func _queue_asset_download(cache_key: String, url: String) -> void:
	asset_requests_started[cache_key] = true
	asset_queue.append({"key":cache_key, "url":url})
	_start_next_asset_download()

func _start_next_asset_download() -> void:
	if not active_asset_request.is_empty() or asset_queue.is_empty(): return
	active_asset_request = asset_queue.pop_front()
	var error: Error = asset_http.request(str(active_asset_request["url"]))
	if error != OK:
		active_asset_request = {}
		_start_next_asset_download()

func _on_asset_download_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200 and not active_asset_request.is_empty():
		var image := Image.new()
		if image.load_svg_from_string(body.get_string_from_utf8()) == OK:
			var key: String = str(active_asset_request["key"])
			asset_textures[key] = ImageTexture.create_from_image(image)
			var cache_path := "user://asset-cache/%s.svg" % key
			var absolute_dir := ProjectSettings.globalize_path(cache_path.get_base_dir())
			DirAccess.make_dir_recursive_absolute(absolute_dir)
			var cache_file := FileAccess.open(cache_path, FileAccess.WRITE)
			if cache_file != null: cache_file.store_buffer(body)
			queue_redraw()
	active_asset_request = {}
	_start_next_asset_download()

func _topbar(title: String, sub: String = "") -> void:
	draw_rect(Rect2(0, 0, W, 70), WSC_GREEN, true)
	draw_circle(Vector2(48, 35), 25, Color("f2f2e7"))
	draw_circle(Vector2(48, 35), 19, Color("226c46"))
	_label("⚽", 31, 43, 20, TEXT)
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
	_wsc_team_header("VOLTAR")
	draw_rect(Rect2(64, 112, 1152, 530), Color("202543"), true)
	_label("CLUB LEGACY", 0, 220, 22, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("CARREIRA", 0, 303, 54, TEXT, W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Escolha um clube para começar sua temporada", 0, 344, 17, Color("bac1d0"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(484, 392, 312, 58), "NOVA CARREIRA", true)
	_button(Rect2(484, 465, 312, 50), "CONTINUAR CARREIRA")
	_button(Rect2(484, 530, 312, 50), "CALENDÁRIO")

func _draw_select() -> void:
	draw_rect(Rect2(0, 0, W, H), Color("e8e9ec"), true)
	draw_rect(Rect2(0, 0, W, 68), Color("5bc5ae"), true)
	_label("‹", 22, 48, 38, TEXT)
	_label("CLUB LEGACY", 90, 43, 22, Color("153d48"))
	_button(Rect2(1120, 12, 132, 44), "CONTINUAR", true)
	_label("Nova Carreira  /  Escolher Liga", 0, 100, 21, Color("263849"), W, HORIZONTAL_ALIGNMENT_CENTER)
	var league: Dictionary = LEAGUES[league_index]
	_panel(Rect2(40, 126, 570, 495), Color("17233a"))
	draw_rect(Rect2(52, 143, 546, 36), Color("263650"), true)
	_label("PAÍS", 70, 167, 13, Color("d5dbe4"))
	_label("LIGA", 305, 167, 13, Color("d5dbe4"))
	_label("TOP 7 TIMES", 484, 167, 13, Color("d5dbe4"))
	for i in range(LEAGUES.size()):
		var row_y: float = 181 + i * 40
		if i == league_index: draw_rect(Rect2(52, row_y, 546, 39), Color("3c5367"), true)
		var flag_path := "res://assets/flag-icons/flags/4x3/%s.svg" % LEAGUES[i]["flag"]
		var flag_rect := Rect2(68, row_y + 8, 28, 20)
		if ResourceLoader.exists(flag_path): _draw_texture_fit(load(flag_path), flag_rect)
		else:
			var flag_code: String = str(LEAGUES[i]["flag"])
			var flag_texture := _remote_asset_texture("flags/4x3/%s" % flag_code, "https://raw.githubusercontent.com/lipis/flag-icons/refs/heads/main/flags/4x3/%s.svg" % flag_code)
			if flag_texture != null: _draw_texture_fit(flag_texture, flag_rect)
			else: _draw_flag(flag_code, flag_rect)
		_label(str(LEAGUES[i]["country"]), 108, row_y + 26, 14, Color("f1f2f4"), 172)
		_label(str(LEAGUES[i]["name"]), 286, row_y + 26, 12, Color("c1c9d4"), 156)
		_label("★★★", 480, row_y + 26, 14, WSC_GOLD)
	draw_rect(Rect2(630, 126, 610, 495), Color("17233a"), true)
	_label("CLUBES MAIS FORTES", 0, 166, 13, Color("c6ced9"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_draw_league_badge(league, Rect2(810, 180, 48, 48))
	_label(str(league["country"]).to_upper() + "   •   " + str(league["name"]), 650, 245, 20, TEXT, 570, HORIZONTAL_ALIGNMENT_CENTER)
	var teams: Array = league["teams"]
	_button(Rect2(645, 365, 48, 48), "◀")
	_button(Rect2(1175, 365, 48, 48), "▶")
	var selected_team: String = str(teams[club_index])
	_draw_crest(selected_team, league, Rect2(850, 250, 150, 150))
	_label(selected_team.to_upper(), 690, 445, 22, Color("f3f4f6"), 520, HORIZONTAL_ALIGNMENT_CENTER)
	_label("ATAQUE  ★★★       MEIO  ★★★★       DEFESA  ★★★", 0, 485, 14, WSC_GOLD, W, HORIZONTAL_ALIGNMENT_CENTER)
	_label("Elenco inicial  •  primeira temporada", 0, 520, 14, Color("b9c2cf"), W, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(855, 560, 336, 54), "COMEÇAR CARREIRA", true)
	_label("←/→ muda o país  •  A/D muda o clube", 34, 690, 12, MUTED)

func _draw_crest(team: String, league: Dictionary, rect: Rect2) -> void:
	var aliases := {
		"Atlético-MG":"Atlético_Mineiro", "São Paulo":"São_Paulo", "Santos":"Santos_FC", "Grêmio":"Grêmio", "Internacional":"Internacional",
		"Liverpool":"Liverpool_FC", "Manchester City":"Manchester_City", "Manchester United":"Manchester_United", "Newcastle":"Newcastle_United",
		"Atlético de Madrid":"Atletico_Madrid", "Real Madrid":"Real_Madrid", "Real Sociedad":"Real_Sociedad", "Athletic Club":"Athletic_Club_Bilbao",
		"Milan":"Milan", "Inter":"Inter", "Roma":"AS_Roma", "Porto":"FC_Porto", "Sporting CP":"Sporting_CP", "Vitória SC":"Vitória_de_Guimarães",
		"Braga":"SC_Braga", "Famalicão":"Famalicao", "PSV":"PSV_Eindhoven", "Utrecht":"FC_Utrecht", "Heerenveen":"sc_Heerenveen", "AZ Alkmaar":"AZ_Alkmaar", "Sparta Rotterdam":"Sparta_Rotterdam",
		"Boca Juniors":"Boca_Juniors", "River Plate":"River_Plate", "Racing Club":"Racing_Club", "Independiente":"Independiente", "Estudiantes":"Estudiantes_de_La_Plata", "Lanús":"Lanús", "San Lorenzo":"San_Lorenzo_de_Almagro",
		"Inter Miami":"Inter_Miami_CF", "LA Galaxy":"Los_Angeles_Galaxy", "LAFC":"Los_Angeles_Football_Club", "Seattle Sounders":"Seattle_Sounders_FC",
		"New York City":"New_York_City_Football_Club", "Portland Timbers":"Portland_Timbers", "Yokohama F. Marinos":"Yokohama_F._Marinos",
		"Kashima Antlers":"Kashima_Antlers", "Urawa Reds":"Urawa_Reds", "Kawasaki Frontale":"Kawasaki_Frontale",
		"Gamba Osaka":"Gamba_Osaka", "Cerezo Osaka":"Cerezo_Osaka", "Vissel Kobe":"Vissel_Kobe", "FC Tokyo":"FC_Tokyo",
		"América":"Club_America", "Guadalajara":"CD_Guadalajara", "Cruz Azul":"Cruz_Azul", "Tigres":"Tigres_UANL", "Pumas":"UNAM_Pumas"
	}
	var file_name: String = aliases.get(team, team.replace(" ", "_"))
	var path := "res://assets/football-logos-source/logos/%s/%s.svg" % [league["folder"], file_name]
	if ResourceLoader.exists(path):
		_draw_texture_fit(load(path), rect)
	else:
		var folder: String = str(league["folder"])
		var remote_path := "logos/%s/%s" % [folder, file_name]
		var logo_url := "https://raw.githubusercontent.com/JoseArroyave/football-logos/refs/heads/main/logos/%s/%s.svg" % [folder, file_name.uri_encode()]
		var logo_texture := _remote_asset_texture(remote_path, logo_url)
		if logo_texture != null: _draw_texture_fit(logo_texture, rect)
		else: _draw_fallback_crest(team, rect)

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
	var badge_files := {
		"Brasil":"Brazilian_Serie_A.svg", "Inglaterra":"Premier_League.svg", "Espanha":"La_Liga.svg", "Itália":"Serie_A.svg",
		"Portugal":"Primeira_Liga.svg", "Países Baixos":"Eredivisie.svg", "Argentina":"Argentina_Primera_Division.svg",
		"Estados Unidos":"MLS_-_Major_League_Soccer.svg", "Japão":"J3_League.svg", "México":"Liga_MX.svg"
	}
	var file_name: String = badge_files.get(str(league["country"]), "")
	if file_name == "": return
	var path := "res://assets/football-logos-source/logos/%s/%s" % [league["folder"], file_name]
	if ResourceLoader.exists(path): _draw_texture_fit(load(path), rect)
	else:
		var folder: String = str(league["folder"])
		var cache_key := "logos/%s/%s" % [folder, file_name.trim_suffix(".svg")]
		var logo_url := "https://raw.githubusercontent.com/JoseArroyave/football-logos/refs/heads/main/logos/%s/%s" % [folder, file_name.uri_encode()]
		var logo_texture := _remote_asset_texture(cache_key, logo_url)
		if logo_texture != null: _draw_texture_fit(logo_texture, rect)

func _draw_texture_fit(texture: Texture2D, rect: Rect2) -> void:
	var source_size := texture.get_size()
	if source_size.x <= 0 or source_size.y <= 0: return
	var fit_scale := minf(rect.size.x / source_size.x, rect.size.y / source_size.y)
	var fitted_size := source_size * fit_scale
	draw_texture_rect(texture, Rect2(rect.position + (rect.size - fitted_size) * 0.5, fitted_size), false)

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
	draw_rect(Rect2(0, 0, W, H), Color("aaa33b"), true)
	var field := Rect2(14, 68, W - 28, H - 68)
	draw_rect(field, Color("aaa33b"), true)
	for stripe in range(9):
		if stripe % 2 == 0:
			draw_rect(Rect2(field.position.x + field.size.x * float(stripe) / 9.0, field.position.y, field.size.x / 9.0, field.size.y), Color("b5af49"), true)
	var line_color := Color("e8e4bd", 0.78)
	draw_rect(Rect2(26, 78, W - 52, H - 88), line_color, false, 2)
	draw_line(Vector2(640, 78), Vector2(640, 710), line_color, 2)
	draw_arc(Vector2(640, 394), 86, 0, TAU, 48, line_color, 2)
	draw_rect(Rect2(26, 214, 170, 360), line_color, false, 2)
	draw_rect(Rect2(W - 196, 214, 170, 360), line_color, false, 2)
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
		_draw_match_player(p["pos"], int(p["num"]), int(p["team"]) == 0, int(p["team"]) == 0 and i == selected_match_player)
	draw_circle(match_ball, 7, Color("fcf9ee"))
	draw_circle(match_ball, 2, Color("334155"))
	_button(Rect2(1192, 12, 72, 42), "Ⅱ")
	if match_over:
		draw_rect(Rect2(0, 0, W, H), Color(0.02, 0.04, 0.06, 0.8), true)
		_panel(Rect2(356, 213, 568, 300), Color("142233"))
		_label("FIM DE JOGO", 0, 278, 24, MINT, W, HORIZONTAL_ALIGNMENT_CENTER)
		_label(left_name + "    %d  -  %d    " % [match_score[0], match_score[1]] + right_name, 0, 344, 24, TEXT, W, HORIZONTAL_ALIGNMENT_CENTER)
		_label("Toque para retornar ao calendário da temporada", 0, 387, 13, MUTED, W, HORIZONTAL_ALIGNMENT_CENTER)
		_button(Rect2(461, 420, 358, 60), "CONTINUAR", true)

func _draw_match_player(pos: Vector2, number: int, blue_team: bool, selected: bool) -> void:
	var kit: Color = Color("f4f3eb") if blue_team else Color("3153a4")
	var trim: Color = Color("265a41") if blue_team else Color("e2c944")
	if selected: draw_arc(pos, 19, 0, TAU, 28, WSC_GOLD, 3)
	draw_circle(pos + Vector2(1, 4), 13, Color(0.02, 0.03, 0.03, 0.30))
	draw_circle(pos, 13, kit)
	draw_circle(pos, 10, trim)
	draw_circle(pos + Vector2(0, -1), 5, kit)
	draw_string(ThemeDB.fallback_font, pos + Vector2(-5, 4), str(number), HORIZONTAL_ALIGNMENT_CENTER, 10, 8, Color.WHITE)

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

func _money(value: int) -> String:
	if value >= 1000000: return "%.1f mi" % (float(value) / 1000000.0)
	return "%d mil" % int(value / 1000)
