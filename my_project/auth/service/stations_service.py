from my_project.auth.dao.stations_dao import StationsDAO
from my_project.auth.domain.stations import StationDTO
from my_project.auth.domain.users import UserDTO

class StationsService:

    @staticmethod
    def get_all_stations():
        return [StationDTO(**s).to_dict() for s in StationsDAO.get_all()]

    @staticmethod
    def get_station(station_id):
        station = StationsDAO.get_by_id(station_id)
        if station:
            return StationDTO(**station).to_dict()
        return None

    @staticmethod
    def create_station(name, address, city, install_date, timezone='Europe/Kyiv'):
        new_id = StationsDAO.create(name, address, city, install_date, timezone)
        station = StationsDAO.get_by_id(new_id)
        if station:
            return StationDTO(**station).to_dict()
        return None

    @staticmethod
    def update_station(station_id, **kwargs):
        return StationsDAO.update(station_id, **kwargs)

    @staticmethod
    def delete_station(station_id):
        return StationsDAO.delete(station_id)

    @staticmethod
    def get_users(station_id):
        users = StationsDAO.get_users(station_id)
        return [UserDTO(**u).to_dict() for u in users]
