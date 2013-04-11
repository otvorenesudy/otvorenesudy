// Settings Manager - This is a utility for saving settings
// First we see if localStorage is available
// If not, we use FUEL in FF
var Settings = (function SettingsClosure() {
  var isLocalStorageEnabled = (function localStorageEnabledTest() {
    // Feature test as per http://diveintohtml5.info/storage.html
    // The additional localStorage call is to get around a FF quirk, see
    // bug #495747 in bugzilla
    try {
      return 'localStorage' in window && window['localStorage'] !== null &&
          localStorage;
    } catch (e) {
      return false;
    }
  })();

  function Settings(fingerprint) {
    var database = null;
    var index;
    if (isLocalStorageEnabled)
      database = localStorage.getItem('database') || '{}';
    else
      return;

    database = JSON.parse(database);
    if (!('files' in database))
      database.files = [];
    if (database.files.length >= kSettingsMemory)
      database.files.shift();
    for (var i = 0, length = database.files.length; i < length; i++) {
      var branch = database.files[i];
      if (branch.fingerprint == fingerprint) {
        index = i;
        break;
      }
    }
    if (typeof index != 'number')
      index = database.files.push({fingerprint: fingerprint}) - 1;
    this.file = database.files[index];
    this.database = database;
  }

  Settings.prototype = {
    set: function settingsSet(name, val) {
      if (!('file' in this))
        return false;

      var file = this.file;
      file[name] = val;
      var database = JSON.stringify(this.database);
      if (isLocalStorageEnabled)
        localStorage.setItem('database', database);
    },

    get: function settingsGet(name, defaultValue) {
      if (!('file' in this))
        return defaultValue;

      return this.file[name] || defaultValue;
    }
  };

  return Settings;
})();
