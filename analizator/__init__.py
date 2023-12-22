import os
import random
import signal
import sqlite3
import subprocess
import time
import traceback
from threading import Thread

import Config
from db import get_SELECT

from . import Defolt
from . import PointsMode

modeAnalisFuncsion = {
    "Defolt":Defolt.Analis,
    "PointsMode": PointsMode.Analis,
}

def init():
    for i in range(Config.potoc):
        Thread(target=Unit, args=(i,), daemon=True).start()

def Unit(i):
    time.sleep(i)
    while True:
        try:
            ContractPoisc()
        except Exception as e:
            print(f"Ошибка: {e}")
            traceback.print_exc()
        time.sleep(5)

def ContractPoisc():
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    for i in range(5):
        res = get_SELECT(sql,f"SELECT * FROM Contarcts WHERE Stayt = 0 AND Priority == {i}")
        if (len(res) != 0):
            break
    if(len(res) == 0):
        return
    res = res[0]
    print(f"ContractPoisc: ok id:{res['id']}")
    sql.execute(f"UPDATE Contarcts SET Stayt = 1 WHERE id = {res['id']}")
    db.commit()
    sql.close()
    db.close()

    resAnalis = modeAnalisFuncsion[res['Mode']](res['ContractCode'])

    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    if(resAnalis["isUspex"]):
        sql.execute(f"UPDATE Contarcts SET Stayt = 2 WHERE id = {res['id']}")
    else:
        sql.execute(f"UPDATE Contarcts SET Stayt = 3 WHERE id = {res['id']}")
    sql.execute("UPDATE Contarcts SET ContractOutp = ? WHERE id = ?", (resAnalis["text"], res['id']))
    for data in ["Points","SeverityLow","SeverityMedium","SeverityHigh","SeverityCritical"]:
        sql.execute(f"UPDATE Contarcts SET {data} = ? WHERE id = ?", (resAnalis.get(data), res['id']))
    db.commit()
    sql.close()
    db.close()






