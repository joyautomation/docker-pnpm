FROM node:lts AS base

# Install SSH client and GitHub CLI
RUN apt-get update \
    && apt-get install -y \
    openssh-client \
    curl \
    iputils-ping \
    vim \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y \
    && rm -rf /var/lib/apt/lists/*

# Set up bash customization
RUN echo 'force_color_prompt=yes' >> /root/.bashrc && \
    echo 'parse_git_branch() {' >> /root/.bashrc && \
    echo '    git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1)/"' >> /root/.bashrc && \
    echo '}' >> /root/.bashrc && \
    echo 'if [ "$color_prompt" = yes ]; then' >> /root/.bashrc && \
    echo '    PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\$ "' >> /root/.bashrc && \
    echo 'else' >> /root/.bashrc && \
    echo '    PS1="\u@\h:\w\$(parse_git_branch)\$ "' >> /root/.bashrc && \
    echo 'fi' >> /root/.bashrc

RUN npm i -g pnpm@$PNPM_VERSION
WORKDIR /app
CMD ["tail", "-f", "/dev/null"]
