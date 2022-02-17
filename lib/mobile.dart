import 'dart:ffi';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' show get;

Future<void> saveAndLaunchFile(List<int> bytes,String fileName) async{
  final path= (await getExternalStorageDirectory())?.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes,flush: true);
  OpenFile.open('$path/$fileName');
}

PdfLayoutResult drawPDFTextElement(PdfPage page, Size pageSize,String BillTotalAmount,String BillUserName,String BillUserAddress,String BillUserContact,String invoiceNo,DateTime dateTime,Uint8List fontData,PdfBitmap image,PdfBitmap logo) {
  final PdfFont font = PdfTrueTypeFont(fontData, 12);
  //Create Header

  //Draw rectangle
  // page.graphics.drawRectangle(
  //     brush: PdfSolidBrush(PdfColor(0, 0, 0, 0)),
  //     bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
  //Draw string
  // page.graphics.drawString(
  //     'दख्खन सप्लायर्स अपशिंगे', font,
  //     brush: PdfBrushes.black,
  //     bounds: Rect.fromLTWH(25, 0, pageSize.width, 90),
  //     format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle,alignment: PdfTextAlignment.center));


  
  page.graphics.drawImage(image, Rect.fromLTWH(10, 0, pageSize.width - 120, 70));

  const String details =
  // ignore: leading_newlines_in_multiline_strings
  '''At Post Apshinge Tal Koregoan dist Satara Pin Code 415511.''';

  page.graphics.drawString(
      details, font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(25, 30, pageSize.width, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle,alignment: PdfTextAlignment.left));

  // page.graphics.drawRectangle(
  //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 300, 90),
  //     brush: PdfSolidBrush(PdfColor(0,0,0,0)));

  page.graphics.drawImage(logo, Rect.fromLTWH(380, 0, pageSize.width - 400, 90));

  page.graphics.drawLine(PdfPens.black, Offset(520, 250), Offset(0, 250));
  page.graphics.drawLine(PdfPens.black, Offset(520, 253), Offset(0, 253));
  page.graphics.drawLine(PdfPens.black, Offset(520, 93), Offset(0, 93));
  page.graphics.drawLine(PdfPens.black, Offset(520, 90), Offset(0, 90));
  page.graphics.drawLine(PdfPens.black, Offset(520, 420), Offset(0, 420));
  page.graphics.drawLine(PdfPens.black, Offset(520, 423), Offset(0, 423));

  // page.graphics.drawString(r'Rs.' + BillTotalAmount,
  //     PdfStandardFont(PdfFontFamily.helvetica, 18),
  //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
  //     brush: PdfBrushes.black,
  //     format: PdfStringFormat(
  //         alignment: PdfTextAlignment.center,
  //         lineAlignment: PdfVerticalAlignment.middle));


  // //Draw string
  // page.graphics.drawString('Amount', PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     brush: PdfBrushes.white,
  //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
  //     format: PdfStringFormat(
  //         alignment: PdfTextAlignment.center,
  //         lineAlignment: PdfVerticalAlignment.bottom));
  //Create data format and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');


  final String invoiceNumber =
      'Invoice Number: $invoiceNo\nDate: ${format.format(dateTime)}\n\nMobile No -  \n+91 8208553219\n+91 9765999189';


  String address = '''Bill To: \nName : $BillUserName,\nAddress : $BillUserAddress,\nPhone no : + 91 $BillUserContact ''';
  String Payment = '''Account Details - \nBank Name: HDFC BANK, DHANGARWADI\nBank Account no : 50100272967118\nBank IFSC code : HDFC0004850\nAccount Holder Name : Vaibhav Popat Tate\r\n\r\n''';
  // String mobile = '''Mobile No -  \n+91 8208553219\n+91 9765999189''';
  final PdfFont contentFont = font;
  final Size contentSize = contentFont.measureString(invoiceNumber);
  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
          contentSize.width + 30, pageSize.height - 120));
  //
  // const String Pay = '\r\n\r\n\r\n\r\nPay To - \nBank Name: HDFC BANK,DHANGARWADI '
  //     '\nBank Account no: 50100272967118 '
  //     '\nBank IFSC code:HDFC0004850 '
  //     '\nAccount Holder Name:Vaibhav Popat Tate\r\n\r\n';
  //
  //
  //
  PdfTextElement(text: Payment, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 500,
          pageSize.width - (contentSize.width + 60), pageSize.height - 80));

  // PdfTextElement(text: mobile, font: contentFont).draw(
  //     page: page,
  //     bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 480,
  //         contentSize.width + 30, pageSize.height - 120));
  return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 120,
          pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
}

PdfGrid getTheGrid(String BillContentName,String BillContentValue,String BillTotal,Uint8List fontData){
  final PdfFont font = PdfTrueTypeFont(fontData, 12);
  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 5);
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(248, 194, 115, 0));
  headerRow.style.textBrush = PdfBrushes.black;
  headerRow.style.font = font;
  headerRow.cells[0].value = 'Index';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Product Name';
  headerRow.cells[2].value = 'Price(Per)';
  headerRow.cells[3].value = 'Bras';
  headerRow.cells[4].value = 'Total';

  final double Price = (int.parse(BillTotal) / int.parse(BillContentValue));
  //Add rows
  addProducts('1', BillContentName, double.parse(Price.toStringAsFixed(2)), int.parse(BillContentValue), double.parse(BillTotal), grid);
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent2);
  //Set gird columns width
  grid.columns[1].width = 150;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }


  grid.style.font = font;

  return grid;
}




//Draw the invoice footer data.
void drawFooter(PdfPage page, Size pageSize) async{

  final PdfPen linePen =
  PdfPen(PdfColor(0,0,0,0), dashStyle: PdfDashStyle.solid);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100));

  const String footerContent =
  // ignore: leading_newlines_in_multiline_strings
  '''Dakhan Supplier Upsinge.\nAt Post Apshinge tal koregoan Dist Satara.,
         Phone No - 8208553219\nAny Questions? vaibhavtate002@gmail.com''';

  //Added 30 as a margin for the layout
  page.graphics.drawString(
      footerContent,PdfStandardFont(PdfFontFamily.helvetica, 14),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
}


//Create and row for the grid.
void addProducts(String productId, String productName, double price,
    int quantity, double total, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
  row.cells[2].value = price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total.toString();
}

//Draws the grid
void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result,Uint8List fontData) {
  final PdfFont font = PdfTrueTypeFont(fontData, 15);
  Rect? totalPriceCellBounds;
  Rect? quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: const Rect.fromLTWH(0,300,0,0))!;

  //Draw grand total.
  page.graphics.drawString('Grand Total : ',
      PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          300,
          result.bounds.bottom + 10,
          200,
          quantityCellBounds!.height));
  page.graphics.drawString('₹ '+getTotalAmount(grid).toString() + ' ',
      font,
      bounds: Rect.fromLTWH(
          totalPriceCellBounds!.left,
          result.bounds.bottom + 10,
          3500,
          totalPriceCellBounds!.height));


}


//Get the total amount.
double getTotalAmount(PdfGrid grid) {
  double total = 0;
  for (int i = 0; i < grid.rows.count; i++) {
    final String value =
    grid.rows[i].cells[grid.columns.count - 1].value as String;
    total += double.parse(value);
  }
  return total;
}

