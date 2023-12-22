import sqlite3

from flask import Flask, render_template, request

import Config
from db import get_SELECT
from . import CreateTask, Contract, Sortirowka


def Conect():
    app: Flask = Config.app

    @app.route("/", methods=["GET"])
    def Home():
        title = int(request.args.get('title', 0))
        listScanov = api_GetListAll()
        allSize = len(listScanov)
        listScanov = listScanov[title*100:title*100 + 100:]
        titleInt = int(allSize / 100)+1
        return render_template("home.html", listScanov=listScanov, str=str, titleList=range(titleInt))

    @app.route("/api/GetListAll", methods=["GET"])
    def api_GetListAll():
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()
        res = get_SELECT(sql, f"SELECT * FROM Contarcts")
        listScanov = list(res)
        return listScanov

    @app.route("/prehomepage", methods=["GET"])
    def PreHomePage():
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()
        res = get_SELECT(sql, f"SELECT * FROM Contarcts")
        listScanov = list(res)
        return render_template("preHomePage.html", listScanov=listScanov, str=str)

    CreateTask.Conect()
    Contract.Conect()
    Sortirowka.Conect()
