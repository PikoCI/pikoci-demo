secret_type "env" {
  source = "pikoci://file"
  path   = ".env"
}

variable "github_token" {
  type = string
  secret "env" { key = "GITHUB_TOKEN" }
}

resource_type "git" {
  source = "pikoci://git"
}

resource "git" "pr" {
  params {
    url   = "https://github.com/PikoCI/pikoci-demo"
    pr    = true
    token = var.github_token
  }
}

resource "git" "main" {
  params {
    url    = "https://github.com/PikoCI/pikoci-demo"
    branch = "main"
    token  = var.github_token
  }
}

notification_type "github-check" {
  source = "pikoci://github-check"
}

notification "github-check" "pr-status" {
  params {
    token = var.github_token
    repo  = "PikoCI/pikoci-demo"
  }
  on = ["success", "failure"]
}

job "build" {
  get "git" "pr" { trigger = true }
  notify "github-check" "pr-status" { status = "in_progress" }
  task "build" {
    run "exec" {
      path = "make"
      args = ["build"]
    }
  }
  on_success {
    notify "github-check" "pr-status" { conclusion = "success" }
  }
  on_failure {
    notify "github-check" "pr-status" { conclusion = "failure" }
  }
  on_cancel {
    notify "github-check" "pr-status" { conclusion = "cancelled" }
  }
}

job "lint" {
  get "git" "pr" { trigger = true }
  notify "github-check" "pr-status" { status = "in_progress" }
  task "lint" {
    run "exec" {
      path = "make"
      args = ["lint"]
    }
  }
  on_success {
    notify "github-check" "pr-status" { conclusion = "success" }
  }
  on_failure {
    notify "github-check" "pr-status" { conclusion = "failure" }
  }
  on_cancel {
    notify "github-check" "pr-status" { conclusion = "cancelled" }
  }
}

job "test" {
  get "git" "pr" { trigger = true }
  notify "github-check" "pr-status" { status = "in_progress" }
  task "test" {
    run "exec" {
      path = "make"
      args = ["test"]
    }
  }
  on_success {
    notify "github-check" "pr-status" { conclusion = "success" }
  }
  on_failure {
    notify "github-check" "pr-status" { conclusion = "failure" }
  }
  on_cancel {
    notify "github-check" "pr-status" { conclusion = "cancelled" }
  }
}

job "checks-passed" {
  get "git" "pr" { passed = ["build", "lint", "test"] }
  notify "github-check" "pr-status" { conclusion = "success" }
}

job "deploy" {
  get "git" "main" { trigger = true }
  task "deploy" {
    run "exec" {
      path = "/bin/sh"
      args = ["-ec", "echo 'deploying to production'"]
    }
  }
}
