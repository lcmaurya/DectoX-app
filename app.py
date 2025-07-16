from flask import Flask, render_template
from data import coins

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("home.html", coins=coins)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050, debug=True)
@app.route("/scan_contract", methods=["POST"])
def scan_contract():
    contract_address = request.form.get("contract_address")

    # Dummy result
    result = {
        "owner_control": "YES",
        "can_mint": "YES",
        "freeze_function": "NO",
        "blacklist": "NO",
        "audit_link": "No Audit Found",
        "risk_level": "HIGH"
    }

    return render_template("home.html", coins=coins, scan_result=result)
