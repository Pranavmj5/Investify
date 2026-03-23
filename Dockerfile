# ═══════════════════════════════════════════════════════════════
#  Investify — Single-stage: compile from source → ROOT.war
#  Uses the bundled JDK in the Tomcat image — no second pull
# ═══════════════════════════════════════════════════════════════

FROM tomcat:10.1-jdk17

# Remove default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Disable shutdown port to avoid Render health-check noise
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/' \
    /usr/local/tomcat/conf/server.xml

# ── Build area ──────────────────────────────────────────────────
WORKDIR /build

# Copy Java source and WEB-INF (lib + web.xml)
COPY src/      src/
COPY WEB-INF/  WEB-INF/

# Compile all Java sources
RUN mkdir -p WEB-INF/classes && \
    find src -name "*.java" > sources.txt && \
    javac -encoding UTF-8 \
          -cp "/usr/local/tomcat/lib/servlet-api.jar:WEB-INF/lib/*" \
          -d WEB-INF/classes \
          @sources.txt && \
    echo "=== Compiled classes ===" && \
    ls WEB-INF/classes/com/investify/servlet/

# Copy all web content into staging area
COPY index.jsp    ./
COPY login.jsp    ./
COPY register.jsp ./
COPY admin/       admin/
COPY founder/     founder/
COPY investor/    investor/
COPY government/  government/
COPY docs/        docs/

# Package everything into ROOT.war
RUN jar -cvf /usr/local/tomcat/webapps/ROOT.war \
        index.jsp login.jsp register.jsp \
        admin founder investor government docs \
        WEB-INF && \
    echo "=== ROOT.war size ===" && \
    ls -lh /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
