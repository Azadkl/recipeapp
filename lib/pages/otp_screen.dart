import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  
  const OtpScreen({
    super.key, 
    this.email = "user@example.com", // Default value for demonstration
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for each digit
  final TextEditingController _firstDigitController = TextEditingController();
  final TextEditingController _secondDigitController = TextEditingController();
  final TextEditingController _thirdDigitController = TextEditingController();
  final TextEditingController _fourthDigitController = TextEditingController();
  
  // Focus nodes for each digit
  final FocusNode _firstDigitFocusNode = FocusNode();
  final FocusNode _secondDigitFocusNode = FocusNode();
  final FocusNode _thirdDigitFocusNode = FocusNode();
  final FocusNode _fourthDigitFocusNode = FocusNode();
  
  // Timer for resend functionality
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _isResendEnabled = false;
  bool _isVerifying = false;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  @override
  void dispose() {
    _firstDigitController.dispose();
    _secondDigitController.dispose();
    _thirdDigitController.dispose();
    _fourthDigitController.dispose();
    
    _firstDigitFocusNode.dispose();
    _secondDigitFocusNode.dispose();
    _thirdDigitFocusNode.dispose();
    _fourthDigitFocusNode.dispose();
    
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isResendEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }
  
  void _resendCode() {
    if (!_isResendEnabled) return;
    
    // Here you would implement the actual code resending logic
    setState(() {
      _isResendEnabled = false;
      _remainingSeconds = 60;
    });
    
    _startTimer();
    
    // Show a snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Doğrulama kodu tekrar gönderildi.'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isVerifying = true;
      });
      
      // Combine the digits to get the complete OTP
      final otp = _firstDigitController.text + 
                 _secondDigitController.text + 
                 _thirdDigitController.text + 
                 _fourthDigitController.text;
      
      // Here you would implement the actual verification logic
      // For demonstration, we'll just simulate a delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isVerifying = false;
        });
        
        // Show success message and navigate to next screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doğrulama başarılı!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to the next screen
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NextScreen()));
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),
                
                // Email icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                const SizedBox(height: 24.0),
                
                // Title
                const Text(
                  "Emailinizi kontrol ediniz!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12.0),
                
                // Subtitle
                Text(
                  "Kodu ${widget.email} adresine gönderdik.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48.0),
                
                // OTP Input Fields
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDigitBox(
                        controller: _firstDigitController,
                        focusNode: _firstDigitFocusNode,
                        nextFocusNode: _secondDigitFocusNode,
                      ),
                      _buildDigitBox(
                        controller: _secondDigitController,
                        focusNode: _secondDigitFocusNode,
                        nextFocusNode: _thirdDigitFocusNode,
                        previousFocusNode: _firstDigitFocusNode,
                      ),
                      _buildDigitBox(
                        controller: _thirdDigitController,
                        focusNode: _thirdDigitFocusNode,
                        nextFocusNode: _fourthDigitFocusNode,
                        previousFocusNode: _secondDigitFocusNode,
                      ),
                      _buildDigitBox(
                        controller: _fourthDigitController,
                        focusNode: _fourthDigitFocusNode,
                        isLastDigit: true,
                        previousFocusNode: _thirdDigitFocusNode,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32.0),
                
                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Doğrula',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 24.0),
                
                // Resend Code
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kod almadınız mı?',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: _isResendEnabled ? _resendCode : null,
                      child: Text(
                        _isResendEnabled
                            ? 'Tekrar Gönder'
                            : 'Tekrar Gönder ($_remainingSeconds)',
                        style: TextStyle(
                          color: _isResendEnabled
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDigitBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    FocusNode? previousFocusNode,
    bool isLastDigit = false,
  }) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: focusNode == _firstDigitFocusNode,
        textInputAction: isLastDigit ? TextInputAction.done : TextInputAction.next,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            nextFocusNode.requestFocus();
          } else if (value.isEmpty && previousFocusNode != null) {
            previousFocusNode.requestFocus();
          }
          
          if (isLastDigit && value.isNotEmpty) {
            // Auto-verify when all digits are filled
            Future.delayed(const Duration(milliseconds: 100), () {
              if (_firstDigitController.text.isNotEmpty &&
                  _secondDigitController.text.isNotEmpty &&
                  _thirdDigitController.text.isNotEmpty &&
                  _fourthDigitController.text.isNotEmpty) {
                _verifyOtp();
              }
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }
}
