from flask import Blueprint, request, jsonify
from my_project.auth.service.users_service import UsersService

users_bp = Blueprint('users', __name__, url_prefix='/users')


@users_bp.route('/', methods=['GET'])
def get_users():
    users = UsersService.get_all_users()
    return jsonify(users), 200


@users_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = UsersService.get_user(user_id)
    if user:
        return jsonify(user), 200
    return jsonify({"error": "User not found"}), 404


@users_bp.route('/', methods=['POST'])
def create_user():
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body is required or invalid JSON"}), 400

    full_name = data.get('full_name')
    if not full_name:
        return jsonify({"error": "full_name is required"}), 400

    email = data.get('email')
    phone = data.get('phone')

    # Виклик сервісу
    user = UsersService.create_user(full_name, email, phone)
    if not user:
        return jsonify({"error": "Failed to create user"}), 500

    return jsonify({"status": "User created", "user": dict(user)}), 201  # <-- явно конвертуємо в dict


@users_bp.route('/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body is required or invalid JSON"}), 400

    full_name = data.get('full_name')
    email = data.get('email')
    phone = data.get('phone')

    affected = UsersService.update_user(user_id, full_name, email, phone)
    if affected:
        return jsonify({"status": "User updated"}), 200
    return jsonify({"error": "User not found or no changes made"}), 404


@users_bp.route('/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    affected = UsersService.delete_user(user_id)
    if affected:
        return jsonify({"status": "User deleted"}), 200
    return jsonify({"error": "User not found"}), 404


# M:1 - всі користувачі по місту
@users_bp.route('/city/<string:city>', methods=['GET'])
def get_users_by_city(city):
    users = UsersService.get_users_by_city(city)
    return jsonify(users), 200

# M:M - всі користувачі по станції
@users_bp.route('/station/<int:station_id>', methods=['GET'])
def get_users_by_station(station_id):
    users = UsersService.get_users_by_station(station_id)
    return jsonify(users), 200
