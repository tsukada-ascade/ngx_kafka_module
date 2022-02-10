use Test::Nginx::Socket 'no_plan';

repeat_each(1);

run_tests();

__DATA__


=== TEST 1: post 1000001 data to kafka topic
--- http_config
    kafka;
    kafka_broker_list 127.0.0.1:9092;
--- config
    location /t {
        client_body_buffer_size 2m;
	client_max_body_size 2m;
        kafka_topic ngx-kafka-test-topic-huge;
    }
--- request eval
"POST /t
" . ('a' x 1000001)
--- error_code: 500
--- error_log


=== TEST 2: post 1000001 data to kafka topic with kafka_message_max_bytes
--- http_config
    kafka;
    kafka_broker_list 127.0.0.1:9092;
    kafka_message_max_bytes 2097152;
--- config
    location /t {
        client_body_buffer_size 2m;
	client_max_body_size 2m;
        kafka_topic ngx-kafka-test-topic-huge;
    }
--- request eval
"POST /t
" . ('a' x 1000001)
--- error_code: 204
--- no_error_log
