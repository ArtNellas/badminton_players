import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/save_player.dart';
import '../widgets/cancel.dart';

class AddNewPlayerScreen extends StatefulWidget {
  const AddNewPlayerScreen({super.key});

  @override
  State<AddNewPlayerScreen> createState() => _AddNewPlayerScreenState();
}

class _AddNewPlayerScreenState extends State<AddNewPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for form fields
  final _nicknameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarksController = TextEditingController();
  
  // Skill level slider values
  RangeValues _skillLevelRange = const RangeValues(0, 6); // Default: Beginner Weak to Intermediate Weak
  
  // Skill level mapping
  final List<String> _skillLevels = [
    'Beginner', 'Beginner', 'Beginner',        // 0, 1, 2
    'Intermediate', 'Intermediate', 'Intermediate', // 3, 4, 5
    'Level G', 'Level G', 'Level G',           // 6, 7, 8
    'Level F', 'Level F', 'Level F',           // 9, 10, 11
    'Level E', 'Level E', 'Level E',           // 12, 13, 14
    'Level D', 'Level D', 'Level D',           // 15, 16, 17
    'Open Player', 'Open Player', 'Open Player' // 18, 19, 20
  ];
  
  final List<String> _skillSubLevels = [
    'Weak', 'Mid', 'Strong',    // Beginner
    'Weak', 'Mid', 'Strong',    // Intermediate
    'Weak', 'Mid', 'Strong',    // Level G
    'Weak', 'Mid', 'Strong',    // Level F
    'Weak', 'Mid', 'Strong',    // Level E
    'Weak', 'Mid', 'Strong',    // Level D
    'Weak', 'Mid', 'Strong'     // Open Player
  ];

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _nicknameController.dispose();
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Phone number validation for Philippine format
  bool _isValidPhoneNumber(String phone) {
    // Remove all spaces, dashes, and parentheses
    String cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check for 09xxxxxxxxx format (11 digits total)
    if (cleanPhone.startsWith('09')) {
      return cleanPhone.length == 11 && RegExp(r'^09\d{9}$').hasMatch(cleanPhone);
    }
    
    // Check for +63xxxxxxxxxx format (13 characters total)
    if (cleanPhone.startsWith('+63')) {
      return cleanPhone.length == 13 && RegExp(r'^\+63\d{10}$').hasMatch(cleanPhone);
    }
    
    return false;
  }
  
  // Get skill level description
  String _getSkillLevelText(double value) {
    int index = value.round();
    if (index >= 0 && index < _skillLevels.length) {
      return '${_skillLevels[index]} (${_skillSubLevels[index]})';
    }
    return 'Unknown';
  }
  
  // Get range description
  String _getSkillRangeText() {
    String minLevel = _getSkillLevelText(_skillLevelRange.start);
    String maxLevel = _getSkillLevelText(_skillLevelRange.end);
    
    if (_skillLevelRange.start == _skillLevelRange.end) {
      return minLevel;
    }
    return '$minLevel → $maxLevel';
  }

  // Helper method to build level indicator
  Widget _buildLevelIndicator(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Helper method to build sub-level dots
  Widget _buildSubLevelDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }

  // Helper method to build legend items
  Widget _buildLegendItem(String dot, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dot,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Player'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nickname Field
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'Enter player nickname',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a nickname';
                  }
                  if (value.trim().length < 2) {
                    return 'Nickname must be at least 2 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              
              const SizedBox(height: 16),
              
              // Full Name Field
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter player full name',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the full name';
                  }
                  if (value.trim().length < 3) {
                    return 'Full name must be at least 3 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              
              const SizedBox(height: 16),
              
              // Contact Number Field
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  hintText: '09xxxxxxxxx or +63xxxxxxxxxx',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\+]')),
                  LengthLimitingTextInputFormatter(13), // Max length for +63xxxxxxxxxx
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a contact number';
                  }
                  if (!_isValidPhoneNumber(value.trim())) {
                    return 'Please enter a valid Philippine phone number (09xxxxxxxxx or +63xxxxxxxxxx)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!_isValidEmail(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Skill Level Slider Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.sports_tennis,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Skill Level Range',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select the player\'s skill level range (from minimum to maximum)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Current selection display
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getSkillRangeText(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Range Slider
                      RangeSlider(
                        values: _skillLevelRange,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        labels: RangeLabels(
                          _getSkillLevelText(_skillLevelRange.start),
                          _getSkillLevelText(_skillLevelRange.end),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _skillLevelRange = values;
                          });
                        },
                      ),
                      
                      // Level indicators
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLevelIndicator('Beginner'),
                            _buildLevelIndicator('Intermediate'),
                            _buildLevelIndicator('Level G'),
                            _buildLevelIndicator('Level F'),
                            _buildLevelIndicator('Level E'),
                            _buildLevelIndicator('Level D'),
                            _buildLevelIndicator('Open'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Sub-level indicators (Weak, Mid, Strong)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (levelIndex) {
                            return Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildSubLevelDot(),
                                  _buildSubLevelDot(),
                                  _buildSubLevelDot(),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('●', 'Weak'),
                          const SizedBox(width: 16),
                          _buildLegendItem('●', 'Mid'),
                          const SizedBox(width: 16),
                          _buildLegendItem('●', 'Strong'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Address Field (Multiline)
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter complete address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an address';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a complete address';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              
              const SizedBox(height: 16),
              
              // Remarks Field (Multiline, Optional)
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks (Optional)',
                  hintText: 'Any additional notes about the player',
                  prefixIcon: Icon(Icons.note_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
              
              const SizedBox(height: 32),
              
              // Save Button
              SavePlayerButton(
                formKey: _formKey,
                nicknameController: _nicknameController,
                fullNameController: _fullNameController,
                contactNumberController: _contactNumberController,
                emailController: _emailController,
                addressController: _addressController,
                remarksController: _remarksController,
                skillLevelRange: _skillLevelRange,
              ),
              
              const SizedBox(height: 16),
              
              // Cancel Button
              const CancelButton(),
            ],
          ),
        ),
      ),
    );
  }
}
