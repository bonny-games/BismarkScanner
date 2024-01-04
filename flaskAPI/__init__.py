import sqlite3

from flask import Flask, render_template, request

import Config
from db import get_SELECT
from . import CreateTask,Contract

def api_GetListAll():
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts")
    listScanov = list(res)
    return listScanov

def api_GetListAll_NouCode():
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts")
    listScanov = list(res)
    for i in listScanov:
        del i["ContractCode"]
    return listScanov

def Conect():
    app: Flask = Config.app
    app.route("/api/GetListAll",methods=["GET"])(api_GetListAll)
    app.route("/api/GetListAllNouCode",methods=["GET"])(api_GetListAll_NouCode)

    CreateTask.Conect()
    Contract.Conect()

