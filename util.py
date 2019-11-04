import click
from typing import NamedTuple, Dict, List


class Race(NamedTuple):
    race_id: str
    num: int
    tan_odds: Dict[int, float]
    ren_odds: float
    order: List[int]


def loaddata():
    num_invalid = 0
    data = []
    for line in open('dataset/data.txt'):
        fs = line.strip().split('\t')
        if len(fs) != 4:
            num_invalid += 1
            continue
        race_id, tan_odds, ren_odds, order = fs
        tan_odds = [float(x) for x in tan_odds.split(',')]
        ren_odds = float(ren_odds)
        order = [int(x) - 1 for x in order.split(',')]
        if len(tan_odds) != len(order):
            num_invalid += 1
            continue
        data.append(Race(race_id, len(order), tan_odds, ren_odds, order))
    if num_invalid > 0:
        click.secho(f"#invalid data = {num_invalid}", err=True, fg='red')
    return data
