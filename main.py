import os

from flask import Flask

import Config
import analizator
import db
import flaskView

# @app.before_request
# def check_devolepers():
#     if not ('frags' in request.cookies and request.cookies['frags'] == ''):
#         return render_template('devoleper/register.html')


if __name__ == "__main__":
    if ('PYCHARM_HOSTED' in os.environ):
        Config.NameBD = "db T.db"
        # if os.path.exists(Config.NameBD):
        #     os.remove(Config.NameBD)
    app = Flask(__name__)
    Config.app = app
    flaskView.Conect()

    db.init()

    analizator.init()

    if ('PYCHARM_HOSTED' in os.environ):
        app.run(host='0.0.0.0', debug=True, port=3001)
    else:
        app.run(host='0.0.0.0', debug=False, port=3000)#False
