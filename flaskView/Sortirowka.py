from flask import Flask

import Config

from db import get_SELECT
from . import CreateTask,Contract,Sortirowka
import sqlite3

from flask import Flask, render_template, request, redirect, url_for
import Config

def Conect():
    app: Flask = Config.app

    @app.route("/Sortirowka", methods=["GET"])
    def Sortirowka():
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()

        search = request.args.get('search','id')
        rewert = request.args.get('rewert','false') == 'true'


        res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE {search} IS NOT NULL AND {search} <> 0 ORDER BY {search} "+("DESC" if rewert else ""))
        listScanov = list(res)

        return render_template("home.html", listScanov=listScanov,sortirovca = True, str=str)






