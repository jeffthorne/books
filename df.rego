package ghost_dockerfile

ghost_image_result["allowed"] =  count(image_violations) == 0
ghost_image_result["reason"] = image_violations
ghost_image_result["package"] = "ghost_dockerfile"
ghost_image_result["policy"] = "ghost-dockerfile-policy"

bad_users = [
    "root",
    "ROOT",
    "0"
]

suspicious_env_keys = [
    "passwd",
    "password",
    "secret",
    "key",
    "access",
    "api_key",
    "apikey",
    "token",
]

image_violations[reason] {
    input.nodes[i].value == "add"
    reason := sprintf("Use COPY instead of ADD, original command %s", [input.nodes[i].original])
}

image_violations[reason] {
    contains(input.nodes[i].original, bad_users[_])
    reason := sprintf("Do not use root as user, original command: %s", [input.nodes[i].original])
}

image_violations[reason] {
    input.nodes[i].value == "env"
    contains(lower(input.nodes[i].next), suspicious_env_keys[_])
    reason := sprintf("Suspicious ENV key found: %s", [input.nodes[i].original])
}