package lacework


    # currently helios expects these results objects to take these names and format.
    # will become more flexible in the future
    helios_image_result["allowed"] =  count(image_violations) == 0
    helios_image_result["reason"] = image_violations


    helios_bypass_result["bypass"] =  count(bypass_found) > 0
    helios_bypass_result["reason"] = bypass_found


    helios_exec_result["allow"] = false
    helios_exec_result["reason"] = "DENY: pod exec prohibited"

    # Helios IA violation rule
    # Will fail on any high/critical vulnerabilities found and fixible vulns found > 5.
    image_violations[reason]{
        to_number(input.medium_vulnerabilities) != 0
        reason := sprintf("DENY: medium vulnerabilities[%v] > 0", [input.medium_vulnerabilities])
    }

    image_violations[reason]{
        to_number(input.critical_vulnerabilities) != 0
        reason := sprintf("DENY: critical vulnerabilities[%v] > 0", [input.high_vulnerabilities])
    }

    image_violations[reason]{
        to_number(input.fixable_vulnerabilities) > 5
        reason := sprintf("DENY: fixable vulnerabilities[%v] > 5", [input.fixable_vulnerabilities])
    }


     image_violations[reason]{
        not input.securityContext.seccompProfile
        reason := "DENY: seccomp profile not found"
    }

    # Helios bypass criteria rules
    bypass_found[reason]{
        bypass_namespaces := ["default", "kube-system", "kube-public"]
        namespace_found := [ x | x := bypass_namespaces[_]; input.namespace == x]
        count(namespace_found) > 0
        reason := sprintf("ALLOW: bypass namespace [%v] found", [input.namespace])
    }


    bypass_found[reason]{
        bypass_images := ["opa"]
        image_found = [ x | x := bypass_images[_]; startswith(input.image_name, x)]
        count(image_found) > 0
        reason := sprintf("ALLOW: bypass image [%v] found", [input.image_name])
    }

