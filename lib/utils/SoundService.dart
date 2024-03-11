class SoundItem {
  final String path;
  // final Codec codec;
  final SoundType type;
  final VibrationItem vibration;
  const SoundItem({
    required this.path,
    // required this.codec,
    required this.type,
    required this.vibration,
  });
}

class VibrationItem {
  final int duration;
  final int amplitude;
  final List<int> intensities;
  final int repeat;
  VibrationItem(
      {required this.duration,
      this.amplitude = 100,
      this.intensities = const [0, 1, 5, 1, 0],
      this.repeat = 1});
}

enum SoundType {
  correct,
  wrong,
  eraser,
  note,
}

class SoundService {
  static List<SoundItem> correctSounds = [
    SoundItem(
        path: 'sounds/correct1.mp3',
        // codec: Codec.mp3,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct2.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct3.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct4.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct5.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct6.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct7.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct8.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/correct9.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50))
  ];

  static List<SoundItem> wrongSounds = [
    SoundItem(
        path: 'sounds/wrong1.mp3',
        // codec: Codec.mp3,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/wrong2.mp3',
        // codec: Codec.mp3,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/wrong3.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50)),
    SoundItem(
        path: 'sounds/wrong4.wav',
        // codec: Codec.pcm16WAV,
        type: SoundType.correct,
        vibration: VibrationItem(duration: 50))
  ];

  static SoundItem eraser() => SoundItem(
      path: 'sounds/eraser.wav',
      // codec: Codec.pcm16WAV,
      type: SoundType.correct,
      vibration: VibrationItem(duration: 50));
  static SoundItem note() => SoundItem(
      path: 'sounds/note.wav',
      // codec: Codec.pcm16WAV,
      type: SoundType.correct,
      vibration: VibrationItem(duration: 50));
}
