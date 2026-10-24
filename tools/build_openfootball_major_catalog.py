#!/usr/bin/env python3
"""Build a compact senior men's league catalog from CC0 OpenFootball repos."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(sys.argv[1])
OUT = Path(sys.argv[2])
MATCH = re.compile(r"^\s*(?:\d{1,2}:\d{2}\s+)?(?P<home>.+?)\s+v\s+(?P<away>.+?)(?:\s+\d+\s*-\s*\d+.*|\s+\[[^]]+\])?\s*$", re.I)
LEAGUES = [
    ("england-master", ".", "Inglaterra", "gb-eng", "Premier League", "1-premierleague.txt", 1),
    ("england-master", ".", "Inglaterra", "gb-eng", "Championship", "2-championship.txt", -1),
    ("england-master", ".", "Inglaterra", "gb-eng", "League One", "3-leagueone.txt", -1),
    ("england-master", ".", "Inglaterra", "gb-eng", "League Two", "4-leaguetwo.txt", -1),
    ("espana-master", ".", "Espanha", "es", "La Liga", "1-liga.txt", 2),
    ("espana-master", ".", "Espanha", "es", "Segunda División", "2-liga2.txt", -1),
    ("deutschland-master", ".", "Alemanha", "de", "Bundesliga", "1-bundesliga.txt", -1),
    ("deutschland-master", ".", "Alemanha", "de", "2. Bundesliga", "2-bundesliga2.txt", -1),
    ("deutschland-master", ".", "Alemanha", "de", "3. Liga", "3-liga3.txt", -1),
	("italy-master", ".", "Itália", "it", "Serie A", "1-seriea.txt", 3),
    ("italy-master", ".", "Itália", "it", "Serie B", "2-serieb.txt", -1),
    ("italy-master", ".", "Itália", "it", "Serie C - Grupo A", "3-seriec_a.txt", -1),
    ("italy-master", ".", "Itália", "it", "Serie C - Grupo B", "3-seriec_b.txt", -1),
    ("italy-master", ".", "Itália", "it", "Serie C - Grupo C", "3-seriec_c.txt", -1),
	("europe-master", "france", "França", "fr", "Ligue 1", "*_fr1.txt", -1),
    ("europe-master", "france", "França", "fr", "Ligue 2", "*_fr2.txt", -1),
	("europe-master", "netherlands", "Países Baixos", "nl", "Eredivisie", "*_nl1.txt", 5),
    ("europe-master", "netherlands", "Países Baixos", "nl", "Eerste Divisie", "*_nl2.txt", -1),
	("europe-master", "portugal", "Portugal", "pt", "Primeira Liga", "*_pt1.txt", 4),
    ("europe-master", "portugal", "Portugal", "pt", "Liga Portugal 2", "*_pt2.txt", -1),
	("south-america-master", "argentina", "Argentina", "ar", "Liga Profesional", "*_ar1.txt", 6),
	("south-america-master", "brazil", "Brasil", "br", "Série A", "*_br1.txt", 0),
	("world-master", "north-america/major-league-soccer", "Estados Unidos", "us", "MLS", "*_mls.txt", 7),
    ("FootballData-main", "database/brasil-serie-b", "Brasil", "br", "Série B", "brasil-serie-b 2026.json", -1),
    ("FootballData-main", "database/brasil-serie-c", "Brasil", "br", "Série C", "brasil-serie-c 2026.json", -1),
    ("FootballData-main", "database/brasil-serie-d", "Brasil", "br", "Série D", "brasil-serie-d 2026.json", -1),
]


def pick_latest(folder: Path, pattern: str) -> Path | None:
    candidates = sorted(
        path for path in folder.rglob(pattern)
        if not {"archive", "rsssf", "openliga"}.intersection(part.lower() for part in path.parts)
    )
    return candidates[-1] if candidates else None


def extract_teams(path: Path) -> list[str]:
    teams: dict[str, str] = {}
    if path.suffix.lower() == ".json":
        matches = json.loads(path.read_text(encoding="utf-8"))
        for match in matches:
            for key in ("home", "away"):
                raw_name = str(match.get(key, "")).strip()
                raw_name = re.sub(r"[\r\n]+\d+$", "", raw_name)
                name = re.sub(r"\s+", " ", raw_name).strip()
                if name:
                    teams.setdefault(name.casefold(), name)
        return sorted(teams.values(), key=str.casefold)
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        found = MATCH.match(line)
        if not found:
            continue
        for key in ("home", "away"):
            name = re.sub(r"\s+", " ", found.group(key)).strip()
            if name and not re.search(r"\b(?:women|woman|femin|ladies|u[- ]?\d{2}|sub[- ]?\d{2})\b", name, re.I):
                teams.setdefault(name.casefold(), name)
    return sorted(teams.values(), key=str.casefold)


def main() -> None:
    result = []
    for repo, relative, country, flag, name, pattern, legacy_index in LEAGUES:
        path = pick_latest(ROOT / repo / relative, pattern)
        if path is None:
            print(f"Aviso: competição não encontrada: {country} - {name}")
            continue
        teams = extract_teams(path)
        if len(teams) < 6:
            print(f"Aviso: elenco insuficiente: {path}")
            continue
        result.append({
            "id": f"openfootball:{repo}:{relative}:{path.stem}",
            "source_code": path.stem.rsplit("_", 1)[-1],
            "season_data": path.parent.name if re.match(r"^20\d{2}(?:-\d{2})?$", path.parent.name) else (re.search(r"20\d{2}(?:-\d{4})?", path.stem).group(0) if re.search(r"20\d{2}(?:-\d{4})?", path.stem) else path.stem.split("_", 1)[0]),
            "country": country,
            "flag": flag,
            "folder": f"openfootball-major-{country.lower().replace(' ', '-')}",
            "name": name,
            "teams": teams,
            "team_logos": [],
            "competition_logo_available": False,
            "legacy_index": legacy_index,
        })
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"{len(result)} ligas principais; {sum(len(x['teams']) for x in result)} equipes")


if __name__ == "__main__":
    main()
