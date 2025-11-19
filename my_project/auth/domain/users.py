class UserDTO:
    def __init__(self, User_ID, Full_Name, Email, Phone, Created_At):
        self.user_id = User_ID
        self.full_name = Full_Name
        self.email = Email
        self.phone = Phone
        self.created_at = Created_At
    
    def to_dict(self):
        return {
            "user_id": self.user_id,
            "full_name": self.full_name,
            "email": self.email,
            "phone": self.phone,
            "created_at": self.created_at
        }
