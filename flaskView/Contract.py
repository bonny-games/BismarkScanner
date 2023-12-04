import json
import sqlite3
from threading import Thread

from flask import Flask, render_template, request, redirect, url_for
import Config
import analizator
from db import get_SELECT
import os

import flaskView


def Conect():
    app:Flask = Config.app

    @app.route("/contract/<indeficator>", methods=["GET"])
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

    @app.route("/contract/<indeficator>/view", methods=["GET"])
    def ContractView(indeficator):
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()
        res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
        if (len(res) == 0):
            return redirect('/')
        res = res[0]
        return render_template("ContractView.html", res=res)

    @app.route("/contract/<indeficator>/Stayt", methods=["GET"])
    def ContractStayt(indeficator):
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()
        res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
        if (len(res) == 0):
            return redirect('/')
        res = res[0]
        return str(res["Stayt"])

    @app.route("/contract/<indeficator>/AnalisText", methods=["GET"])
    def ContractAnalisText(indeficator):
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()
        res = get_SELECT(sql, f"SELECT * FROM Contarcts WHERE id = '{indeficator}'")
        if (len(res) == 0):
            return redirect('/')
        res = res[0]
        resjson = json.loads(res['ContractOutp'])
        restext = ""
        print(resjson["issues"])
        for contract in resjson["issues"]:
            restext += \
            f"==== Dependence on predictable environment variable ====\n"\
            f"SWC ID: {contract['swc-id']}\n"\
            f"Severity: {contract['severity']}\n"\
            f"Contract: {contract['contract']}\n"\
            f"Function name: {contract['function']}\n"\
            f"PC address:  {contract['address']}\n"\
            f"Estimated Gas Usage:  {contract['min_gas_used']} - {contract['max_gas_used']}\n"\
            f"{contract['description']}\n"\

            restext += \
            f"--------------------\n"\
            f"In file:  {contract['filename']}:{contract['lineno']}\n\n"\
            f"{contract['code']}\n\n"\

            # restext +=\
            # f"--------------------\n"\
            # f"Initial State:\n\n"\
            # "Account: "

        res["ContractCode"] = restext
        return render_template("ContractView.html", res=res)

    @app.route("/contract/<indeficator>/Analis", methods=["GET"])
    def ContractAnalis(indeficator):
        return "в разработке"
