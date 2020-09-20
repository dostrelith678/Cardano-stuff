# shelley-scripts

Delete logs older thatn 1 day
```bash
find /opt/cardano/cnode/logs/archive/ -mtime +1 -name "*.json" -print -exec /bin/rm {} \;
```
