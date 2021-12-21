<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    <style>
        body{ font-family: 'Montserrat', sans-serif; font-size: 14px; }
        h5{font-weight: 600}
        th {font-weight: bold;}
        td { padding-right: 20px;}
        tr.heading td { font-weight: bold;;}
        .critical {background-color: #F41806;}
        .blue {color: blue; display: inline;}
        .boldred {color: #E06C75;, font-weight: bold; display: inline;}
        .yellow{color:#FFE7CC;display: inline;}
        .fail {background-color: #FF4347;}
        .exception{background-color: #D68100;}
        .success{ background-color: #61B631;}
        .high{background-color: #F66E0A; }
        .medium{background-color: #FBBC02;}
        .low{background-color: #24B801;}
        .info{background-color: #02AEEF;}
        .fixable{background-color: green;}
        .tile{width: 30px; color: white; border-radius: 5px; text-align: center;}
        .square {width: 40px; color: white; border-radius: 1px; text-align: center;}
        .failed{color:red}
        .passed{color: green}
        .none {display: none}
        .block{display: block}
    </style>
    <script src="https://kit.fontawesome.com/27e233ddae.js" crossorigin="anonymous"></script>
</head>
<body>

<div class="container">
<div class="row">
<div class="col-md-12">
    <div id="app"></div>
</div>
</div>
</div> <!-- end container -->


<script>
    var scan_result = {{ . | toJson }}
    var logo_url = "https://awsmp-logos.s3.amazonaws.com/5b9daf89-2101-4cd3-b096-bf5bc33b6b4a/d40ea1ecf105eb00d2270bf36dced371.png"
</script>
<script src="https://cdn.jsdelivr.net/npm/@g3t/pumpkin@0.0.11/pumpkin.min.js"></script>

</body>
</html>
