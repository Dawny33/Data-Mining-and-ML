from pymongo import MongoClient

def get_db():
    client = MongoClient("localhost:27017")
    db = client.countriesDB
    return db

def add_data(db):
    db.countries.insert({"name": "Canada"})

def get_country(db):
    return db.countries.find_one()

if __name__ == "__main__":
    db = get_db()
    add_data(db)
    print get_country(db)
