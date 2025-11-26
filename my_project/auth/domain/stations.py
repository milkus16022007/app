class StationDTO:
    def __init__(self, Station_ID, Station_Name, Address, City, Install_Date, Timezone, Created_At):
        self.station_id = Station_ID
        self.station_name = Station_Name
        self.address = Address
        self.city = City
        self.install_date = Install_Date
        self.timezone = Timezone
        self.created_at = Created_At

    def to_dict(self):
        return {
            "station_id": self.station_id,
            "station_name": self.station_name,
            "address": self.address,
            "city": self.city,
            "install_date": self.install_date,
            "timezone": self.timezone,
            "created_at": self.created_at
        }
