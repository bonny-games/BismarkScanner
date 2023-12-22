import sqlite3
from flask import Flask, render_template, request, redirect
import Config
from db import get_SELECT


def Conect():
    app:Flask = Config.app

    @app.route("/CreateTask", methods=["GET", "POST"])
    def CreateTask():
        if request.method == 'POST':
            code = request.form.get('Code')
            mode = request.form.get('mode')
            priority = int(request.form.get('priority',"0"))
            db = sqlite3.connect(Config.NameBD)
            sql = db.cursor()

            res = sql.execute(f"SELECT * FROM Contarcts WHERE ContractCode = ?", (code,))
            res = res.fetchall()
            if (len(res) > 0):
                return redirect(f'/contract/{res[0][0]}')

            sql.execute("INSERT INTO Contarcts (ContractCode,Stayt,Mode,Priority)VALUES(?,?,?,?)", (code, 0, mode,priority))
            inserted_id = sql.lastrowid
            db.commit()
            return redirect(f'/contract/{inserted_id}')
        return render_template("CreateTask.html")

    @app.route("/api/CreateTask", methods=["GET", "POST"])
    def api_CreateTask():
        json_data = request.get_json()
        code = json_data.get('Code')
        mode = json_data.get('mode')
        priority = int(json_data.get('priority', "0"))
        db = sqlite3.connect(Config.NameBD)
        sql = db.cursor()

        res = sql.execute(f"SELECT * FROM Contarcts WHERE ContractCode = ?", (code,))
        res = res.fetchall()
        if(len(res)>0):
            return str(res[0][0])

        sql.execute("INSERT INTO Contarcts (ContractCode,Stayt,Mode,Priority)VALUES(?,?,?,?)", (code, 0, mode, priority))
        inserted_id = sql.lastrowid
        db.commit()
        return str(inserted_id)

    @app.route("/CreateTaskFiles", methods=["GET", "POST"])
    def CreateTaskFiles():
        if request.method == 'POST':
            mode = request.form.get('mode')
            priority = int(request.form.get('priority', "0"))
            print(request.files)
            files = request.files.getlist('file')
            print(files)
            for file in files:

                if file:
                    if file.filename == '':
                        continue
                    code = None
                    try:
                        byte_string = file.read()
                        possible_encodings = ['utf-8', 'latin-1', 'cp1252']
                        for encoding in possible_encodings:
                            try:
                                code = byte_string.decode(encoding)
                                # print(f"Декодированная строка с использованием {encoding}: {code}")
                                break
                            except UnicodeDecodeError:
                                pass
                    except:
                        continue
                    if code == None:
                        continue
                    db = sqlite3.connect(Config.NameBD)
                    sql = db.cursor()

                    res = sql.execute(f"SELECT * FROM Contarcts WHERE ContractCode = ?", (code,))
                    res = res.fetchall()

                    if (len(res) > 0):
                        continue

                    sql.execute("INSERT INTO Contarcts (ContractCode,Stayt,Mode,filename,Priority)VALUES(?,?,?,?,?)",
                                (code, 0, mode,file.filename, priority))
                    # sql.execute("INSERT INTO Contarcts (ContractCode,Stayt,Mode,filename)VALUES(?,?,?,?)", (code, 0, mode,file.filename))
                    db.commit()
            return redirect('/')
        return render_template("CreateTaskFiles.html")
