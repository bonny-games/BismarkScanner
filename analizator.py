import os
import random
import signal
import sqlite3
import subprocess
import time

import Config


def init(i):
    time.sleep(i)
    while True:
        ContractPoisc()
        # try:
        #     ContractPoisc()
        # except:
        #     print("eroor")
        time.sleep(5)

def ContractPoisc():
    db = sqlite3.connect("db.db")
    sql = db.cursor()
    res = list(sql.execute(f"SELECT * FROM Contarcts WHERE Stayt = 0"))
    if(len(res) == 0):
        return
    res = res[0]
    print(f"ContractPoisc: ok id:{res[0]}")
    sql.execute(f"UPDATE Contarcts SET Stayt = 1 WHERE id = {res[0]}")
    db.commit()
    sql.close()
    db.close()

    resAnalis,yspex = Analis(res[1])
    print(len(resAnalis))
    print(yspex)

    db = sqlite3.connect("db.db")
    sql = db.cursor()
    if(yspex):
        sql.execute(f"UPDATE Contarcts SET Stayt = 2 WHERE id = {res[0]}")
    else:
        sql.execute(f"UPDATE Contarcts SET Stayt = 3 WHERE id = {res[0]}")
    # db.commit()
    # print(res[0])
    # print(resAnalis)
    sql.execute("UPDATE Contarcts SET ContractOutp = ? WHERE id = ?", (resAnalis, res[0]))
    db.commit()
    sql.close()
    db.close()



def Analis(code):
    current_directory = os.getcwd()
    neme = str(random.random())[2:]+".sol"
    with open(f"{current_directory}/cont/{neme}","w") as f:
        f.write(code)
    command = f"docker run -v {current_directory}/cont/:/contracts mythril/myth myth analyze /contracts/{neme}"

    # return "dasdfasd",True
    try:
        # print(command)
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate(timeout=Config.timeout)

        if process.returncode == 0:
            res = ""
            if stdout:
                res += f"Output: {stdout.decode()}\n"
            if stderr:
                res += f"Eroor: {stderr.decode()}\n"
            print(res)
            return res, True
        else:
            res = ""
            if stdout:
                res += f"Стандартный вывод: {stdout.decode()}\n"
            if stderr:
                res += f"Стандартный вывод ошибок: {stderr.decode()}\n"
            returncode = process.returncode
            print(f"Команда завершилась с ошибкой. Код завершения: {returncode}")
            return f"Команда завершилась с ошибкой. Код завершения: {returncode} \nres:{res}",False

    except subprocess.TimeoutExpired:
        print(f"Превышено время ожидания ({Config.timeout} секунд). Процесс будет прерван.")
        os.kill(process.pid, signal.SIGTERM)
        process.communicate()
        return f"Превышено время ожидания ({Config.timeout} секунд). Процесс будет прерван.",False



