var exec = require('cordova/exec');

exports.join = function(serverUrl, room, token, audioOnly, success, error) {
    exec(success, error, "JitsiPlugin", "join", [serverUrl, room, token, !!audioOnly]);
};

exports.destroy = function(success, error) {
    exec(success, error, "JitsiPlugin", "destroy", []);
};
