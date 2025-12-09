{{-- resources/views/emails/help-request.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <title>Permintaan Bantuan Baru</title>
</head>
<body>
    <h2>Permintaan Bantuan Baru</h2>
    
    <p><strong>Dari:</strong> {{ $data['name'] }} ({{ $data['email'] }})</p>
    <p><strong>Subjek:</strong> {{ $data['subject'] }}</p>
    <p><strong>Tanggal:</strong> {{ now()->format('d F Y H:i') }}</p>
    
    <hr>
    
    <h3>Pesan:</h3>
    <p>{{ $data['message'] }}</p>
    
    <hr>
    
    <p style="color: #666; font-size: 12px;">
        Email ini dikirim melalui formulir bantuan aplikasi ZieMart.
    </p>
</body>
</html>