import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import { Router, Switch, Route } from 'react-router-dom';
import { ApolloProvider } from 'react-apollo';
import { ApolloClient } from 'apollo-client';
import { split } from 'apollo-link';
import { HttpLink } from 'apollo-link-http';
import { WebSocketLink } from 'apollo-link-ws';
import { getMainDefinition } from 'apollo-utilities';
import { InMemoryCache } from 'apollo-cache-inmemory';
import createHistory from 'history/createBrowserHistory';
import * as serviceWorker from './serviceWorker';

const history = createHistory()
/* History was used for page navigation, the whole switch/route setup was only 
implemented to pass the url down as a prop so I could use it */

// using public ip w/ 5000 port testing backend
// TODO: In deployment, change to actual address
const BASE_GRAPHQL_URL = 'https://backend.ithaqueue.com/graphql';
const cache = new InMemoryCache();
const httpLink = new HttpLink({
    uri: BASE_GRAPHQL_URL
});

// Create a WebSocket link:
const wsLink = new WebSocketLink({
    uri: `wss://backend.ithaqueue.com/subscriptions/`,
    options: {
        reconnect: true
    }
});

const link = split(
    // split based on operation type
    ({ query }) => {
        const definition = getMainDefinition(query);
        return (
            definition.kind === 'OperationDefinition' &&
            definition.operation === 'subscription'
        );
    },
    wsLink,
    httpLink,
);


const client = new ApolloClient({
    link: link,
    cache: cache
});

ReactDOM.render(
    <ApolloProvider client={client}>
        <Router history={history}>
            <Switch>
                <Route exact path="/">
                    <App />
                </Route>
                <Route path="/:id">
                    <App />
                </Route>
            </Switch>
        </Router>
    </ApolloProvider>,
    document.getElementById('root')
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
