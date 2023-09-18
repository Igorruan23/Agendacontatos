import 'package:agendacontatos/contacts/contacts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<String> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      contacts = prefs.getStringList('contacts') ?? [];
    });
  }

  void _saveContact() async {
    String phoneNumber = phoneNumberController.text;
    String contactName = contactController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> updatedContacts = prefs.getStringList('contacts') ?? [];

    String newContact = '$contactName - $phoneNumber';
    updatedContacts.add(newContact);

    await prefs.setStringList('contacts', updatedContacts);

    phoneNumberController.clear();
    contactController.clear();

    setState(() {
      contacts = updatedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue[100], // Fundo azul claro
        appBar: AppBar(
          title: Text("Agenda App"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: TextField(
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Número de telefone, insira o DDD ex: 94",
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextField(
                  controller: contactController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Nome do contato",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _saveContact,
                child: Text("Salvar Contato"),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Salvos",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 2, // Adiciona sombreamento
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(contacts[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsDetailPage(
                              contactDetails: contacts[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}