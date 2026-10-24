#!/usr/bin/env python3
"""Create an exact, low-404 logo map from the public football-logos repository."""

from __future__ import annotations

import json
import re
import sys
import unicodedata
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
COUNTRY_FOLDERS = {
    "Brasil": "brazil", "Inglaterra": "england", "Espanha": "spain", "Itália": "italy",
    "Portugal": "portugal", "Países Baixos": "netherlands", "Argentina": "argentina",
    "Estados Unidos": "usa", "Japão": "japan", "México": "mexico", "Alemanha": "germany",
    "França": "france", "Arábia Saudita": "saudi-arabia", "China": "china",
}
ALIASES = {
    ("Brasil", "CA Mineiro"): "Atlético_Mineiro.svg",
    ("Brasil", "CA Paranaense"): "Athletico_Paranaense.svg",
    ("Brasil", "Atlético-MG"): "Atlético_Mineiro.svg",
    ("Brasil", "Atlético-GO"): "Atlético_Goianiense.svg",
    ("Brasil", "Atlético-CE"): "Futebol_Clube_Atlético_Cearense.svg",
    ("Brasil", "América-MG"): "América_Mineiro.svg",
    ("Brasil", "Aparecidense"): "Associação_Atlética_Aparecidense.svg",
    ("Brasil", "Araguaína"): "Araguaína_Futebol_e_Regatas.svg",
    ("Brasil", "ASA"): "ASA_de_Arapiraca.svg",
    ("Brasil", "Altos-PI"): "Associação_Atlética_de_Altos.svg",
    ("Brasil", "Capital-DF"): "Capital_Clube_de_Futebol.svg",
    ("Brasil", "Decisão"): "Decisão_Goiana_FC.svg",
    ("Brasil", "Ferroviário"): "Ferroviário_Atlético_Clube.svg",
    ("Brasil", "Laguna-RN"): "Clube_Laguna_SAF.svg",
    ("Brasil", "Maguary"): "Associação_Atlética_Maguary.svg",
    ("Brasil", "Manauara"): "Manauara_Esporte_Clube.svg",
    ("Brasil", "Maracanã"): "Maracanã_Esporte_Clube.svg",
    ("Brasil", "Mixto"): "Mixto_Esporte_Clube.svg",
    ("Brasil", "Moto Club"): "Moto_Club_de_São_Luís.svg",
    ("Brasil", "Operário"): "Operário_Ferroviário.svg",
    ("Brasil", "Operário-VG"): "Operário_Várzea-Grandense.svg",
    ("Brasil", "Oratório"): "Oratório_Recreativo_Clube.svg",
    ("Brasil", "Ouvidorense"): "ABECAT_Ouvidorense.svg",
    ("Brasil", "Parnahyba"): "Parnahyba_Sport_Club.svg",
    ("Brasil", "Piauí"): "Piauí_Esporte_Clube.svg",
    ("Brasil", "Porto Velho"): "Porto_Velho_Esporte_Clube.svg",
    ("Brasil", "Portuguesa"): "Associação_Portuguesa_de_Desportos.svg",
    ("Brasil", "Portuguesa-RJ"): "Associação_Atlética_Portuguesa_(RJ).svg",
    ("Brasil", "Sergipe"): "Club_Sportivo_Sergipe.svg",
    ("Brasil", "Sousa"): "Sousa_Esporte_Clube.svg",
    ("Brasil", "São Bernardo"): "São_Bernardo.svg",
    ("Brasil", "São José"): "São_José_EC.svg",
    ("Brasil", "Tirol"): "Centro_de_Formação_de_Atletas_Tirol.svg",
    ("Brasil", "Tocantinópolis"): "Tocantinópolis_Esporte_Clube.svg",
    ("Brasil", "Trem"): "Trem_Desportivo_Clube.svg",
    ("Brasil", "Tuna Luso"): "Tuna_Luso_Brasileira.svg",
    ("Brasil", "Uberlândia"): "Uberlândia_Esporte_Clube.svg",
    ("Brasil", "Água Santa"): "Esporte_Clube_Água_Santa.svg",
    ("Brasil", "Blumenau"): "Blumenau_Esporte_Clube.svg",
    ("Brasil", "Ceilândia"): "Ceilândia_Esporte_Clube.svg",
    ("Brasil", "Fluminense-PI"): "Fluminense_Piauí.svg",
    ("Brasil", "GAS"): "Grêmio_Atlético_Sampaio_(GAS).svg",
    ("Brasil", "Galvez"): "Galvez_Esporte_Clube.svg",
    ("Brasil", "Gama"): "Sociedade_Esportiva_do_Gama.svg",
    ("Brasil", "Goiatuba"): "Goiatuba_Esporte_Clube.svg",
    ("Brasil", "Grêmio FBPA"): "Grêmio.svg",
    ("Brasil", "Humaitá"): "Sport_Clube_Humaitá.svg",
    ("Brasil", "Iguatu"): "Associação_Desportiva_Iguatu.svg",
    ("Brasil", "Imperatriz"): "Sociedade_Imperatriz_de_Desportos.svg",
    ("Brasil", "Inhumas"): "Inhumas_Esporte_Clube.svg",
    ("Brasil", "Internacional de Limeira"): "Internacional_de_Limeira.svg",
    ("Brasil", "Joinville"): "Joinville_Esporte_Clube.svg",
    ("Brasil", "Luverdense"): "Luverdense_Esporte_Clube.svg",
    ("Brasil", "Madureira"): "Madureira_Esporte_Clube.svg",
    ("Brasil", "Cascavel"): "Cascavel_CR.svg",
    ("Brasil", "Central"): "Central_Sport_Club.svg",
    ("Brasil", "ASA de Arapiraca"): "ASA_de_Arapiraca.svg",
    ("Brasil", "Altos"): "Altos.svg",
    ("Brasil", "Avaí"): "Avaí_FC.svg",
    ("Brasil", "Athletic Club"): "Athletic.svg",
    ("Brasil", "Botafogo-PB"): "Botafogo_PB.svg",
    ("Brasil", "Santa Cruz"): "Santa_Cruz_FC.svg",
    ("Brasil", "Paysandu"): "Paysandu_SC.svg",
    ("Inglaterra", "Brighton & Hove Albion FC"): "Brighton.svg",
    ("Inglaterra", "Ipswich Town FC"): "Ipswich.svg",
    ("Inglaterra", "Tottenham Hotspur FC"): "Tottenham.svg",
    ("Inglaterra", "West Ham United FC"): "West_Ham.svg",
    ("Espanha", "AD Ceuta FC"): "Ceuta.svg",
    ("Espanha", "Athletic Club"): "Athletic_Club_Bilbao.svg",
    ("Espanha", "Levante UD"): "Levante.svg",
    ("Espanha", "RC Celta de Vigo"): "Celta.svg",
    ("Espanha", "RC Deportivo La Coruña"): "Deportivo_La_Coruña.svg",
    ("Espanha", "RCD Espanyol de Barcelona"): "Espanyol.svg",
    ("Espanha", "Rayo Vallecano de Madrid"): "Rayo_Vallecano.svg",
    ("Espanha", "Real Betis Balompié"): "Real_Betis.svg",
    ("Espanha", "Real Racing Club de Santander"): "Racing_Santander.svg",
    ("Espanha", "Real Sociedad B"): "Real_Sociedad.svg",
    ("Espanha", "Real Sociedad de Fútbol"): "Real_Sociedad.svg",
    ("Espanha", "UD Almería"): "Almería.svg",
    ("Espanha", "UD Las Palmas"): "Las_Palmas.svg",
    ("Itália", "AC Milan II"): "Milan.svg",
    ("Itália", "AC Rimini"): "Rimini.svg",
    ("Itália", "ACF Fiorentina"): "Fiorentina.svg",
    ("Itália", "Atalanta BC"): "Atalanta.svg",
    ("Itália", "Atalanta II"): "Atalanta.svg",
    ("Itália", "Aurora Pro Patria"): "Pro_Patria.svg",
    ("Itália", "Clodiense SSD"): "Union_Clodiense_Chioggia_FC.svg",
    ("Itália", "Delfino Pescara"): "Pescara.svg",
    ("Itália", "FC Internazionale Milano"): "Inter.svg",
    ("Itália", "FC Südtirol"): "Suditrol.svg",
    ("Itália", "FC Turris"): "Turris.svg",
    ("Itália", "Juventus II"): "Juventus_Next_Gen.svg",
    ("Itália", "L.R. Vicenza"): "Vicenza.svg",
    ("Itália", "Roma"): "AS_Roma.svg",
    ("Itália", "SPAL 2013 Ferrara"): "SPAL.svg",
    ("Itália", "Taranto FC"): "Taranto_FC.svg",
    ("Itália", "USD Sestri Levante"): "Sestri_Levante.svg",
    ("Portugal", "CD Nacional"): "Nacional_da_Madeira.svg",
    ("Portugal", "CS Marítimo"): "Marítimo.svg",
    ("Portugal", "FC Felgueiras 1932"): "Felgueiras.svg",
    ("Portugal", "FC Porto B"): "FC_Porto.svg",
    ("Portugal", "GD Chaves"): "Grupo_Desportivo_de_Chaves.svg",
    ("Portugal", "GD Estoril Praia"): "Estoril.svg",
    ("Portugal", "SL Benfica B"): "Benfica.svg",
    ("Portugal", "Sport Lisboa e Benfica"): "Benfica.svg",
    ("Portugal", "Sporting Clube de Braga"): "SC_Braga.svg",
    ("Portugal", "Sporting Clube de Portugal"): "Sporting_CP.svg",
    ("Portugal", "UD Oliveirense"): "Oliveirense.svg",
    ("Portugal", "União Torreense"): "S.C.U._Torreense.svg",
    ("Portugal", "Vitória SC"): "Vitória_de_Guimarães.svg",
    ("Países Baixos", "AZ"): "AZ_Alkmaar.svg",
    ("Países Baixos", "AZ Alkmaar J"): "AZ_Alkmaar.svg",
    ("Países Baixos", "FC Twente '65"): "Twente.svg",
    ("Países Baixos", "FC Utrecht J"): "FC_Utrecht.svg",
    ("Países Baixos", "Feyenoord Rotterdam"): "Feyenoord.svg",
    ("Países Baixos", "Jong Ajax"): "Ajax.svg",
    ("Países Baixos", "Jong PSV"): "PSV_Eindhoven.svg",
    ("Países Baixos", "MVV"): "MVV_Maastricht.svg",
    ("Países Baixos", "NEC"): "N.E.C._Nijmegen.svg",
    ("Países Baixos", "PSV"): "PSV_Eindhoven.svg",
    ("Países Baixos", "SBV Excelsior"): "Excelsior_Rotterdam.svg",
    ("Países Baixos", "SC Cambuur-Leeuwarden"): "SC_Cambuur.svg",
    ("Países Baixos", "Telstar 1963"): "Telstar.svg",
    ("Países Baixos", "Willem II Tilburg"): "Willem_II.svg",
    ("Argentina", "Argentinos Juniors"): "Argeninos_Juniors.svg",
    ("Argentina", "Belgrano de Córdoba"): "Belgrano.svg",
    ("Argentina", "Central Córdoba SdE"): "Central_Córdoba.svg",
    ("Argentina", "Estudiantes"): "Estudiantes_de_La_Plata.svg",
    ("Argentina", "Gimnasia de La Plata"): "Gimnasia_LP.svg",
    ("Argentina", "San Lorenzo"): "San_Lorenzo_de_Almagro.svg",
    ("Argentina", "Sarmiento de Junín"): "Sarmiento.svg",
    ("Argentina", "Talleres de Córdoba"): "Talleres.svg",
    ("Argentina", "Unión de Santa Fe"): "Union.svg",
    ("Estados Unidos", "LA Galaxy"): "Los_Angeles_Galaxy.svg",
    ("Estados Unidos", "LAFC"): "Los_Angeles_Football_Club.svg",
    ("Estados Unidos", "New York RB"): "New_York_Red_Bulls.svg",
    ("Japão", "Urawa Red Diamonds"): "Urawa_Reds.svg",
    ("México", "Atlas Guadalajara"): "Atlas.svg",
    ("México", "Club Celaya"): "Celaya.svg",
    ("México", "Coyotes de Tlaxcala"): "Tlaxcala_FC.svg",
    ("México", "Deportivo Guadalajara"): "CD_Guadalajara.svg",
    ("México", "Deportivo Toluca"): "Toluca.svg",
    ("México", "Gallos Blancos"): "Queretaro_FC.svg",
    ("México", "Leones Negros"): "Leones_Negros_UdeG.svg",
    ("México", "Pumas"): "UNAM_Pumas.svg",
    ("México", "Pumas UNAM"): "UNAM_Pumas.svg",
    ("México", "Tampico Madero"): "Tampico_Madero.svg",
    ("México", "Tigres"): "Tigres_UANL.svg",
    ("México", "UANL Tigres"): "Tigres_UANL.svg",
    ("Alemanha", "Bayer 04 Leverkusen"): "Bayer_Leverkusen.svg",    ("Alemanha", "1. FC Kaiserslautern"): "FC_Kaiserslautern.svg",
    ("Alemanha", "1. FC Nürnberg"): "FC_Nürnberg.svg",
    ("Alemanha", "1. FC Saarbrücken"): "Saarbrücken.svg",
    ("Alemanha", "1. FC Union Berlin"): "Union_Berlin.svg",
    ("Alemanha", "1. FSV Mainz 05"): "Mainz_05.svg",
    ("Alemanha", "1899 Hoffenheim II"): "Hoffenheim.svg",
    ("Alemanha", "Erzgebirge Aue"): "Erzgebirge.svg",
    ("Alemanha", "FC Ingolstadt 04"): "Ingolstadt.svg",
    ("Alemanha", "Jahn Regensburg"): "Jahn.svg",
    ("Alemanha", "Rot-Weiss Essen"): "Essen.svg",
    ("Alemanha", "SC Paderborn 07"): "SC_Paderborn.svg",
    ("Alemanha", "SSV Ulm 1846"): "SSV_Ulm_1846_Fußball.svg",
    ("Alemanha", "SV 07 Elversberg"): "SV_Elversberg.svg",
    ("Alemanha", "SV Werder Bremen"): "Werder_Bremen.svg",
    ("Alemanha", "VfB Stuttgart II"): "VfB_Stuttgart.svg",
    ("Alemanha", "VfL Osnabrück"): "Osnabrück.svg",
    ("Alemanha", "Waldhof Mannheim"): "SV_Waldhof_Mannheim.svg",
    ("Alemanha", "TSG 1899 Hoffenheim"): "Hoffenheim.svg",
    ("Brasil", "SC Corinthians Paulista"): "Corinthians.svg",
    ("França", "Paris Saint-Germain FC"): "Paris_Saint-Germain_(PSG).svg",
    ("França", "Olympique de Marseille"): "Marseille.svg",
    ("França", "AJ Auxerre"): "Auxerre.svg",
    ("França", "Angers SCO"): "Angers.svg",
    ("França", "Clermont Foot 63"): "Clermont_Foot.svg",
    ("França", "ES Troyes AC"): "Troyes.svg",
    ("França", "ESTAC Troyes"): "Troyes.svg",
    ("França", "Lille OSC"): "Lille.svg",
    ("França", "Montpellier HSC"): "Montpellier.svg",
    ("França", "OGC Nice"): "Nice.svg",
    ("França", "Racing Club de Lens"): "RC_Lens.svg",
    ("França", "Stade Brestois 29"): "Brest.svg",
    ("França", "Stade Rennais FC 1901"): "Rennes.svg",
    ("França", "USL Dunkerque"): "Dunkerque.svg",

    ("Arábia Saudita", "Al Ahli SFC"): "Al_Ahli.svg",
    ("China", "Henan FC"): "Henan_Songshan_Longmen.svg",
    ("China", "Shenzhen Peng City"): "Shenzhen_Xinpengcheng.svg",
    ("Brasil", "América-RJ"): "America_Football_Club_(RJ).svg",
    ("Brasil", "América-RN"): "América_de_Natal.svg",
    ("Brasil", "CRB"): "Clube_de_Regatas_Brasil.svg",
    ("Brasil", "RB Bragantino"): "RB_Bragantino.svg",
    ("Brasil", "Novorizontino"): "Grêmio_Novorizontino.svg",
    ("Brasil", "Sport"): "Sport_Recife.svg",
    ("Japão", "Roasso Kumamoto"): "Roasso_Kumamoto.svg",
    ("Japão", "Matsumoto Yamaga FC"): "Matsumoto_Yamaga_FC.svg",
    ("Japão", "Fukushima United FC"): "Fukushima_United_FC.svg",
}
LEAGUE_FILES = {
    ("Brasil", "Série A"): "brazil/Brazilian_Serie_A.svg",
    ("Brasil", "Série B"): "brazil/Brazilian_Serie_B.svg",
    ("Brasil", "Série C"): "brazil/Brazilian_Serie_C.svg",
    ("Brasil", "Série C - Grupo A"): "brazil/Brazilian_Serie_C.svg",
    ("Brasil", "Série C - Grupo B"): "brazil/Brazilian_Serie_C.svg",
    ("Brasil", "Série C - Grupo C"): "brazil/Brazilian_Serie_C.svg",
    ("Brasil", "Série D"): "brazil/Brazilian_Serie_D.svg",
    ("Inglaterra", "Premier League"): "england/Premier_League.svg",
    ("Inglaterra", "Championship"): "england/English_Football_League.svg",
    ("Inglaterra", "League One"): "england/EFL_League_One.svg",
    ("Inglaterra", "League Two"): "england/EFL_League_Two.svg",
    ("Espanha", "La Liga"): "spain/La_Liga.svg",
    ("Espanha", "Segunda División"): "spain/La_Liga_2.svg",
    ("Alemanha", "Bundesliga"): "germany/Bundesliga.svg",
    ("Alemanha", "2. Bundesliga"): "germany/2._Bundesliga.svg",
    ("Alemanha", "3. Liga"): "germany/3._Liga.svg",
    ("Itália", "Serie A"): "italy/Serie_A.svg",
    ("Itália", "Serie B"): "italy/Serie_B.svg",
    ("Itália", "Serie C - Grupo A"): "italy/Serie_C.svg",
    ("Itália", "Serie C - Grupo B"): "italy/Serie_C.svg",
    ("Itália", "Serie C - Grupo C"): "italy/Serie_C.svg",
    ("França", "Ligue 1"): "france/Ligue_1.svg",
    ("França", "Ligue 2"): "france/Ligue_2.svg",
    ("Países Baixos", "Eredivisie"): "netherlands/Eredivisie.svg",
    ("Países Baixos", "Eerste Divisie"): "netherlands/Eerste_Divisie.svg",
    ("Portugal", "Primeira Liga"): "portugal/Primeira_Liga.svg",
    ("Portugal", "Liga Portugal 2"): "portugal/Liga_Portugal_2.svg",
    ("Portugal", "Liga 3"): "portugal/Liga_3.svg",
    ("Argentina", "Liga Profesional"): "argentina/Argentina_Primera_Division.svg",
    ("Estados Unidos", "MLS"): "usa/MLS_-_Major_League_Soccer.svg",
    ("Japão", "J1 League"): "japan/J1_League.svg",
    ("Japão", "J3 League"): "japan/J3_League.svg",
    ("México", "Liga MX"): "mexico/Liga_MX.svg",
    ("México", "Liga de Expansión MX"): "mexico/Liga_de_Expansión_MX.svg",
    ("Arábia Saudita", "Saudi Professional League"): "saudi-arabia/Saudi_Professional_League.svg",
    ("China", "Super League"): "china/Chinese_Super_League.svg",
}
CUP_FILES = {
    "Copa do Brasil": "brazil/Copa_do_Brasil.svg",
    "Libertadores": "tournaments/Copa_Libertadores.svg",
    "Sul-Americana": "tournaments/Copa_Sudamericana.svg",
    "Mundial de Clubes": "tournaments/FIFA_Club_World_Cup.svg",
    "Champions League": "tournaments/UEFA_Champions_League.svg",
    "Europa League": "tournaments/UEFA_Europa_League.svg",
    "Conference League": "tournaments/UEFA_Conference_League.svg",
    "Champions da Ásia": "tournaments/AFC_Champions_League_Elite.svg",
    "FA Cup": "england/Emirates_FA_Cup.svg",
    "EFL Cup": "england/EFL_Carabao_Cup.svg",
    "Community Shield": "england/FA_Community_Shield.svg",
    "Copa do Rei": "spain/Copa_del_Rey.svg",
    "Supercopa da Espanha": "spain/Supercopa_de_España.svg",
    "Coppa Italia": "italy/Coppa_Italia.svg",
    "Supercoppa Italiana": "italy/Italian_Super_Cup.svg",
    "Taça de Portugal": "portugal/Taça_de_Portugal.svg",
    "KNVB Beker": "netherlands/KNVB_Cup.svg",
    "Copa dos Campeões da Concacaf": "tournaments/CONCACAF_Champions_Cup.svg",
    "Leagues Cup": "tournaments/Leagues_Cup.svg",
    "Copa da China": "china/Chinese_FA_Cup.svg",
    "DFB-Pokal": "germany/DFB_Pokal.svg",
    "Supercopa da Alemanha": "germany/Franz_Beckenbauer_Supercup.svg",
    "Coupe de France": "france/French_Cup.svg",
    "MLS Cup": "usa/MLS_Cup.svg",
    "U.S. Open Cup": "usa/U.S._Open_Cup.svg",
}


def normalize(value: str) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode().casefold()
    return re.sub(r"[^a-z0-9]", "", value)


def variants(value: str) -> set[str]:
    tokens = re.findall(r"[^\W_]+", value.casefold())
    result = {normalize(value)}
    removable = {"fc", "cf", "ca", "sc", "se", "cr", "ec", "cd", "ac", "as", "ss", "ssc", "asd", "asc", "ssd", "sd", "us", "uc", "cfc", "afc", "fbc", "sad", "af", "sef", "lr", "club", "clube", "football", "futebol", "calcio", "de", "del", "da", "do", "dos", "das", "the"}
    result.add(normalize(" ".join(token for token in tokens if token not in removable and not (token.isdigit() and len(token) == 4))))
    while tokens and tokens[0] in removable:
        tokens = tokens[1:]
        result.add(normalize(" ".join(tokens)))
    tokens = re.findall(r"[^\W_]+", value.casefold())
    while tokens and (tokens[-1] in removable or (tokens[-1].isdigit() and len(tokens[-1]) == 4)):
        tokens = tokens[:-1]
        result.add(normalize(" ".join(tokens)))
    return {candidate for candidate in result if candidate}


def fetch_paths() -> list[str]:
    request = Request(
        "https://api.github.com/repos/JoseArroyave/football-logos/git/trees/main?recursive=1",
        headers={"Accept": "application/vnd.github+json", "User-Agent": "Club-Legacy-logo-manifest"},
    )
    with urlopen(request, timeout=30) as response:
        payload = json.load(response)
    if payload.get("truncated"):
        raise RuntimeError("A list of logo files returned by GitHub was incomplete.")
    return [item["path"] for item in payload.get("tree", []) if item.get("path", "").startswith("logos/") and item["path"].endswith(".svg")]


def read_project_teams() -> dict[str, set[str]]:
    teams: dict[str, set[str]] = {country: set() for country in COUNTRY_FOLDERS}
    for catalog_name in ("openfootball_major_catalog.json", "openfootball_world_catalog.json"):
        catalog_path = ROOT / "assets" / catalog_name
        if catalog_path.exists():
            for league in json.loads(catalog_path.read_text(encoding="utf-8")):
                teams.setdefault(league["country"], set()).update(league.get("teams", []))
    source = (ROOT / "scripts" / "game.gd").read_text(encoding="utf-8")
    base_block = source.split("const BASE_LEAGUES := [", 1)[1].split("\n]", 1)[0]
    for country, team_list in re.findall(r'\{"country":"([^"]+)".*?"teams":(\[[^]]*\])\}', base_block):
        teams.setdefault(country, set()).update(json.loads(team_list))
    return teams


def main() -> None:
    source_paths = Path(sys.argv[1]) if len(sys.argv) > 1 else None
    paths = [line.strip() for line in source_paths.read_text(encoding="utf-8-sig").splitlines() if line.strip()] if source_paths else fetch_paths()
    filenames: dict[str, dict[str, set[str]]] = {}
    valid_paths = set(paths)
    for path in paths:
        if path.count("/") != 2:
            continue
        folder, filename = path.split("/")[1:]
        for candidate in variants(Path(filename).stem):
            filenames.setdefault(folder, {}).setdefault(candidate, set()).add(filename)

    clubs: dict[str, dict[str, str]] = {}
    unresolved: list[str] = []
    for country, names in read_project_teams().items():
        folder = COUNTRY_FOLDERS.get(country)
        if not folder:
            continue
        folder_files = filenames.get(folder, {})
        mapped: dict[str, str] = {}
        for team in sorted(names):
            manual = ALIASES.get((country, team), "")
            if manual and f"logos/{folder}/{manual}" in valid_paths:
                mapped[team] = manual
                continue
            hits: set[str] = set()
            for candidate in sorted(variants(team), key=len, reverse=True):
                candidate_hits = folder_files.get(candidate, set())
                if len(candidate_hits) == 1:
                    hits = candidate_hits
                    break
                hits.update(candidate_hits)
            if len(hits) == 1:
                mapped[team] = next(iter(hits))
            else:
                unresolved.append(f"{country}: {team}")
        clubs[country] = mapped

    leagues = {f"{country}|{name}": path.split("/", 1)[1] for (country, name), path in LEAGUE_FILES.items() if f"logos/{path}" in valid_paths}
    cups = {name: path for name, path in CUP_FILES.items() if f"logos/{path}" in valid_paths}
    manifest = {"source": "JoseArroyave/football-logos", "revision": "main", "clubs": clubs, "leagues": leagues, "cups": cups}
    output = ROOT / "assets" / "football_logo_manifest.json"
    output.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Clubes com imagem real: {sum(len(entries) for entries in clubs.values())}; sem correspondência única: {len(unresolved)}")
    print(f"Logos de liga: {len(leagues)}; logos de copas: {len(cups)}")
    if unresolved:
        print("Alguns clubes sem arquivo reconhecido:")
        print("\n".join(unresolved[:30]))


if __name__ == "__main__":
    main()
