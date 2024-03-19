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

FROM sharelatex/sharelatex
USER root
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y texlive-full
RUN apt install --no-install-recommends ttf-mscorefonts-installe fonts-noto texlive-fonts-recommended tex-gyre fonts-wqy-microhei fonts-wqy-zenhei fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji fonts-noto-extra fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted fonts-texgyre
RUN apt install python3-pygments
RUN echo "shell_escape = t" >> /usr/local/texlive/2023/texmf.cnf
RUN echo '#!/bin/bash\npushd /usr/local/bin\nfor f in `ls /usr/local/texlive/2023/bin/x86_64-linux`\ndo\n[ -f $f ] || ln -s /usr/local/texlive/2023/bin/x86_64-linux/$f $f\ndone' > /overleaf/link.sh
RUN cat /overleaf/link.sh
RUN chmod +x /overleaf/link.sh
RUN bash /overleaf/link.sh
WORKDIR /
ENTRYPOINT ["/sbin/my_init"]
