# Restore Firefox windows and tabs

The profile's `user.js` contains:

```javascript
user_pref("browser.startup.page", 3);
```

Use Firefox's `about:profiles` page to identify your own default profile, then merge the line from `firefox/user.js` into its existing `user.js`. Do not replace a file containing other preferences. On this Fedora setup profiles are under `~/.config/mozilla/firefox/`; other installations may use another location.

Firefox reads this preference at startup and restores normal windows and tabs from the previous session. Private tabs are not retained. This does not launch Firefox automatically when logging in.

The file was checked; a restart/session-restoration test was not performed. To change the startup preference later, remove this line from `user.js` as well as changing the setting in Firefox.
