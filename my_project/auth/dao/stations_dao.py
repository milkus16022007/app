from my_project.utils.db import get_connection

class StationsDAO:
    TABLE = "Stations"

    @staticmethod
    def get_all():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {StationsDAO.TABLE}")
        res = cursor.fetchall()
        cursor.close()
        conn.close()
        return res

    @staticmethod
    def get_by_id(station_id):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {StationsDAO.TABLE} WHERE Station_ID=%s", (station_id,))
        station = cursor.fetchone()
        cursor.close()
        conn.close()
        return station

    @staticmethod
    def create(name, address, city, install_date, timezone='Europe/Kyiv'):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(f"""INSERT INTO {StationsDAO.TABLE} 
            (Station_Name, Address, City, Install_Date, Timezone) 
            VALUES (%s,%s,%s,%s,%s)""", 
            (name, address, city, install_date, timezone))
        conn.commit()
        new_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return new_id

    @staticmethod
    def update(station_id, name=None, address=None, city=None, install_date=None, timezone=None):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(f"""UPDATE {StationsDAO.TABLE} 
            SET Station_Name=%s, Address=%s, City=%s, Install_Date=%s, Timezone=%s 
            WHERE Station_ID=%s""",
            (name, address, city, install_date, timezone, station_id))
        conn.commit()
        affected = cursor.rowcount
        cursor.close()
        conn.close()
        return affected

    @staticmethod
    def delete(station_id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(f"DELETE FROM {StationsDAO.TABLE} WHERE Station_ID=%s", (station_id,))
        conn.commit()
        affected = cursor.rowcount
        cursor.close()
        conn.close()
        return affected

    # M:M – всі користувачі станції
    @staticmethod
    def get_users(station_id):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = """SELECT u.* FROM Users u
                   JOIN Station_Owners so ON u.User_ID=so.User_ID
                   WHERE so.Station_ID=%s"""
        cursor.execute(query, (station_id,))
        res = cursor.fetchall()
        cursor.close()
        conn.close()
        return res
