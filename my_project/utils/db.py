import mysql.connector
from mysql.connector import pooling

# Конфігурація підключення
dbconfig = {
    "host": "localhost",
    "user": "root",
    "password": "16022007",
    "database": "SolarDB",
}

# Створюємо пул з'єднань
connection_pool = mysql.connector.pooling.MySQLConnectionPool(
    pool_name="mypool",
    pool_size=5,
    **dbconfig
)

def get_connection():
    """
    Повертає нове підключення з пулу
    """
    return connection_pool.get_connection()

# Якщо ти хочеш init_db як раніше:
def init_db(app=None):
    """
    Функція-ініціалізатор (для сумісності з Flask)
    """
    # нічого робити не потрібно, оскільки пул створено при імпорті
    pass
