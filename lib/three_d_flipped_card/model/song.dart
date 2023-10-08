final songList = [
  Song(image: 'assets/cover1.jpg', name: 'Song 1'),
  Song(image: 'assets/cover2.jpg', name: 'Song 2'),
  Song(image: 'assets/cover3.jpg', name: 'Song 3'),
  Song(image: 'assets/cover4.jpg', name: 'Song 4'),
];

class Song {
  Song({required this.image, required this.name});

  final String image;
  final String name;
}
