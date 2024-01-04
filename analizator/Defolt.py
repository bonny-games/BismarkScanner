import os
import random
import signal
import sqlite3
import subprocess
import time
import psutil
import docker

import Config
from db import get_SELECT


def Analis(code, id, output="text"):
    if (code == None):
        return {
            "text": "code == None",
            "isUspex": False
        }
    current_directory = os.getcwd()
    neme = str(random.random())[2:] + ".sol"
    with open(f"{current_directory}/cont/{neme}", "w") as f:
        f.write(code)
    command = f"docker run -v {current_directory}/cont/:/contracts mythril/myth myth analyze /contracts/{neme} -o {output} --execution-timeout {int(Config.timeout)}"


    Eroor = None
    try:
        # print(command)
        start_time = time.time()

        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        Config.PIDActive.append(process.pid)
        while process.poll() is None:
            time.sleep(5)
            elapsed_time = time.time() - start_time
            if elapsed_time > Config.timeout + (5 * 60):
                Eroor = f"Превышено время ожидания ({Config.timeout} секунд). Процесс будет прерван.",
                raise TypeError(Eroor)
            res = 0
            try:
                db = sqlite3.connect(Config.NameBD)
                sql = db.cursor()
                res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = {id}")
                res = res[0]
                res = res["Stayt"]

                sql.close()
                db.close()
            except:
                pass
            if (res == -1):
                Eroor = f"Визван Breic"
                raise TypeError(f"Визван Breic")
        stdout, stderr = process.communicate()
        # stdout, stderr = process.communicate(timeout=Config.timeout)

        if stdout:
            res = f"{stdout.decode()}\n"
            return {
                "text": res,
                "isUspex": True
            }
        if stderr:
            res = f"{stderr.decode()}\n"
            returncode = process.returncode
            # print(f"Команда завершилась с ошибкой. Код завершения: {returncode}")
            return {
                "text": f"Команда завершилась с ошибкой. Код завершения: {returncode} \nres:{res}",
                "isUspex": False
            }
    except Exception as e:
        # print(f"Превышено время ожидания ({Config.timeout} секунд). Процесс будет прерван.")
        killPid = [process.pid]

        parent_process = psutil.Process(process.pid)
        children = parent_process.children()
        for child in children:
            killPid.append(child.pid)
            print(f"PID: {child.pid}, Имя: {child.name()}")

        try:
            os.kill(process.pid, signal.SIGTERM)
        except:
            pass

        try:
            os.kill(process.pid, 9)
        except:
            pass

        try:
            subprocess.run(f"kill -9 {process.pid}", shell=True)
        except:
            pass

        try:
            process.communicate()
        except:
            pass

        try:
            Config.PIDActive.remove(process.pid)
        except:
            pass

        if (Eroor == None):
            Eroor = str(e)
        return {
            "text": Eroor,
            "isUspex": False
        }
