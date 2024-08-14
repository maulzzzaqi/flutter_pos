import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/authentication/auth_bloc/auth_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatelessWidget {
  static const String route = '/account';
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: GoogleFonts.rubik(
            color: const Color(0xFF1A72DD),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const CircularProgressIndicator();
              } else if (state.userData != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF1A72DD),
                          radius: 50,
                          backgroundImage: state.profileImageUrl != null && state.profileImageUrl!.isNotEmpty
                            ? NetworkImage(state.profileImageUrl!)
                            : null,
                          child: state.profileImageUrl == null || state.profileImageUrl!.isEmpty
                            ? const Icon(Icons.account_circle, size: 50, color: Colors.white)
                            : null,
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.name}',
                              style: GoogleFonts.rubik(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${state.phoneNumber}',
                              style: GoogleFonts.rubik(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${state.userData?.email}',
                              style: GoogleFonts.rubik(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Text(
                              'Account Settings',
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            contentPadding: EdgeInsets.zero,
                            shape: const Border(
                              bottom: BorderSide(color: Colors.black, width: 0.3, style: BorderStyle.solid),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/account_settings');
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Account Details',
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            contentPadding: EdgeInsets.zero,
                            shape: const Border(
                              bottom: BorderSide(color: Colors.black, width: 0.3, style: BorderStyle.solid),
                            ),
                            onTap: () {

                            },
                          ),
                          ListTile(
                            title: Text(
                              'Help',
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            contentPadding: EdgeInsets.zero,
                            shape: const Border(
                              bottom: BorderSide(color: Colors.black, width: 0.3, style: BorderStyle.solid),
                            ),
                            onTap: () {
                              
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFF4261A)
                          )
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthLogout());
                          Navigator.pushReplacementNamed(context, '/welcome');
                        },
                        child: Text(
                          'Log Out',
                          style: GoogleFonts.rubik(
                            color: const Color(0xFFF4261A),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Text(
                  'No user data available: ${state.errorMessage}'
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
