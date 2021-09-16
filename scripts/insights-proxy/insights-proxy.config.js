/*global module, process*/

// Hack so that Mac OSX docker can sub in host.docker.internal instead of localhost
// see https://docs.docker.com/docker-for-mac/networking/#i-want-to-connect-from-a-container-to-a-service-on-the-host
const localhost = (process.env.PLATFORM === 'linux') ? 'localhost' : 'host.docker.internal';

module.exports = {
    routes: {
        //
        // APIs
        //
        '/api/sources': {host: `http://${localhost}:3002`},
        '/api/topological-inventory': {host: `http://${localhost}:3001`},
        // '/api/catalog': {host: `http://${localhost}:3003`},
        // '/api/approval': {host: `http://${localhost}:3004`},

        //
        // Sources UI
        //
        // '/beta/settings/sources': {host: `http://${localhost}:8002`},
    }
};
