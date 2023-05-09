from flask import Flask, render_template, request
from flask_pymongo import PyMongo
from bson.objectid import ObjectId
from pymongo import IndexModel, TEXT, ASCENDING


app = Flask(__name__)
app.config["MONGO_URL"] = "mongodb://localhost:27017/news_db"
mongo = PyMongo(app)


def init_mongo_collection():
    # Get the database and collection
    db = mongo.db
    collection = db['articles']

    # Create a unique index on the 'url' field
    url_index = IndexModel([("url", ASCENDING)], unique=True)

    # Create a compound text index on the 'title', 'text', 'summary', and 'keywords' fields
    text_index = IndexModel([("title", TEXT), ("text", TEXT), ("summary", TEXT), ("keywords", TEXT)])

    # Create indexes
    collection.create_indexes([url_index, text_index])

    return collection


collection = init_mongo_collection()


@app.route("/")
def index():
    documents = collection.find().sort("quality", -1)
    return render_template("index.html", documents=documents)


@app.route("/search", methods=["POST"])
def search():
    query = request.form.get("query")
    documents = collection.find({"$text": {"$search": query}}).sort("quality", -1)
    return render_template("index.html", documents=documents)


if __name__ == "__main__":
    app.run(debug=True)
