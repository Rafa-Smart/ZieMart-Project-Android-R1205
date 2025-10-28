<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Kirim Email</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-5">

<div class="container">
    <div class="col-md-6 offset-md-3">
        <div class="card shadow-sm rounded-3">
            <div class="card-body">
                <h3 class="text-center mb-4">Kirim Email Laravel</h3>

                @if(session('success'))
                    <div class="alert alert-success">{{ session('success') }}</div>
                @endif

                <form action="{{ route('email.send') }}" method="POST">
                    @csrf
                    <div class="mb-3">
                        <label for="email" class="form-label">Alamat Email Tujuan</label>
                        <input type="email" name="email" id="email" class="form-control"
                               placeholder="contoh@gmail.com" required>
                        @error('email')
                            <small class="text-danger">{{ $message }}</small>
                        @enderror
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Kirim Email</button>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
