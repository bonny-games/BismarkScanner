import sqlite3
from threading import Thread

from flask import Flask, render_template, request, redirect, url_for
import Config
import analizator
import db

db.init()
app = Flask(__name__)
Config.app = app

@app.route("/")
def Home():
    db = sqlite3.connect("db.db")
    sql = db.cursor()
    res = sql.execute(f"SELECT * FROM Contarcts")
    listScanov = list(res)
    # print(listScanov[0][0])
    return render_template("home.html",listScanov=listScanov)

@app.route("/CreateTask", methods=["GET","POST"])
def CreateTask():
    if request.method == 'POST':
        code = request.form.get('Code')
        db = sqlite3.connect("db.db")
        sql = db.cursor()
        sql.execute("INSERT INTO Contarcts (ContractCode,Stayt)VALUES(?,?)", (code,0))
        db.commit()
        return redirect('/')
    return render_template("CreateTask.html")

@app.route("/contract/<indeficator>", methods=["GET"])
def Contract(indeficator):
    db = sqlite3.connect("db.db")
    sql = db.cursor()
    res = list(sql.execute(f"SELECT * FROM Contarcts WHERE id = '{indeficator}'"))
    if(len(res) == 0):
        return redirect('/')
    res = res[0]
    if(res[2]==0 or res[2]==1):
        return render_template("ContractView.html", res=res)
    return render_template("ContractOutp.html", res=res)

@app.route("/contract/<indeficator>/view", methods=["GET"])
def ContractView(indeficator):
    db = sqlite3.connect("db.db")
    sql = db.cursor()
    res = list(sql.execute(f"SELECT * FROM Contarcts WHERE id = '{indeficator}'"))
    if(len(res) == 0):
        return redirect('/')
    res = res[0]
    return render_template("ContractView.html", res=res)


if __name__ == "__main__":
    db = sqlite3.connect("db.db")
    sql = db.cursor()
    sql.execute(f"UPDATE Contarcts SET Stayt = 0 WHERE Stayt = 1")
    db.commit()
    sql.close()
    db.close()
    for i in range(Config.potoc):
        Thread(target=analizator.init, args=(i,)).start()
    app.run(host='0.0.0.0', debug=False, port=3000)

