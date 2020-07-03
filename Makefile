generate-pb:
	@for file in `\find proto/v1 -type f -name '*.proto'`; do \
		protoc \
			$$file \
			-I ./proto/v1/ \
			-I $(GOPATH)/pkg/mod/github.com/envoyproxy/protoc-gen-validate@v0.4.0 \
			-I $(GOPATH)/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.14.6 \
			-I $(GOPATH)/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.14.6/third_party/googleapis/ \
			--go_out=plugins=grpc:$(GOPATH)/src \
			--validate_out="lang=go:$(GOPATH)/src" \
			--grpc-gateway_out=logtostderr=true:$(GOPATH)/src; \
	done

test:
	# It can't use `--grpc-gateway_out` if it uses a wildcard.
	@protoc \
	$(wildcard ./proto/v1/*.proto) \
	-I ./proto/v1/ \
	-I $(GOPATH)/pkg/mod/github.com/envoyproxy/protoc-gen-validate@v0.4.0 \
	-I $(GOPATH)/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.14.6 \
	-I $(GOPATH)/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.14.6/third_party/googleapis/ \
	--go_out=plugins=grpc:$(GOPATH)/src \
	--validate_out="lang=go:$(GOPATH)/src"
