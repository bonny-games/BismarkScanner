import os
import signal
import subprocess

from flask import Flask

import Config
import analizator
import db
import flaskView,flaskAPI
import atexit

def on_exit():
    for notoc in Config.PotocsActive:
        try:
            os.kill(notoc.ident, 9)
        except:
            pass
    for pid in Config.PIDActive:
        try:
            os.kill(pid, signal.SIGTERM)
        except ProcessLookupError:
            print(f"Процесс с PID {pid} не найден.")
        except PermissionError:
            print(f"Отсутствуют права на завершение процесса с PID {pid}.")

        try:
            os.kill(pid, 9)
        except:
            pass

        try:
            subprocess.run(f"kill -9 {pid}", shell=True)
        except:
            pass
    print("Программа завершена. Вызвана конечная функция.")

# @app.before_request
# def check_devolepers():
#     if not ('frags' in request.cookies and request.cookies['frags'] == ''):
#         return render_template('devoleper/register.html')


if __name__ == "__main__":
    atexit.register(on_exit)

    # if ('PYCHARM_HOSTED' in os.environ):
    #     Config.NameBD = "db T.db"
    #     # if os.path.exists(Config.NameBD):
    #     #     os.remove(Config.NameBD)

    app = Flask(__name__)
    Config.app = app

    flaskView.Conect()
    flaskAPI.Conect()

    db.init()

    analizator.init()

    if ('PYCHARM_HOSTED' in os.environ):
        # app.run(host='0.0.0.0', debug=True, port=3001)
        app.run(host='0.0.0.0', debug=True, port=3000)
    else:
        app.run(host='0.0.0.0', debug=False, port=3000)#False
