import sqlite3
from flask import Flask, render_template, request, redirect
import Config

def Conect():
    app:Flask = Config.app

    @app.route("/CreateTask", methods=["GET", "POST"])
    def CreateTask():
        if request.method == 'POST':
            code = request.form.get('Code')
            mode = request.form.get('mode')
            db = sqlite3.connect(Config.NameBD)
            sql = db.cursor()
            sql.execute("INSERT INTO Contarcts (ContractCode,Stayt,Mode)VALUES(?,?,?)", (code, 0, mode))
            inserted_id = sql.lastrowid
            db.commit()
            return redirect(f'/contract/{inserted_id}')
        return render_template("CreateTask.html")

    @app.route("/CreateTaskFiles", methods=["GET", "POST"])
    def CreateTaskFiles():
        if request.method == 'POST':
            mode = request.form.get('mode')
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
                    sql.execute("INSERT INTO Contarcts (ContractCode,Stayt,Mode,filename)VALUES(?,?,?,?)", (code, 0, mode,file.filename))
                    db.commit()
            return redirect('/')
        return render_template("CreateTaskFiles.html")
