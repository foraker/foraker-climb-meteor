(function () {

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
// packages/meteor-headers/headers-common.js                                              //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////
                                                                                          //
headers = {                                                                               // 1
	list: {},                                                                                // 2
	proxyCount: 0,                                                                           // 3
	setProxyCount: function(proxyCount) {                                                    // 4
		this.proxyCount = proxyCount;                                                           // 5
	},                                                                                       // 6
	getProxyCount: function() {                                                              // 7
		return this.proxyCount;                                                                 // 8
	}                                                                                        // 9
}                                                                                         // 10
                                                                                          // 11
Package.headers = { headers: headers };                                                   // 12
                                                                                          // 13
////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function () {

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
// packages/meteor-headers/headers-server.js                                              //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////
                                                                                          //
var HEADERS_CLEANUP_TIME = 300000;  // 5 minutes                                          // 1
                                                                                          // 2
/*                                                                                        // 3
 * Returns an array describing the suspected IP route the connection has taken.           // 4
 * This is in order of trust, see the README.md for which value to use                    // 5
 */                                                                                       // 6
function ipChain(headers, connection) {                                                   // 7
  var chain = [];                                                                         // 8
  if (headers['x-forwarded-for'])                                                         // 9
    _.each(headers['x-forwarded-for'].split(','), function(ip) {                          // 10
      chain.push(ip.replace('/\s*/g', ''));                                               // 11
    });                                                                                   // 12
  if (chain.length == 0 || chain[chain.length-1] != connection.remoteAddress)             // 13
    chain.push(connection.remoteAddress);                                                 // 14
  return chain;                                                                           // 15
}                                                                                         // 16
                                                                                          // 17
/*                                                                                        // 18
 * The client will request this "script", and send a unique token with it,                // 19
 * which we later use to re-associate the headers from this request with                  // 20
 * the user's livedata session (since XHR requests only send a subset of                  // 21
 * all the regular headers).                                                              // 22
 */                                                                                       // 23
WebApp.connectHandlers.use('/headersHelper.js', function(req, res, next) {                // 24
  var token = req.query.token;                                                            // 25
                                                                                          // 26
  req.headers['x-ip-chain'] = ipChain(req.headers, req.connection).join(',');             // 27
  headers.list[token] = req.headers;                                                      // 28
                                                                                          // 29
  res.writeHead(200, { 'Content-type': 'application/javascript' });                       // 30
  res.end("Package.headers.headers.store(" + JSON.stringify(req.headers) + ");", 'utf8'); // 31
});                                                                                       // 32
                                                                                          // 33
/*                                                                                        // 34
 * After user has requested the headers (which were stored in headers.list                // 35
 * at the same time with the client's token, the below is called, which we                // 36
 * use to re-associate with the user's livedata session (see above)                       // 37
 */                                                                                       // 38
Meteor.methods({                                                                          // 39
  'headersToken': function(token) {                                                       // 40
    if (headers.list[token]) {                                                            // 41
      this._sessionData.headers = headers.list[token];                                    // 42
      headerDep(this._sessionData).changed();                                             // 43
      delete headers.list[token];                                                         // 44
    }                                                                                     // 45
  }                                                                                       // 46
});                                                                                       // 47
                                                                                          // 48
/*                                                                                        // 49
 * Cleanup unclaimed headers                                                              // 50
 */                                                                                       // 51
Meteor.setInterval(function() {                                                           // 52
  for (key in headers.list)                                                               // 53
    if (parseInt(key) < new Date().getTime() - HEADERS_CLEANUP_TIME)                      // 54
      delete(headers.list[key]);                                                          // 55
}, HEADERS_CLEANUP_TIME);                                                                 // 56
                                                                                          // 57
/*                                                                                        // 58
 * Return the headerDep.  Create if necessary.                                            // 59
 */                                                                                       // 60
function headerDep(obj) {                                                                 // 61
  if (!obj.headerDep)                                                                     // 62
    obj.headerDep = new Deps.Dependency();                                                // 63
  return obj.headerDep;                                                                   // 64
}                                                                                         // 65
                                                                                          // 66
/*                                                                                        // 67
 * Usage in a Meteor method: headers.get(this, 'host')                                    // 68
 */                                                                                       // 69
headers.get = function(self, key) {                                                       // 70
  if (!self)                                                                              // 71
    throw new Error('Must be called like this on the server: headers.get(this)');         // 72
  var sessionData = self._session ? self._session.sessionData : self._sessionData;        // 73
  headerDep(sessionData).depend();                                                        // 74
  if (!(sessionData && sessionData.headers))                                              // 75
    return key ? undefined : {};                                                          // 76
  return key ? sessionData.headers[key] : sessionData.headers;                            // 77
}                                                                                         // 78
                                                                                          // 79
headers.ready = function(self) {                                                          // 80
  if (!self)                                                                              // 81
    throw new Error('Must be called like this on the server: headers.get(this)');         // 82
  var sessionData = self._session ? self._session.sessionData : self._sessionData;        // 83
  headerDep(sessionData).depend();                                                        // 84
  return Object.keys(sessionData.headers).length > 0;                                     // 85
}                                                                                         // 86
                                                                                          // 87
headers.getClientIP = function(self, proxyCount) {                                        // 88
  if (!self)                                                                              // 89
    throw new Error('Must be called like this on the server: headers.get(this)');         // 90
  var sessionData = self._session ? self._session.sessionData : self._sessionData;        // 91
  var chain = sessionData.headers['x-ip-chain'].split(',');                               // 92
  headerDep(sessionData).depend();                                                        // 93
  if (typeof(proxyCount) == 'undefined')                                                  // 94
    proxyCount = this.proxyCount;                                                         // 95
  return chain[chain.length - proxyCount - 1];                                            // 96
}                                                                                         // 97
                                                                                          // 98
/*                                                                                        // 99
 * Get the IP for the livedata connection used by a Method (see README.md)                // 100
 */                                                                                       // 101
headers.methodClientIP = function(self, proxyCount) {                                     // 102
  // convoluted way to find our session                                                   // 103
  // TODO, open an issue with Meteor to see if we can get easier access                   // 104
  var sessionData = self._session ? self._session.sessionData : self._sessionData;        // 105
  var token, session;                                                                     // 106
  token = new Date().getTime() + Math.random();                                           // 107
  sessionData.tmpToken = token;                                                           // 108
  session = _.find(Meteor.server.sessions, function(session) {                            // 109
    return sessionData.tmpToken == token;                                                 // 110
  });                                                                                     // 111
                                                                                          // 112
  var chain = ipChain(session.socket.headers, session.socket);                            // 113
  if (typeof(proxyCount) == 'undefined')                                                  // 114
    proxyCount = this.proxyCount;                                                         // 115
  return chain[chain.length - proxyCount - 1];                                            // 116
}                                                                                         // 117
                                                                                          // 118
////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);
