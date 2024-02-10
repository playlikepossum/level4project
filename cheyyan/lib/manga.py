# server.py
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
from libgen_api import LibgenSearch

import socket
hostname = socket.gethostname()
IPAddr = socket.gethostbyname(hostname)
print(IPAddr)

app = Flask(__name__)


@app.route('/search', methods=['GET'])
def search_author():
    author_name = request.args.get('author_name')
    title_name = request.args.get('title_name')
    link = request.args.get('link')


    if author_name and title_name and link:
        s = LibgenSearch()
        title_filters = {"title": title_name ,"Extension": "pdf"}
        results =s.search_author_filtered(author_name, title_filters, exact_match=True)
        results = s.search_author(author_name)
        


        if results:
            item_to_download = results[int(link)]
            print(results)
            download_links = s.resolve_download_links(item_to_download)
            return jsonify({"download_links": download_links})
        else:
            return jsonify({"error": "Author not found"}), 404


    elif author_name and title_name:
        s = LibgenSearch()
        title_filters = {"title": title_name ,"Extension": "pdf"}
        results =s.search_author_filtered(author_name, title_filters, exact_match=True)
        results = s.search_author(author_name)
        


        if results:
            item_to_download = results[0]
            print(results)
            download_links = s.resolve_download_links(item_to_download)
            return jsonify({"download_links": download_links, "results": results})
        else:
            return jsonify({"error": "Author not found"}), 404

    elif author_name:
        s = LibgenSearch()
        title_filters = {"Extension": "pdf"}
        results =s.search_author_filtered(author_name, title_filters)
        results = s.search_author(author_name)
        


        if results:
            item_to_download = results[0]
            download_links = s.resolve_download_links(item_to_download)
            return jsonify({"download_links": download_links})
        else:
            return jsonify({"error": "Author not found"}), 404
        
    elif title_name:
        s = LibgenSearch()
        title_filters = {"Extension": "pdf"}
        results = s.search_title_filtered(title_name, title_filters)
        
        


        if results:
            item_to_download = results[0]
            download_links = s.resolve_download_links(item_to_download)
            return jsonify({"download_links": download_links})
        else:
            return jsonify({"error": "Author not found"}), 404

    else:
        
        return jsonify({"error": "Author name not provided"}), 400
    


    


if __name__ == '__main__':
    app.run(debug=True, host=IPAddr)
