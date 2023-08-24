## pull your image

### single
```yml
version: "3.9"

services:
  cucukakek-single:
    image: fahrizalfarid/cucu-kakek
    container_name: cucukakek-0
    command:
      - "--http=:1081"
      - "-a=1@127.0.0.1:8081"
      - "--join=-1"
      - "--secret-key=sEcr3t"
    ports:
      - 1081:1081
      - 8081:8081
    volumes:
      - ${HOME}/cucukakek:/data
    restart: always
```

### multi

```yml
version: "3.9"

services:
  cucukakek-leader:
    image: fahrizalfarid/cucu-kakek
    container_name: cucukakek-leader
    command:
      - "--http=:1081"
      - "-a=1@127.0.0.1:8081"
      - "--join=0"
      - "--secret-key=sEcr3t"
      - "-c=1@127.0.0.1:8081"
      - "-c=2@127.0.0.1:8082"
      - "-c=3@127.0.0.1:8083"
    ports:
      - 1081:1081
      - 8081:8081
    restart: always

  cucukakek-0:
    image: fahrizalfarid/cucu-kakek
    container_name: cucukakek-0
    command:
      - "--http=:1082"
      - "-a=2@127.0.0.1:8082"
      - "--join=1"
      - "--secret-key=sEcr3t"
    ports:
      - 1082:1082
      - 8082:8082
    restart: always

  cucukakek-1:
    image: fahrizalfarid/cucu-kakek
    container_name: cucukakek-1
    command:
      - "--http=:1083"
      - "-a=3@127.0.0.1:8083"
      - "--join=1"
      - "--secret-key=sEcr3t"
    ports:
      - 1083:1083
      - 8083:8083
    ports:
      - 1083:1083
      - 8083:8083
    restart: always
```

## make request
```bash
$ make set
curl --header "Content-Type: application/json" \
--header "Accept: application/json" \
--header "secret-key: sEcr3t" \
--data '{"key":"hello", "value":"world"}' \
--request POST http://localhost:1081/api/v1/set \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    82  100    50  100    32   3333   2133 --:--:-- --:--:-- --:--:--  5466
{
   "data" : {},
   "message" : "Success",
   "status" : "Success"
}
curl --header "Content-Type: application/json" \
--header "Accept: application/json" \
--header "secret-key: sEcr3t" \
--data '{"key":"hello1", "value":"world"}' \
--request POST http://localhost:1082/api/v1/set \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    83  100    50  100    33   4166   2750 --:--:-- --:--:-- --:--:--  6916
{
   "data" : {},
   "status" : "Success",
   "message" : "Success"
}
curl --header "Content-Type: application/json" \
--header "Accept: application/json" \
--header "secret-key: sEcr3t" \
--data '{"key":"hello2", "value":"world"}' \
--request POST http://localhost:1083/api/v1/set \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    83  100    50  100    33   3846   2538 --:--:-- --:--:-- --:--:--  6384
{
   "status" : "Success",
   "message" : "Success",
   "data" : {}
}


$ make get
curl --header "Content-Type: application/json" \
--header "Accept: application/json" \
--header "secret-key: sEcr3t" \
--request GET http://localhost:1082/api/v1/get/hello \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    79  100    79    0     0  13166      0 --:--:-- --:--:-- --:--:-- 13166
{
   "status" : "Success",
   "data" : {
      "key" : "hello",
      "value" : "world"
   },
   "message" : "Success"
}


$ make all
curl --header "Accept: application/json" \
--header "secret-key: sEcr3t" \
--request GET http://localhost:1081/api/v1/fetch-all \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   147  100   147    0     0  21000      0 --:--:-- --:--:-- --:--:-- 21000
{
   "message" : "Success",
   "status" : "Success",
   "data" : [
      {
         "value" : "world",
         "key" : "hello"
      },
      {
         "key" : "hello1",
         "value" : "world"
      },
      {
         "value" : "world",
         "key" : "hello2"
      }
   ]
}


$ make del
curl --header "Content-Type: application/json" \
--header "Accept: application/json" \
--header "secret-key: sEcr3t" \
--request DELETE http://localhost:1083/api/v1/remove/hello \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    50  100    50    0     0   3125      0 --:--:-- --:--:-- --:--:--  3125
{
   "message" : "Success",
   "status" : "Success",
   "data" : {}
}


$ make metric
curl --header "Accept: application/json" \
--request GET http://localhost:1081/api/v1/cluster/metric \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   157  100   157    0     0  31400      0 --:--:-- --:--:-- --:--:-- 39250
{
   "pid" : {
      "cpu" : 0.113257698569354,
      "ram" : 64655360,
      "conns" : 6
   },
   "os" : {
      "cpu" : 0.0834028356964141,
      "load_avg" : 0,
      "ram" : 433913856,
      "conns" : 16,
      "total_ram" : 12873052160
   }
}


$ make cluster
curl --header "Accept: application/json" \
--header "secret-key: sEcr3t" \
--request GET http://localhost:1081/api/v1/cluster/info \
| json_pp
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   469  100   469    0     0  67000      0 --:--:-- --:--:-- --:--:-- 67000
{
   "data" : {
      "NodeHostID" : "nhid-18144196435440057149",
      "Gossip" : {
         "Enabled" : false,
         "AdvertiseAddress" : "",
         "NumOfKnownNodeHosts" : 0
      },
      "ClusterInfoList" : [
         {
            "IsLeader" : true,
            "ClusterID" : 128,
            "NodeID" : 1,
            "ConfigChangeIndex" : 3,
            "StateMachineType" : 1,
            "IsWitness" : false,
            "IsObserver" : false,
            "Pending" : false,
            "Nodes" : {
               "2" : "127.0.0.1:8082",
               "1" : "127.0.0.1:8081",
               "3" : "127.0.0.1:8083"
            }
         }
      ],
      "LogInfo" : [
         {
            "NodeID" : 1,
            "ClusterID" : 128
         }
      ],
      "RaftAddress" : "127.0.0.1:8081"
   },
   "message" : "Success",
   "status" : "Success"
}
```