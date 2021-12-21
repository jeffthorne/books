package ghost

ghost_image_result["allowed"] =  count(image_violations) == 0
ghost_image_result["reason"] = image_violations
ghost_image_result["package"] = "ghost"
ghost_image_result["policy"] = "ghost-vuln-policy"



image_violations[reason] {
    input.critical >= 1
    reason := sprintf("DENY: critical vulnerabilities[%v] >= 1", [input.critical])
}


image_violations[reason]{
    input.vulnerabilities[_].VulnerabilityID = "CVE-2021-44228"
    reason := sprintf("DENY: Found Log4j CVE [%s] ", ["CVE-2021-44228"])
}

image_violations[reason]{
    input.vulnerabilities[_].VulnerabilityID = "CVE-2021-45046"
    reason := sprintf("DENY: Found Log4j CVE [%s] ", ["CVE-2021-45046"])
}

image_violations[reason]{
    input.vulnerabilities[_].VulnerabilityID = "CVE-2021-45105"
    reason := sprintf("DENY: Found Log4j CVE [%s] ", ["CVE-2021-45105"])
}


image_violations[reason] {
    input.user == "root"
    reason := "DENY: image running as root"
}