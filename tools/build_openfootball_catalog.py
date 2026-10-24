#!/usr/bin/env python3
"""Build the game's compact league/team catalog from openfootball/world."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


COUNTRIES = {
    "algeria": ("Argélia", "dz", "Algeria"),
    "australia": ("Austrália", "au", "Australia"),
    "china": ("China", "cn", "China"),
    "costa-rica": ("Costa Rica", "cr", "Costa Rica"),
    "egypt": ("Egito", "eg", "Egypt"),
    "ghana": ("Gana", "gh", "Ghana"),
    "israel": ("Israel", "il", "Israel"),
    "japan": ("Japão", "jp", "Japan"),
    "kazakhstan": ("Cazaquistão", "kz", "Kazakhstan"),
    "kenya": ("Quênia", "ke", "Kenya"),
    "malawi": ("Malawi", "mw", "Malawi"),
    "mexico": ("México", "mx", "Mexico"),
    "morocco": ("Marrocos", "ma", "Morocco"),
    "nigeria": ("Nigéria", "ng", "Nigeria"),
    "rwanda": ("Ruanda", "rw", "Rwanda"),
    "saudi-arabia": ("Arábia Saudita", "sa", "Saudi Arabia"),
    "senegal": ("Senegal", "sn", "Senegal"),
    "south-africa": ("África do Sul", "za", "South Africa"),
    "tanzania": ("Tanzânia", "tz", "Tanzania"),
    "uganda": ("Uganda", "ug", "Uganda"),
    "zambia": ("Zâmbia", "zm", "Zambia"),
    "zimbabwe": ("Zimbábue", "zw", "Zimbabwe"),
}

CUP_CODES = {"afl", "cafcl", "concacafcl", "ilcup"}
ALLOWED_CODES = {"cn1", "jp1", "mx1", "mx2expansion", "sa1"}
FILENAME = re.compile(r"^(?P<year>\d{4})(?:-(?P<end>\d{2,4}))?_(?P<code>[a-z0-9]+)\.txt$", re.I)
MATCH = re.compile(
    r"^\s*(?:\d{1,2}:\d{2}\s+)?(?P<home>.+?)\s+v\s+"
    r"(?P<away>.+?)(?:\s+(?:(?:\d+\s*-\s*\d+).*|\[[^\]]+\]))?\s*$",
    re.I,
)
YEAR_SUFFIX = re.compile(r"\s+20\d{2}(?:/\d{2,4})?\s*$")
NON_SENIOR = re.compile(r"\b(?:women|woman|femin|ladies|youth|u[- ]?\d{2}|sub[- ]?\d{2})\b", re.I)


def season_rank(path: Path) -> tuple[int, int, str]:
    match = FILENAME.match(path.name)
    if not match:
        return (0, 0, path.name)
    return (int(match.group("year")), int(match.group("end") or 0), path.name)


def league_name(header: str, country_en: str) -> str:
    title = header.lstrip("= ").strip()
    if "|" in title:
        title = title.split("|", 1)[1].strip()
    else:
        title = re.sub(rf"^{re.escape(country_en)}\s+", "", title, flags=re.I)
    title = YEAR_SUFFIX.sub("", title).strip()
    return title or header.lstrip("= ").strip()


def read_teams(path: Path) -> list[str]:
    teams: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        match = MATCH.match(line)
        if not match:
            continue
        for side in ("home", "away"):
            name = re.sub(r"\s+", " ", match.group(side)).strip()
            if name and not re.search(r"\b(?:women|woman|femin|ladies|u[- ]?\d{2}|sub[- ]?\d{2})\b", name, re.I):
                teams.setdefault(name.casefold(), name)
    return sorted(teams.values(), key=str.casefold)


def build(source_dir: Path) -> list[dict[str, object]]:
    files = sorted(source_dir.rglob("*.txt"))
    latest: dict[str, Path] = {}
    metadata: dict[str, tuple[str, str, str, str]] = {}

    for path in files:
        filename = FILENAME.match(path.name)
        if not filename:
            continue
        code = filename.group("code").lower()
        if code not in ALLOWED_CODES:
            continue
        relative = path.relative_to(source_dir)
        if code in CUP_CODES or "champions-league" in relative.parts:
            continue
        country_key = path.parent.name.lower()
        if country_key not in COUNTRIES:
            continue
        country_pt, flag, country_en = COUNTRIES[country_key]
        key = f"{relative.parent.as_posix()}:{code}"
        if key not in latest or season_rank(path) > season_rank(latest[key]):
            latest[key] = path
            metadata[key] = (code, country_pt, flag, country_en)

    result: list[dict[str, object]] = []
    for key, path in sorted(latest.items(), key=lambda item: (metadata[item[0]][1].casefold(), item[0])):
        code, country, flag, country_en = metadata[key]
        header = path.read_text(encoding="utf-8-sig").splitlines()[0]
        if NON_SENIOR.search(header) or NON_SENIOR.search(key):
            continue
        teams = read_teams(path)
        if len(teams) < 6:
            continue
        result.append(
            {
                "id": f"openfootball:{key}",
                "source_code": code,
                "season_data": path.stem.split("_", 1)[0],
                "country": country,
                "flag": flag,
                "folder": f"openfootball-{code}",
                "name": league_name(header, country_en),
                "teams": teams,
                "team_logos": [],
                "competition_logo_available": False,
            }
        )
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source_dir", type=Path, help="Caminho da cópia openfootball/world")
    parser.add_argument("output", type=Path, help="JSON de saída")
    args = parser.parse_args()
    catalog = build(args.source_dir)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"{len(catalog)} ligas; {sum(len(item['teams']) for item in catalog)} vagas de equipes")


if __name__ == "__main__":
    main()
