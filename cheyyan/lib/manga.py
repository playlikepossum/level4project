# server.py
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
from libgen_api import LibgenSearch

app = Flask(__name__)


@app.route('/search_author', methods=['GET'])
def search_author():
    author_name = request.args.get('author_name')


    if author_name:
        s = LibgenSearch()
        results = s.search_author(author_name)
        


        if results:
            item_to_download = results[0]
            download_links = s.resolve_download_links(item_to_download)
            return jsonify({"download_links": download_links})
        else:
            return jsonify({"error": "Author not found"}), 404
    else:
        return jsonify({"error": "Author name not provided"}), 400

if __name__ == '__main__':
    app.run(debug=True, host='192.168.1.98')
