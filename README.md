# Failover
A prove of concept on how to behave when mongo instances goes down.

You can read this blog post on www.chiarato.com/failover-com-ruby-e-mongodb

___

# Initiate replica set

```bash
$ sudo bash create_replset.sh
```

# Configure replica set

```bash
$ mongo < init.js
```
