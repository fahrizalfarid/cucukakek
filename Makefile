set:
	curl --header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--header "secret-key: sEcr3t" \
	--data '{"key":"hello", "value":"world"}' \
	--request POST http://localhost:1081/api/v1/set \
	| json_pp

	curl --header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--header "secret-key: sEcr3t" \
	--data '{"key":"hello1", "value":"world"}' \
	--request POST http://localhost:1082/api/v1/set \
	| json_pp

	curl --header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--header "secret-key: sEcr3t" \
	--data '{"key":"hello2", "value":"world"}' \
	--request POST http://localhost:1083/api/v1/set \
	| json_pp

get:
	curl --header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--header "secret-key: sEcr3t" \
	--request GET http://localhost:1082/api/v1/get/hello \
	| json_pp

all:
	curl --header "Accept: application/json" \
	--header "secret-key: sEcr3t" \
	--request GET http://localhost:1081/api/v1/fetch-all \
	| json_pp

del:
	curl --header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--header "secret-key: sEcr3t" \
	--request DELETE http://localhost:1083/api/v1/remove/hello \
	| json_pp

metric:
	curl --header "Accept: application/json" \
	--request GET http://localhost:1081/api/v1/cluster/metric \
	| json_pp

cluster:
	curl --header "Accept: application/json" \
	--header "secret-key: sEcr3t" \
	--request GET http://localhost:1081/api/v1/cluster/info \
	| json_pp