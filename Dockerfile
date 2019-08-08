
### Builder
#
FROM hashicorp/consul-template:0.21.0-light AS builder
LABEL maintainer "Thiebaud Ernstberger <Thiebaud.Ernstberger@gmail.com>"

RUN addgroup -S -g 20002 appgroup \
    && adduer -D -u 20001 -s /sbin/nologin -g "Consul Template User" appuser -G appgroup appgroup

### Final
#
FROM alpine:latest
LABEL maintainer "Thiebaud Ernstberger <Thiebaud.Ernstberger@gmail.com>"

RUN apk add --no-cache ca-certificates
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder "/bin/consul-template" "/bin/consul-template"

USER 20001

ENTRYPOINT ["/bin/consul-template"]