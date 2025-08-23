# Stage 1: Build
FROM golang:1.22.5 as base

WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod .
RUN go mod download

# Copy source code
COPY . .

# Build the Go binary
RUN go build -o main .

# Stage 2: Distroless minimal runtime
FROM gcr.io/distroless/base

WORKDIR /

# Copy compiled binary and static files
COPY --from=base /app/main .
COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]
