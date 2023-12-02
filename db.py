import sqlite3

def init():
    db = sqlite3.connect("db.db")
    sql = db.cursor()

    sql.execute(
    """CREATE TABLE IF NOT EXISTS Contarcts (
        id INTEGER PRIMARY KEY,
        ContractCode TEXT,
        Stayt INTEGER,
        ContractOutp TEXT
    )
    """)


"""
Stayt
0 - null
1 - proses
2 - output ok
3 - output Eroor
"""