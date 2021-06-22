package ghost

ghost_image_result["allowed"] =  count(image_violations) == 0
ghost_image_result["reason"] = image_violations
ghost_image_result["package"] = "ghost"
ghost_image_result["policy"] = "ghost-vuln-policy"

image_violations[reason] {
    input.critical >= 1
    reason := sprintf("DENY: critical vulnerabilities[%v] >= 1", [input.critical])
}

image_violations[reason] {
    input.high >= 5
    reason := sprintf("DENY: high vulnerabilities[%v] >= 5", [input.high])
}

contains_vuln(vulns, vuln_id){
    vulns[_] = vuln_id
}

image_violates[reason]{
    vuln_id = "CVE-2020-1747"
    vulns := input[_].Vulnerabilities[_].VulnerabilityID
    result := contains_vuln(vulns, vuln_id)
    reason := sprintf("DENY: CVE-2020-1747 found", [result])
}

image_violations[reason] {
    input.user == "root"
    reason := "DENY: image running as root"
}