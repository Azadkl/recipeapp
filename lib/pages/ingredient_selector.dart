import 'package:flutter/material.dart';

class IngredientSelector extends StatefulWidget {
  final List<Map<String, dynamic>> selectedIngredients;
  final Function(List<Map<String, dynamic>>) onIngredientsChanged;

  const IngredientSelector({
    Key? key,
    required this.selectedIngredients,
    required this.onIngredientsChanged,
  }) : super(key: key);

  @override
  State<IngredientSelector> createState() => _IngredientSelectorState();
}

class _IngredientSelectorState extends State<IngredientSelector> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? _selectedUnit; // Artık null olabilir
  String? _selectedIngredient;
  List<String> _filteredIngredients = [];
  bool _showIngredientList = false;

  // Birim seçenekleri
  final List<String> _units = [
    'gr',
    'kg',
    'ml',
    'lt',
    'adet',
    'yemek kaşığı',
    'tatlı kaşığı'
    'çay kaşığı',
    'su bardağı',
    'fincan',
    'dilim',
    'demet',
  ];

  // Örnek malzeme listesi
  final List<String> _ingredients = [
    // Sebzeler
    'Domates',
    'Salatalık',
    'Biber',
    'Patlıcan',
    'Kabak',
    'Havuç',
    'Patates',
    'Soğan',
    'Sarımsak',
    'Ispanak',
    'Marul',
    'Lahana',
    'Brokoli',
    'Karnabahar',
    'Pırasa',
    'Mantar',
    'Mısır',

    // Meyveler
    'Elma',
    'Armut',
    'Portakal',
    'Mandalina',
    'Muz',
    'Çilek',
    'Kiraz',
    'Karpuz',
    'Kavun',
    'Üzüm', 'Şeftali', 'Kayısı', 'Ananas', 'Avokado', 'Limon', 'Greyfurt',

    // Bakliyat
    'Mercimek', 'Nohut', 'Fasulye', 'Barbunya', 'Bulgur', 'Pirinç', 'Makarna',

    // Süt Ürünleri
    'Süt', 'Yoğurt', 'Peynir', 'Kaşar', 'Tereyağı', 'Kaymak', 'Krema',

    // Et Ürünleri
    'Kıyma',
    'Tavuk',
    'Dana Eti',
    'Kuzu Eti',
    'Balık',
    'Sucuk',
    'Pastırma',
    'Sosis',
    'Salam',

    // Baharatlar
    'Tuz',
    'Karabiber',
    'Kırmızı Biber',
    'Pul Biber',
    'Kimyon',
    'Nane',
    'Kekik',
    'Tarçın',
    'Zencefil', 'Zerdeçal', 'Köri', 'Sumak',

    // Yağlar
    'Zeytinyağı', 'Ayçiçek Yağı', 'Mısır Yağı', 'Tereyağı',

    // Diğer
    'Un',
    'Şeker',
    'Tuz',
    'Maya',
    'Kabartma Tozu',
    'Vanilya',
    'Kakao',
    'Bal',
    'Reçel',
    'Salça', 'Sirke', 'Limon Suyu', 'Yumurta', 'Ekmek', 'Galeta Unu',
  ];

  @override
  void initState() {
    super.initState();
    _filteredIngredients = List.from(_ingredients);
  }

  void _filterIngredients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredIngredients = List.from(_ingredients);
      } else {
        _filteredIngredients =
            _ingredients
                .where(
                  (ingredient) =>
                      ingredient.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _addIngredient({String? customName}) {
    // Eğer özel isim verilmişse onu kullan, yoksa seçili malzemeyi veya arama metnini kullan
    final String ingredientName =
        customName ?? _selectedIngredient ?? _searchController.text;

    if (ingredientName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir malzeme adı girin')),
      );
      return;
    }

    final String quantity = _quantityController.text;
    final String? unit = _selectedUnit; // Artık null olabilir

    final Map<String, dynamic> newIngredient = {
      'name': ingredientName,
      'quantity': quantity,
      'unit': unit ?? '', // Eğer null ise boş string kullan
    };

    final updatedIngredients = List<Map<String, dynamic>>.from(
      widget.selectedIngredients,
    );
    updatedIngredients.add(newIngredient);
    widget.onIngredientsChanged(updatedIngredients);

    // Formu temizle
    setState(() {
      _selectedIngredient = null;
      _quantityController.clear();
      _searchController.clear();
      _selectedUnit = null; // Birim seçimini sıfırla
      _showIngredientList = false;
    });
  }

  void _removeIngredient(int index) {
    final updatedIngredients = List<Map<String, dynamic>>.from(
      widget.selectedIngredients,
    );
    updatedIngredients.removeAt(index);
    widget.onIngredientsChanged(updatedIngredients);
  }

  @override
  Widget build(BuildContext context) {
    bool isCustomIngredient =
        _searchController.text.isNotEmpty &&
        !_ingredients.contains(_searchController.text) &&
        _selectedIngredient == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Malzeme arama ve seçme
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Malzeme Ara veya Seç',
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredIngredients = List.from(_ingredients);
                          _showIngredientList = false;
                          _selectedIngredient = null;
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
          onChanged: (value) {
            _filterIngredients(value);
            setState(() {
              _showIngredientList = value.isNotEmpty;
              if (value.isEmpty) {
                _selectedIngredient = null;
              }
            });
          },
          onTap: () {
            setState(() {
              _showIngredientList = _searchController.text.isNotEmpty;
            });
          },
        ),

        // Malzeme listesi
        if (_showIngredientList && _filteredIngredients.isNotEmpty)
          Container(
            height: 150,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: _filteredIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = _filteredIngredients[index];
                return ListTile(
                  dense: true,
                  title: Text(ingredient),
                  onTap: () {
                    setState(() {
                      _selectedIngredient = ingredient;
                      _searchController.text = ingredient;
                      _showIngredientList = false;
                    });
                  },
                );
              },
            ),
          ),

        // Malzeme bulunamadı veya özel malzeme ekleme seçeneği
        if (_showIngredientList && _filteredIngredients.isEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Malzeme bulunamadı',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '"${_searchController.text}" malzemesini listeye eklemek ister misiniz?',
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedIngredient = null;
                      _showIngredientList = false;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Özel Malzeme Olarak Ekle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

        // Seçilen malzeme bilgisi
        if (_selectedIngredient != null || isCustomIngredient)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  isCustomIngredient ? Icons.add_circle : Icons.check_circle,
                  color: isCustomIngredient ? Colors.black : Colors.black,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isCustomIngredient
                        ? 'Özel malzeme: ${_searchController.text}'
                        : 'Seçilen malzeme: $_selectedIngredient',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // Miktar ve birim seçimi
        Row(
          children: [
            // Miktar girişi
            Expanded(
              flex: 2,
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Miktar (Opsiyonel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Birim seçimi - artık opsiyonel
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String?>(
                value: _selectedUnit,
                decoration: InputDecoration(
                  labelText: 'Birim (Opsiyonel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                items: [
                  // Boş seçenek ekle
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Birim Yok'),
                  ),
                  // Diğer birimler
                  ..._units.map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Malzeme ekleme butonu
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _addIngredient(),
            icon: const Icon(Icons.add),
            label: const Text('Malzeme Ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Seçilen malzemeler listesi
        if (widget.selectedIngredients.isNotEmpty) ...[
          const Text(
            'Seçilen Malzemeler',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.selectedIngredients.length,
            itemBuilder: (context, index) {
              final ingredient = widget.selectedIngredients[index];
              final bool hasUnit = ingredient['unit'] != null && ingredient['unit'].isNotEmpty;
              final bool hasQuantity = ingredient['quantity'] != null && ingredient['quantity'].isNotEmpty;
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      _ingredients.contains(ingredient['name'])
                          ? Colors.black
                          : Colors.green,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(ingredient['name']),
                subtitle: hasQuantity || hasUnit 
                    ? Text(
                        '${hasQuantity ? ingredient['quantity'] : ''} ${hasUnit ? ingredient['unit'] : ''}',
                      )
                    : null,
                trailing: IconButton(
                  onPressed: () => _removeIngredient(index),
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
