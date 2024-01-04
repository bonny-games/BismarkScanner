import json

from . import Defolt

UisvimostToPoints = {
    "Low": 1,
    "Medium": 10,
    "High": 30,
    "Critical": 100
}


def Analis(code,id):
    res = Defolt.Analis(code, id, "json")
    if (not res["isUspex"]):
        return res
    text = res["text"]
    try:
        resjson = json.loads(text)
    except:
        return {
            "text": f"не смог перебразавать в json \n {text}",
            "isUspex": False
        }

    if resjson.get("error") != None:
        return {
            "text": json.dumps(resjson, indent=2),
            "isUspex": False
        }

    Points = 0
    NumbersSeverity = {
        "SeverityLow": 0, "SeverityMedium": 0, "SeverityHigh": 0, "SeverityCritical": 0
    }
    for i in resjson["issues"]:
        severity = i["severity"]
        Points += UisvimostToPoints[severity]
        NumbersSeverity["Severity" + severity] += 1

    newres = {
        "text": json.dumps(resjson, indent=2),
        "isUspex": True,
        "Points": Points,
    }
    newres.update(NumbersSeverity)
    return newres
