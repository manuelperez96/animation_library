import 'package:animation_library/three_d_flipped_card/three_d_flipped_card.dart';
import 'package:flutter/material.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My playslist'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: const Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: SongAlbum(),
          ),
          Expanded(
            flex: 2,
            child: _HorizontalCardsSection(),
          )
        ],
      ),
    );
  }
}

class SongAlbum extends StatefulWidget {
  const SongAlbum({super.key});

  @override
  State<SongAlbum> createState() => _SongAlbumState();
}

class _SongAlbumState extends State<SongAlbum> with TickerProviderStateMixin {
  late final AnimationController _selectionAnimationController;
  late final AnimationController _movementAnimationController;

  var _isSelectedMode = false;
  var _moving = false;
  var _selectedSong = -1;

  @override
  void initState() {
    super.initState();
    _selectionAnimationController = AnimationController(
      vsync: this,
      lowerBound: .15,
      upperBound: .5,
      duration: const Duration(milliseconds: 500),
    );
    _movementAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  @override
  void dispose() {
    _selectionAnimationController.dispose();
    _movementAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _selectionAnimationController,
          builder: (context, widget) {
            return GestureDetector(
              onVerticalDragUpdate: _updateAlbumStatus,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_selectionAnimationController.value),
                child: SizedBox(
                  width: constraints.maxWidth * 0.45,
                  height: constraints.maxHeight,
                  child: AbsorbPointer(
                    absorbing: !_isSelectedMode,
                    child: Stack(
                      children: [
                        ...List.generate(
                          songList.length,
                          (index) => _Card3DItem(
                            song: songList[index],
                            height: constraints.maxHeight / 2,
                            percent: _selectionAnimationController.value,
                            depth: index,
                            verticalFactor: getCurrentFactor(index),
                            listenable: _movementAnimationController,
                            onSongTap: (song) {
                              _onSelectSong(index, song);
                            },
                          ),
                        ).reversed,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateAlbumStatus(DragUpdateDetails details) {
    if (!_moving && details.delta.direction > 0) {
      _moving = true;
      _selectionAnimationController.reverse().then((value) => setState(() {
            _isSelectedMode = false;
            _moving = false;
          }));
    } else if (!_moving && details.delta.direction < 0) {
      _moving = true;
      _selectionAnimationController.forward().then((value) => setState(() {
            _isSelectedMode = true;
            _moving = false;
          }));
    }
  }

  Future<void> _onSelectSong(int index, Song song) async {
    setState(() {
      _selectedSong = index;
    });
    const duration = Duration(milliseconds: 750);
    _movementAnimationController.forward();
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        pageBuilder: (context, animation, _) => FadeTransition(
          opacity: animation,
          child: DetailSongPage(song: song),
        ),
      ),
    );
    _movementAnimationController.reverse(from: 1);
  }

  int getCurrentFactor(int currentIndex) {
    if (_selectedSong < 0) return 0;
    return _selectedSong.compareTo(currentIndex);
  }
}

class _HorizontalCardsSection extends StatelessWidget {
  const _HorizontalCardsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Recently played'),
          ),
          Expanded(
            child: _HorizontalSongSlider(songList: songList),
          )
        ],
      ),
    );
  }
}

class _HorizontalSongSlider extends StatelessWidget {
  const _HorizontalSongSlider({
    required this.songList,
  });

  final List<Song> songList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: songList.length,
      itemBuilder: (context, index) {
        final song = songList[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: SongCard(song: song),
        );
      },
    );
  }
}

typedef OnSongTap = void Function(Song song);

class _Card3DItem extends AnimatedWidget {
  const _Card3DItem({
    required this.height,
    required this.song,
    required this.percent,
    required this.depth,
    required this.onSongTap,
    required this.verticalFactor,
    required super.listenable,
  });

  final Song song;
  final double height;
  final double percent;
  final int depth;
  final OnSongTap onSongTap;
  final int verticalFactor;

  Animation<double> get animation => super.listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0 + depth * height / 2 * percent + height / 4,
      child: Opacity(
        opacity: verticalFactor == 0 ? 1 : 1 - animation.value,
        child: Hero(
          tag: song.name,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(
                  0.0, verticalFactor * animation.value * height, depth * 50),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSongTap(song),
                child: SongCard(
                  song: song,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
