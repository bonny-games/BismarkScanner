import sqlite3

from flask import Flask, render_template, request

import Config
from db import get_SELECT


def Conect():
    app: Flask = Config.app

    @app.route("/Sortirowka", methods=["GET"])
    def Sortirowka():
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()

        title = int(request.args.get('title', 0))
        search = request.args.get('search', 'id')
        rewert = request.args.get('rewert', 'false') == 'true'

        res = get_SELECT(sql,
                         f"SELECT * FROM Contarcts WHERE {search} IS NOT NULL AND {search} <> 0 ORDER BY {search} " + (
                             "DESC" if rewert else ""))
        listScanov = list(res)

        allSize = len(listScanov)
        listScanov = listScanov[title*100:title*100 + 100:]
        titleInt = int(allSize / 100)+1
        return render_template("home.html", listScanov=listScanov, sortirovca=True, str=str, titleList=range(titleInt))
