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
    def create(full_name, email, phone):
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
    def update(user_id, full_name, email, phone):
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
