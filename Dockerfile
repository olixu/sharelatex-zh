FROM sharelatex/sharelatex:4.2.1
RUN tlmgr option repository ctan
RUN tlmgr update --self --all
RUN tlmgr install scheme-full
RUN echo '#!/bin/bash\npushd /usr/local/bin\nfor f in `ls /usr/local/texlive/2023/bin/x86_64-linux`\ndo\n[ -f $f ] || ln -s /usr/local/texlive/2023/bin/x86_64-linux/$f $f\ndone' > /overleaf/link.sh
RUN cat /overleaf/link.sh
RUN chmod +x /overleaf/link.sh
RUN bash /overleaf/link.sh
WORKDIR /
ENTRYPOINT ["/sbin/my_init"]
