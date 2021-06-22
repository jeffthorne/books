<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    <style>
        body{
            font-family: 'Montserrat', sans-serif;
            font-size: 14px;
        }

        th {font-weight: bold;}
        td { padding-right: 20px;}
        tr.heading td { font-weight: bold;;}
        .critical {background-color: #F41806;}
        .high{background-color: #F66E0A; }
        .medium{background-color: #FBBC02;}
        .low{background-color: #24B801;}
        .info{background-color: #02AEEF;}
        .fixable{background-color: green;}
        .tile{width: 30px; color: white; border-radius: 5px; text-align: center;}
        .failed{color:red}
        .passed{color: green}
        h5{font-weight: 600}

    </style>
    <script src="https://kit.fontawesome.com/27e233ddae.js" crossorigin="anonymous"></script>
</head>
<body onload="setup()">
<div class="container">

<div class="row" style="margin-top: 75px">
<div class="col-md-12">
<div style="display: inline-block; float: right;margin-top:-20px;margin-right: -20px;">
    <img src="https://www.lacework.com/wp-content/uploads/2019/07/Lacework_Logo_color_2019.svg" width="350px" height="175px" />
</div>
<h1 style="font-size: 30px" id="target"></h1>


<table>
<tbody>
<tr><td>Type</td><td id="type"></td></tr>
<tr><td>Scan Tags:</td><td id="scanner_tags"></td></tr>
<tr><td>Scan Time:</td><td id="time"></td></tr>
<tr><td>Digest:</td><td id="digest"></td></tr>
<tr><td>Size:</td><td id="size"></td></tr>
</tbody>
</table>

</div>
</div>

<div class="row">
<div class="col-md-12">
    <div id="app"></div>
</div>
</div>


</div><!-- end container -->


<script>
    var scan_result = {{ . | toJson }}

    let setup = () => {
        document.getElementById("target").innerHTML = scan_result[0].Target;
        document.getElementById("type").innerHTML = scan_result[0].Type;
        document.getElementById("digest").innerHTML = scan_result[0].Manifest.config.digest
        document.getElementById("time").innerHTML = scan_result[0].Timer
        document.getElementById("size").innerHTML = image_size
        document.getElementById("scanner_tags").innerHTML = scan_result[0].Tags
    }

    function formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';

    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}

    layers = scan_result[0].Manifest.layers
    scan_result[0].critical_vulnerabilities = 0
    scan_result[0].fixable_vulnerabilities = 0
    scan_result[0].high_vulnerabilities = 0
    scan_result[0].medium_vulnerabilities = 0
    scan_result[0].low_vulnerabilities = 0
    scan_result[0].unknown_vulnerabilities = 0

    fixable = []

    function addToSeverity(severity, fixable, vuln){
        switch (severity) {
            case "CRITICAL":
                scan_result[0].critical_vulnerabilities++;
                break;
            case "HIGH":
                scan_result[0].high_vulnerabilities++;
                break;
            case "MEDIUM":
                scan_result[0].medium_vulnerabilities++;
                break;
            case "LOW":
                scan_result[0].low_vulnerabilities++;
                break;
            case "UNKNOWN":
                scan_result[0].unknown_vulnerabilities++;
                break;
        }

        if(fixable != "" && fixable != undefined){
            scan_result[0].fixable_vulnerabilities++
        }
    }

    let total = 0
    scan_result.forEach(sr => {
        if(sr.Vulnerabilities != null){
            sr.Vulnerabilities.forEach(vuln => {
                total++
                addToSeverity(vuln.Severity, vuln.FixedVersion, vuln)
            })
        }

    })

    scan_result[0].total_vulnerabilities = total
    let image_size = 0

    layers.forEach( layer => {
        image_size = image_size + layer.size
        scan_result.forEach( sr => {

        if(sr.Vulnerabilities != null){
            sr.Vulnerabilities.forEach( vuln => {
                if(vuln.Layer.DiffID == layer.diff_id){
                    if('packages' in layer){
                        let hit = 0
                        layer.packages.forEach(pack => {
                            if(pack.name == vuln.PkgName && pack.version == vuln.InstalledVersion){
                                if('vulnerabilities' in pack){
                                    pack.vulnerabilities.push({target: sr.Target, ...vuln})
                                }else{
                                    pack.vulnerabilities == [[{target: sr.Target,...vuln}]]
                                }
                                hit = 1
                            }
                        })

                        if(hit == 0){
                            layer.packages.push({name: vuln.PkgName, type: sr.Type, version: vuln.InstalledVersion, vulnerabilities: [{target: sr.Target, ...vuln}]})
                        }

                    }else{
                        layer.packages = [{name: vuln.PkgName, type: sr.Type, version: vuln.InstalledVersion, vulnerabilities: [{target: sr.Target, ...vuln}]}]
                    }
                }
            })
        }

        })
    })

    image_size = formatBytes(image_size)
    console.log(image_size)

    var colors = ["#F41806", "#F66E0A", "#FBBC02", "#24B801","#02AEEF"]

    //options
    var options = {
        responsive: false,
        legend: {
            display: false,
            position: "bottom",
            labels: {
                fontColor: "#333",
                fontSize: 16
            }
        }
    };


    //doughnut chart data
    var data1 = {
        labels: ["Critical", "High", "Medium", "Low", "Info"],
        datasets: [
            {
                data: [ scan_result.critical_vulnerabilities,  scan_result.high_vulnerabilities,  scan_result.medium_vulnerabilities,  scan_result.low_vulnerabilities,  scan_result.unknown_vulnerabilities ],
                backgroundColor: colors,
            }
        ]
    };



    function truncateString(str, num) {
        if (str.length <= num) {
            return str
        }
        return str.slice(0, num) + '...'
    }

    function getBackground(severity){
        switch (severity.color.toLowerCase()) {
            case "critical":
                return colors[0];
            case "high":
                return colors[1];
            case "medium":
                return colors[2];
            case "low":
                return colors[3];
            case "unknown":
                return colors[4];
            default:
                return "#fff";
        }
    }

    var test = []
</script>

<script src="https://cdn.jsdelivr.net/npm/@g3t/pumpkin@0.0.5/pumpkin.min.js"></script> 


</body>
</html>
