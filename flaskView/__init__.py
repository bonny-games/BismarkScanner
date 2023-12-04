from db import get_SELECT
from . import CreateTask,Contract,Sortirowka
import sqlite3

from flask import Flask, render_template, request, redirect, url_for
import Config

def Conect():
    app:Flask = Config.app
    @app.route("/", methods=["GET"])
    def Home():
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()
        res = get_SELECT(sql,f"SELECT * FROM Contarcts")
        listScanov = list(res)
        # print(listScanov[0][0])
        print(listScanov[0]['filename'])
        return render_template("home.html", listScanov=listScanov, str=str)
    CreateTask.Conect()
    Contract.Conect()
    Sortirowka.Conect()