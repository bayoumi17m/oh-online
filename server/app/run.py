from database.base import db_session
from flask import Flask
from flask_graphql import GraphQLView
from graphene import Schema
from schema import Query, Mutation, Subscription
from flask_cors import CORS

from graphql.backend import GraphQLCoreBackend
from flask_sockets import Sockets
from graphql_ws.gevent import  GeventSubscriptionServer
from overriddenview import OverriddenView

import logging
import sys

logger = logging.getLogger("TestLogger")
logger.setLevel(logging.INFO)
stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
stdout_handler.setFormatter(formatter)
logger.addHandler(stdout_handler)


class CustomBackend(GraphQLCoreBackend):
    def __init__(self, executor=None):
        super().__init__(executor)
        self.execute_params["allow_subscriptions"] = True

schema = Schema(query=Query, mutation=Mutation, subscription=Subscription)

view_func = OverriddenView.as_view(
    "graphql", schema=schema, backend=CustomBackend(), graphiql=True
)

app = Flask(__name__)
app.logger = logger
app.add_url_rule("/", view_func=view_func)
# CORS(app)

sockets = Sockets(app)
subscription_server = GeventSubscriptionServer(schema)
app.app_protocol = lambda environ_path_info: 'graphql-ws'

CORS(app)

@sockets.route('/subscriptions')
def echo_socket(ws):
    subscription_server.handle(ws)
    return []


@app.teardown_appcontext
def shutdown_session(exception=None):
    db_session.remove()


if __name__ == "__main__":
    # app.run(host="0.0.0.0", port=5000)
    from gevent import pywsgi
    from geventwebsocket.handler import WebSocketHandler
    server = pywsgi.WSGIServer(('0.0.0.0', 5000), app, handler_class=WebSocketHandler, log=logger, error_log=logger)
    server.serve_forever()