from my_project.utils.db import get_connection

class UsersDAO:
    TABLE = "Users"

    @staticmethod
    def get_all():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {UsersDAO.TABLE}")
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result

    @staticmethod
    def get_by_id(user_id):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {UsersDAO.TABLE} WHERE User_ID=%s", (user_id,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        return user

    @staticmethod
    def create(full_name, email=None, phone=None):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            f"INSERT INTO {UsersDAO.TABLE} (Full_Name, Email, Phone) VALUES (%s, %s, %s)",
            (full_name, email, phone)
        )
        conn.commit()
        inserted_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return inserted_id

    @staticmethod
    def update(user_id, full_name=None, email=None, phone=None):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            f"UPDATE {UsersDAO.TABLE} SET Full_Name=%s, Email=%s, Phone=%s WHERE User_ID=%s",
            (full_name, email, phone, user_id)
        )
        conn.commit()
        affected = cursor.rowcount
        cursor.close()
        conn.close()
        return affected

    @staticmethod
    def delete(user_id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(f"DELETE FROM {UsersDAO.TABLE} WHERE User_ID=%s", (user_id,))
        conn.commit()
        affected = cursor.rowcount
        cursor.close()
        conn.close()
        return affected


    # M:1: користувачі по місту
    @staticmethod
    def get_users_by_city(city):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT u.* FROM Users u
            JOIN Station_Owners so ON u.User_ID = so.User_ID
            JOIN Stations s ON so.Station_ID = s.Station_ID
            WHERE s.City=%s
        """
        cursor.execute(query, (city,))
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result

    # M:M: користувачі по станції
    @staticmethod
    def get_users_by_station(station_id):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT u.* FROM Users u
            JOIN Station_Owners so ON u.User_ID = so.User_ID
            WHERE so.Station_ID=%s
        """
        cursor.execute(query, (station_id,))
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result
