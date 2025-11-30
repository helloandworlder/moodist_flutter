class SoundDefinition {
  final String id;
  final String label;
  final String icon;
  final String path;

  const SoundDefinition({
    required this.id,
    required this.label,
    required this.icon,
    required this.path,
  });
}

class CategoryDefinition {
  final String id;
  final String title;
  final String icon;
  final List<SoundDefinition> sounds;

  const CategoryDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.sounds,
  });
}

class SoundAssets {
  SoundAssets._();

  static const String _basePath = 'assets/sounds';

  static const List<CategoryDefinition> categories = [
    // ========== Nature (12) ==========
    CategoryDefinition(
      id: 'nature',
      title: 'Nature',
      icon: 'tree-pine',
      sounds: [
        SoundDefinition(id: 'river', label: 'River', icon: 'waves', path: '$_basePath/nature/river.mp3'),
        SoundDefinition(id: 'waves', label: 'Waves', icon: 'waves', path: '$_basePath/nature/waves.mp3'),
        SoundDefinition(id: 'campfire', label: 'Campfire', icon: 'flame', path: '$_basePath/nature/campfire.mp3'),
        SoundDefinition(id: 'wind', label: 'Wind', icon: 'wind', path: '$_basePath/nature/wind.mp3'),
        SoundDefinition(id: 'howling-wind', label: 'Howling Wind', icon: 'wind', path: '$_basePath/nature/howling-wind.mp3'),
        SoundDefinition(id: 'wind-in-trees', label: 'Wind in Trees', icon: 'tree-pine', path: '$_basePath/nature/wind-in-trees.mp3'),
        SoundDefinition(id: 'waterfall', label: 'Waterfall', icon: 'droplet', path: '$_basePath/nature/waterfall.mp3'),
        SoundDefinition(id: 'walk-in-snow', label: 'Walk in Snow', icon: 'snowflake', path: '$_basePath/nature/walk-in-snow.mp3'),
        SoundDefinition(id: 'walk-on-leaves', label: 'Walk on Leaves', icon: 'leaf', path: '$_basePath/nature/walk-on-leaves.mp3'),
        SoundDefinition(id: 'walk-on-gravel', label: 'Walk on Gravel', icon: 'footprints', path: '$_basePath/nature/walk-on-gravel.mp3'),
        SoundDefinition(id: 'droplets', label: 'Droplets', icon: 'droplet', path: '$_basePath/nature/droplets.mp3'),
        SoundDefinition(id: 'jungle', label: 'Jungle', icon: 'tree-palm', path: '$_basePath/nature/jungle.mp3'),
      ],
    ),

    // ========== Rain (8) ==========
    CategoryDefinition(
      id: 'rain',
      title: 'Rain',
      icon: 'cloud-rain',
      sounds: [
        SoundDefinition(id: 'light-rain', label: 'Light Rain', icon: 'cloud-rain', path: '$_basePath/rain/light-rain.mp3'),
        SoundDefinition(id: 'heavy-rain', label: 'Heavy Rain', icon: 'cloud-rain-wind', path: '$_basePath/rain/heavy-rain.mp3'),
        SoundDefinition(id: 'thunder', label: 'Thunder', icon: 'cloud-lightning', path: '$_basePath/rain/thunder.mp3'),
        SoundDefinition(id: 'rain-on-window', label: 'Rain on Window', icon: 'square', path: '$_basePath/rain/rain-on-window.mp3'),
        SoundDefinition(id: 'rain-on-car-roof', label: 'Rain on Car Roof', icon: 'car', path: '$_basePath/rain/rain-on-car-roof.mp3'),
        SoundDefinition(id: 'rain-on-umbrella', label: 'Rain on Umbrella', icon: 'umbrella', path: '$_basePath/rain/rain-on-umbrella.mp3'),
        SoundDefinition(id: 'rain-on-tent', label: 'Rain on Tent', icon: 'tent', path: '$_basePath/rain/rain-on-tent.mp3'),
        SoundDefinition(id: 'rain-on-leaves', label: 'Rain on Leaves', icon: 'leaf', path: '$_basePath/rain/rain-on-leaves.mp3'),
      ],
    ),

    // ========== Animals (16) ==========
    CategoryDefinition(
      id: 'animals',
      title: 'Animals',
      icon: 'dog',
      sounds: [
        SoundDefinition(id: 'birds', label: 'Birds', icon: 'bird', path: '$_basePath/animals/birds.mp3'),
        SoundDefinition(id: 'seagulls', label: 'Seagulls', icon: 'bird', path: '$_basePath/animals/seagulls.mp3'),
        SoundDefinition(id: 'crickets', label: 'Crickets', icon: 'bug', path: '$_basePath/animals/crickets.mp3'),
        SoundDefinition(id: 'wolf', label: 'Wolf', icon: 'dog', path: '$_basePath/animals/wolf.mp3'),
        SoundDefinition(id: 'owl', label: 'Owl', icon: 'bird', path: '$_basePath/animals/owl.mp3'),
        SoundDefinition(id: 'frog', label: 'Frog', icon: 'frog', path: '$_basePath/animals/frog.mp3'),
        SoundDefinition(id: 'dog-barking', label: 'Dog Barking', icon: 'dog', path: '$_basePath/animals/dog-barking.mp3'),
        SoundDefinition(id: 'horse-gallop', label: 'Horse Gallop', icon: 'horse', path: '$_basePath/animals/horse-gallop.mp3'),
        SoundDefinition(id: 'cat-purring', label: 'Cat Purring', icon: 'cat', path: '$_basePath/animals/cat-purring.mp3'),
        SoundDefinition(id: 'crows', label: 'Crows', icon: 'bird', path: '$_basePath/animals/crows.mp3'),
        SoundDefinition(id: 'whale', label: 'Whale', icon: 'fish', path: '$_basePath/animals/whale.mp3'),
        SoundDefinition(id: 'beehive', label: 'Beehive', icon: 'hexagon', path: '$_basePath/animals/beehive.mp3'),
        SoundDefinition(id: 'woodpecker', label: 'Woodpecker', icon: 'bird', path: '$_basePath/animals/woodpecker.mp3'),
        SoundDefinition(id: 'chickens', label: 'Chickens', icon: 'egg', path: '$_basePath/animals/chickens.mp3'),
        SoundDefinition(id: 'cows', label: 'Cows', icon: 'beef', path: '$_basePath/animals/cows.mp3'),
        SoundDefinition(id: 'sheep', label: 'Sheep', icon: 'cloud', path: '$_basePath/animals/sheep.mp3'),
      ],
    ),

    // ========== Urban (7) ==========
    CategoryDefinition(
      id: 'urban',
      title: 'Urban',
      icon: 'building',
      sounds: [
        SoundDefinition(id: 'highway', label: 'Highway', icon: 'road', path: '$_basePath/urban/highway.mp3'),
        SoundDefinition(id: 'road', label: 'Road', icon: 'road', path: '$_basePath/urban/road.mp3'),
        SoundDefinition(id: 'ambulance-siren', label: 'Ambulance Siren', icon: 'siren', path: '$_basePath/urban/ambulance-siren.mp3'),
        SoundDefinition(id: 'busy-street', label: 'Busy Street', icon: 'users', path: '$_basePath/urban/busy-street.mp3'),
        SoundDefinition(id: 'crowd', label: 'Crowd', icon: 'users', path: '$_basePath/urban/crowd.mp3'),
        SoundDefinition(id: 'traffic', label: 'Traffic', icon: 'traffic-cone', path: '$_basePath/urban/traffic.mp3'),
        SoundDefinition(id: 'fireworks', label: 'Fireworks', icon: 'sparkles', path: '$_basePath/urban/fireworks.mp3'),
      ],
    ),

    // ========== Places (16) ==========
    CategoryDefinition(
      id: 'places',
      title: 'Places',
      icon: 'map-pin',
      sounds: [
        SoundDefinition(id: 'cafe', label: 'Cafe', icon: 'coffee', path: '$_basePath/places/cafe.mp3'),
        SoundDefinition(id: 'airport', label: 'Airport', icon: 'plane', path: '$_basePath/places/airport.mp3'),
        SoundDefinition(id: 'church', label: 'Church', icon: 'church', path: '$_basePath/places/church.mp3'),
        SoundDefinition(id: 'temple', label: 'Temple', icon: 'landmark', path: '$_basePath/places/temple.mp3'),
        SoundDefinition(id: 'construction-site', label: 'Construction Site', icon: 'construction', path: '$_basePath/places/construction-site.mp3'),
        SoundDefinition(id: 'underwater', label: 'Underwater', icon: 'waves', path: '$_basePath/places/underwater.mp3'),
        SoundDefinition(id: 'crowded-bar', label: 'Crowded Bar', icon: 'beer', path: '$_basePath/places/crowded-bar.mp3'),
        SoundDefinition(id: 'night-village', label: 'Night Village', icon: 'home', path: '$_basePath/places/night-village.mp3'),
        SoundDefinition(id: 'subway-station', label: 'Subway Station', icon: 'train', path: '$_basePath/places/subway-station.mp3'),
        SoundDefinition(id: 'office', label: 'Office', icon: 'building', path: '$_basePath/places/office.mp3'),
        SoundDefinition(id: 'supermarket', label: 'Supermarket', icon: 'shopping-cart', path: '$_basePath/places/supermarket.mp3'),
        SoundDefinition(id: 'carousel', label: 'Carousel', icon: 'ferris-wheel', path: '$_basePath/places/carousel.mp3'),
        SoundDefinition(id: 'laboratory', label: 'Laboratory', icon: 'flask', path: '$_basePath/places/laboratory.mp3'),
        SoundDefinition(id: 'laundry-room', label: 'Laundry Room', icon: 'washing-machine', path: '$_basePath/places/laundry-room.mp3'),
        SoundDefinition(id: 'restaurant', label: 'Restaurant', icon: 'utensils', path: '$_basePath/places/restaurant.mp3'),
        SoundDefinition(id: 'library', label: 'Library', icon: 'book-open', path: '$_basePath/places/library.mp3'),
      ],
    ),

    // ========== Transport (6) ==========
    CategoryDefinition(
      id: 'transport',
      title: 'Transport',
      icon: 'car',
      sounds: [
        SoundDefinition(id: 'train', label: 'Train', icon: 'train', path: '$_basePath/transport/train.mp3'),
        SoundDefinition(id: 'inside-a-train', label: 'Inside a Train', icon: 'train', path: '$_basePath/transport/inside-a-train.mp3'),
        SoundDefinition(id: 'airplane', label: 'Airplane', icon: 'plane', path: '$_basePath/transport/airplane.mp3'),
        SoundDefinition(id: 'submarine', label: 'Submarine', icon: 'ship', path: '$_basePath/transport/submarine.mp3'),
        SoundDefinition(id: 'sailboat', label: 'Sailboat', icon: 'sailboat', path: '$_basePath/transport/sailboat.mp3'),
        SoundDefinition(id: 'rowing-boat', label: 'Rowing Boat', icon: 'sailboat', path: '$_basePath/transport/rowing-boat.mp3'),
      ],
    ),

    // ========== Things (16) ==========
    CategoryDefinition(
      id: 'things',
      title: 'Things',
      icon: 'box',
      sounds: [
        SoundDefinition(id: 'keyboard', label: 'Keyboard', icon: 'keyboard', path: '$_basePath/things/keyboard.mp3'),
        SoundDefinition(id: 'typewriter', label: 'Typewriter', icon: 'type', path: '$_basePath/things/typewriter.mp3'),
        SoundDefinition(id: 'paper', label: 'Paper', icon: 'file', path: '$_basePath/things/paper.mp3'),
        SoundDefinition(id: 'clock', label: 'Clock', icon: 'clock', path: '$_basePath/things/clock.mp3'),
        SoundDefinition(id: 'wind-chimes', label: 'Wind Chimes', icon: 'wind', path: '$_basePath/things/wind-chimes.mp3'),
        SoundDefinition(id: 'singing-bowl', label: 'Singing Bowl', icon: 'circle', path: '$_basePath/things/singing-bowl.mp3'),
        SoundDefinition(id: 'ceiling-fan', label: 'Ceiling Fan', icon: 'fan', path: '$_basePath/things/ceiling-fan.mp3'),
        SoundDefinition(id: 'dryer', label: 'Dryer', icon: 'wind', path: '$_basePath/things/dryer.mp3'),
        SoundDefinition(id: 'slide-projector', label: 'Slide Projector', icon: 'projector', path: '$_basePath/things/slide-projector.mp3'),
        SoundDefinition(id: 'boiling-water', label: 'Boiling Water', icon: 'droplet', path: '$_basePath/things/boiling-water.mp3'),
        SoundDefinition(id: 'bubbles', label: 'Bubbles', icon: 'circle', path: '$_basePath/things/bubbles.mp3'),
        SoundDefinition(id: 'tuning-radio', label: 'Tuning Radio', icon: 'radio', path: '$_basePath/things/tuning-radio.mp3'),
        SoundDefinition(id: 'morse-code', label: 'Morse Code', icon: 'radio', path: '$_basePath/things/morse-code.mp3'),
        SoundDefinition(id: 'washing-machine', label: 'Washing Machine', icon: 'loader', path: '$_basePath/things/washing-machine.mp3'),
        SoundDefinition(id: 'vinyl-effect', label: 'Vinyl Effect', icon: 'disc', path: '$_basePath/things/vinyl-effect.mp3'),
        SoundDefinition(id: 'windshield-wipers', label: 'Windshield Wipers', icon: 'car', path: '$_basePath/things/windshield-wipers.mp3'),
      ],
    ),

    // ========== Noise (3) ==========
    CategoryDefinition(
      id: 'noise',
      title: 'Noise',
      icon: 'radio',
      sounds: [
        SoundDefinition(id: 'white-noise', label: 'White Noise', icon: 'radio', path: '$_basePath/noise/white-noise.wav'),
        SoundDefinition(id: 'pink-noise', label: 'Pink Noise', icon: 'radio', path: '$_basePath/noise/pink-noise.wav'),
        SoundDefinition(id: 'brown-noise', label: 'Brown Noise', icon: 'radio', path: '$_basePath/noise/brown-noise.wav'),
      ],
    ),
  ];

  /// Get all sound IDs
  static List<String> get allSoundIds =>
      categories.expand((c) => c.sounds.map((s) => s.id)).toList();

  /// Get asset path by sound ID
  static String getAssetPath(String soundId) {
    for (final category in categories) {
      for (final sound in category.sounds) {
        if (sound.id == soundId) {
          return sound.path;
        }
      }
    }
    throw ArgumentError('Unknown sound ID: $soundId');
  }

  /// Get sound definition by ID
  static SoundDefinition? getSoundById(String soundId) {
    for (final category in categories) {
      for (final sound in category.sounds) {
        if (sound.id == soundId) {
          return sound;
        }
      }
    }
    return null;
  }

  /// Get total sound count
  static int get totalCount =>
      categories.fold(0, (sum, c) => sum + c.sounds.length);
}
