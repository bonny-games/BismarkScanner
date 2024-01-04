import sqlite3

import Config


def init():
    db = sqlite3.connect(Config.NameBD)
    sql = db.cursor()

    sql.execute(
    """CREATE TABLE IF NOT EXISTS Contarcts (
        id INTEGER PRIMARY KEY,
        ContractCode TEXT,
        Stayt INTEGER,
        ContractOutp TEXT,
        Mode TEXT,
        Points INTEGER,
        SeverityLow INTEGER,
        SeverityMedium INTEGER,
        SeverityHigh INTEGER,
        SeverityCritical INTEGER,
        filename TEXT,
        Priority INTEGER
    )
    """)
    db.commit()

    sql.execute(f"UPDATE Contarcts SET Stayt = 0 WHERE Stayt = 1")
    db.commit()

    sql.execute(f"UPDATE Contarcts SET Stayt = 3, ContractOutp=\"Breic\" WHERE Stayt = -1")
    db.commit()

    sql.close()
    db.close()


"""
Stayt
0 - null
1 - proses
2 - output ok
3 - output Eroor
"""


def get_SELECT(sql,zapros):
    sql.execute(zapros)
    columns = [col[0] for col in sql.description]
    result = [dict(zip(columns, row)) for row in sql.fetchall()]
    return result