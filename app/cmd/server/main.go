package main

import (
	"net"

	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_recovery "github.com/grpc-ecosystem/go-grpc-middleware/recovery"
	grpc_validator "github.com/grpc-ecosystem/go-grpc-middleware/validator"
	"github.com/sirupsen/logrus"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func newGRPCServer() *grpc.Server {
	s := grpc.NewServer(
		grpc.UnaryInterceptor(grpc_middleware.ChainUnaryServer(
			grpc_validator.UnaryServerInterceptor(),
			grpc_recovery.UnaryServerInterceptor(),
		)),
	)

	//loginpb.RegisterLoginServiceServer(s, loginimpl.NewLoginServiceServer(r, u))
	//userpb.RegisterUserServiceServer(s, userimpl.NewUserServiceServer(r, u))

	return s
}

func main() {
	listenPort, err := net.Listen("tcp", ":9090")
	if err != nil {
		logrus.Fatalln(err)
	}

	s := newGRPCServer()
	reflection.Register(s)
	err = s.Serve(listenPort)
	if err != nil {
		logrus.Fatalln(err)
	}
	s.GracefulStop()
}
