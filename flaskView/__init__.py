from flask import Flask, render_template, request

import Config
from flaskAPI import api_GetListAll
from . import CreateTask, Contract, Sortirowka


def Home():
    title = int(request.args.get('title', 0))
    listScanov = api_GetListAll()
    allSize = len(listScanov)
    listScanov = listScanov[title * 100:title * 100 + 100:]
    titleInt = int(allSize / 100) + 1
    return render_template("home.html", listScanov=listScanov, str=str, titleList=range(titleInt), titleIndex=title)


def PreHomePage():
    return render_template("preHomePage.html")
def Prosent():
    return render_template("Prosent.html",pidList=str(Config.PIDActive)+"*")


def Conect():
    app: Flask = Config.app

    app.route("/", methods=["GET"])(Home)
    app.route("/prehomepage", methods=["GET"])(PreHomePage)
    app.route("/Prosent", methods=["GET"])(Prosent)

    CreateTask.Conect()
    Contract.Conect()
    Sortirowka.Conect()
