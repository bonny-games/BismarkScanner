import sqlite3

from flask import Flask, render_template, redirect

import Config
from db import get_SELECT
from flaskAPI.Contract import api_ContractStayt, api_ContractAnalisText


def Contract(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
    if (len(res) == 0):
        return redirect('/')
    res = res[0]
    if (res['Stayt'] == 0 or res['Stayt'] == 1):
        return render_template("ContractView.html", res=res)
    return render_template("ContractOutp.html", res=res)


def ContractView(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
    if (len(res) == 0):
        return redirect('/')
    res = res[0]
    return render_template("ContractView.html", res=res)


def ContractStayt(indeficator):
    return api_ContractStayt(indeficator)


def ContractAnalisText(indeficator):
    return render_template("ContractView.html", res=api_ContractAnalisText(indeficator))


def ContractAnalis(indeficator):
    return "в разработке"


def Conect():
    app: Flask = Config.app

    app.route("/contract/<indeficator>", methods=["GET"])(Contract)
    app.route("/contract/<indeficator>/view", methods=["GET"])(ContractView)
    app.route("/contract/<indeficator>/Stayt", methods=["GET"])(ContractStayt)
    app.route("/contract/<indeficator>/AnalisText", methods=["GET"])(ContractAnalisText)
    app.route("/contract/<indeficator>/Analis", methods=["GET"])(ContractAnalis)
