# Persistent ssh-agent across terminals, so git/GitHub access doesn't need a
# fresh `ssh-add` every shell.
SSH_ENV="$HOME/.ssh/agent.env"

start_ssh_agent() {
    (umask 077; ssh-agent -s > "$SSH_ENV")
    source "$SSH_ENV" >/dev/null

    # Only the personal key is guaranteed to exist. The work keys are only
    # present on a full (victoria-id) setup, so guard each.
    for key in ~/.ssh/id_ed25519 ~/.ssh/victoria-github; do
        [ -f "$key" ] && ssh-add "$key" 2>/dev/null
    done
}

[ -f "$SSH_ENV" ] && source "$SSH_ENV" >/dev/null

ssh-add -l >/dev/null 2>&1 || start_ssh_agent
