// Code generated by protoc-gen-go-grpc. DO NOT EDIT.

package proto

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// SpeechMatchClient is the client API for SpeechMatch service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type SpeechMatchClient interface {
	// create dialogue
	Init(ctx context.Context, in *InitRequest, opts ...grpc.CallOption) (*InitResponse, error)
	// stream recogize
	MatchStream(ctx context.Context, opts ...grpc.CallOption) (SpeechMatch_MatchStreamClient, error)
	// wholly recogize
	MatchResponse(ctx context.Context, in *Request, opts ...grpc.CallOption) (*Response, error)
	// destory dialogue
	Terminate(ctx context.Context, in *TerminateRequest, opts ...grpc.CallOption) (*TerminateResponse, error)
}

type speechMatchClient struct {
	cc grpc.ClientConnInterface
}

func NewSpeechMatchClient(cc grpc.ClientConnInterface) SpeechMatchClient {
	return &speechMatchClient{cc}
}

func (c *speechMatchClient) Init(ctx context.Context, in *InitRequest, opts ...grpc.CallOption) (*InitResponse, error) {
	out := new(InitResponse)
	err := c.cc.Invoke(ctx, "/com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch/init", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *speechMatchClient) MatchStream(ctx context.Context, opts ...grpc.CallOption) (SpeechMatch_MatchStreamClient, error) {
	stream, err := c.cc.NewStream(ctx, &SpeechMatch_ServiceDesc.Streams[0], "/com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch/match_stream", opts...)
	if err != nil {
		return nil, err
	}
	x := &speechMatchMatchStreamClient{stream}
	return x, nil
}

type SpeechMatch_MatchStreamClient interface {
	Send(*Request) error
	Recv() (*Response, error)
	grpc.ClientStream
}

type speechMatchMatchStreamClient struct {
	grpc.ClientStream
}

func (x *speechMatchMatchStreamClient) Send(m *Request) error {
	return x.ClientStream.SendMsg(m)
}

func (x *speechMatchMatchStreamClient) Recv() (*Response, error) {
	m := new(Response)
	if err := x.ClientStream.RecvMsg(m); err != nil {
		return nil, err
	}
	return m, nil
}

func (c *speechMatchClient) MatchResponse(ctx context.Context, in *Request, opts ...grpc.CallOption) (*Response, error) {
	out := new(Response)
	err := c.cc.Invoke(ctx, "/com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch/match_response", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *speechMatchClient) Terminate(ctx context.Context, in *TerminateRequest, opts ...grpc.CallOption) (*TerminateResponse, error) {
	out := new(TerminateResponse)
	err := c.cc.Invoke(ctx, "/com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch/terminate", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// SpeechMatchServer is the server API for SpeechMatch service.
// All implementations must embed UnimplementedSpeechMatchServer
// for forward compatibility
type SpeechMatchServer interface {
	// create dialogue
	Init(context.Context, *InitRequest) (*InitResponse, error)
	// stream recogize
	MatchStream(SpeechMatch_MatchStreamServer) error
	// wholly recogize
	MatchResponse(context.Context, *Request) (*Response, error)
	// destory dialogue
	Terminate(context.Context, *TerminateRequest) (*TerminateResponse, error)
	mustEmbedUnimplementedSpeechMatchServer()
}

// UnimplementedSpeechMatchServer must be embedded to have forward compatible implementations.
type UnimplementedSpeechMatchServer struct {
}

func (UnimplementedSpeechMatchServer) Init(context.Context, *InitRequest) (*InitResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Init not implemented")
}
func (UnimplementedSpeechMatchServer) MatchStream(SpeechMatch_MatchStreamServer) error {
	return status.Errorf(codes.Unimplemented, "method MatchStream not implemented")
}
func (UnimplementedSpeechMatchServer) MatchResponse(context.Context, *Request) (*Response, error) {
	return nil, status.Errorf(codes.Unimplemented, "method MatchResponse not implemented")
}
func (UnimplementedSpeechMatchServer) Terminate(context.Context, *TerminateRequest) (*TerminateResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Terminate not implemented")
}
func (UnimplementedSpeechMatchServer) mustEmbedUnimplementedSpeechMatchServer() {}

// UnsafeSpeechMatchServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to SpeechMatchServer will
// result in compilation errors.
type UnsafeSpeechMatchServer interface {
	mustEmbedUnimplementedSpeechMatchServer()
}

func RegisterSpeechMatchServer(s grpc.ServiceRegistrar, srv SpeechMatchServer) {
	s.RegisterService(&SpeechMatch_ServiceDesc, srv)
}

func _SpeechMatch_Init_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(InitRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SpeechMatchServer).Init(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch/init",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SpeechMatchServer).Init(ctx, req.(*InitRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _SpeechMatch_MatchStream_Handler(srv interface{}, stream grpc.ServerStream) error {
	return srv.(SpeechMatchServer).MatchStream(&speechMatchMatchStreamServer{stream})
}

type SpeechMatch_MatchStreamServer interface {
	Send(*Response) error
	Recv() (*Request, error)
	grpc.ServerStream
}

type speechMatchMatchStreamServer struct {
	grpc.ServerStream
}

func (x *speechMatchMatchStreamServer) Send(m *Response) error {
	return x.ServerStream.SendMsg(m)
}

func (x *speechMatchMatchStreamServer) Recv() (*Request, error) {
	m := new(Request)
	if err := x.ServerStream.RecvMsg(m); err != nil {
		return nil, err
	}
	return m, nil
}

func _SpeechMatch_MatchResponse_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(Request)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SpeechMatchServer).MatchResponse(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch/match_response",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SpeechMatchServer).MatchResponse(ctx, req.(*Request))
	}
	return interceptor(ctx, in, info, handler)
}

func _SpeechMatch_Terminate_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TerminateRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SpeechMatchServer).Terminate(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch/terminate",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SpeechMatchServer).Terminate(ctx, req.(*TerminateRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// SpeechMatch_ServiceDesc is the grpc.ServiceDesc for SpeechMatch service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var SpeechMatch_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "com.qihoo.shuke.aibot.vmatch.proto.SpeechMatch",
	HandlerType: (*SpeechMatchServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "init",
			Handler:    _SpeechMatch_Init_Handler,
		},
		{
			MethodName: "match_response",
			Handler:    _SpeechMatch_MatchResponse_Handler,
		},
		{
			MethodName: "terminate",
			Handler:    _SpeechMatch_Terminate_Handler,
		},
	},
	Streams: []grpc.StreamDesc{
		{
			StreamName:    "match_stream",
			Handler:       _SpeechMatch_MatchStream_Handler,
			ServerStreams: true,
			ClientStreams: true,
		},
	},
	Metadata: "vmatch.proto",
}
