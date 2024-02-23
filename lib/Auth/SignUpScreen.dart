import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/Auth/LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final Form_key = GlobalKey<FormState>();
  var password = false, con_password = true;
  bool passwordVisible = false;
  bool con_passwordVisible = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isLoading = false;
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();

  Future<bool>doesRegisterExist(String email) async{

    final querySnapshot = await FirebaseFirestore.instance.collection("User")
        .where("email",isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: Form_key,
            child: Container(
              margin: const EdgeInsets.only(top: 100, left: 20,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Welcome to ShopperStore",style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  ),
                  const Text("Let's Login into ShopperStore",style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: usernameController,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please enter your name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Your Username",
                        label: const Text("Username"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(30),)
                          ),
                        prefixIcon: const Icon(Icons.account_box_rounded),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        } else if (!value.contains("@") || !value.contains(".")) {
                          return "Please enter valid email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          label: const Text("Email"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(30),)
                          ),
                          prefixIcon: const Icon(Icons.email_outlined)),
                    ),
                  ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Password";
                          }
                          return null;
                        },
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          label: const Text("Password"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(30),)
                            ),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Mobile Number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Please Enter Your Mobile No.",
                        label: const Text("Mobile No."),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(30),)
                          ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () async{
                        if(Form_key.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                                .then((value) {
                                  FirebaseFirestore.instance.collection("User").doc(value.user!.uid)
                                      .set({
                                    "Name": usernameController.text,
                                    "Email": emailController.text,
                                    "Password": passwordController.text,
                                    "Mobile": mobileController.text,
                                    "UID": FirebaseAuth.instance.currentUser!.uid,
                                    "DocumentID": value.user!.uid,
                                    "Address": '',

                                  });
                            });
                            setState(() {
                              usernameController.clear();
                              emailController.clear();
                              passwordController.clear();
                              mobileController.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered Successfully")));
                          }
                          on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Password is too weak"),
                                  ));
                            }
                            else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Email is already Registered"),
                                  ));
                            }
                          }
                        }
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[600],
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70),
                          ),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, color: Colors.black),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an Account?"),
                      const SizedBox(height: 10,),
                      TextButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      }, child: const Text("Login",style: TextStyle(color: Colors.lightGreen),))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
