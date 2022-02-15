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

PdfLayoutResult drawPDFTextElement(PdfPage page, Size pageSize,String BillTotalAmount,String BillUserName,String BillUserAddress,String BillUserContact,String invoiceNo,DateTime dateTime, PdfBitmap image) {

  //Create Header

  //Draw rectangle
  page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(246, 158, 92, 1)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
  //Draw string
  page.graphics.drawString(
      'INVOICE BILL', PdfStandardFont(PdfFontFamily.helvetica, 30),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(65, 104, 205)));

  // page.graphics.drawString(r'RS.' + BillTotalAmount,
  //     PdfStandardFont(PdfFontFamily.helvetica, 18),
  //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
  //     brush: PdfBrushes.white,
  //     format: PdfStringFormat(
  //         alignment: PdfTextAlignment.center,
  //         lineAlignment: PdfVerticalAlignment.middle));

  // Uri myUri = Uri.parse('assets/images/logo.png');
  // final Uint8List imageData = File.fromUri(myUri).readAsBytesSync();

  // String base64 = CryptoUtils.bytesToBase64(bytes);
  page.graphics.drawImage(image, Rect.fromLTWH(400, 0, pageSize.width - 400, 100));

  //Draw string
  page.graphics.drawString('Amount', PdfStandardFont(PdfFontFamily.helvetica, 9),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom));
  //Create data format and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');


  final String invoiceNumber =
      'Invoice Number: $invoiceNo\r\n\r\nDate: ${format.format(dateTime)}';


  String address = '''Bill To: \n Name : $BillUserName,\n Address : - $BillUserAddress,\n Phone no : + 91 $BillUserContact''';

  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9,style: PdfFontStyle.bold);
  final Size contentSize = contentFont.measureString(invoiceNumber);
  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
          contentSize.width + 30, pageSize.height - 120));

  return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 120,
          pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
}

PdfGrid getTheGrid(String BillContentName,String BillContentValue,String BillTotal){
  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 5);
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Index';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Product Name';
  headerRow.cells[2].value = 'Price';
  headerRow.cells[3].value = 'Quantity';
  headerRow.cells[4].value = 'Total';

  final double Price = (int.parse(BillTotal) / int.parse(BillContentValue));
  //Add rows
  addProducts('1', BillContentName, Price, int.parse(BillContentValue), double.parse(BillTotal), grid);
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[1].width = 200;
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
  return grid;
}




//Draw the invoice footer data.
void drawFooter(PdfPage page, Size pageSize) async{

  final PdfPen linePen =
  PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100));

  const String footerContent =
  // ignore: leading_newlines_in_multiline_strings
  '''Dakhan Supplier Upsinge.\r\n\r\nAt Post Apshinge tal koregoan Dist Satara.,
         Phone No - 8208553219\r\n\r\nAny Questions? support@adventure-works.com''';

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
void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
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
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

  //Draw grand total.
  page.graphics.drawString('Grand Total',
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          quantityCellBounds!.left,
          result.bounds.bottom + 10,
          quantityCellBounds!.width,
          quantityCellBounds!.height));
  page.graphics.drawString(getTotalAmount(grid).toString(),
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          totalPriceCellBounds!.left,
          result.bounds.bottom + 10,
          totalPriceCellBounds!.width,
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

// Future<Uint8List> _readFileByte(String filePath) async {
//   Uri myUri = Uri.parse(filePath);
//   File audioFile = new File.fromUri(myUri);
//   Uint8List bytes ;
//   await audioFile.readAsBytes().then((value) {
//     bytes = Uint8List.fromList(value);
//     print('reading of bytes is completed');
//   }).catchError((onError) {
//     print('Exception Error while reading audio from path:' +
//         onError.toString());
//   });
//   return bytes;
// }


//get the imgae

Future<Uint8List> getTheImage() async{
  var url =
      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg";
  var response = await get(Uri.parse(url));
  var data = response.bodyBytes;


  return data;
}