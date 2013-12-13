(function () {

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
// packages/meteor-headers/headers-common.js                               //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////
                                                                           //
headers = {                                                                // 1
	list: {},                                                                 // 2
	proxyCount: 0,                                                            // 3
	setProxyCount: function(proxyCount) {                                     // 4
		this.proxyCount = proxyCount;                                            // 5
	},                                                                        // 6
	getProxyCount: function() {                                               // 7
		return this.proxyCount;                                                  // 8
	}                                                                         // 9
}                                                                          // 10
                                                                           // 11
Package.headers = { headers: headers };                                    // 12
                                                                           // 13
/////////////////////////////////////////////////////////////////////////////

}).call(this);






(function () {

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
// packages/meteor-headers/headers-client.js                               //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////
                                                                           //
/*                                                                         // 1
 * Generate a unique token                                                 // 2
 */                                                                        // 3
headers.token = new Date().getTime() + Math.random();                      // 4
                                                                           // 5
/*                                                                         // 6
 * Used for reactivity                                                     // 7
 */                                                                        // 8
headers.dep = new Deps.Dependency;                                         // 9
                                                                           // 10
/*                                                                         // 11
 * Called after receiving all the headers, used to re-associate headers    // 12
 * with this clients livedata session (see headers-server.js)              // 13
 */                                                                        // 14
headers.store = function(headers) {                                        // 15
	this.list = headers;                                                      // 16
	Meteor.call('headersToken', this.token);                                  // 17
 	for (var i=0; i < this.readies.length; i++)                              // 18
 		this.readies[i]();                                                      // 19
 	this.readiesRun = true;                                                  // 20
 	this.dep.changed();                                                      // 21
};                                                                         // 22
                                                                           // 23
/*                                                                         // 24
 * This has two completely different uses, but retains the same name       // 25
 * as this is what people expect.                                          // 26
 *                                                                         // 27
 * With an arg: Store a callback to be run when headersHelper.js completes // 28
 * Without an arg: Return a reactive boolean on whether or not we're ready // 29
 */                                                                        // 30
headers.readies = [];                                                      // 31
headers.readiesRun = false;                                                // 32
headers.ready = function(callback) {                                       // 33
	if (callback) {                                                           // 34
		this.readies.push(callback);                                             // 35
		// Run immediately if headers.store() was already called previously      // 36
		if (this.readiesRun)                                                     // 37
			callback();                                                             // 38
	} else {                                                                  // 39
		this.dep.depend();                                                       // 40
		return Object.keys(this.list).length > 0;                                // 41
	}                                                                         // 42
};                                                                         // 43
                                                                           // 44
/*                                                                         // 45
 * Create another connection to retrieve our headers (see README.md for    // 46
 * why this is necessary).  Called with our unique token, the retrieved    // 47
 * code runs headers.store() above with the results                        // 48
 */                                                                        // 49
(function(d, t) {                                                          // 50
    var g = d.createElement(t),                                            // 51
        s = d.getElementsByTagName(t)[0];                                  // 52
    g.src = '/headersHelper.js?token=' + headers.token;                    // 53
    s.parentNode.insertBefore(g, s);                                       // 54
}(document, 'script'));                                                    // 55
                                                                           // 56
/*                                                                         // 57
 * Get a header or all headers                                             // 58
 */                                                                        // 59
headers.get = function(header) {                                           // 60
 	this.dep.depend();                                                       // 61
	return header ? this.list[header] : this.list;                            // 62
}                                                                          // 63
                                                                           // 64
/*                                                                         // 65
 * Get the client's IP address (see README.md)                             // 66
 */                                                                        // 67
headers.getClientIP = function(proxyCount) {                               // 68
	var chain = this.get('x-ip-chain').split(',');                            // 69
	if (typeof(proxyCount) == 'undefined')                                    // 70
		proxyCount = this.proxyCount;                                            // 71
	return chain[chain.length - proxyCount - 1];                              // 72
}                                                                          // 73
                                                                           // 74
/////////////////////////////////////////////////////////////////////////////

}).call(this);
