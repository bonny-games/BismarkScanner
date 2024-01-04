import json
import sqlite3

from flask import Flask, redirect

import Config
from db import get_SELECT


def api_Contract(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
    if (len(res) == 0):
        return redirect('/')
    res = res[0]
    return res


def api_ContractStayt(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
    if (len(res) == 0):
        return "indeficator !=", 404
    res = res[0]
    return str(res["Stayt"])


def api_ContractAnalisText(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
    if (len(res) == 0):
        return "indeficator !=", 404
    res = res[0]
    resjson = json.loads(res['ContractOutp'])
    restext = ""
    print(resjson["issues"])
    for contract in resjson["issues"]:
        restext += \
            f"==== Dependence on predictable environment variable ====\n" \
            f"SWC ID: {contract['swc-id']}\n" \
            f"Severity: {contract['severity']}\n" \
            f"Contract: {contract['contract']}\n" \
            f"Function name: {contract['function']}\n" \
            f"PC address:  {contract['address']}\n" \
            f"Estimated Gas Usage:  {contract['min_gas_used']} - {contract['max_gas_used']}\n" \
            f"{contract['description']}\n"

        restext += \
            f"--------------------\n" \
            f"In file:  {contract['filename']}:{contract['lineno']}\n\n" \
            f"{contract['code']}\n\n" \

                    # restext +=\
        # f"--------------------\n"\
        # f"Initial State:\n\n"\
        # "Account: "

    res["ContractCode"] = restext
    return res


def api_ContractAnalis(indeficator):
    return "в разработке"

def api_ContractBreic(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = {indeficator}")
    if (len(res) == 0):
        return "null", 404
    res = res[0]
    if(res["Stayt"] != 1):
        return f"Stayt != 1, {res['Stayt']}", 404
    sql.execute(f"UPDATE Contarcts SET Stayt = -1, ContractOutp=\"Breic\" WHERE id = {res['id']}")
    db.commit()
    sql.close()
    db.close()
    return "ok"

def api_ContractCancel(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = {indeficator}")
    if (len(res) == 0):
        return "null", 404
    res = res[0]
    if(res["Stayt"] != 0):
        return f"Stayt != 0, {res['Stayt']}", 404
    sql.execute(f"UPDATE Contarcts SET Stayt = 3, ContractOutp=\"Cancel\" WHERE id = {res['id']}")
    db.commit()
    sql.close()
    db.close()
    return "ok"

def api_ContractRestart(indeficator):
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()
    res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = {indeficator}")
    if (len(res) == 0):
        return "null", 404
    res = res[0]
    if not (res["Stayt"] == 2 or res["Stayt"] == 3):
        return f"Stayt != 2,3 , {res['Stayt']}", 404
    sql.execute(f"UPDATE Contarcts SET Stayt = 0 WHERE id = {res['id']}")
    db.commit()
    sql.close()
    db.close()
    return "ok"


def Conect():
    app: Flask = Config.app

    app.route("/api/contract/<indeficator>", methods=["GET"])(api_Contract)
    app.route("/api/contract/<indeficator>/Stayt", methods=["GET"])(api_ContractStayt)
    app.route("/api/contract/<indeficator>/AnalisText", methods=["GET"])(api_ContractAnalisText)
    app.route("/api/contract/<indeficator>/Analis", methods=["GET"])(api_ContractAnalis)

    app.route("/api/contract/<indeficator>/Breic", methods=["GET"])(api_ContractBreic)
    app.route("/api/contract/<indeficator>/Cancel", methods=["GET"])(api_ContractCancel)
    app.route("/api/contract/<indeficator>/Restart", methods=["GET"])(api_ContractRestart)
