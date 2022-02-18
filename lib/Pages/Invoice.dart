// import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:typed_data';

import 'package:bill_creator/mobile.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  final Bill_user_name = TextEditingController();
  final Bill_user_address = TextEditingController();
  final Bill_user_Contact = TextEditingController();
  final Bill_content_value = TextEditingController();
  final invoice_no = TextEditingController();
  final Bill_Total_amount = TextEditingController();
  final Receive_amount = TextEditingController();
  String Bill_content_name = 'मुरुम';
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("दख्खन सप्लायर्स अपशिंगे"),
              actions: [
                IconButton(
                    onPressed: () {
                      if(Bill_user_name.text == '' || Bill_user_address.text == '' || Bill_user_Contact.text == ''  || Bill_content_value.text == null || invoice_no.text == null || Bill_Total_amount == null || Receive_amount.text == ''){
                        showAlertDialog(context);
                      }else{
                        _createPDF(Bill_user_name.text,Bill_user_address.text,Bill_user_Contact.text,Bill_content_name,Bill_content_value.text,invoice_no.text,Bill_Total_amount.text,_dateTime,Receive_amount.text);
                      }

                      Bill_user_name.text='';
                      Bill_user_address.text='';
                      Bill_user_Contact.text='';
                      Bill_content_value.text='';
                      invoice_no.text = '';
                      Bill_Total_amount.text ='';
                      Receive_amount.text='';
                      // Bill_content_name='';


                    },
                    icon: const Icon(Icons.contact_page))
              ],
            ),
            body: Scrollbar(
                child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: TextField(
                    controller: Bill_user_name,
                    decoration: const InputDecoration(
                        hintText: "नाव",
                        labelText: "बिल धारक नाव : (Name)",
                        labelStyle:
                            TextStyle(fontSize: 19, color: Colors.black),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: TextField(
                    controller: Bill_user_address,
                    decoration: const InputDecoration(
                        hintText: "पत्ता",
                        labelText: "बिल धारक पत्ता : (Address)",
                        labelStyle:
                            TextStyle(fontSize: 19, color: Colors.black),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: Bill_user_Contact,
                    decoration: const InputDecoration(
                        hintText: "मोबाईल नंबर",
                        labelText: "बिल धारक मोबाईल नंबर : ( Mobile No )",
                        labelStyle:
                            TextStyle(fontSize: 19, color: Colors.black),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButton(
                        value: Bill_content_name,
                        items: <String>['मुरुम', 'खडी','वाळू','माती','ग्रिट (Grit)','दगड','Crash Sand','Plaster Sand']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            // enabled: true,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down),
                        underline: const SizedBox(),
                        alignment: Alignment.center,
                        onChanged: (String? newValue) {
                          setState(() {
                            Bill_content_name = newValue!;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: Bill_content_value,
                    decoration: const InputDecoration(
                        hintText: "क्रमांक",
                        labelText: "साहित्य क्रमांक: (Quantity)",
                        labelStyle:
                            TextStyle(fontSize: 19, color: Colors.black),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: invoice_no,
                    decoration: const InputDecoration(
                        hintText: "Invoice क्रमांक",
                        labelText: "Invoice क्रमांक",
                        labelStyle:
                        TextStyle(fontSize: 19, color: Colors.black),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: Bill_Total_amount,
                    decoration: const InputDecoration(
                        hintText: "एकूण किंमत",
                        labelText: "₹ एकूण किंमत ( Total )",
                        labelStyle:
                        TextStyle(fontSize: 19, color: Colors.black),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: Receive_amount,
                    decoration: const InputDecoration(
                        hintText: "मिळालेला बॅलेन्स",
                        labelText: "₹ Received Balance",
                        labelStyle:
                        TextStyle(fontSize: 19, color: Colors.black),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 15.0, bottom: 4.0),
                   child: ElevatedButton(
                  onPressed: () {
                    showDatePicker(context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2034)
                    ).then((date) => {
                      setState(() {
                        _dateTime = date!;
                      })
                    });
                  },
                  child: Text('तारीख बदला ( Change Date )'),
                ),
                )
              ],
            ))));
  }
}


showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Warning"),
    content: Text("Please fill all required fields"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

 Future<void> _createPDF(String BillUserName ,String BillUserAddress,String BillUserContact,String BillContentName,String BillContentValue,String invoiceNo ,String BillTotalAmount,  DateTime dateTime,String Received_Balance) async{
  // Create a new PDF document.
   final PdfDocument document = PdfDocument();
   //Add page to the PDF
   final PdfPage page = document.pages.add();
   //Get page client size
   final Size pageSize = page.getClientSize();
   //Draw rectangle
   page.graphics.drawRectangle(
       bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
       pen: PdfPen(PdfColor(1, 1, 1, 1)));
   page.graphics.drawRectangle(
       bounds: Rect.fromLTWH(2, 2, pageSize.width - 4, pageSize.height -4),
       pen: PdfPen(PdfColor(1, 1, 1, 1)));

   final path= (await getExternalStorageDirectory())?.path;
   //Read font data.
   final Uint8List fontData = File('$path/Poppins.ttf').readAsBytesSync();


   //Read image data.
   final Uint8List imageData = File('$path/text_red.png').readAsBytesSync();
//Load the image using PdfBitmap.
   final PdfBitmap image = PdfBitmap(imageData);



    //Read Image
  final Uint8List logoData = File('$path/logo.png').readAsBytesSync();
   final PdfBitmap logo = PdfBitmap(logoData);



   //Draw PDF Text Element
   final PdfGrid grid = getTheGrid(BillContentName,BillContentValue,BillTotalAmount,fontData,Received_Balance);
   final PdfLayoutResult result = drawPDFTextElement(page, pageSize,BillTotalAmount,BillUserName,BillUserAddress,BillUserContact,invoiceNo,dateTime,fontData,image,logo);

   //Draw grid
   drawGrid(page, grid, result,fontData,Received_Balance);
   //Add invoice footer
   // drawFooter(page, pageSize);


   final List<int> bytes = document.save();
   //Dispose the document.
   document.dispose();
   //Save and launch the file.
   await saveAndLaunchFile(bytes, 'Invoice.pdf');

}

