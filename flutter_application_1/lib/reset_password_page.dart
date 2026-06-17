import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage
    extends StatefulWidget {

  const ResetPasswordPage({
    super.key,
  });

  @override
  State<ResetPasswordPage>
  createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState
    extends State<ResetPasswordPage> {

  final TextEditingController
  passwordController =
  TextEditingController();

  bool isLoading = false;

  ////////////////////////////////////////////////////////////
  /// UPDATE PASSWORD
  ////////////////////////////////////////////////////////////

  Future<void> updatePassword()
  async {

    try {

      setState(() {

        isLoading = true;
      });

      await Supabase.instance.client
          .auth
          .updateUser(

        UserAttributes(

          password:
          passwordController
              .text
              .trim(),
        ),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Password updated",
          ),
        ),
      );

      Navigator.pop(context);
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(e.toString()),
        ),
      );
    }

    finally {

      setState(() {

        isLoading = false;
      });
    }
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Reset Password",
        ),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(
            24),

        child: Column(

          children: [

            const SizedBox(
                height: 40),

            TextField(

              controller:
              passwordController,

              obscureText: true,

              decoration:
              const InputDecoration(

                hintText:
                "New Password",
              ),
            ),

            const SizedBox(
                height: 30),

            SizedBox(

              width:
              double.infinity,

              height: 55,

              child:
              ElevatedButton(

                onPressed:

                isLoading

                    ? null

                    : updatePassword,

                child:

                isLoading

                    ? const CircularProgressIndicator()

                    : const Text(
                  "Update Password",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}