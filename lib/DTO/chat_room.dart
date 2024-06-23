class ChatRoom {
  late String _roomid;
  late String _roomname;
  late List<String> _users = [];
  late String _mode; //일회성만남, 정기모임
  late String _overviewmsg;
  late String _img;
  late int _talkcnt; //몇 개의 톡이 와있는가

  ChatRoom();

// setting //
  void setID(String id) {
    _roomid = id;
  }
  void setUsers(List<String> usrs) {
    _users = usrs;
  }
  void appendUser(String userID) {
    _users.add(userID);
  }
  void setName(String name) {
    _roomname = name;
  }
  void setImg(String url) {
    _img = url;
  }
  void setTalkCnt(int cnt) {
    _talkcnt = cnt;
  }
  void setOvm(String ovm) {
    _overviewmsg = ovm;
  }
  void setMode(String m) {
    _mode = m;
  }
// getting //
  String getRoomId() {
    return (_roomid);
  }
  String getRoomName() {
    return (_roomname);
  }
  List<String> getUsers() {
    return (_users);
  }
  int usersSize() {
    return (_users.length);
  }
  String getMode() {
    return (_mode);
  }
  String getOvm() {
    return (_overviewmsg);
  }
  String getImg() {
    return (_img);
  }
  int getTalkCnt() {
    return (_talkcnt);
  }
}