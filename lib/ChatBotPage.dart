import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = false;

  // Define a list of questions and responses
  final Map<String, String> _responses = {
    'great job buddy': 'Thankyou do you have any other queries',
    'good job':
        'Its awesome to hear these words from you do you have any other queries',
    'ideal temperature for my moneyplant':
        '32.1°C with 50% moisture and 20% humidity.',
    'best light for succulents':
        'Bright, indirect sunlight is best for succulents.',
    'how to water an orchid':
        'Water the orchid once a week, allowing the top 1-2 inches of soil to dry out between waterings.',
    'what is the best time to plant tomatoes in India':
        'Tomatoes can be planted from September to December in most parts of India.',
    'how often should I water my tulsi plant':
        'Tulsi should be watered 2-3 times a week, allowing the soil to dry out between waterings.',
    'how to care for a hibiscus plant':
        'Hibiscus plants need full sun, regular watering, and well-drained soil. Fertilize every 6-8 weeks.',
    'best soil for growing marigolds':
        'Marigolds thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'when should I prune my guava tree':
        'Prune guava trees after the harvest or during the early spring to remove dead or diseased wood.',
    'how to protect plants from monsoon pests':
        'Use neem oil or insecticidal soap to protect plants from pests during the monsoon season.',
    'ideal humidity for growing ferns':
        'Ferns prefer high humidity, ideally around 60-80%. Use a humidifier or mist regularly.',
    'how to propagate aloe vera':
        'Aloe vera can be propagated through offsets or pups, which can be separated from the main plant and replanted.',
    'when is the best time to plant ginger in India':
        'Ginger is best planted from March to June in India, before the onset of the monsoon.',
    'how to care for a bougainvillea plant':
        'Bougainvilleas need full sun, well-drained soil, and occasional watering. Fertilize with a balanced fertilizer.',
    'ideal temperature for growing curry leaves':
        'Curry leaves grow best in temperatures between 20°C and 35°C.',
    'how to grow chrysanthemums in India':
        'Chrysanthemums should be planted in well-drained soil with full sunlight. Water regularly and apply a balanced fertilizer.',
    'what are common pests for indoor plants in India':
        'Common indoor plant pests include spider mites, aphids, and mealybugs. Use insecticidal soap or neem oil to control them.',
    'how to grow and care for a pomegranate tree':
        'Pomegranate trees need full sun, well-drained soil, and regular watering. Fertilize in early spring and prune annually.',
    'best fertilizer for hibiscus plants':
        'Use a balanced fertilizer (e.g., 10-10-10) for hibiscus plants every 6-8 weeks during the growing season.',
    'how to handle waterlogged soil':
        'Improve drainage by adding organic matter and avoiding overwatering. Raised beds can also help with drainage.',
    'ideal planting season for spinach in India':
        'Spinach can be planted from September to February for a successful crop in India.',
    'how to grow and care for jasmine plants':
        'Jasmine plants need full sun, well-drained soil, and regular watering. Fertilize every 4-6 weeks during the growing season.',
    'what is the best time to plant basil in India':
        'Basil can be planted from March to June in India for optimal growth.',
    'how to grow tomatoes in a container':
        'Use a large container with good drainage, and provide support for the tomato plants. Water regularly and fertilize as needed.',
    'how to protect plants from heat stress':
        'Provide shade, water regularly, and use mulch to help retain soil moisture during periods of extreme heat.',
    'when should I fertilize my mango tree':
        'Fertilize mango trees in the early spring and again in mid-summer with a balanced fertilizer.',
    'how to care for a spider plant':
        'Spider plants need bright, indirect light and well-drained soil. Water when the top inch of soil feels dry.',
    'ideal temperature for growing brinjal':
        'Brinjal (eggplant) grows best in temperatures between 20°C and 30°C.',
    'how to grow and care for a banana plant':
        'Banana plants need full sun, regular watering, and rich, well-drained soil. Fertilize with a balanced fertilizer every 6-8 weeks.',
    'what type of soil is best for growing lettuce':
        'Lettuce prefers well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to grow and care for a bottle gourd':
        'Bottle gourd needs full sun, regular watering, and fertile, well-drained soil. Provide support for the vines to climb.',
    'ideal humidity for growing orchids in India':
        'Orchids thrive in humidity levels between 50% and 70%. Use a humidifier or place the pots on a humidity tray.',
    'when should I start planting peppers':
        'Peppers should be planted from February to April for a successful harvest in most parts of India.',
    'how to care for a cactus plant':
        'Cacti need bright, indirect light and minimal watering. Allow the soil to dry completely between waterings.',
    'ideal temperature for growing okra':
        'Okra grows best in temperatures between 25°C and 35°C.',
    'how to protect plants from cold weather':
        'Cover plants with frost cloth, mulch around the base, and consider using row covers during cold spells.',
    'when is the best time to plant beans in India':
        'Beans can be planted from March to July for the best results in India.',
    'how to care for a lemon tree':
        'Lemon trees need full sun, well-drained soil, and regular watering. Fertilize with a citrus-specific fertilizer every 6-8 weeks.',
    'ideal temperature for growing peas':
        'Peas grow best in temperatures between 10°C and 20°C.',
    'how to grow and care for a sweet potato plant':
        'Sweet potatoes need full sun, well-drained soil, and regular watering. Fertilize with a balanced fertilizer during the growing season.',
    'what is the best soil for growing carrots':
        'Carrots thrive in loose, sandy loam with good drainage and a pH between 6.0 and 6.8.',
    'how to grow and care for a grape vine':
        'Grape vines need full sun, well-drained soil, and regular watering. Prune annually to maintain shape and improve fruit production.',
    'ideal humidity for growing ferns indoors':
        'Ferns prefer humidity levels of 60-80%. Use a humidifier or mist regularly to maintain humidity.',
    'when should I plant okra in India':
        'Okra can be planted from March to June for optimal growth in most parts of India.',
    'how to grow and care for a papaya tree':
        'Papaya trees need full sun, well-drained soil, and regular watering. Fertilize with a balanced fertilizer every 6-8 weeks.',
    'best soil for growing radishes':
        'Radishes prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to protect plants from heavy rains':
        'Ensure proper drainage, use mulch to prevent soil erosion, and consider using raised beds to protect plants from waterlogging.',
    'ideal temperature for growing mint':
        'Mint grows best in temperatures between 15°C and 25°C.',
    'how to care for a rose plant':
        'Roses need full sun, well-drained soil, and regular watering. Fertilize every 6-8 weeks and prune annually to promote healthy growth.',
    'when should I water my garden during the summer':
        'Water your garden early in the morning or late in the afternoon to minimize evaporation and ensure deep watering.',
    'how to grow and care for a guava plant':
        'Guava plants need full sun, well-drained soil, and regular watering. Fertilize in the early spring and prune after fruiting.',
    'best fertilizer for growing cucumbers':
        'Use a balanced fertilizer (e.g., 10-10-10) for cucumbers every 4-6 weeks during the growing season.',
    'ideal temperature for growing spinach':
        'Spinach grows best in temperatures between 10°C and 20°C.',
    'how to grow and care for a dragon fruit plant':
        'Dragon fruit needs full sun, well-drained soil, and regular watering. Provide support for the climbing vines and fertilize monthly.',
    'when should I start planting carrots':
        'Carrots can be planted from September to December for a successful harvest in most parts of India.',
    'how to protect plants from high humidity':
        'Improve air circulation around plants and use fungicides if necessary to prevent fungal diseases caused by high humidity.',
    'ideal temperature for growing celery':
        'Celery grows best in temperatures between 15°C and 25°C.',
    'how to care for a neem tree':
        'Neem trees need full sun, well-drained soil, and occasional watering. Fertilize annually with a balanced fertilizer.',
    'best soil for growing beans':
        'Beans thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to grow and care for a pomegranate plant':
        'Pomegranate plants need full sun, well-drained soil, and regular watering. Fertilize annually and prune to maintain shape.',
    'ideal temperature for growing lettuce':
        'Lettuce grows best in temperatures between 10°C and 20°C.',
    'how to protect plants from drought':
        'Use mulch to retain soil moisture, water deeply and infrequently, and consider using drip irrigation for efficient watering.',
    'when should I start planting herbs':
        'Herbs can be planted from March to June for optimal growth in most parts of India.',
    'how to grow and care for a fig tree':
        'Fig trees need full sun, well-drained soil, and regular watering. Fertilize with a balanced fertilizer and prune annually.',
    'ideal temperature for growing asparagus':
        'Asparagus grows best in temperatures between 15°C and 25°C.',
    'how to protect plants from strong winds':
        'Use windbreaks or stakes to support plants and reduce wind damage. Mulch can also help stabilize soil around plants.',
    'when should I plant strawberries in India':
        'Strawberries can be planted from September to November for optimal growth and fruiting in India.',
    'how to care for a bamboo plant':
        'Bamboo needs full to partial sun, regular watering, and well-drained soil. Fertilize annually with a balanced fertilizer.',
    'best soil for growing sweet corn':
        'Sweet corn thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing bell peppers':
        'Bell peppers grow best in temperatures between 20°C and 30°C.',
    'how to grow and care for a pumpkin plant':
        'Pumpkin plants need full sun, well-drained soil, and regular watering. Provide space for vines to spread and fertilize every 6-8 weeks.',
    'when should I plant onions in India':
        'Onions can be planted from October to December for a successful harvest in India.',
    'how to protect plants from frost':
        'Cover plants with frost cloth or blankets, and mulch around the base to protect roots from freezing temperatures.',
    'ideal temperature for growing turmeric':
        'Turmeric grows best in temperatures between 20°C and 30°C.',
    'how to grow and care for a cauliflower plant':
        'Cauliflower needs full sun, well-drained soil, and regular watering. Fertilize with a balanced fertilizer and keep soil consistently moist.',
    'best soil for growing squash':
        'Squash thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing cilantro':
        'Cilantro grows best in temperatures between 15°C and 25°C.',
    'how to care for a dragonfruit plant':
        'Dragonfruit needs full sun, well-drained soil, and regular watering. Provide support for climbing and fertilize monthly.',
    'when should I plant sweet potatoes in India':
        'Sweet potatoes can be planted from March to June for optimal growth in India.',
    'how to grow and care for a rosemary plant':
        'Rosemary needs full sun, well-drained soil, and minimal watering. Prune regularly to promote bushy growth.',
    'ideal temperature for growing broccoli':
        'Broccoli grows best in temperatures between 15°C and 20°C.',
    'how to protect plants from fungal diseases':
        'Use fungicides if necessary, ensure proper air circulation, and avoid overhead watering to reduce fungal growth.',
    'best soil for growing herbs':
        'Herbs prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to grow and care for a strawberry plant':
        'Strawberries need full sun, well-drained soil, and regular watering. Mulch around the base and fertilize every 4-6 weeks.',
    'ideal temperature for growing chillies':
        'Chillies grow best in temperatures between 20°C and 35°C.',
    'when should I plant brussels sprouts in India':
        'Brussels sprouts can be planted from July to September for a successful harvest in India.',
    'how to protect plants from extreme heat':
        'Provide shade, use mulch to retain moisture, and water plants early in the morning or late in the evening.',
    'ideal temperature for growing leeks':
        'Leeks grow best in temperatures between 15°C and 25°C.',
    'how to care for a passion fruit plant':
        'Passion fruit needs full sun, well-drained soil, and regular watering. Provide support for the climbing vines and fertilize every 6-8 weeks.',
    'best soil for growing asparagus':
        'Asparagus prefers well-drained, sandy loam with a pH between 7.0 and 8.0.',
    'how to grow and care for a cherry tomato plant':
        'Cherry tomatoes need full sun, well-drained soil, and regular watering. Provide support and fertilize every 4-6 weeks.',
    'ideal temperature for growing mint':
        'Mint grows best in temperatures between 15°C and 25°C.',
    'when should I start planting radishes':
        'Radishes can be planted from September to March for a successful harvest in India.',
    'how to protect plants from heavy rains':
        'Ensure proper drainage, use mulch to prevent soil erosion, and consider using raised beds to protect plants from waterlogging.',
    'ideal temperature for growing lettuce':
        'Lettuce grows best in temperatures between 10°C and 20°C.',
    'how to care for a calendula plant':
        'Calendula needs full sun, well-drained soil, and regular watering. Deadhead flowers to encourage continuous blooming.',
    'best soil for growing squash':
        'Squash thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to grow and care for a tarragon plant':
        'Tarragon needs full sun, well-drained soil, and minimal watering. Prune regularly to maintain shape and promote bushy growth.',
    'ideal temperature for growing leeks':
        'Leeks grow best in temperatures between 15°C and 25°C.',
    'how to care for a peppermint plant':
        'Peppermint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist.',
    'best soil for growing peas':
        'Peas prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'ideal temperature for growing green beans':
        'Green beans grow best in temperatures between 20°C and 30°C.',
    'when should I plant garlic in India':
        'Garlic can be planted from October to December for a successful harvest in India.',
    'how to care for a sweet basil plant':
        'Sweet basil needs full sun, well-drained soil, and regular watering. Pinch off flower buds to promote leaf growth.',
    'best soil for growing coriander':
        'Coriander thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to grow and care for a tomato plant':
        'Tomatoes need full sun, well-drained soil, and regular watering. Provide support and fertilize every 4-6 weeks.',
    'ideal temperature for growing carrots':
        'Carrots grow best in temperatures between 15°C and 20°C.',
    'when should I plant lettuce in India':
        'Lettuce can be planted from September to February for a successful harvest in India.',
    'how to protect plants from frost':
        'Cover plants with frost cloth or blankets, and mulch around the base to protect roots from freezing temperatures.',
    'ideal temperature for growing spinach':
        'Spinach grows best in temperatures between 10°C and 20°C.',
    'how to care for a lemongrass plant':
        'Lemongrass needs full sun, well-drained soil, and regular watering. Fertilize every 6-8 weeks and prune to maintain shape.',
    'best soil for growing radishes':
        'Radishes prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'how to grow and care for a strawberry plant':
        'Strawberries need full sun, well-drained soil, and regular watering. Mulch around the base and fertilize every 4-6 weeks.',
    'ideal temperature for growing chillies':
        'Chillies grow best in temperatures between 20°C and 35°C.',
    'how to protect plants from extreme heat':
        'Provide shade, use mulch to retain moisture, and water plants early in the morning or late in the evening.',
    'when should I start planting coriander':
        'Coriander can be planted from September to March for optimal growth in India.',
    'how to care for a celery plant':
        'Celery needs full sun, well-drained soil, and regular watering. Fertilize every 6-8 weeks and keep soil consistently moist.',
    'best soil for growing beans':
        'Beans thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing zucchini':
        'Zucchini grows best in temperatures between 20°C and 30°C.',
    'when should I plant onions in India':
        'Onions can be planted from October to December for a successful harvest in India.',
    'how to grow and care for a brinjal plant':
        'Brinjal needs full sun, well-drained soil, and regular watering. Fertilize every 4-6 weeks and prune to promote healthy growth.',
    'ideal temperature for growing kale':
        'Kale grows best in temperatures between 15°C and 20°C.',
    'how to protect plants from strong winds':
        'Use windbreaks or stakes to support plants and reduce wind damage. Mulch can also help stabilize soil around plants.',
    'best soil for growing mint':
        'Mint thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'ideal temperature for growing peas':
        'Peas grow best in temperatures between 15°C and 25°C.',
    'when should I start planting carrots':
        'Carrots can be planted from September to February for optimal growth in India.',
    'how to grow and care for a ginger plant':
        'Ginger needs warm temperatures, well-drained soil, and regular watering. Fertilize every 6-8 weeks and provide partial shade.',
    'best soil for growing garlic':
        'Garlic thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing okra':
        'Okra grows best in temperatures between 20°C and 30°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing coriander':
        'Coriander thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a dill plant':
        'Dill needs full sun, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'ideal temperature for growing fennel':
        'Fennel grows best in temperatures between 15°C and 25°C.',
    'when should I plant carrots in India':
        'Carrots can be planted from September to February for a successful harvest in India.',
    'how to protect plants from drought':
        'Use mulch to retain soil moisture, water deeply and infrequently, and consider using drip irrigation for efficient watering.',
    'ideal temperature for growing basil':
        'Basil grows best in temperatures between 20°C and 30°C.',
    'how to care for a oregano plant':
        'Oregano needs full sun, well-drained soil, and minimal watering. Prune regularly to maintain shape and promote bushy growth.',
    'best soil for growing garlic':
        'Garlic thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing kale':
        'Kale grows best in temperatures between 15°C and 20°C.',
    'how to care for a sage plant':
        'Sage needs full sun, well-drained soil, and minimal watering. Prune regularly to maintain shape and prevent overgrowth.',
    'when should I plant potatoes in India':
        'Potatoes can be planted from October to December for a successful harvest in India.',
    'best soil for growing asparagus':
        'Asparagus prefers well-drained, sandy loam with a pH between 7.0 and 8.0.',
    'how to grow and care for a cucumber plant':
        'Cucumbers need full sun, well-drained soil, and regular watering. Provide support for vines and fertilize every 4-6 weeks.',
    'ideal temperature for growing zucchini':
        'Zucchini grows best in temperatures between 20°C and 30°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing pumpkins':
        'Pumpkins thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a lemongrass plant':
        'Lemongrass needs full sun, well-drained soil, and regular watering. Fertilize every 6-8 weeks and prune to maintain shape.',
    'ideal temperature for growing garlic':
        'Garlic grows best in temperatures between 10°C and 20°C.',
    'when should I plant beetroots in India':
        'Beetroots can be planted from September to February for a successful harvest in India.',
    'how to protect plants from fungal diseases':
        'Use fungicides if necessary, ensure proper air circulation, and avoid overhead watering to reduce fungal growth.',
    'best soil for growing peas':
        'Peas prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing corn':
        'Corn grows best in temperatures between 20°C and 30°C.',
    'how to grow and care for a lettuce plant':
        'Lettuce needs full sun, well-drained soil, and regular watering. Fertilize with a balanced fertilizer and keep soil consistently moist.',
    'best soil for growing herbs':
        'Herbs prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a ginger plant':
        'Ginger needs warm temperatures, well-drained soil, and regular watering. Fertilize every 6-8 weeks and provide partial shade.',
    'ideal temperature for growing mint':
        'Mint grows best in temperatures between 15°C and 25°C.',
    'how to protect plants from frost':
        'Cover plants with frost cloth or blankets, and mulch around the base to protect roots from freezing temperatures.',
    'best soil for growing carrots':
        'Carrots prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'how to grow and care for a bean plant':
        'Beans need full sun, well-drained soil, and regular watering. Provide support and fertilize every 4-6 weeks.',
    'ideal temperature for growing eggplants':
        'Eggplants grow best in temperatures between 20°C and 30°C.',
    'how to care for a rosemary plant':
        'Rosemary needs full sun, well-drained soil, and minimal watering. Prune regularly to promote bushy growth.',
    'best soil for growing tomatoes':
        'Tomatoes thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing lettuce':
        'Lettuce grows best in temperatures between 10°C and 20°C.',
    'how to protect plants from drought':
        'Use mulch to retain soil moisture, water deeply and infrequently, and consider using drip irrigation for efficient watering.',
    'best soil for growing herbs':
        'Herbs prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing cucumbers':
        'Cucumbers grow best in temperatures between 20°C and 30°C.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'best soil for growing garlic':
        'Garlic thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing carrots':
        'Carrots grow best in temperatures between 15°C and 20°C.',
    'how to care for a rosemary plant':
        'Rosemary needs full sun, well-drained soil, and minimal watering. Prune regularly to promote bushy growth.',
    'best soil for growing eggplants':
        'Eggplants thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing peppers':
        'Peppers grow best in temperatures between 20°C and 30°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing sweet potatoes':
        'Sweet potatoes prefer well-drained, sandy loam with a pH between 5.5 and 6.5.',
    'ideal temperature for growing peas':
        'Peas grow best in temperatures between 15°C and 25°C.',
    'how to care for a celery plant':
        'Celery needs full sun, well-drained soil, and regular watering. Fertilize every 6-8 weeks and keep soil consistently moist.',
    'best soil for growing radishes':
        'Radishes prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'ideal temperature for growing cauliflower':
        'Cauliflower grows best in temperatures between 15°C and 20°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing beans':
        'Beans thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing corn':
        'Corn grows best in temperatures between 20°C and 30°C.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'best soil for growing sweet potatoes':
        'Sweet potatoes prefer well-drained, sandy loam with a pH between 5.5 and 6.5.',
    'ideal temperature for growing peas':
        'Peas grow best in temperatures between 15°C and 25°C.',
    'how to protect plants from drought':
        'Use mulch to retain soil moisture, water deeply and infrequently, and consider using drip irrigation for efficient watering.',
    'best soil for growing tomatoes':
        'Tomatoes thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a dill plant':
        'Dill needs full sun, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'best soil for growing garlic':
        'Garlic thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing spinach':
        'Spinach grows best in temperatures between 10°C and 20°C.',
    'how to care for a lemongrass plant':
        'Lemongrass needs full sun, well-drained soil, and regular watering. Fertilize every 6-8 weeks and prune to maintain shape.',
    'best soil for growing beets':
        'Beets prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'ideal temperature for growing okra':
        'Okra grows best in temperatures between 20°C and 30°C.',
    'how to care for a celery plant':
        'Celery needs full sun, well-drained soil, and regular watering. Fertilize every 6-8 weeks and keep soil consistently moist.',
    'best soil for growing herbs':
        'Herbs prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing kale':
        'Kale grows best in temperatures between 15°C and 20°C.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'best soil for growing garlic':
        'Garlic thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing beans':
        'Beans grow best in temperatures between 20°C and 30°C.',
    'how to care for a rosemary plant':
        'Rosemary needs full sun, well-drained soil, and minimal watering. Prune regularly to promote bushy growth.',
    'best soil for growing carrots':
        'Carrots prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'ideal temperature for growing cauliflower':
        'Cauliflower grows best in temperatures between 15°C and 20°C.',
    'how to care for a ginger plant':
        'Ginger needs warm temperatures, well-drained soil, and regular watering. Fertilize every 6-8 weeks and provide partial shade.',
    'best soil for growing beets':
        'Beets prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'how to care for a lettuce plant':
        'Lettuce needs full sun, well-drained soil, and regular watering. Fertilize with a balanced fertilizer and keep soil consistently moist.',
    'best soil for growing mint':
        'Mint thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing celery':
        'Celery grows best in temperatures between 15°C and 20°C.',
    'how to care for a dill plant':
        'Dill needs full sun, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'best soil for growing lettuce':
        'Lettuce prefers well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing sweet potatoes':
        'Sweet potatoes grow best in temperatures between 20°C and 30°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing spinach':
        'Spinach prefers well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a coriander plant':
        'Coriander needs full sun, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'best soil for growing carrots':
        'Carrots prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'how to protect plants from fungal diseases':
        'Use fungicides if necessary, ensure proper air circulation, and avoid overhead watering to reduce fungal growth.',
    'ideal temperature for growing eggplants':
        'Eggplants grow best in temperatures between 20°C and 30°C.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'best soil for growing radishes':
        'Radishes prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'ideal temperature for growing lettuce':
        'Lettuce grows best in temperatures between 10°C and 20°C.',
    'how to care for a parsley plant':
        'Parsley needs full sun to partial shade, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'best soil for growing asparagus':
        'Asparagus prefers well-drained, sandy loam with a pH between 7.0 and 8.0.',
    'ideal temperature for growing beetroots':
        'Beetroots grow best in temperatures between 15°C and 20°C.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'best soil for growing garlic':
        'Garlic thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing mint':
        'Mint grows best in temperatures between 15°C and 25°C.',
    'how to care for a dill plant':
        'Dill needs full sun, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'best soil for growing lettuce':
        'Lettuce prefers well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing beans':
        'Beans grow best in temperatures between 20°C and 30°C.',
    'how to protect plants from drought':
        'Use mulch to retain soil moisture, water deeply and infrequently, and consider using drip irrigation for efficient watering.',
    'best soil for growing cucumbers':
        'Cucumbers thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing sweet potatoes':
        'Sweet potatoes grow best in temperatures between 20°C and 30°C.',
    'how to protect plants from frost':
        'Cover plants with frost cloth or blankets, and mulch around the base to protect roots from freezing temperatures.',
    'best soil for growing celery':
        'Celery thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing okra':
        'Okra grows best in temperatures between 20°C and 30°C.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'best soil for growing zucchini':
        'Zucchini thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing beets':
        'Beets grow best in temperatures between 15°C and 20°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing radishes':
        'Radishes prefer well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'ideal temperature for growing kale':
        'Kale grows best in temperatures between 15°C and 20°C.',
    'how to protect plants from strong winds':
        'Use windbreaks or stakes to support plants and reduce wind damage. Mulch can also help stabilize soil around plants.',
    'best soil for growing peppers':
        'Peppers thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a lettuce plant':
        'Lettuce needs full sun, well-drained soil, and regular watering. Fertilize with a balanced fertilizer and keep soil consistently moist.',
    'ideal temperature for growing radishes':
        'Radishes grow best in temperatures between 10°C and 20°C.',
    'best soil for growing kale':
        'Kale thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to protect plants from drought':
        'Use mulch to retain soil moisture, water deeply and infrequently, and consider using drip irrigation for efficient watering.',
    'best soil for growing okra':
        'Okra prefers well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing celery':
        'Celery grows best in temperatures between 15°C and 20°C.',
    'how to care for a mint plant':
        'Mint needs full sun to partial shade, well-drained soil, and regular watering. Keep soil consistently moist and prune regularly.',
    'best soil for growing garlic':
        'Garlic thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing lettuce':
        'Lettuce grows best in temperatures between 10°C and 20°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing sweet potatoes':
        'Sweet potatoes thrive in well-drained, sandy loam with a pH between 6.0 and 7.0.',
    'ideal temperature for growing carrots':
        'Carrots grow best in temperatures between 15°C and 20°C.',
    'how to care for a dill plant':
        'Dill needs full sun, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'best soil for growing cucumbers':
        'Cucumbers thrive in well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'ideal temperature for growing okra':
        'Okra grows best in temperatures between 20°C and 30°C.',
    'how to protect plants from pests':
        'Use organic pest control methods such as neem oil or insecticidal soap, and maintain good plant hygiene to prevent infestations.',
    'best soil for growing herbs':
        'Herbs prefer well-drained, loamy soil with a pH between 6.0 and 7.0.',
    'how to care for a dill plant':
        'Dill needs full sun, well-drained soil, and regular watering. Prune regularly to encourage bushy growth and prevent flowering.',
    'best soil for growing zucchini':
        'Zucchini thrives in well-drained, loamy soil with a pH between 6.0 and 7.0.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageWidget(message: message);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpinKitWave(
                color: Colors.blue,
                size: 30.0,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isLoading = true;
    });

    // Simulate a delay for response
    await Future.delayed(Duration(seconds: 1));

    final response = _getResponse(text);
    setState(() {
      _isLoading = false;
      _messages.add(Message(text: response, isUser: false));
      _scrollToBottom();
    });
  }

  String _getResponse(String text) {
    // Find the response based on user input
    final response = _responses.entries
        .firstWhere((entry) => text.toLowerCase().contains(entry.key),
            orElse: () => MapEntry('', 'Sorry, I don\'t understand.'))
        .value;

    return response;
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class MessageWidget extends StatelessWidget {
  final Message message;

  MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TypewriterAnimatedText(message.text),
        ),
      ),
    );
  }
}

class TypewriterAnimatedText extends StatefulWidget {
  final String text;

  TypewriterAnimatedText(this.text);

  @override
  _TypewriterAnimatedTextState createState() => _TypewriterAnimatedTextState();
}

class _TypewriterAnimatedTextState extends State<TypewriterAnimatedText> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    const duration = Duration(milliseconds: 50);

    _timer = Timer.periodic(duration, (timer) {
      if (_currentIndex >= widget.text.length) {
        timer.cancel();
      } else {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
