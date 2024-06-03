# HTTP Topological Sort

Source in this repository implements an HTTP service to order tasks in topological order.

Simplest way to run:
```
rebar3 shell
```
Simple test:
```
$ curl -X POST http://localhost:8080/ -H "Content-Type: application/json" -d @./test/query.json | jq .
{
    "script": "#!/usr/bin/env bash\ntouch /tmp/file1\necho 'Hello World!' > /tmp/file1\ncat /tmp/file1\nrm /tmp/file1\n",
    "tasks": [
        {
          "command": "touch /tmp/file1",
          "name": "task-1"
        },
        {
          "command": "echo 'Hello World!' > /tmp/file1",
          "name": "task-3"
        },
        {
          "command": "cat /tmp/file1",
          "name": "task-2"
        },
        {
          "command": "rm /tmp/file1",
          "name": "task-4"
        }
  ]
}
```
