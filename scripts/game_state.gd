extends Node2D

const W := 1280.0
const H := 720.0
const SAVE_SLOT_COUNT := 4
const FAST_SIMULATION_RATE := 8.0
const QUICK_SIMULATION_EVENT_INTERVAL := 2.2
const FIRST_NAMES := ["Caio", "Rafael", "Davi", "Luca", "Bruno", "Enzo", "Mateus", "Arthur", "Theo", "Nicolas", "João", "Gabriel", "Samuel", "Leonardo", "André", "Marcos", "Daniel", "Ícaro", "Vitor", "Felipe", "Renan", "Alex", "Tomás", "Diego", "Heitor", "Miguel", "Erick", "Murilo", "David", "Lucas"]
const LAST_NAMES := ["Silva", "Costa", "Almeida", "Santos", "Ferreira", "Lima", "Pereira", "Rocha", "Mendes", "Barros", "Oliveira", "Carvalho", "Ramos", "Freitas", "Azevedo", "Martins", "Nunes", "Moraes", "Teixeira", "Dias", "Moreira", "Castro", "Lopes", "Vieira", "Cardoso", "Correia", "Farias", "Cunha", "Gomes", "Reis"]
const BASE_LEAGUES := [
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
var LEAGUES: Array = []
var league_display_order: Array[int] = []
var country_display_order: Array[int] = []
const LEAGUE_ROWS_PER_PAGE := 10
var league_list_offset := 0
var division_picker_open := false
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
var match_time_limit := 120.0
var fast_sim_timer := 0.0
var key_play_active := false
var pending_ball_action := ""
var match_over := false
var match_paused := false
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
var brand_mark_texture: Texture2D
var football_logo_manifest: Dictionary = {}
var asset_queue: Array[Dictionary] = []
var active_asset_request: Dictionary = {}
var asset_textures: Dictionary = {}
var asset_requests_started: Dictionary = {}
var asset_download_total := 0
var asset_download_success := 0
var asset_download_failures := 0
var asset_notice := ""
var asset_notice_time := 0.0
var asset_animation_time := 0.0
var asset_failure_hint := ""
var active_save_slot := 0
var preferred_save_slot := 0
var save_screen_mode := "load"
var pending_new_league := 0
var pending_new_club := 0
var overwrite_confirm_slot := 0
var save_overwrite_confirm := false
var save_slot_summaries: Array[Dictionary] = []
var match_visual_time := 0.0
var match_state := "PREPARATION"
var match_event_text := ""
var match_event_timer := 0.0
var match_ball_height := 0.0
var match_ball_vertical_speed := 0.0
var match_ball_spin := 0.0
var match_camera_offset := Vector2.ZERO
var match_last_touch_team := 0
var match_restart_timer := 0.0
var match_half_time_shown := false
var match_player_accel := 520.0
var match_player_decel := 620.0
