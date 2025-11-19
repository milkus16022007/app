from my_project.auth.dao.users_dao import UsersDAO
from my_project.auth.domain.users import UserDTO

class UsersService:
    @staticmethod
    @staticmethod
    def get_all_users():
        users = UsersDAO.get_all()
        return [UserDTO(**user).to_dict() for user in users]


    @staticmethod
    def get_user(user_id):
        user = UsersDAO.get_by_id(user_id)
        if user:
            return UserDTO(**user).to_dict()
        return None

    @staticmethod
    def create_user(full_name, email, phone):
        new_id = UsersDAO.create(full_name, email, phone)
        return UsersDAO.get_by_id(new_id)

    @staticmethod
    def update_user(user_id, full_name, email, phone):
        affected = UsersDAO.update(user_id, full_name, email, phone)
        return affected

    @staticmethod
    def delete_user(user_id):
        affected = UsersDAO.delete(user_id)
        return affected
