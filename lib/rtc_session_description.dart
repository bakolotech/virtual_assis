class RTCSessionDescription {
  RTCSessionDescription(this.sdp, this.type);
  String? sdp;
  String? type;
  dynamic topMap() {
    return {'sdp': sdp, 'type': type};
  }
}