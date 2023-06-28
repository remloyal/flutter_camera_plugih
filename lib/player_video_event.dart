enum PlayerVideoEventType {
  //视频开始播放
  start,
  //视频正在加载
  loading,
  //视频回放时间
  duration,
  //视频回放播放完成
  finished,
  unknown,
}

class PlayerVideoEvent<T> {
  PlayerVideoEventType type;

  T? message;

  PlayerVideoEvent({required this.type, this.message});
}