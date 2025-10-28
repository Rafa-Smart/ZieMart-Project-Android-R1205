<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title>Document</title>
</head>

<body>
    
    
    <div class="container">
        @include('testing.navbar')
        <div class="mt-5">
            <h1 class="text-center">users List</h1>

            <div class="table-responsive mt-3">
                @if (Session::has('message'))
                    <p style="display: block" class="alert {{ Session::get('alert-class', 'alert-info') }} p-alert">
                        {{ Session::get('message') }}</p>
                    {{-- disini kita pake js aja --}}
                    <script>
                        let pData = document.querySelector('.p-alert');

                        function tampilAlertSuccess() {
                            setTimeout((() => {
                                pData.style.display = 'none';
                            }), 2000);
                        }
                        tampilAlertSuccess();
                    </script>
                @endif
                <form action="" method="get">
                    <div class="input-group">
                        <input type="text" name="title" class="form-control mb-3" placeholder="Search..."
                            value="{{ request('name') }}">
                        <button type="submit" class="btn btn-primary mb-3">Search</button>
                    </div>
                </form>
                <table class="table table-striped table-hover table-light">
                    <thead>
                        <th style="text-align: center">No</th>
                        <th style="text-align: center">Name</th>
                        <th style="text-align: center">Action</th>
                    </thead>
                    <tbody class="table-group-divider">

                        @if ($datas->count() == 0)
                            <tr>
                                <td style="text-align: center" colspan="3" class="text-center">No data found</td>
                            </tr>
                        @endif
                        @foreach ($datas as $data)
                            <tr>
                                
                                <td style="text-align: center">{{ $data->name }}</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous">
    </script>


</body>

</html>
