package dockerfile

import future.keywords.in

# Deny using 'latest' tag
deny[msg] {
    input[i].Cmd == "from"
    val := input[i].Value
    contains(val[i], "latest")
    msg := sprintf("Line %d: Do not use 'latest' tag for base images", [i])
}

# Deny running as root
deny[msg] {
    input[i].Cmd == "user"
    val := input[i].Value
    val[j] == "root"
    msg := sprintf("Line %d: Do not run containers as root user", [i])
}

# Require USER instruction
deny[msg] {
    not has_user_instruction
    msg := "Dockerfile must contain USER instruction (don't run as root)"
}

has_user_instruction {
    input[_].Cmd == "user"
}

# Warn about COPY/ADD from current directory
warn[msg] {
    input[i].Cmd == "copy"
    val := input[i].Value
    val[j] == "."
    msg := sprintf("Line %d: Copying entire current directory - be specific about what you copy", [i])
}

# Deny ADD when COPY should be used
deny[msg] {
    input[i].Cmd == "add"
    val := input[i].Value
    not is_url(val[j])
    msg := sprintf("Line %d: Use COPY instead of ADD for files", [i])
}

is_url(str) {
    startswith(str, "http://")
}

is_url(str) {
    startswith(str, "https://")
}

# Require HEALTHCHECK
warn[msg] {
    not has_healthcheck
    msg := "Dockerfile should contain HEALTHCHECK instruction"
}

has_healthcheck {
    input[_].Cmd == "healthcheck"
}

# Deny apt-get without --no-install-recommends
deny[msg] {
    input[i].Cmd == "run"
    val := input[i].Value
    contains(val[j], "apt-get install")
    not contains(val[j], "--no-install-recommends")
    msg := sprintf("Line %d: apt-get install should use --no-install-recommends", [i])
}

# Deny missing apt-get clean
deny[msg] {
    input[i].Cmd == "run"
    val := input[i].Value
    contains(val[j], "apt-get install")
    not has_apt_clean(input)
    msg := sprintf("Line %d: apt-get install should be followed by apt-get clean", [i])
}

has_apt_clean(dockerfile) {
    dockerfile[_].Cmd == "run"
    val := dockerfile[_].Value
    contains(val[_], "apt-get clean")
}
