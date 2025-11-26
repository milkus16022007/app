from flask import Blueprint, request, jsonify
from my_project.auth.service.stations_service import StationsService

stations_bp = Blueprint('stations', __name__, url_prefix='/stations')

@stations_bp.route('/', methods=['GET'])
def get_stations():
    return jsonify(StationsService.get_all_stations()), 200

@stations_bp.route('/<int:station_id>', methods=['GET'])
def get_station(station_id):
    station = StationsService.get_station(station_id)
    if station:
        return jsonify(station), 200
    return jsonify({"error": "Station not found"}), 404

@stations_bp.route('/', methods=['POST'])
def create_station():
    data = request.get_json(force=True)
    station = StationsService.create_station(
        name=data.get('station_name'),
        address=data.get('address'),
        city=data.get('city'),
        install_date=data.get('install_date'),
        timezone=data.get('timezone','Europe/Kyiv')
    )
    return jsonify({"status": "Station created", "station": station}), 201

@stations_bp.route('/<int:station_id>', methods=['PUT'])
def update_station(station_id):
    data = request.get_json(force=True)
    affected = StationsService.update_station(station_id, **data)
    if affected:
        return jsonify({"status": "Station updated"}), 200
    return jsonify({"error": "Station not found or no changes made"}), 404

@stations_bp.route('/<int:station_id>', methods=['DELETE'])
def delete_station(station_id):
    affected = StationsService.delete_station(station_id)
    if affected:
        return jsonify({"status": "Station deleted"}), 200
    return jsonify({"error": "Station not found"}), 404

@stations_bp.route('/<int:station_id>/users', methods=['GET'])
def get_station_users(station_id):
    return jsonify(StationsService.get_users(station_id)), 200
