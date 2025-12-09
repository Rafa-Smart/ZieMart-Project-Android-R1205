import 'dart:io';
import 'package:excel/excel.dart' as excel_lib;
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as excel_lib show NumberFormat;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/order_model.dart';

class ExportService {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final _simpleDateFormat = DateFormat('dd MMM yyyy');

  // Check storage permission
  static Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        // Request again
        await Permission.storage.request();
      }
      return status.isGranted || status.isLimited;
    }
    return true;
  }

  // Get download directory
  static Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return Directory("/storage/emulated/0/Download");
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return await getDownloadsDirectory() ?? Directory.current;
    }
    return Directory.current;
  }

  // Export to Excel (XLSX)
  static Future<File?> exportToExcel(List<Order> orders, String fileName) async {
    try {
      await _checkPermission();
      
      final excel = excel_lib.Excel.createExcel();
      final sheet = excel['Pesanan'];

      // Styling for headers
      final headerStyle = excel_lib.CellStyle(
        backgroundColorHex: "#2F5DFE",
        fontColorHex: "#FFFFFF",
        bold: true,
        fontSize: 12,
        horizontalAlign: excel_lib.HorizontalAlign.Center,
        verticalAlign: excel_lib.VerticalAlign.Center,
      );

      // Styling for cells
      final cellStyle = excel_lib.CellStyle(
        fontSize: 11,
        horizontalAlign: excel_lib.HorizontalAlign.Left,
        verticalAlign: excel_lib.VerticalAlign.Center,
      );

      // Headers
      final headers = [
        'No',
        'Order ID',
        'Tanggal Pesan',
        'Nama Produk',
        'Kategori',
        'Jumlah',
        'Harga Satuan',
        'Total Harga',
        'Status',
        'Nama Pembeli',
        'Email',
        'No. Telepon',
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(excel_lib.CellIndex.indexByString('${String.fromCharCode(65 + i)}1'));
        cell.value = headers[i];
        cell.cellStyle = headerStyle;
      }

      // Data rows
      for (var i = 0; i < orders.length; i++) {
        final order = orders[i];
        final product = order.product;
        final account = order.account;

        final row = i + 2; // Start from row 2 (row 1 is header)
        
        final data = [
          i + 1,
          '#${order.id}',
          _formatExcelDate(order.orderDate),
          product?.productName ?? '-',
          product?.category?.categoryName ?? '-',
          order.quantity,
          product?.price ?? 0,
          order.totalPrice,
          order.statusText,
          account?.username ?? '-',
          account?.email ?? '-',
          account?.phoneNumber ?? '-',
        ];

        for (int j = 0; j < data.length; j++) {
          final cell = sheet.cell(excel_lib.CellIndex.indexByString('${String.fromCharCode(65 + j)}$row'));
          cell.value = data[j];
          cell.cellStyle = cellStyle;
        }

        // Format currency cells
        final priceCell = sheet.cell(excel_lib.CellIndex.indexByString('G$row'));
        final totalCell = sheet.cell(excel_lib.CellIndex.indexByString('H$row'));
        
        final currencyStyle = excel_lib.CellStyle(
          fontSize: 11,
          horizontalAlign: excel_lib.HorizontalAlign.Right,
        );
        
        priceCell.cellStyle = currencyStyle;
        totalCell.cellStyle = currencyStyle;
      }

      // Auto size columns
      for (int i = 0; i < headers.length; i++) {
        sheet.setColAutoFit(i);
      }

      // Add summary row
      final summaryRow = orders.length + 3;
      final totalCell = sheet.cell(excel_lib.CellIndex.indexByString('G$summaryRow'));
      totalCell.value = 'Total Revenue:';
      
      final totalValueCell = sheet.cell(excel_lib.CellIndex.indexByString('H$summaryRow'));
      sheet.cell(excel_lib.CellIndex.indexByString('H$summaryRow'));
      final totalRevenue = orders.fold(0.0, (sum, order) => sum + order.totalPrice);
      totalValueCell.value = totalRevenue;
      totalValueCell.cellStyle = excel_lib.CellStyle(
        backgroundColorHex: "#E3F2FD",
        bold: true,
        fontSize: 12,
        horizontalAlign: excel_lib.HorizontalAlign.Right,
      );
      // Save file
      final directory = await getDownloadDirectory();
      final filePath = '${directory.path}/$fileName.xlsx';
      final file = File(filePath);
      
      final bytes = excel.save();
      if (bytes != null) {
        await file.writeAsBytes(bytes);
        print('✅ File Excel berhasil disimpan di: $filePath');
        return file;
      }
      
      return null;
    } catch (e) {
      print('❌ Error export to Excel: $e');
      return null;
    }
  }

  // Format date for Excel
  static String _formatExcelDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return _dateFormat.format(date);
    } catch (e) {
      return dateStr;
    }
  }

  // Export to PDF
  static Future<File?> exportToPDF(List<Order> orders, String fileName) async {
    try {
      await _checkPermission();

      final pdf = pw.Document();

      // Add main page
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return [
              // Header
              _buildPDFHeader(orders),
              pw.SizedBox(height: 20),
              
              // Summary
              _buildPDFSummary(orders),
              pw.SizedBox(height: 20),
              
              // Table
              _buildPDFTable(orders),
              pw.SizedBox(height: 30),
              
              // Footer
              _buildPDFFooter(),
            ];
          },
        ),
      );

      // Save file
      final directory = await getDownloadDirectory();
      final filePath = '${directory.path}/$fileName.pdf';
      final file = File(filePath);
      
      await file.writeAsBytes(await pdf.save());
      print('✅ File PDF berhasil disimpan di: $filePath');
      return file;
    } catch (e) {
      print('❌ Error export to PDF: $e');
      return null;
    }
  }

  static pw.Widget _buildPDFHeader(List<Order> orders) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LAPORAN PESANAN',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue700,
                  ),
                ),
                pw.Text(
                  'ZieMart - Toko Online',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.Container(
              width: 60,
              height: 60,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                color: PdfColors.blue700,
              ),
              child: pw.Center(
                child: pw.Text(
                  'ZM',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue200),
      ],
    );
  }

  static pw.Widget _buildPDFSummary(List<Order> orders) {
    final totalRevenue = orders.fold(0.0, (sum, order) => sum + order.totalPrice);
    final pending = orders.where((o) => o.status == 'pending').length;
    final processing = orders.where((o) => o.status == 'processing').length;
    final shipped = orders.where((o) => o.status == 'shipped').length;
    final delivered = orders.where((o) => o.status == 'delivered').length;

    return pw.Container(
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.blue200, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Ringkasan Laporan',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Total Pesanan', '${orders.length}'),
              _buildStatItem('Total Revenue', _currencyFormat.format(totalRevenue)),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Menunggu', '$pending'),
              _buildStatItem('Diproses', '$processing'),
              _buildStatItem('Dikirim', '$shipped'),
              _buildStatItem('Selesai', '$delivered'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey600,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPDFTable(List<Order> orders) {
    return pw.TableHelper.fromTextArray(
      context: null,
      border: pw.TableBorder.all(
        color: PdfColors.grey300,
        width: 0.5,
      ),
      headers: [
        'No',
        'Order ID',
        'Tanggal',
        'Produk',
        'Jumlah',
        'Total',
        'Status',
      ],
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 10,
        color: PdfColors.white,
      ),
      headerDecoration: pw.BoxDecoration(
        color: PdfColors.blue700,
      ),
      cellStyle: pw.TextStyle(fontSize: 9),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.center,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.center,
      },
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey200,
            width: 0.5,
          ),
        ),
      ),
      data: List<List<dynamic>>.generate(
        orders.length,
        (index) {
          final order = orders[index];
          final product = order.product;
          return [
            index + 1,
            '#${order.id}',
            _formatTableDate(order.orderDate),
            product?.productName ?? '-',
            order.quantity,
            _currencyFormat.format(order.totalPrice),
            order.statusText,
          ];
        },
      ),
    );
  }

  static String _formatTableDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return _simpleDateFormat.format(date);
    } catch (e) {
      return dateStr;
    }
  }

  static pw.Widget _buildPDFFooter() {
    return pw.Container(
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Dibuat oleh: ZieMart App',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
              pw.Text(
                'Tanggal cetak: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
              ),
            ],
          ),
          pw.Text(
            'Halaman 1',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  // Export to Word/DOCX
  static Future<File?> exportToWord(List<Order> orders, String fileName) async {
    try {
      await _checkPermission();
      
      // For DOCX, we'll create HTML and convert to DOCX
      // Note: Creating actual DOCX is complex, we'll create HTML that can be opened in Word
      
      final htmlContent = _generateHTMLContent(orders);
      
      final directory = await getDownloadDirectory();
      final filePath = '${directory.path}/$fileName.html'; // Save as HTML
      final file = File(filePath);
      
      await file.writeAsString(htmlContent);
      print('✅ File HTML/Word berhasil disimpan di: $filePath');
      return file;
    } catch (e) {
      print('❌ Error export to Word: $e');
      return null;
    }
  }

  static String _generateHTMLContent(List<Order> orders) {
    final totalRevenue = orders.fold(0.0, (sum, order) => sum + order.totalPrice);
    final now = DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now());

    final html = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Pesanan - ZieMart</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 3px solid #2F5DFE;
            padding-bottom: 20px;
        }
        .company-name {
            color: #2F5DFE;
            font-size: 28px;
            font-weight: bold;
            margin: 0;
        }
        .report-title {
            font-size: 22px;
            margin: 10px 0;
        }
        .date-info {
            color: #666;
            font-size: 14px;
        }
        .summary {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .summary-title {
            color: #2F5DFE;
            font-size: 18px;
            margin-bottom: 15px;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .stat-item {
            background: white;
            padding: 15px;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #2F5DFE;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        th {
            background-color: #2F5DFE;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: bold;
        }
        td {
            padding: 10px 12px;
            border-bottom: 1px solid #dee2e6;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .status-pending { color: #ff9800; font-weight: bold; }
        .status-processing { color: #2196f3; font-weight: bold; }
        .status-shipped { color: #9c27b0; font-weight: bold; }
        .status-delivered { color: #4caf50; font-weight: bold; }
        .status-cancelled { color: #f44336; font-weight: bold; }
        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
            text-align: center;
            color: #666;
            font-size: 12px;
        }
        .currency {
            text-align: right;
            font-family: 'Courier New', monospace;
        }
        .total-row {
            background-color: #e3f2fd !important;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1 class="company-name">ZieMart</h1>
        <h2 class="report-title">Laporan Pesanan Pelanggan</h2>
        <div class="date-info">
            <p>Tanggal Cetak: $now</p>
            <p>Jumlah Pesanan: ${orders.length} transaksi</p>
        </div>
    </div>

    <div class="summary">
        <h3 class="summary-title">Ringkasan</h3>
        <div class="stats">
            <div class="stat-item">
                <div class="stat-label">Total Pesanan</div>
                <div class="stat-value">${orders.length}</div>
            </div>
            <div class="stat-item">
                <div class="stat-label">Total Revenue</div>
                <div class="stat-value">${_currencyFormat.format(totalRevenue)}</div>
            </div>
            <div class="stat-item">
                <div class="stat-label">Pesanan Menunggu</div>
                <div class="stat-value">${orders.where((o) => o.status == 'pending').length}</div>
            </div>
            <div class="stat-item">
                <div class="stat-label">Pesanan Selesai</div>
                <div class="stat-value">${orders.where((o) => o.status == 'delivered').length}</div>
            </div>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>No</th>
                <th>Order ID</th>
                <th>Tanggal</th>
                <th>Produk</th>
                <th>Kategori</th>
                <th>Jumlah</th>
                <th>Harga Satuan</th>
                <th>Total</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            ${orders.asMap().entries.map((entry) {
                final index = entry.key;
                final order = entry.value;
                final product = order.product;
                return '''
                <tr>
                    <td>${index + 1}</td>
                    <td>#${order.id}</td>
                    <td>${_formatTableDate(order.orderDate)}</td>
                    <td>${product?.productName ?? '-'}</td>
                    <td>${product?.category?.categoryName ?? '-'}</td>
                    <td>${order.quantity}</td>
                    <td class="currency">${_currencyFormat.format(product?.price ?? 0)}</td>
                    <td class="currency">${_currencyFormat.format(order.totalPrice)}</td>
                    <td class="status-${order.status}">${order.statusText}</td>
                </tr>
                ''';
            }).join('')}
            <tr class="total-row">
                <td colspan="7"><strong>GRAND TOTAL</strong></td>
                <td class="currency"><strong>${_currencyFormat.format(totalRevenue)}</strong></td>
                <td></td>
            </tr>
        </tbody>
    </table>

    <div class="footer">
        <p>© ${DateTime.now().year} ZieMart - Toko Online. Laporan ini dibuat secara otomatis.</p>
        <p>Dokumen ini bersifat rahasia dan hanya untuk penggunaan internal.</p>
    </div>
</body>
</html>
''';

    return html;
  }

  // Open file with appropriate app
// Open file
static Future<void> openFile(File file) async {
  try {
    if (!await file.exists()) {
      print('❌ File tidak ditemukan: ${file.path}');
      return;
    }
    
    print('📂 Membuka file: ${file.path}');
    
    // Simple open file
    final result = await OpenFile.open(file.path);
    
    if (result.type != ResultType.done) {
      print('⚠️ Gagal membuka file: ${result.message}');
      
      // Fallback: copy file ke external storage
      await _copyToDownloads(file);
    }
  } catch (e) {
    print('❌ Error opening file: $e');
  }
}

static Future<void> _copyToDownloads(File file) async {
  try {
    final directory = await getDownloadDirectory();
    final newPath = '${directory.path}/${file.uri.pathSegments.last}';
    final newFile = File(newPath);
    
    await file.copy(newPath);
    print('✅ File disalin ke: $newPath');
    
    await OpenFile.open(newPath);
  } catch (e) {
    print('❌ Error copying file: $e');
  }
}

  // Share file
  static Future<void> shareFile(BuildContext context, File file) async {
    try {
      // You can use share_plus package for better sharing
      // For now, we'll just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File berhasil dibuat: ${file.path}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error sharing file: $e');
    }
  }
}