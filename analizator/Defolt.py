import os
import random
import signal
import subprocess

import Config


def Analis(code, output="text"):
    if (code == None):
        return {
            "text": "code == None",
            "isUspex": False
        }
    current_directory = os.getcwd()
    neme = str(random.random())[2:] + ".sol"
    with open(f"{current_directory}/cont/{neme}", "w") as f:
        f.write(code)
    command = f"docker run -v {current_directory}/cont/:/contracts mythril/myth myth analyze /contracts/{neme} -o {output}"

    try:
        # print(command)
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate(timeout=Config.timeout)

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
    except subprocess.TimeoutExpired:
        print(f"Превышено время ожидания ({Config.timeout} секунд). Процесс будет прерван.")
        try:
            os.kill(process.pid, signal.SIGTERM)
            process.communicate()
        except:
            pass

        try:
            subprocess.run(f"kill -9 {process.pid}", shell=True)
        except:
            pass

        return {
            "text": f"Превышено время ожидания ({Config.timeout} секунд). Процесс будет прерван.",
            "isUspex": False
        }
