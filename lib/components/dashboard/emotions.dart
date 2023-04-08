class Emotions {
  final String image;
  final String emojiname;
  final String description;
  Emotions({
    required this.image,
    required this.emojiname,
    required this.description,
  });
}

List<Emotions> emoticons = [
  Emotions(
      image: 'assets/images/happy.png',
      emojiname: 'Happy',
      description:
          'A pleasant and emotional state that elicits feelings of joy, contentment and satisfaction'),
  Emotions(
      image: 'assets/images/sick.png',
      emojiname: 'Disgust',
      description:
          'A strong emotion that results in the feeling of being repulsed.'),
  Emotions(
      image: 'assets/images/surprise.png',
      emojiname: 'Surprised',
      description:
          'A brief emotional state  either - or +, following something unexpected.'),
  Emotions(
      image: 'assets/images/anger.png',
      emojiname: 'Anger',
      description:
          'An emotional state leading to feelings of hostility and frustration.'),
  Emotions(
      image: 'assets/images/superb.png',
      emojiname: 'Superb',
      description: 'kjljljlj'),
  Emotions(
      image: 'assets/images/exciting.png',
      emojiname: 'Excited',
      description:
          ' A brief emotional state, either positive or negative, following something unexpected'),
];
