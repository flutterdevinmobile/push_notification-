part of '../data.dart';

abstract class RemoteRequest<P extends Payload> {
  Map<String, String> path();
  Map<String, String> query();
  Json data();

  const RemoteRequest.fromPayload(P payload);
}
