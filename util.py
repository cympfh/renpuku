import click
from typing import NamedTuple, Dict, List


class Race(NamedTuple):
    race_id: str
    num: int
    tan_odds: Dict[int, float]
    renpuku_odds: float
    rentan_odds: float
    order: List[int]


def loaddata():
    num_invalid = 0
    data = []
    for line in open('dataset/data.txt'):
        fs = line.strip().split('\t')
        if len(fs) != 5:
            num_invalid += 1
            continue
        race_id, tan_odds, renpuku_odds, rentan_odds, order = fs
        tan_odds = [float(x) for x in tan_odds.split(',')]
        renpuku_odds = float(renpuku_odds)
        rentan_odds = float(rentan_odds)
        order = [int(x) - 1 for x in order.split(',')]
        if len(tan_odds) != len(order):
            num_invalid += 1
            continue
        data.append(Race(race_id, len(order), tan_odds, renpuku_odds, rentan_odds, order))
    if num_invalid > 0:
        click.secho(f"#invalid data = {num_invalid}", err=True, fg='red')
    return data
