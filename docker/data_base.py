import  pymongo

myclient = pymongo.MongoClient("mongodb://root:pass123@mongodb:27017/drinks?retryWrites=true&w=majority")

mydb = myclient['drinks']
mycol = mydb["drinksCol"]

drinks = [{"brand": "coca cola", "name":"sprite", "price":12}
        ,{"brand": "flavoured water", "name":"grape fruit", "price":20},
        {"brand": "coca cola", "name":"coke", "price":5}]

x = mycol.insert_many(drinks)
print(x.inserted_ids)
