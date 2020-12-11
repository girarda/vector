package metadata

remap: functions: parse_aws_elb: {
	arguments: [
		{
			name:        "value"
			description: "Access log of the Application Load Balancer."
			required:    true
			type: ["string"]
		},
	]
	return: ["map"]
	category: "parse"
	description: #"""
		Parses a Elastic Load Balancer Access log into it's constituent components.
		"""#
	examples: [
		{
			title: "Success"
			input: {
				log: #"http 2018-11-30T22:23:00.186641Z app/my-loadbalancer/50dc6c495c0c9188 192.168.131.39:2817 - 0.000 0.001 0.000 200 200 34 366 "GET http://www.example.com:80/ HTTP/1.1" "curl/7.46.0" - - arn:aws:elasticloadbalancing:us-east-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067 "Root=1-58337364-23a8c76965a2ef7629b185e3" "-" "-" 0 2018-11-30T22:22:48.364000Z "forward" "-" "-" "-" "-" "-" "-""#
			}
			source: #"""
				.parsed = parse_aws_elb(.log)
				"""#
			output: {
				log: #"http 2018-11-30T22:23:00.186641Z app/my-loadbalancer/50dc6c495c0c9188 192.168.131.39:2817 - 0.000 0.001 0.000 200 200 34 366 "GET http://www.example.com:80/ HTTP/1.1" "curl/7.46.0" - - arn:aws:elasticloadbalancing:us-east-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067 "Root=1-58337364-23a8c76965a2ef7629b185e3" "-" "-" 0 2018-11-30T22:22:48.364000Z "forward" "-" "-" "-" "-" "-" "-""#
				parsed: {
					"type":                     "http"
					"timestamp":                "2018-11-30T22:23:00.186641Z"
					"elb":                      "app/my-loadbalancer/50dc6c495c0c9188"
					"client_host":              "192.168.131.39:2817"
					"target_host":              "-"
					"request_processing_time":  0.0
					"target_processing_time":   0.001
					"response_processing_time": 0.0
					"elb_status_code":          "200"
					"target_status_code":       "200"
					"received_bytes":           34
					"sent_bytes":               366
					"request_method":           "GET"
					"request_url":              "http://www.example.com:80/"
					"request_protocol":         "HTTP/1.1"
					"user_agent":               "curl/7.46.0"
					"ssl_cipher":               "-"
					"ssl_protocol":             "-"
					"target_group_arn":         "arn:aws:elasticloadbalancing:us-east-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"
					"trace_id":                 "Root=1-58337364-23a8c76965a2ef7629b185e3"
					"domain_name":              "-"
					"chosen_cert_arn":          "-"
					"matched_rule_priority":    "0"
					"request_creation_time":    "2018-11-30T22:22:48.364000Z"
					"actions_executed":         "forward"
					"redirect_url":             "-"
					"error_reason":             "-"
					"target_port_list": []
					"target_status_code_list": []
					"classification":        "-"
					"classification_reason": "-"
				}
			}
		},
		{
			title: "Error"
			input: {
				log: "I am not a log"
			}
			source: #"""
				.parsed = parse_aws_elb(.log)
				"""#
			output: {
				error: remap.errors.ParseError
			}
		},
	]
}