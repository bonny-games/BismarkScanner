import sqlite3
from flask import Flask, render_template, request, redirect
import Config
from db import get_SELECT


def api_CreateTask():
    json_data = request.get_json()
    code = json_data.get('Code')
    mode = json_data.get('mode')
    priority = int(json_data.get('priority', "0"))
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()

    res = sql.execute(f"SELECT * FROM Contarcts WHERE ContractCode = ?", (code,))
    res = res.fetchall()
    if (len(res) > 0):
        return str(res[0][0])

    sql.execute("INSERT INTO Contarcts (ContractCode,Stayt,Mode,Priority)VALUES(?,?,?,?)", (code, 0, mode, priority))
    inserted_id = sql.lastrowid
    db.commit()
    return str(inserted_id)

def Conect():
    app:Flask = Config.app
    app.route("/api/CreateTask",methods=["GET", "POST"])(api_CreateTask)

