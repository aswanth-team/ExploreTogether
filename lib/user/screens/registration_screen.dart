import 'package:flutter/material.dart';
import 'package:flutter_application_1/user/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}


class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? gender;
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  String? _validateEmail(String? value) {
    final emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Custom InputDecoration with rounded borders
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // Set rounded corners
      ),
      prefixIcon: Icon(icon),
    );
  }

  void signuphandle(){
                    if (_formKey.currentState!.validate()) {
                        // Form is valid
                        print("Name: ${nameController.text}");
                        print("DOB: ${dobController.text}");
                        print("Gender: $gender");
                        print("Aadhaar Number: ${aadhaarController.text}");
                        print("Mobile Number: ${mobileController.text}");
                        print("Username: ${usernameController.text}");
                        print("Email: ${emailController.text}");
                        print("Password: ${passwordController.text}");
                        print("Confirm Password: ${confirmPasswordController.text}");
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        },));
                      }
                    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/logo.jpg',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Text("Explore Together"),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Registration',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration('Name', Icons.person),
                    validator: _requiredValidator,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dobController,
                          readOnly: true,
                          decoration: _inputDecoration('Date of Birth', Icons.calendar_today),
                          onTap: () => _selectDate(context),
                          validator: _requiredValidator,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30), // Added rounded border here
                            ),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          items: ['Male', 'Female', 'Others']
                              .map((String value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue;
                            });
                          },
                          validator: (value) => value == null ? 'Gender is required' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: aadhaarController,
                    decoration: _inputDecoration('Aadhaar Number', Icons.credit_card),
                    validator: _requiredValidator,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: mobileController,
                    decoration: _inputDecoration('Mobile Number', Icons.phone),
                    validator: _requiredValidator,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: usernameController,
                    decoration: _inputDecoration('Username', Icons.account_circle),
                    validator: _requiredValidator,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Email Address', Icons.email),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isPasswordHidden,
                    decoration: _inputDecoration('Password', Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: _requiredValidator,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _isConfirmPasswordHidden,
                    decoration: _inputDecoration('Confirm Password', Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: _requiredValidator,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signuphandle,
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '*The mobile number entered should be connected to Aadhaar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}