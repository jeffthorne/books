package ghost

ghost_image_result["allowed"] =  count(image_violations) == 0
ghost_image_result["reason"] = image_violations
ghost_image_result["package"] = "ghost"
ghost_image_result["policy"] = "ghost-vuln-policy"




image_violations[reason]{
    input.vulnerabilities[_].VulnerabilityID = "CVE-2020-1747"
    reason := sprintf("DENY: Found CVE [%s] ", ["CVE-2020-1747"])
}


