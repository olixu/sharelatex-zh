# FROM sharelatex/sharelatex
# RUN tlmgr option repository ctan
# RUN tlmgr update --self --all
# RUN tlmgr install scheme-full
# RUN echo '#!/bin/bash\npushd /usr/local/bin\nfor f in `ls /usr/local/texlive/2023/bin/x86_64-linux`\ndo\n[ -f $f ] || ln -s /usr/local/texlive/2023/bin/x86_64-linux/$f $f\ndone' > /overleaf/link.sh
# RUN cat /overleaf/link.sh
# RUN chmod +x /overleaf/link.sh
# RUN bash /overleaf/link.sh
# WORKDIR /
# ENTRYPOINT ["/sbin/my_init"]

# FROM sharelatex/sharelatex
# USER root
# SHELL ["/bin/bash", "-c"]
# RUN tlmgr option repository https://worker-soft-fog-2a88.radof26549.workers.dev/CTAN/systems/texlive/tlnet
# RUN tlmgr install scheme-full
# RUN tlmgr update --self --all
# RUN apt-get update && apt-get install -y texlive-full
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ttf-mscorefonts-installer fonts-noto texlive-fonts-recommended tex-gyre fonts-wqy-microhei fonts-wqy-zenhei fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji fonts-noto-extra fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted fonts-texgyre python3-pygments && rm -rf /var/lib/apt/lists/*
# RUN echo "shell_escape = t" >> /usr/local/texlive/2023/texmf.cnf
# RUN echo '#!/bin/bash\npushd /usr/local/bin\nfor f in `ls /usr/local/texlive/2023/bin/x86_64-linux`\ndo\n[ -f $f ] || ln -s /usr/local/texlive/2023/bin/x86_64-linux/$f $f\ndone' > /overleaf/link.sh
# RUN cat /overleaf/link.sh
# RUN chmod +x /overleaf/link.sh
# RUN bash /overleaf/link.sh
# WORKDIR /
# ENTRYPOINT ["/sbin/my_init"]

FROM sharelatex/sharelatex
USER root
SHELL ["/bin/bash", "-c"]

# Set the repository for tlmgr
RUN tlmgr option repository https://worker-soft-fog-2a88.radof26549.workers.dev/CTAN/systems/texlive/tlnet

# Install the full scheme and update all packages
# RUN tlmgr install scheme-full
# RUN tlmgr update --self --all

# Copy the 2023 directory to 2024 and preserve symbolic links
RUN cp -a /usr/local/texlive/2023 /usr/local/texlive/2024

# Remove backups to save space
RUN rm -rf /usr/local/texlive/2024/tlpkg/backups/*


# Update tlmgr to 2024 version. Note that this relies on the update script being available for 2024.
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh || : \
    && sh update-tlmgr-latest.sh -- --upgrade || :

# Remove the old 2023 Tex Live directory
RUN rm -rf /usr/local/texlive/2023

# Set the PATH to include the Tex Live 2024 binaries
ENV PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"

# Update the links to the new 2024 binaries
RUN echo '#!/bin/bash\npushd /usr/local/bin\nfor f in $(ls /usr/local/texlive/2024/bin/x86_64-linux)\ndo\n[ -f $f ] || ln -s /usr/local/texlive/2024/bin/x86_64-linux/$f $f\ndone' > /overleaf/link.sh
RUN chmod +x /overleaf/link.sh && bash /overleaf/link.sh

# Update all packages again after setting 2024 as the active version
RUN tlmgr update --self --all

# Continue with additional package installations
RUN apt-get update && apt-get install -y texlive-full

# Install font and utility packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ttf-mscorefonts-installer \
        fonts-noto \
        texlive-fonts-recommended \
        tex-gyre \
        fonts-wqy-microhei \
        fonts-wqy-zenhei \
        fonts-noto-cjk \
        fonts-noto-cjk-extra \
        fonts-noto-color-emoji \
        fonts-noto-extra \
        fonts-noto-ui-core \
        fonts-noto-ui-extra \
        fonts-noto-unhinted \
        fonts-texgyre \
        python3-pygments && \
    rm -rf /var/lib/apt/lists/*

# Add permissions for shell escape in Tex Live
RUN echo "shell_escape = t" >> /usr/local/texlive/2024/texmf.cnf

