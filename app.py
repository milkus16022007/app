from flask import Flask
from flask_cors import CORS
from my_project.auth.controller.users_controller import users_bp
from my_project.utils.db import init_db

def create_app():
    app = Flask(__name__)
    CORS(app)
    init_db(app)
    app.register_blueprint(users_bp)

    @app.route("/")
    def home():
        return {"status": "Backend is running!"}

    return app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True)
